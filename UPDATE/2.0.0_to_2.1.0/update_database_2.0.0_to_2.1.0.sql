# -- NConf database update script --
# -- from version 2.0.0 to 2.1.0 --

# -- add "service-escalation", "adv-service-escalation", "host-escalation" and --
# -- "eventhandler" classes (idempotent: skips any class/attribute that already --
# -- exists, safe to run even if these were added manually beforehand) --

INSERT INTO ConfigClasses
    (config_class, friendly_name, nav_visible, ordering, `grouping`, nav_links, nav_privs, class_type, out_file, nagios_object)
SELECT
    'service-escalation' AS config_class,
    'Service escalation' AS friendly_name,
    'yes' AS nav_visible,
    6 AS ordering,
    'Advanced Items' AS `grouping`,
    'Show::overview.php?class=service-escalation;;Add::handle_item.php?item=service-escalation' AS nav_links,
    'admin' AS nav_privs,
    'collector' AS class_type,
    'escalation.cfg' AS out_file,
    'serviceescalation' AS nagios_object
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ConfigClasses WHERE config_class = 'service-escalation');

INSERT INTO ConfigClasses
    (config_class, friendly_name, nav_visible, ordering, `grouping`, nav_links, nav_privs, class_type, out_file, nagios_object)
SELECT
    'adv-service-escalation' AS config_class,
    'Adv Srv escalation' AS friendly_name,
    'yes' AS nav_visible,
    7 AS ordering,
    'Advanced Items' AS `grouping`,
    'Show::overview.php?class=adv-service-escalation;;Add::handle_item.php?item=adv-service-escalation' AS nav_links,
    'admin' AS nav_privs,
    'collector' AS class_type,
    'escalation.cfg' AS out_file,
    'serviceescalation' AS nagios_object
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ConfigClasses WHERE config_class = 'adv-service-escalation');

INSERT INTO ConfigClasses
    (config_class, friendly_name, nav_visible, ordering, `grouping`, nav_links, nav_privs, class_type, out_file, nagios_object)
SELECT
    'host-escalation' AS config_class,
    'Host escalation' AS friendly_name,
    'yes' AS nav_visible,
    8 AS ordering,
    'Advanced Items' AS `grouping`,
    'Show::overview.php?class=host-escalation;;Add::handle_item.php?item=host-escalation' AS nav_links,
    'admin' AS nav_privs,
    'collector' AS class_type,
    'escalation.cfg' AS out_file,
    'hostescalation' AS nagios_object
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ConfigClasses WHERE config_class = 'host-escalation');

INSERT INTO ConfigClasses
    (config_class, friendly_name, nav_visible, ordering, `grouping`, nav_links, nav_privs, class_type, out_file, nagios_object)
SELECT
    'eventhandler' AS config_class,
    'Event Handler' AS friendly_name,
    'yes' AS nav_visible,
    9 AS ordering,
    'Advanced Items' AS `grouping`,
    'Show::overview.php?class=eventhandler;;Add::handle_item.php?item=eventhandler' AS nav_links,
    'admin' AS nav_privs,
    'global' AS class_type,
    'eventhandler.cfg' AS out_file,
    'command' AS nagios_object
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ConfigClasses WHERE config_class = 'eventhandler');


-- ----------------------------------------------------------------------------
-- 2. ConfigAttrs - service-escalation
-- ----------------------------------------------------------------------------

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'name' AS attr_name, 'Name' AS friendly_name, 'Name' AS description, 'text' AS datatype, 1024 AS max_length,
    NULL AS poss_values, NULL AS predef_value, 'yes' AS mandatory, 1 AS ordering, 'yes' AS visible,
    'no' AS write_to_conf, 'yes' AS naming_attr, 'no' AS link_as_child, 'no' AS link_bidirectional,
    NULL AS fk_show_class_items,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation') AS fk_id_class
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'name'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'first_notification', 'first notification', NULL, 'text', 1024,
    NULL, '0', 'yes', 2, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'first_notification'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'last_notification', 'last notification', NULL, 'text', 1024,
    NULL, NULL, 'yes', 3, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'last_notification'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'notification_interval', 'notification interval', NULL, 'text', 1024,
    NULL, NULL, 'yes', 4, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'notification_interval'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'service_description', 'service description', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 5, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'service_description'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'contact_groups', 'contact groups', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 6, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'contactgroup'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'contact_groups'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'escalation_period', 'escalation period', NULL, 'assign_one', 0,
    NULL, NULL, 'no', 7, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'timeperiod'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service-escalation')
    AND attr_name = 'escalation_period'
);

