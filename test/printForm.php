<?php
include_once 'arr_inc.php';


foreach ($arr_ther_kv as $key=>$value){
	//echo sprintf("\$investigation->%s= \$this->getNullForObjectFieldIfStringEmpty(\$request['%s']);<br>",$value,$value);
	//echo sprintf("\$investigation->%s=\$row[0]['%s'];<br>", $value,$value);
	//echo sprintf("\$stmt->bindValue(':%s', \$entity->%s, PDO::PARAM_STR);<br>", $value,$value);
	if(endsWithId($key))
		printSelect($key, $value);
	else
		printInput($key, $value);
	
}

function printInput($fname, $fcomment){
	echo htmlspecialchars("<tr>"). "<br/>";
	echo htmlspecialchars("<td>") . $fcomment . htmlspecialchars("</td>")."<br/>";
	echo htmlspecialchars("<td>");
	echo htmlspecialchars("<");
	echo sprintf("input {\$class_req_input} type=\"text\" {\$readonly} name=\"%s\" size=\"50\" value=\"{\$object->%s}\"",
	$fname,$fname);
	echo htmlspecialchars("/>");
	echo htmlspecialchars("</td>"). "<br/>";
	echo htmlspecialchars("</tr>"). "<br/>";
}

/*
 	<tr>
		<td>Медицинский центр</td>
		<td><select {$class_req_input} {$disabled} name="hospital_id">
			<option></option>
			{foreach $hospital_vals as $item}
			<option {if $item->id == $object->hospital_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
 */
function printSelect($fname, $fcomment){
	echo htmlspecialchars("<tr>"). "<br/>";
	echo htmlspecialchars("<td>") . $fcomment . htmlspecialchars("</td>")."<br/>";
	echo htmlspecialchars("<td>");
	echo htmlspecialchars("<");
	echo sprintf("select {\$class_req_input} {\$disabled} name=\"%s\"",$fname) . htmlspecialchars(">") . "<br/>";
	echo htmlspecialchars("<option></option>"). "<br/>";
	echo sprintf("{foreach \$%s as \$item}", str_replace("_id", "_vals", $fname)) . "<br/>"; 
	echo htmlspecialchars("<option"). sprintf(" {if \$item->id == \$object->%s} selected=\"selected\"<br/>",$fname);
	echo "{/if} value=\"{\$item->id}\">{\$item->value}" . htmlspecialchars("</option>") . "<br/>";
	echo "{/foreach}<br/>";
	echo htmlspecialchars("</select></td>") . "<br/>";
	echo htmlspecialchars("</tr>"). "<br/>";
}

function endsWithId($haystack){
	$needle =  "_id";
    $length = strlen($needle);
    if ($length == 0) 
        return true;
    return (substr($haystack, -$length) === $needle);
}