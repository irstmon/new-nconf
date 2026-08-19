<?php
# V 2.1.0 lookup
# are the escalation / eventhandler classes present?
$query = 'SELECT COUNT(*) AS found FROM ConfigClasses
            WHERE config_class IN ("service-escalation", "adv-service-escalation", "host-escalation", "eventhandler")';
$check_210_result = mysqli_query($dbh, $query);
if ( $check_210_result AND $row = @mysqli_fetch_assoc($check_210_result) ){
    if ( $row["found"] == 4 ){
        $installed_version = "2.1.0";
    }
}

?>
