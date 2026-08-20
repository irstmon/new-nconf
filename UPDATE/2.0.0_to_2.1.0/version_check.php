<?php
# V 2.1.0 lookup
# are the escalation / eventhandler classes present, AND does
# "service-escalation" already have its "host_name" field removed?
# (older/hand-rolled installs may already have the 4 classes but still
# carry the pre-2.1.0 "host_name" field on service-escalation)
$query = 'SELECT COUNT(*) AS found FROM ConfigClasses
            WHERE config_class IN ("service-escalation", "adv-service-escalation", "host-escalation", "eventhandler")';
$check_210_result = mysqli_query($dbh, $query);
$classes_found = 0;
if ( $check_210_result AND $row = @mysqli_fetch_assoc($check_210_result) ){
    $classes_found = $row["found"];
}

if ( $classes_found == 4 ){
    $query = 'SELECT COUNT(*) AS found FROM ConfigAttrs
                WHERE attr_name = "host_name"
                AND fk_id_class = (SELECT id_class FROM ConfigClasses WHERE config_class = "service-escalation")';
    $check_host_name_result = mysqli_query($dbh, $query);
    if ( $check_host_name_result AND $row = @mysqli_fetch_assoc($check_host_name_result) ){
        if ( $row["found"] == 0 ){
            $installed_version = "2.1.0";
        }
    }
}

?>
