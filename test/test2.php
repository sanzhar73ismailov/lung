<?php
//include 'includes/global.php';
include "arr_inc.php";

//foreach ($arr_pat as $value){
foreach ($arrTher as $value){
	//echo sprintf("\$entity->%s= \$this->getNullForObjectFieldIfStringEmpty(\$request['%s']);<br>",$value,$value);
	//echo sprintf("\$entity->%s=\$row[0]['%s'];<br>", $value,$value);
	echo sprintf("\$stmt->bindValue(':%s', \$entity->%s, PDO::PARAM_STR);<br>", $value,$value);
	//assignDicVals($value);
	//echo sprintf("<th>%s</th>\n", ++$i);
	//	echo sprintf("\$%s_trans='';<br>", $value);
}

function assignDicVals($field_name){
	//$smarty->assign('hospital_vals', $dao->getDicValues("hospital_id"))
	if(endsWith($field_name, "_id")){
		$vals_name =  str_replace("_id", "_vals", $field_name);
		//echo $field_name . "<br/>";
		echo sprintf("\$smarty->assign('%s', \$dao->getDicValues(\"%s\"));<br/>", $vals_name,$field_name);
	}
}

function endsWith($haystack, $needle){
	$length = strlen($needle);
	if ($length == 0) {
		return true;
	}
	return (substr($haystack, -$length) === $needle);
}
?>