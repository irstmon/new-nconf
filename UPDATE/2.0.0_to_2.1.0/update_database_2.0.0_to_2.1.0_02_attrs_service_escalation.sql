# -- NConf database update script (part 3 of 6) --
# -- from version 2.0.0 to 2.1.0 --
# -- split into independent files on purpose: a failure in one part --
# -- does not prevent the other parts from still being applied --

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