-- Cleanup for installations that already have a "host_name" field on
-- service-escalation (e.g. from an earlier hand-rolled setup, or a
-- pre-release version of this migration): a single escalation entry can
-- cover services on several hosts, so host_name is no longer a field on
-- this class - it is derived per host at export time instead. Removing the
-- attribute also removes any stored value for it (ON DELETE CASCADE).
-- The ordering shift only applies if "host_name" actually existed (captured
-- into a session variable before deleting it) - on a fresh install (no
-- host_name to begin with) this is a no-op.
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


-- ----------------------------------------------------------------------------
-- 3. ConfigAttrs - adv-service-escalation
-- ----------------------------------------------------------------------------

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'name', 'Name', 'Name', 'text', 1024,
    NULL, NULL, 'yes', 1, 'yes',
    'no', 'yes', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'name'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'first_notification', 'first notification', NULL, 'text', 1024,
    NULL, '0', 'yes', 2, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'first_notification'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'last_notification', 'last notification', NULL, 'text', 1024,
    NULL, NULL, 'yes', 3, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'last_notification'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'notification_interval', 'notification interval', NULL, 'text', 1024,
    NULL, NULL, 'yes', 4, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'notification_interval'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'host_name', 'host name', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 5, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'host_name'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'service_description', 'service description', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 6, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'service_description'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'contact_groups', 'contact groups', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 7, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'contactgroup'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'contact_groups'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'escalation_period', 'escalation period', NULL, 'assign_one', 0,
    NULL, NULL, 'no', 8, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'timeperiod'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'adv-service-escalation')
    AND attr_name = 'escalation_period'
);


-- ----------------------------------------------------------------------------
-- 4. ConfigAttrs - host-escalation
-- ----------------------------------------------------------------------------

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'name', 'Name', 'Name', 'text', 1024,
    NULL, NULL, 'yes', 1, 'yes',
    'no', 'yes', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'name'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'first_notification', 'first notification', NULL, 'text', 1024,
    NULL, '0', 'yes', 2, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'first_notification'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'last_notification', 'last notification', NULL, 'text', 1024,
    NULL, NULL, 'yes', 3, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'last_notification'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'notification_interval', 'notification interval', NULL, 'text', 1024,
    NULL, NULL, 'yes', 4, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'notification_interval'
);

-- NOTE: ordering jumps from 4 to 6 here (no ordering=5 attribute) - this
-- matches the source installation exactly, it's not a mistake.
INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'host', 'host', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 6, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'host'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'contact_groups', 'contact groups', NULL, 'assign_many', 0,
    NULL, NULL, 'yes', 7, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'contactgroup'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'contact_groups'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'escalation_period', 'escalation period', NULL, 'assign_one', 0,
    NULL, NULL, 'no', 8, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'timeperiod'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host-escalation')
    AND attr_name = 'escalation_period'
);


-- ----------------------------------------------------------------------------
-- 5. ConfigAttrs - eventhandler
-- ----------------------------------------------------------------------------

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'command_name', 'handler command name', NULL, 'text', 255,
    NULL, NULL, 'yes', 1, 'yes',
    'yes', 'yes', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
    AND attr_name = 'command_name'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'default_handler_name', 'default handler name', 'default name to use for new handler', 'text', 255,
    NULL, NULL, 'no', 2, 'yes',
    'no', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
    AND attr_name = 'default_handler_name'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'command_line', 'handler command line', NULL, 'text', 1024,
    NULL, NULL, 'yes', 3, 'yes',
    'yes', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
    AND attr_name = 'command_line'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'default_params', 'default command params', 'separated by "!"', 'text', 1024,
    NULL, '!', 'no', 4, 'yes',
    'no', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
    AND attr_name = 'default_params'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'command_syntax', 'params description', 'short description of each parameter (comma separated, same order)', 'text', 1024,
    NULL, NULL, 'no', 5, 'yes',
    'no', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
    AND attr_name = 'command_syntax'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'command_param_count', 'amount of params', NULL, 'select', 0,
    '0::1::2::3::4::5::6::7::8::9::10', '1', 'yes', 6, 'yes',
    'no', 'no', 'no', 'no',
    NULL,
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler')
    AND attr_name = 'command_param_count'
);
