<?php
session_start();
// exit("exit on index.php");
include_once 'includes/global.php';
$page = isset($_REQUEST['page'])== true ? $_REQUEST['page'] : null ;
$nav_obj = FabricaNavigate::createNavigate($page, $_SESSION);
$nav_obj->display();

?>