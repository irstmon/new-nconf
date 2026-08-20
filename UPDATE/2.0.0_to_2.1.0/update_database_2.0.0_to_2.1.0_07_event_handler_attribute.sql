# -- NConf database update script (part 8 of 8) --
# -- from version 2.0.0 to 2.1.0 --
# -- split into independent files on purpose: a failure in one part --
# -- does not prevent the other parts from still being applied --

# -- adds the "event_handler" attribute to "host", "service" and --
# -- "advanced-service" - without this, the "eventhandler" class (added --
# -- separately) lets you define handler commands but nothing lets you --
# -- actually assign one to a host/service. --

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'event_handler', 'Event Handler', NULL, 'assign_one', 0,
    NULL, NULL, 'no', 29, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'host')
    AND attr_name = 'event_handler'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'event_handler', 'Event Handler', NULL, 'assign_one', 0,
    NULL, NULL, 'no', 25, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'service')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'service')
    AND attr_name = 'event_handler'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'event_handler', 'Event Handler', NULL, 'assign_one', 0,
    NULL, NULL, 'no', 28, 'yes',
    'yes', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'eventhandler'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service')
    AND attr_name = 'event_handler'
);
