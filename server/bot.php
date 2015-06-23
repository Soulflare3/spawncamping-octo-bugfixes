<?php
$start = microtime(true);
error_reporting(0);
if (!empty($_GET["view"]))
{
	$input = $_GET["view"];
}
$thisFile = basename(__FILE__);;
$title = "hmh_bot";
$quotes = 0;
$commands = 0;
include 'hmhbot/botheader.php';
$render = "";
if(strtolower($input)=="cmd")
{
	$render .= "<br />Here's a list of my available commands:<br /><table cellpadding=\"5\" class=\"heavyTable\"><thead><tr><th width=\"30%\">Command</th><th>Description</th></tr></thead><tbody></tbody></table>";
}
else
{
	$db = new SQLite3('/home/ChronalRobot/handmade.db');
	if(!$db)
	{
		echo $db->lastErrorMsg();
	}
	$prerender .= "</section><table cellpadding=\"5\" class=\"heavyTable\"><thead><tr><th width=\"10%\">ID</th><th width=\"80%\">Quote</th><th width=\"10%\">Timestamp</th></tr></thead><tbody>";

	$results = $db->query('SELECT id, text, timestamp FROM quote');
	while ($row = $results->fetchArray())
	{
		$quotes++;
		$prerender .= "<tr><td width=\"10%\">". $row['id'] . "</td><td width=\"50%\">". $row['text'] . "</td><td width=\"50%\">". date('Y-m-d', $row['timestamp']) . "</td></tr>";
	}
	$prerender .= "</tbody></table><section class=\"content\">";
	$db->close();
	$render .= "<br />I have ".$quotes." quotes ";
	if($commands>0)
	{
		$render .= "and ".$commands." commands ";
	}
	$render .= "available <br />You can download my .db file <a href=\"../hmhbot/db.php\">here</a>".$prerender;
}
echo $render;
include 'hmhbot/botfooter.php';
?>

