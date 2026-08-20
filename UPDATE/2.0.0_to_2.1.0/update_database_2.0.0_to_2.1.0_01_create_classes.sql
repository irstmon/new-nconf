# -- NConf database update script (part 2 of 6) --
# -- from version 2.0.0 to 2.1.0 --
# -- split into independent files on purpose: a failure in one part --
# -- does not prevent the other parts from still being applied --

-- ----------------------------------------------------------------------------
-- 1. ConfigClasses
-- ----------------------------------------------------------------------------

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
