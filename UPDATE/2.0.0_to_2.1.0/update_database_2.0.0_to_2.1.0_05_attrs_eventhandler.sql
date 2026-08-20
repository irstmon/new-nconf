# -- NConf database update script (part 6 of 6) --
# -- from version 2.0.0 to 2.1.0 --
# -- split into independent files on purpose: a failure in one part --
# -- does not prevent the other parts from still being applied --

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

-- ============================================================================
-- Done. Verify with:
--   SELECT config_class, friendly_name FROM ConfigClasses
--   WHERE config_class IN ('service-escalation','adv-service-escalation','host-escalation','eventhandler');
-- ============================================================================
