<?php
require_once 'include/head.php';

$clonable_classes = array("service-escalation", "adv-service-escalation", "host-escalation", "eventhandler");
$class = $_POST["class"];

if ( !in_array($class, $clonable_classes) ){
    message($error, "Cloning is not supported for class '$class'");
}

if ( isset($_SESSION["cache"]["clone_item"]) ) unset($_SESSION["cache"]["clone_item"]);

if (DB_NO_WRITES == 1) {
    message($info, "DB_NO_WRITES = 1: No DB inserts or modifications will be performed");
}

$naming_attr_id = db_templates("get_naming_attr_from_class", $class);

#############
# Check for existing entry with the same name
$query = 'SELECT fk_id_item FROM ConfigValues
            WHERE fk_id_attr = '.$naming_attr_id.'
            AND attr_value = "'.$_POST["new_name"].'"';

$result = mysqli_query($dbh, $query);

echo NConf_HTML::page_title($class, 'Clone item');

#############
# Entry exists?
if (mysqli_num_rows($result)){
    NConf_DEBUG::set('An item with the name &quot;'.$_POST["new_name"].'&quot; already exists!', 'ERROR');
    NConf_DEBUG::set('For its details click the link below or go back:', 'ERROR');
    $list_items = '';
    while($entry = mysqli_fetch_assoc($result)){
        $list_items .= '<li><a href="detail.php?class='.$class.'&id='.$entry["fk_id_item"].'">'.$_POST["new_name"].'</a></li>';
    }
    $list = '<ul>'.$list_items.'</ul>';
    NConf_DEBUG::set($list, 'ERROR');

    if ( NConf_DEBUG::status('ERROR') ) {
        echo '<table><tr><td>';
            echo NConf_HTML::show_error();
            echo "<br><br>";
            echo NConf_HTML::back_button($_SESSION["go_back_page"]);

            $_SESSION["cache"]["use_cache"] = TRUE;
            foreach ($_POST as $key => $value) {
                $_SESSION["cache"]["clone_item"][$key] = $value;
            }
        echo '</td></tr></table>';
    }

}else{

    ?>
    <table>
        <tr>
            <td>
    <?php

    $arr_mandatory = array("template_id", "new_name");
    $write2db = "yes";
    foreach ($arr_mandatory as $mandatory){
        if ( ( isset($_POST[$mandatory]) ) AND ( $_POST[$mandatory] != "") ){
            message($debug, "$mandatory: ok");
        }else{
            $message = "$mandatory: mandatory field";
            NConf_DEBUG::set($message, "ERROR", "");
            message($info, SELECT_EMPTY_FIELD, "overwrite");
            $write2db = "no";
        }
    }

    if ($write2db == "yes"){
        $template_id = (int)$_POST["template_id"];

        # generate new item_id
        $query = 'INSERT INTO ConfigItems (id_item,fk_id_class) VALUES (NULL,(SELECT id_class FROM ConfigClasses WHERE config_class="'.$class.'"))';
        $new_item_id = db_handler($query, "insert_id", "insert new $class");
        if ($new_item_id){
            history_add("created", $class, $_POST["new_name"], $new_item_id);
            message ($debug, "Successfully added new $class");
        }else{
            message ($error, "Error while adding new $class");
        }

        # set the new name (naming attribute)
        $query = 'INSERT INTO ConfigValues (attr_value,fk_id_item,fk_id_attr)
                    VALUES ("'.$_POST["new_name"].'",'.$new_item_id.','.$naming_attr_id.')';
        $result = db_handler($query, "result", "insert new name");
        if ($result){
            history_add("added", $naming_attr_id, $_POST["new_name"], $new_item_id);
        }

        # clone all other ordinary attribute values from the template item (everything except the naming attr)
        NConf_DEBUG::open_group("clone basic data");
        $query = 'INSERT INTO ConfigValues (fk_id_attr,attr_value,fk_id_item)
                    SELECT id_attr,attr_value,'.$new_item_id.' FROM ConfigAttrs,ConfigValues,ConfigItems
                        WHERE id_attr=fk_id_attr
                            AND id_item=fk_id_item
                            AND id_attr <> '.$naming_attr_id.'
                            AND id_item='.$template_id.'
                        ORDER BY ordering';
        $result = db_handler($query, "result", "clone basic data");
        if ($result){
            $query = 'SELECT id_attr,attr_value FROM ConfigAttrs,ConfigValues,ConfigItems
                        WHERE id_attr=fk_id_attr
                            AND id_item=fk_id_item
                            AND id_attr <> '.$naming_attr_id.'
                            AND id_item='.$template_id.'
                        ORDER BY ordering';
            $b_data = db_handler($query, "array", "get basic data");
            foreach($b_data as $data){
                history_add("added", $data["id_attr"], $data["attr_value"], $new_item_id);
            }
        }

        # clone all linked items (assign_one / assign_many attrs: host_name, service_description, contact_groups, escalation_period, ...)
        NConf_DEBUG::open_group("clone linked data");
        $query = 'INSERT INTO ItemLinks (fk_id_item,fk_item_linked2,fk_id_attr,cust_order)
                    SELECT '.$new_item_id.',fk_item_linked2,fk_id_attr,cust_order
                        FROM ItemLinks WHERE fk_id_item = '.$template_id.'
                        ORDER BY fk_item_linked2';
        $result = db_handler($query, "result", "clone linked data");
        if ($result){
            $query = 'SELECT fk_item_linked2,fk_id_attr FROM ItemLinks WHERE fk_id_item = '.$template_id.' ORDER BY fk_id_attr,cust_order';
            $l_data = db_handler($query, "array", "get linked data for history");
            foreach($l_data as $data){
                history_add("assigned", $data["fk_id_attr"], $data["fk_item_linked2"], $new_item_id, "resolve_assignment");
            }
        }

        echo '<b>Successfully cloned selected '.htmlspecialchars($class).' to &quot;'.htmlspecialchars($_POST["new_name"]).'&quot;</b>';
        echo '<br><br>Click for details: ';
        echo '<a href="detail.php?class='.$class.'&id='.$new_item_id.'">'.htmlspecialchars($_POST["new_name"]).'</a>';
        echo '<br><br>';
        echo NConf_HTML::back_button($_SESSION["go_back_page"]);
    }

    ?>
            </td>
        </tr>
    </table>
    <?php
}

mysqli_close($dbh);
require_once 'include/foot.php';
?>