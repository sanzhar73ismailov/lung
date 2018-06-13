<?php
session_start();
include_once 'includes/global.php';
//$str_path = "contacts";
//$str_path = "list";
//$session = $_SESSION;


//$nav_obj = FabricaNavigate::createNavigate($str_path, $session);
//$nav_obj->init();
//$res = $dao->isVisitExist(1, 2);
$res = $dao->getPatient(1);
//$res=$dao->getDicValues("hospital_id");
//$res = $dao->getPatients();
//$res =$dao->getAllTherapies();
/*
foreach ($res as $key=>$val){
	echo $val["id"]."<br/>";
}
*/
//$res =$dao->isVisitExistFromArray(1,3,$res);
//$res = new Patient();
//$res =$dao->getTherapyByPatientAndVisit(1,1);

var_dump($res);
