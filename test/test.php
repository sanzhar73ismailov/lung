<?php 
//include_once 'included.php';
//$_SESSION['x'] = 12;
//
//echo "on test: x=" . $_SESSION['x'] . "<p>";
//var_dump($_SESSION);
//echo "<p>";
//var_dump($_COOKIE);
//echo "<p>";
$mysqldate = "2012-07-25";
echo $mysqldate . "<p>";
$phpdate = strtotime( $mysqldate );
echo $phpdate . "<p>";
$mysqldate = date( 'Y-m-d', $phpdate );
echo $mysqldate . "<p>";
echo "---------<p>";
$strMysqlDate = "2011-12-23";
$strMysqlDate = "";
echo date('d/m/Y',strtotime($strMysqlDate)) . "<p>";
echo "---------<p>";

//$var = '20/04/2012';
//$date = str_replace('/', '-', $var);
//echo date('Y-m-d', strtotime($date));

?>
<br/>
<a href="test3.php">test3.php</a><br/>
<a href="kill_session.php">kill_session.php</a>