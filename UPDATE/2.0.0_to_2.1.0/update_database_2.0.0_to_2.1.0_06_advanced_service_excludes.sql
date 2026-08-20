# -- NConf database update script (part 7 of 8) --
# -- from version 2.0.0 to 2.1.0 --
# -- split into independent files on purpose: a failure in one part --
# -- does not prevent the other parts from still being applied --

# -- adds "host_exclude" and "hostgroup_exclude" attributes to the --
# -- "advanced-service" class. These are NOT written to the generated --
# -- config directly (write_to_conf = 'no') - the export logic in --
# -- ExportNagios.pm folds their values into "host_name"/"hostgroup_name" --
# -- as Nagios-native "!hostname" exclusions instead. --

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'host_exclude', 'exclude advanced-service from host', NULL, 'assign_many', 0,
    NULL, NULL, 'no', 26, 'yes',
    'no', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'host'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service')
    AND attr_name = 'host_exclude'
);

INSERT INTO ConfigAttrs
    (attr_name, friendly_name, description, datatype, max_length, poss_values, predef_value, mandatory, ordering, visible, write_to_conf, naming_attr, link_as_child, link_bidirectional, fk_show_class_items, fk_id_class)
SELECT
    'hostgroup_exclude', 'exclude advanced-service from hostgroup', NULL, 'assign_many', 0,
    NULL, NULL, 'no', 27, 'yes',
    'no', 'no', 'no', 'no',
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'hostgroup'),
    (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service')
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ConfigAttrs
    WHERE fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = 'advanced-service')
    AND attr_name = 'hostgroup_exclude'
);
