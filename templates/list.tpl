<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="style.css">
<title>{$title}</title>
{include file="js_include.tpl"}
<script src="jscript/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(document).ready(function() 
	    { 
	        $("#myTable").tablesorter(); 
	    } 
	);
</script>
</head>
<body>
<div id="wrap">{include file="header.tpl"}



<div id="content">


<!--<div class="quick_panel"></div>-->
<div class="center_title">Список пациентов</div>
<div class="comment_label">* Для сортировки по столбцу кликните по заголовку этого столбца</div>
<table class="table_list" id="myTable">
	<thead>
		<tr>
			<th>Код пациента</th>
			<th>Пол</th>
			<th>Дата рожд</th>
			<th>Больница-леч. врач</th>
			<th>Дата рег.</th>
			<th>ХТ 1</th>
			<th>ХТ 2</th>
			<th>ХТ 3</th>
			<th>ХТ 4</th>
			<th>ХТ 5</th>
			<th>ХТ 6</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
	{foreach $patients as $item}
		<tr>
		<td style="font-size: medium;"><a href="edit.php?entity=patient&id={$item->id}">{$item->patient_number}</a></td>
		<td style="font-size: small;">{if $item->sex_id==1}муж{else}жен{/if}</td>
		<td style="font-size: small;">{$item->date_birth}</td>
		<td style="font-size: small;">{$item->hospital_id} - {$item->doctor}</td>
		<td style="font-size: small;">{$item->insert_date} </td>
		{foreach $item->visits as $visit_num=>$is_visit}
		<td style="font-size: small;{if $is_visit}background-color:green{/if}"><a href="edit.php?entity=therapy&exist={if $is_visit}1{else}0{/if}&patient_id={$item->id}&visit_id={$visit_num}">Визит 1</a></td>
		{/foreach}
	</tr>
	{/foreach}
	</tbody>
</table>


</div>


<p>&nbsp</p>
{include file="footer.tpl"}
</div>
</body>
</html>
