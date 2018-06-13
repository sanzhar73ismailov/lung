<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="style.css">
<title>{$title}</title>
<script src="jscript/myScript.js"></script>
</head>
<body>


<div id="wrap">{include file="header.tpl"}



<div id="content">
{* <div id="wrap">{include file="panel.tpl"} *}
<div class="center_title">Курс ХТ: визит {$object->visit_id}</div>

<form method="post" action="edit.php" onsubmit="return checkform(this)">
<input type="hidden" name="do" value="save"> 
<input type="hidden" name="entity" value="{$entity}" /> 
<input type="hidden" name="patient_id" value="{$object->patient_id}" /> 
<input type="hidden" name="id" value="{$object->id}" />
<input type="hidden" name="visit_id" value="{$object->visit_id}" />




<table class="form">
	{if $edit}
	<tr>
		<td><input type="submit" value="Сохранить"
			style="width: 120px; height: 20px"></td>
		<td class="req_input">Обязательные поля выделены этим цветом, <br />
		без их заполнения данные не сохранятся!</td>
	</tr>
	{else}
	<tr>
		<td><a
			href="edit.php?entity={$entity}&id={$object->id}&patient_id={$object->patient_id}&do=edit&visit_id={$object->visit_id}"><img
			width="20" height="20" alt="Править" src="images/edit.jpg" /></a></td>
		<td></td>
	</tr>
	{/if}
	<td style="color:blue;">Пациент</td>
	<td style="font-size: large; font-weight: bold">{$patient->patient_number}</td>
	</tr>
	<tr>
		<td style="color:blue;">Номер визита</td>
		<td style="font-size: large; font-weight: bold">
			{foreach $visit_vals as $item}
			{if $item->id == $object->visit_id} {$item->value} {/if}
			{/foreach}
		</select></td>
	</tr>
	<tr class="tr_open_close"><td colspan="2">Химиотерапия</td></tr>
	<tr>
		<td>Карбоплатин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_karboplatin_id" name="chmt_karboplatin_id" value="1" {if isset($object->chmt_karboplatin_id) && $object->chmt_karboplatin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_karboplatin_id" name="chmt_karboplatin_id" value="0" {if isset($object->chmt_karboplatin_id) && $object->chmt_karboplatin_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Цисплатин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_cisplatin_id" name="chmt_cisplatin_id" value="1" {if isset($object->chmt_cisplatin_id) && $object->chmt_cisplatin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_cisplatin_id" name="chmt_cisplatin_id" value="0" {if isset($object->chmt_cisplatin_id) && $object->chmt_cisplatin_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Циклофосфан (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_ciklofosfan_id" name="chmt_ciklofosfan_id" value="1" {if isset($object->chmt_ciklofosfan_id) && $object->chmt_ciklofosfan_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_ciklofosfan_id" name="chmt_ciklofosfan_id" value="0" {if isset($object->chmt_ciklofosfan_id) && $object->chmt_ciklofosfan_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Паклитаксел (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_paklitaksel_id" name="chmt_paklitaksel_id" value="1" {if isset($object->chmt_paklitaksel_id) && $object->chmt_paklitaksel_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_paklitaksel_id" name="chmt_paklitaksel_id" value="0" {if isset($object->chmt_paklitaksel_id) && $object->chmt_paklitaksel_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Доксорубицин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_doksorubicin_id" name="chmt_doksorubicin_id" value="1" {if isset($object->chmt_doksorubicin_id) && $object->chmt_doksorubicin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_doksorubicin_id" name="chmt_doksorubicin_id" value="0" {if isset($object->chmt_doksorubicin_id) && $object->chmt_doksorubicin_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Топотекан (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_topotekan_id" name="chmt_topotekan_id" value="1" {if isset($object->chmt_topotekan_id) && $object->chmt_topotekan_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_topotekan_id" name="chmt_topotekan_id" value="0" {if isset($object->chmt_topotekan_id) && $object->chmt_topotekan_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Гемцитабин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_gemcitabin_id" name="chmt_gemcitabin_id" value="1" {if isset($object->chmt_gemcitabin_id) && $object->chmt_gemcitabin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_gemcitabin_id" name="chmt_gemcitabin_id" value="0" {if isset($object->chmt_gemcitabin_id) && $object->chmt_gemcitabin_id == 0} checked {/if}/>
		</td>
	</tr>
	<tr>
		<td>Винорельбин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_vinorelbin_id" name="chmt_vinorelbin_id" value="1" {if isset($object->chmt_vinorelbin_id) && $object->chmt_vinorelbin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_vinorelbin_id" name="chmt_vinorelbin_id" value="0" {if isset($object->chmt_vinorelbin_id) && $object->chmt_vinorelbin_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Иринотекан (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_irinotekan_id" name="chmt_irinotekan_id" value="1" {if isset($object->chmt_irinotekan_id) && $object->chmt_irinotekan_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_irinotekan_id" name="chmt_irinotekan_id" value="0" {if isset($object->chmt_irinotekan_id) && $object->chmt_irinotekan_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Этопозид (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_jetopozid_id" name="chmt_jetopozid_id" value="1" {if isset($object->chmt_jetopozid_id) && $object->chmt_jetopozid_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_jetopozid_id" name="chmt_jetopozid_id" value="0" {if isset($object->chmt_jetopozid_id) && $object->chmt_jetopozid_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Эпирубицин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_jepirubicin_id" name="chmt_jepirubicin_id" value="1" {if isset($object->chmt_jepirubicin_id) && $object->chmt_jepirubicin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_jepirubicin_id" name="chmt_jepirubicin_id" value="0" {if isset($object->chmt_jepirubicin_id) && $object->chmt_jepirubicin_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Доцетаксел (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_docetaksel_id" name="chmt_docetaksel_id" value="1" {if isset($object->chmt_docetaksel_id) && $object->chmt_docetaksel_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_docetaksel_id" name="chmt_docetaksel_id" value="0" {if isset($object->chmt_docetaksel_id) && $object->chmt_docetaksel_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Оксалиплатин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_oksaliplatin_id" name="chmt_oksaliplatin_id" value="1" {if isset($object->chmt_oksaliplatin_id) && $object->chmt_oksaliplatin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_oksaliplatin_id" name="chmt_oksaliplatin_id" value="0" {if isset($object->chmt_oksaliplatin_id) && $object->chmt_oksaliplatin_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Трабектедин (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_trabektedin_id" name="chmt_trabektedin_id" value="1" {if isset($object->chmt_trabektedin_id) && $object->chmt_trabektedin_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_trabektedin_id" name="chmt_trabektedin_id" value="0" {if isset($object->chmt_trabektedin_id) && $object->chmt_trabektedin_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Другое (да, нет)</td>
		<td>
		Да <input required type="radio" {$disabled} id="chmt_other_id" name="chmt_other_id" value="1" {if isset($object->chmt_other_id) && $object->chmt_other_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="chmt_other_id" name="chmt_other_id" value="0" {if isset($object->chmt_other_id) && $object->chmt_other_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Другое (описание)</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="chmt_other_descr" size="50"
			value="{$object->chmt_other_descr}" /></td>
	</tr>
	<tr>
		<td>Дата начала лечения</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="chmt_date_start" size="50"
			value="{if $object->chmt_date_start}{date('d/m/Y',strtotime($object->chmt_date_start))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Дата окончания лечения</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="chmt_date_finish" size="50"
			value="{if $object->chmt_date_finish}{date('d/m/Y',strtotime($object->chmt_date_finish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr class="tr_open_close"><td colspan="2">Лабораторные исследования после химиотерапии</td></tr>
	<tr>
		<td>Гемоглобин</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_afterchmt_hb" size="50"
			value="{$object->diaganem_afterchmt_hb}" /></td>
	</tr>
	<tr>
		<td>Дата проведения
		гемоглобина</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_afterchmt_hb_date" size="50"
			value="{if $object->diaganem_afterchmt_hb_date}{date('d/m/Y',strtotime($object->diaganem_afterchmt_hb_date))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Эритроциты</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_afterchmt_erythrocytes" size="50"
			value="{$object->diaganem_afterchmt_erythrocytes}" /></td>
	</tr>
	<tr>
		<td>Дата проведения
		Эритроциты</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_afterchmt_lab_erythrocytes_date" size="50"
			value="{if $object->diaganem_afterchmt_lab_erythrocytes_date}{date('d/m/Y',strtotime($object->diaganem_afterchmt_lab_erythrocytes_date))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr class="tr_open_close"><td colspan="2">Эпоэтины</td></tr>
	<tr>
		<td>да, нет</td>
		<td>
		Да <input required type="radio" {$disabled} id="epoetin_yes_no_id" name="epoetin_yes_no_id" value="1" {if isset($object->epoetin_yes_no_id) && $object->epoetin_yes_no_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="epoetin_yes_no_id" name="epoetin_yes_no_id" value="0" {if isset($object->epoetin_yes_no_id) && $object->epoetin_yes_no_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Эпрекс 40K (дата начала)</td>
		<td><input type="text"
			{$readonly} name="epoetin_eprex40k_dstart" size="50"
			value="{if $object->epoetin_eprex40k_dstart}{date('d/m/Y',strtotime($object->epoetin_eprex40k_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Эпрекс 40K (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="epoetin_eprex40k_dfinish" size="50"
			value="{if $object->epoetin_eprex40k_dfinish}{date('d/m/Y',strtotime($object->epoetin_eprex40k_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" " /></td>
	</tr>
	<tr>
		<td>Эпрекс 40K лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="epoetin_eprex40k_trfinish_yes_no_id">
			<option></option>
			{foreach $epoetin_eprex40k_trfinish_yes_no_vals as $item}
			<option {if $item->id ==
			$object->epoetin_eprex40k_trfinish_yes_no_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Эпрекс 40K лечение - причина прекращения</td>
		<td><select
			{$disabled} name="epoetin_eprex40k_trfinish_cause_id">
			<option></option>
			{foreach $epoetin_eprex40k_trfinish_cause_vals as $item}
			<option {if $item->id == $object->epoetin_eprex40k_trfinish_cause_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Эпрекс 2K 5ML (дата начала)</td>
		<td><input type="text"
			{$readonly} name="epoetin_eprex2k5ML_dstart" size="50"
			value="{if $object->epoetin_eprex2k5ML_dstart}{date('d/m/Y',strtotime($object->epoetin_eprex2k5ML_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"/></td>
	</tr>
	<tr>
		<td>Эпрекс 2K 5ML (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="epoetin_eprex2k5ML_dfinish" size="50"
			value="{if $object->epoetin_eprex2k5ML_dfinish}{date('d/m/Y',strtotime($object->epoetin_eprex2k5ML_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Эпрекс 2K 5ML лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="epoetin_eprex2k5ML_trfinish_yes_no_id">
			<option></option>
			{foreach $epoetin_eprex2k5ML_trfinish_yes_no_vals as $item}
			<option {if $item->id ==
			$object->epoetin_eprex2k5ML_trfinish_yes_no_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Эпрекс 2K 5ML лечение - причина прекращения</td>
		<td><select
			{$disabled} name="epoetin_eprex2k5ML_trfinish_cause_id">
			<option></option>
			{foreach $epoetin_eprex2k5ML_trfinish_cause_vals as $item}
			<option {if $item->id ==
			$object->epoetin_eprex2k5ML_trfinish_cause_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Рекормон 2000IU (дата начала)</td>
		<td><input type="text"
			{$readonly} name="epoetin_rekormon_dstart" size="50"
			value="{if $object->epoetin_rekormon_dstart}{date('d/m/Y',strtotime($object->epoetin_rekormon_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Рекормон 2000IU (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="epoetin_rekormon_dfinish" size="50"
			value="{if $object->epoetin_rekormon_dfinish}{date('d/m/Y',strtotime($object->epoetin_rekormon_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
	</tr>
	<tr>
		<td>Рекормон 2000IU лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="epoetin_rekormon_trfinish_yes_no_id">
			<option></option>
			{foreach $epoetin_rekormon_trfinish_yes_no_vals as $item}
			<option {if $item->id ==
			$object->epoetin_rekormon_trfinish_yes_no_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Рекормон 2000IU лечение - причина прекращения</td>
		<td><select
			{$disabled} name="epoetin_rekormon_trfinish_cause_id">
			<option></option>
			{foreach $epoetin_rekormon_trfinish_cause_vals as $item}
			<option {if $item->id == $object->epoetin_rekormon_trfinish_cause_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Другой препарат наименование</td>
		<td><input type="text"
			{$readonly} name="epoetin_other_name" size="50"
			value="{$object->epoetin_other_name}" /></td>
	</tr>
	<tr>
		<td>Другой препарат (дата начала)</td>
		<td><input type="text"
			{$readonly} name="epoetin_other_dstart" size="50"
			value="{if $object->epoetin_other_dstart}{date('d/m/Y',strtotime($object->epoetin_other_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Другой препарат (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="epoetin_other_dfinish" size="50"
			value="{if $object->epoetin_other_dfinish}{date('d/m/Y',strtotime($object->epoetin_other_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Другой препарат лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="epoetin_other_trfinish_yes_no_id">
			<option></option>
			{foreach $epoetin_other_trfinish_yes_no_vals as $item}
			<option {if $item->id == $object->epoetin_other_trfinish_yes_no_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Другой препарат лечение - причина прекращения</td>
		<td><select
			{$disabled} name="epoetin_other_trfinish_cause_id">
			<option></option>
			{foreach $epoetin_other_trfinish_cause_vals as $item}
			<option {if $item->id == $object->epoetin_other_trfinish_cause_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr class="tr_open_close"><td colspan="2">Терапия препаратами железа</td></tr>
	<tr>
		<td>да, нет</td>
		<td>
		Да <input required type="radio" {$disabled} id="ferrum_yes_no_id" name="ferrum_yes_no_id" value="1" {if isset($object->ferrum_yes_no_id) && $object->ferrum_yes_no_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="ferrum_yes_no_id" name="ferrum_yes_no_id" value="0" {if isset($object->ferrum_yes_no_id) && $object->ferrum_yes_no_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>дата начала</td>
		<td><input type="text"
			{$readonly} name="ferrum_dstart" size="50"
			value="{if $object->ferrum_dstart}{date('d/m/Y',strtotime($object->ferrum_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>дата завершения</td>
		<td><input type="text"
			{$readonly} name="ferrum_dfinish" size="50"
			value="{if $object->ferrum_dfinish}{date('d/m/Y',strtotime($object->ferrum_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
	</tr>
	<tr class="tr_open_close"><td colspan="2">Другие препараты для коррекции анемии, не эпоэтины</td></tr>
	<tr>
		<td>да, нет</td>
		<td>
		Да <input required type="radio" {$disabled} id="notepoetin_yes_no_id" name="notepoetin_yes_no_id" value="1" {if isset($object->notepoetin_yes_no_id) && $object->notepoetin_yes_no_id == 1} checked {/if}/>
        Нет <input required type="radio" {$disabled} id="notepoetin_yes_no_id" name="notepoetin_yes_no_id" value="0" {if isset($object->notepoetin_yes_no_id) && $object->notepoetin_yes_no_id == 0} checked {/if}/>
        </td>
	</tr>
	<tr>
		<td>Препарат 1 - наименование</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug1_name" size="50"
			value="{$object->notepoetin_drug1_name}" /></td>
	</tr>
	<tr>
		<td>Препарат 1 (дата начала)</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug1_dstart" size="50"
			value="{if $object->notepoetin_drug1_dstart}{date('d/m/Y',strtotime($object->notepoetin_drug1_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Препарат 1 (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug1_dfinish" size="50"
			value="{if $object->notepoetin_drug1_dfinish}{date('d/m/Y',strtotime($object->notepoetin_drug1_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Препарат 1 лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="notepoetin_drug1_trfinish_yes_no_id">
			<option></option>
			{foreach $notepoetin_drug1_trfinish_yes_no_vals as $item}
			<option {if $item->id ==
			$object->notepoetin_drug1_trfinish_yes_no_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Препарат 1 лечение - причина прекращения</td>
		<td><select
			{$disabled} name="notepoetin_drug1_trfinish_cause_id">
			<option></option>
			{foreach $notepoetin_drug1_trfinish_cause_vals as $item}
			<option {if $item->id == $object->notepoetin_drug1_trfinish_cause_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Препарат 2 - наименование</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug2_name" size="50"
			value="{$object->notepoetin_drug2_name}" /></td>
	</tr>
	<tr>
		<td>Препарат 2 (дата начала)</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug2_dstart" size="50"
			value="{if $object->notepoetin_drug2_dstart}{date('d/m/Y',strtotime($object->notepoetin_drug2_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Препарат 2 (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug2_dfinish" size="50"
			value="{if $object->notepoetin_drug2_dfinish}{date('d/m/Y',strtotime($object->notepoetin_drug2_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Препарат 2 лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="notepoetin_drug2_trfinish_yes_no_id">
			<option></option>
			{foreach $notepoetin_drug2_trfinish_yes_no_vals as $item}
			<option {if $item->id ==
			$object->notepoetin_drug2_trfinish_yes_no_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Препарат 2 лечение - причина прекращения</td>
		<td><select
			{$disabled} name="notepoetin_drug2_trfinish_cause_id">
			<option></option>
			{foreach $notepoetin_drug2_trfinish_cause_vals as $item}
			<option {if $item->id == $object->notepoetin_drug2_trfinish_cause_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Препарат 3 - наименование</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug3_name" size="50"
			value="{$object->notepoetin_drug3_name}" /></td>
	</tr>
	<tr>
		<td>Препарат 3 (дата начала)</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug3_dstart" size="50"
			value="{if $object->notepoetin_drug3_dstart}{date('d/m/Y',strtotime($object->notepoetin_drug3_dstart))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Препарат 3 (дата завершения)</td>
		<td><input type="text"
			{$readonly} name="notepoetin_drug3_dfinish" size="50"
			value="{if $object->notepoetin_drug3_dfinish}{date('d/m/Y',strtotime($object->notepoetin_drug3_dfinish))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Препарат 3 лечение прекращено (да, нет)</td>
		<td><select
			{$disabled} name="notepoetin_drug3_trfinish_yes_no_id">
			<option></option>
			{foreach $notepoetin_drug3_trfinish_yes_no_vals as $item}
			<option {if $item->id ==
			$object->notepoetin_drug3_trfinish_yes_no_id} selected="selected"
			{/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr>
		<td>Препарат 3 лечение - причина прекращения</td>
		<td><select
			{$disabled} name="notepoetin_drug3_trfinish_cause_id">
			<option></option>
			{foreach $notepoetin_drug3_trfinish_cause_vals as $item}
			<option {if $item->id == $object->notepoetin_drug3_trfinish_cause_id}
			selected="selected" {/if} value="{$item->id}">{$item->value}</option>
			{/foreach}
		</select></td>
	</tr>
	<tr class="tr_open_close"><td colspan="2">Лабораторные исследования после коррекции</td></tr>
	<tr>
		<td>Гемоглобин</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_after_correct_hb" size="50"
			value="{$object->diaganem_after_correct_hb}" /></td>
	</tr>
	<tr>
		<td>Дата проведения
		гемоглобина</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_after_correct_hb_date" size="50"
			value="{if $object->diaganem_after_correct_hb_date}{date('d/m/Y',strtotime($object->diaganem_after_correct_hb_date))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
	<tr>
		<td>Эритроциты</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_after_correct_erythrocytes" size="50"
			value="{$object->diaganem_after_correct_erythrocytes}" /></td>
	</tr>
	<tr>
		<td>Дата проведения
		Эритроциты</td>
		<td><input {$class_req_input} type="text"
			{$readonly} name="diaganem_after_correct_lab_erythrocytes_date"
			size="50"
			value="{if $object->diaganem_after_correct_lab_erythrocytes_date}{date('d/m/Y',strtotime($object->diaganem_after_correct_lab_erythrocytes_date))}{/if}"
			onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"  /></td>
	</tr>
 {* *}
	{if $edit}
	<tr>
		<td><input type="submit" value="Сохранить"
			style="width: 120px; height: 20px"></td>
		<td><input type="reset" value="Сброс"
			style="width: 120px; height: 20px"></td>
	</tr>
	{/if}

</table>

</form>

</div>

{include file="footer.tpl"}</div>

</body>
</html>
