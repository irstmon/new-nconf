# -- NConf database update script (part 1 of 6) --
# -- from version 2.0.0 to 2.1.0 --
# -- split into independent files on purpose: a failure in one part --
# -- does not prevent the other parts from still being applied --

-- ----------------------------------------------------------------------------
-- 0. Cleanup: remove "host_name" from service-escalation if present
-- ----------------------------------------------------------------------------
-- Placed FIRST and standalone on purpose: if any statement further down in
-- this file fails (e.g. because of some other pre-existing local deviation
-- in a hand-modified installation), the update runner aborts the rest of
-- the file - this cleanup is important enough that it should not depend on
-- anything else here succeeding first.
--
-- service-escalation may already have a "host_name" field from an earlier
-- hand-rolled setup, or a pre-release version of this migration: a single
-- escalation entry can cover services on several hosts, so host_name is no
-- longer a field on this class - it is derived per host at export time
-- instead. Removing the attribute also removes any stored value for it
-- (ON DELETE CASCADE). The ordering shift only applies if "host_name"
-- actually existed (captured into a session variable before deleting it) -
-- on a fresh install (no host_name, and no service-escalation class at all
-- yet) this is a harmless no-op.
SET @service_escalation_had_host_name = (
    SELECT COUNT(*) FROM ConfigAttrs
    WHERE attr_name = 'host_name'
    AND fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
);

DELETE FROM ConfigAttrs
WHERE attr_name = 'host_name'
AND fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation');

UPDATE ConfigAttrs
SET ordering = ordering - 1
WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
AND ordering > 4
AND @service_escalation_had_host_name > 0;
