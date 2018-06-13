<?php session_start(); ?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create report page</title>
</head>
<body>
<?php
include_once 'includes/global.php';

createChemListFile("c:/temp");

function getChemArray(){
	$chem_array = array();
	$chem_array[]="chmt_karboplatin_id";
	$chem_array[]="chmt_cisplatin_id";
	$chem_array[]="chmt_ciklofosfan_id";
	$chem_array[]="chmt_paklitaksel_id";
	$chem_array[]="chmt_doksorubicin_id";
	$chem_array[]="chmt_topotekan_id";
	$chem_array[]="chmt_gemcitabin_id";
	$chem_array[]="chmt_vinorelbin_id";
	$chem_array[]="chmt_irinotekan_id";
	$chem_array[]="chmt_jetopozid_id";
	$chem_array[]="chmt_jepirubicin_id";
	$chem_array[]="chmt_docetaksel_id";
	$chem_array[]="chmt_oksaliplatin_id";
	$chem_array[]="chmt_trabektedin_id";
	return $chem_array;
}

function createChemListFile($dir){
	global $dao;
	$res =$dao->getAllTherapies();

	$myfile = fopen($dir . "/newfile.txt", "w") or die("Unable to open file!");

	$str_row = "count_id;therapy_id;patient_id;visit_id;chem;from_list\r\n";
	fwrite($myfile, $str_row) or die("Unable to write to file text: " . $str_row);

	$chem_array = getChemArray();
	$line_num = 0;
	$val_label_arr = array();
	$label_id=101;
	foreach ($res as $key=>$row){
		//echo $row["id"]."<br/>";

		$visit_id=$row["visit_id"];
		$patient_id=$row["patient_id"];

		//$chema_name = "chmt_cisplatin_id";
		//$chem = $val["chmt_cisplatin_id"];
		$from_list=1;
		foreach ($chem_array as $chem){
			$chem_val = $row[$chem];
			if($chem_val==1){
				$line_num++;
				$str_row = $line_num .";".$row["id"] . ";" . $patient_id . ";" . $visit_id . ";" . $chem . ";" . $from_list. ";\r\n";
				fwrite($myfile, $str_row) or die("Unable to write to file text: " . $str_row);

				echo $str_row."<br/>";
			}
		}

		if($row["chmt_other_id"] == 1){
			//5ФУ (1000, 1500)
			//фторурацил (1000, 1500)
			//кемоплат (40, 25);
			$chmt_other_descr =  $row["chmt_other_descr"];
			$chmt_other_descr =  str_replace("5ФУ (1000, 1500)","фторурацил",$chmt_other_descr);
			$chmt_other_descr =  str_replace("фторурацил (1000, 1500)","фторурацил",$chmt_other_descr);
			$chmt_other_descr =  str_replace("кемоплат (40, 25)","кемоплат",$chmt_other_descr);

			$other_array = explode(",",$chmt_other_descr);
			$from_list=0;



			foreach ($other_array as $chemRaw){
				$chemVal = mb_strtolower(trim($chemRaw));
				if($chemVal=="натриофолиин"){
					$chemVal ="натриофолин";
				}
				if($chemVal=="фтоурацил"){
					$chemVal ="фторурацил";
				}

				if(trim($chemVal) == ""){
					continue;
				}
				$chem = "";
				if(array_key_exists($chemVal,$val_label_arr)){
					$chem = $val_label_arr[$chemVal];
				}else{
					$val_label_arr[$chemVal]=$label_id;
					$chem = $label_id;
					$label_id++;
				}
				//$chem = (trim($chemRaw));
				$chem =  str_replace("|",",",$chem);
				$line_num++;
				$str_row = $line_num .";".$row["id"] . ";" . $patient_id . ";" . $visit_id . ";" . $chem . ";" . $from_list. ";\r\n";
				fwrite($myfile, $str_row) or die("Unable to write to file text: " . $str_row);
				echo $str_row."<br/>";
			}


		}
	}//end for
	$file_add_chem_descr = fopen($dir . "\add_chem_descr.txt", "w") or die("Unable to open file!");
	var_dump($val_label_arr);
	foreach ($val_label_arr as $key=>$val){
		$fc = mb_strtoupper(mb_substr($key, 0, 1));
		$kepFirstUp = $fc . mb_substr($key, 1);
		//$kepFirstUp = ucfirst($key);
		$str_row = "$val \"$kepFirstUp\"\r\n";
		fwrite($file_add_chem_descr, $str_row) or die("Unable to write to file text: " . $str_row);
	}
	fclose($file_add_chem_descr);
	fclose($myfile);

	//var_dump($res);
}
?>
</body>
</html>
