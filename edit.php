<?php
session_start();
include_once 'includes/global.php';
//include_once 'includes/check_session.php';

if(!isset($_SESSION["authorized"]) || $_SESSION["authorized"] != 1){
	$smarty->assign('title',"Вход");
	$smarty->assign('message',"Необходимио авторизоваться");
	$smarty->display('templates/login.tpl');
	exit;
}else{
	$smarty->assign('authorized',1);
}
if(isset($_REQUEST["entity"])){
	$entity = $_REQUEST["entity"];
	$smarty->assign('entity',$entity);
	$do = isset($_REQUEST["do"])?  $_REQUEST["do"] : "view" ;
	if($do == "edit" and READ_MODE == 1){
		$do = "view";
	}
	$id =   isset($_REQUEST["id"])?  (int) $_REQUEST["id"] : null;
	switch ($do){
		case "view":
			if($entity == "patient"){
				$smarty->assign('title',"Просмотр пациента");
				open_tpl_to_view_patient($id, $smarty, $dao);
			} elseif ($entity == "investigation"){
				$smarty->assign('title',"Просмотр клин данных");
				open_tpl_to_view_investigation((int) $_REQUEST["patient_id"], $smarty, $dao);
			} elseif ($entity == "therapy"){
				$smarty->assign('title',"Просмотр данных XT, курс " . $_REQUEST["visit_id"]);
				open_tpl_to_view_therapy($_REQUEST, $smarty, $dao);
				//open_tpl_to_view_investigation((int) $_REQUEST["patient_id"], $smarty, $dao);
			}
			break;
		case "edit":
			if($entity == "patient"){
				$smarty->assign('title',"Редактирование пациента");
				open_tpl_to_view_patient($id, $smarty, $dao, $do="edit");
			} elseif ($entity == "investigation"){
				$smarty->assign('title',"Редактирование клин. данных");
				open_tpl_to_view_investigation((int) $_REQUEST["patient_id"], $smarty, $dao, $do="edit");
			} elseif ($entity == "therapy"){
				$smarty->assign('title',"Редактирование данных XT, курс " . $_REQUEST["visit_id"]);
				open_tpl_to_view_therapy($_REQUEST, $smarty, $dao, $do="edit");
				//open_tpl_to_view_investigation((int) $_REQUEST["patient_id"], $smarty, $dao);
			}
			break;
		case "save":
			//echo "in save init<br/>";
			if($entity == "patient"){
				//echo "in save ent pat<br/>";
				$entityParsed = $dao->parse_form_to_patient($_REQUEST);
				$insert_id = $dao->save_patient($entityParsed);
				$smarty->assign('title',"Просмотр пациента");
				open_tpl_to_view_patient($insert_id, $smarty, $dao);
			} elseif ($entity == "therapy"){
				//echo "in save ent ther<br/>";
				$entityParsed = $dao->parse_form_to_therapy($_REQUEST);
				//var_dump($investigationParsed);
				$insert_id = $dao->save_therapy($entityParsed);
				$smarty->assign('title',"Просмотр клин данных");
				//echo "<p>insert_id=$insert_id <p>";
				open_tpl_to_view_therapy($_REQUEST, $smarty, $dao);
			}else{
				exit("error entity");
			}
			break;
		default: break;
	}
}else{
	exit ("Error!");
}
