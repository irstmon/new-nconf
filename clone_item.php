<?php
require_once 'include/head.php';

// generic item cloning - currently enabled for these simple, "flat" classes
// (no host-style special fields like IP/alias, just ordinary attrs + links)
$clonable_classes = array("service-escalation", "adv-service-escalation", "host-escalation", "eventhandler");

$class = $_GET["class"];

if ( !in_array($class, $clonable_classes) ){
    message($error, "Cloning is not supported for class '$class'");
}

//delete cache if not resent from clone
if( !preg_match('/^clone/', $_SESSION["go_back_page"]) ){
    unset($_SESSION["cache"]["clone_item"]);
}
set_page();

if ( isset($_SESSION["cache"]["clone_item"]) ){
    $cache = $_SESSION["cache"]["clone_item"];
}elseif( !empty($_GET["id"]) ){
    $cache["template_id"] = $_GET["id"];
}

$item_name = db_templates("naming_attr", $_GET["id"]);
$naming_attr_friendly = db_templates("get_attributes_from_class", $class);
$naming_attr_label = "name";
foreach ($naming_attr_friendly as $attr){
    if ( $attr["naming_attr"] == "yes" ){
        $naming_attr_label = $attr["friendly_name"];
    }
}

# Title
echo NConf_HTML::page_title($class, 'Clone item');
$title = "Clone a $class";
echo '<div class="ui-nconf-header ui-widget-header ui-corner-tl ui-corner-tr ui-helper-clearfix">';
    echo '<h2 class="page_action_title">'.$title.' <span class="item_name">'.$item_name.'</span></h2>';
echo '</div>';
# content block
echo '<div class="ui-nconf-content ui-widget-content ui-corner-bottom">';
?>

<form name="clone_item" action="clone_item_write2db.php" method="post">
  <br>
    <table>
      <tr><td valign="top"><?php echo htmlspecialchars($class); ?> to clone</td>
          <td width="10"></td>
          <td><select name="template_id">

<?php
$query = 'SELECT fk_id_item,attr_value FROM ConfigValues,ConfigAttrs,ConfigClasses
                WHERE id_attr=fk_id_attr
                    AND naming_attr="yes"
                    AND id_class=fk_id_class
                    AND config_class="'.$class.'"
                ORDER BY attr_value';

$result = mysqli_query($dbh, $query);

while($items = mysqli_fetch_assoc($result)){
    echo '<option value='.$items["fk_id_item"];
    if ( (isset($cache["template_id"])) AND ($cache["template_id"] == $items["fk_id_item"]) ) {
        echo ' SELECTED';
    }
    echo '>'.$items["attr_value"].'</option>';
}
?>
          </select></td><td valign="top" class="attention">*</td></tr>
      <tr><td valign="top">new <?php echo htmlspecialchars($naming_attr_label); ?></td>
          <td width="10"></td>
          <td><input name="new_name" type="text" maxlength="255"
                value="<?php if (isset($cache["new_name"])) echo htmlspecialchars($cache["new_name"]);?>"></td>
          <td valign="top" class="attention">*</td></tr>
      <input type="hidden" name="class" value="<?php echo htmlspecialchars($class); ?>">
    </table>

<?php
$_SESSION["submited"] = "yes";
?>
    <div id="buttons"><br><br>
    <input type="Submit" value="Submit" name="submit" align="middle">
    <input type="Reset" value="Reset">
    <?php
        if ( isset($_SESSION["cache"]["clone_item"]) ){
            if ( strstr($_SERVER['REQUEST_URI'], ".php?") ){
                $clear_url = $_SERVER['REQUEST_URI'].'&clear=1&class=clone_item';
            }else{
                $clear_url = $_SERVER['REQUEST_URI'].'?clear=1&class=clone_item';
            }
            echo '<input type="button" name="clear" value="Clear" onClick="window.location.href=\''.$clear_url.'\'">';
        }
    ?>
    </div>
</form>

<?php
mysqli_close($dbh);
require_once 'include/foot.php';
?>