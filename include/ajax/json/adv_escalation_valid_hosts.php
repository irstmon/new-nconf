<?php
// JSON response: given one or more "advanced-service" item IDs, returns the
// list of "host" item IDs that actually have ALL of these services applied
// (directly linked OR inherited over a hostgroup the host is a member of).
//
// Used by the "adv-service-escalation" edit form: the Advanced Service
// selection drives the form, and the Host selection is filtered down to
// only the hosts that are valid for the *entire* current set of selected
// services - so one escalation entry can cleanly cover N hosts x M services
// without allowing an invalid host/service combination to be picked.
//
// Known limitation: this does not take the advanced-service "host_exclude" /
// "hostgroup_exclude" attributes into account (neither does NConf's own
// built-in host-service management view) - if you rely on excludes for a
// service, double check the resulting host list manually.

header('Content-Type: application/json');

$service_ids = array();
if ( !empty($_POST["service_ids"]) ){
    foreach ( explode(",", $_POST["service_ids"]) as $id ){
        $id = (int)trim($id);
        if ( $id > 0 ) $service_ids[] = $id;
    }
}

if ( empty($service_ids) ){
    // no advanced service selected (yet) -> no restriction, caller should show all hosts
    echo json_encode( array("restrict" => FALSE, "valid_ids" => array()) );
    exit;
}

function get_hostgroup_member_hosts($hostgroup_id){
    // NOTE: the "members" link between a hostgroup and its hosts is stored in
    // ItemLinks with fk_id_item = the HOST and fk_item_linked2 = the HOSTGROUP
    // (not the other way around), so this cannot use the generic get_linked_item()
    // helper (which assumes fk_id_item = the item you're starting from). This
    // mirrors the direction already used by the "hostgroup_services" template.
    $host_ids = array();
    $query = 'SELECT ItemLinks.fk_id_item AS host_id
                FROM ItemLinks, ConfigItems, ConfigClasses, ConfigAttrs
                WHERE ItemLinks.fk_id_item = ConfigItems.id_item
                AND ConfigItems.fk_id_class = ConfigClasses.id_class
                AND ConfigClasses.config_class = "host"
                AND ItemLinks.fk_id_attr = ConfigAttrs.id_attr
                AND ConfigAttrs.attr_name = "members"
                AND ItemLinks.fk_item_linked2 = '.(int)$hostgroup_id;
    $rows = db_handler($query, "array", "Get member hosts of hostgroup ".$hostgroup_id);
    if ( is_array($rows) ){
        foreach ( $rows as $row ){
            if ( !empty($row["host_id"]) ) $host_ids[$row["host_id"]] = TRUE;
        }
    }
    return $host_ids;
}

function get_hosts_for_advanced_service($service_id){
    $host_ids = array();

    // (1) hosts this service is directly linked to
    $direct = db_templates("get_linked_item", $service_id, "host_name");
    if ( is_array($direct) ){
        foreach ( $direct as $row ){
            if ( !empty($row["fk_id_item"]) ) $host_ids[$row["fk_id_item"]] = TRUE;
        }
    }

    // (2) hosts inherited via hostgroups this service is linked to
    $hostgroups = db_templates("get_linked_item", $service_id, "hostgroup_name");
    if ( is_array($hostgroups) ){
        foreach ( $hostgroups as $hg_row ){
            if ( empty($hg_row["fk_id_item"]) ) continue;
            $members = get_hostgroup_member_hosts($hg_row["fk_id_item"]);
            foreach ( $members as $host_id => $true ){
                $host_ids[$host_id] = TRUE;
            }
        }
    }

    return $host_ids;
}

$valid_ids = NULL; // running intersection across all selected services

foreach ( $service_ids as $service_id ){
    $hosts_this_service = get_hosts_for_advanced_service($service_id);

    if ( $valid_ids === NULL ){
        $valid_ids = $hosts_this_service;
    }else{
        foreach ( array_keys($valid_ids) as $host_id ){
            if ( !isset($hosts_this_service[$host_id]) ){
                unset($valid_ids[$host_id]);
            }
        }
    }
}

echo json_encode( array("restrict" => TRUE, "valid_ids" => array_map('intval', array_keys($valid_ids))) );
