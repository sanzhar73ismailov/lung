<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="style.css">
<title>{$title}</title>
<script src="jscript/myScript.js"></script>
</head>
<body>


	<div id="wrap">
		{include file="header.tpl"}



		<div id="content">
			{* <div id="wrap">{include file="panel.tpl"} *}
			<div class="center_title">Курс ХТ: визит {$object->visit_id}</div>

			<form method="post" action="edit.php" onsubmit="return checkform(this)">
				<input type="hidden" name="do" value="save"> <input type="hidden" name="entity" value="{$entity}" /> <input type="hidden" name="patient_id" value="{$object->patient_id}" /> <input type="hidden" name="id" value="{$object->id}" /> <input type="hidden" name="visit_id" value="{$object->visit_id}" />




				<table class="form">
					{if $edit}
					<tr>
						<td><input type="submit" value="Сохранить" style="width: 120px; height: 20px"></td>
						<td class="req_input">Обязательные поля выделены этим цветом, <br /> без их заполнения данные не сохранятся!
						</td>
					</tr>
					{else}
					<tr>
						<td><a href="edit.php?entity={$entity}&id={$object->id}&patient_id={$object->patient_id}&do=edit&visit_id={$object->visit_id}"><img width="20" height="20" alt="Править" src="images/edit.jpg" /></a></td>
						<td></td>
					</tr>
					{/if}
					<td style="color: blue;">Пациент</td>
					<td style="font-size: large; font-weight: bold">{$patient->patient_number}</td>
					</tr>
					<tr>
						<td style="color: blue;">Номер визита</td>
						<td style="font-size: large; font-weight: bold">{foreach $visit_vals as $item} {if $item->id == $object->visit_id} {$item->value} {/if} {/foreach} </select></td>
					</tr>
					<tr class="tr_open_close">
						<td colspan="2">Химиотерапия</td>
					</tr>
					<tr>
						<td>Карбоплатин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_karboplatin_yes_no_id" name="chmt_karboplatin_yes_no_id" value="1" {if isset($object->chmt_karboplatin_yes_no_id) && $object->chmt_karboplatin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_karboplatin_yes_no_id" name="chmt_karboplatin_yes_no_id" value="0" {if isset($object->chmt_karboplatin_yes_no_id)
							&& $object->chmt_karboplatin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Цисплатин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_cisplatin_yes_no_id" name="chmt_cisplatin_yes_no_id" value="1" {if isset($object->chmt_cisplatin_yes_no_id) && $object->chmt_cisplatin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_cisplatin_yes_no_id" name="chmt_cisplatin_yes_no_id" value="0" {if isset($object->chmt_cisplatin_yes_no_id) &&
							$object->chmt_cisplatin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Циклофосфан (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_ciklofosfan_yes_no_id" name="chmt_ciklofosfan_yes_no_id" value="1" {if isset($object->chmt_ciklofosfan_yes_no_id) && $object->chmt_ciklofosfan_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_ciklofosfan_yes_no_id" name="chmt_ciklofosfan_yes_no_id" value="0" {if isset($object->chmt_ciklofosfan_yes_no_id)
							&& $object->chmt_ciklofosfan_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Паклитаксел (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_paklitaksel_yes_no_id" name="chmt_paklitaksel_yes_no_id" value="1" {if isset($object->chmt_paklitaksel_yes_no_id) && $object->chmt_paklitaksel_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_paklitaksel_yes_no_id" name="chmt_paklitaksel_yes_no_id" value="0" {if isset($object->chmt_paklitaksel_yes_no_id)
							&& $object->chmt_paklitaksel_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Доксорубицин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_doksorubicin_yes_no_id" name="chmt_doksorubicin_yes_no_id" value="1" {if isset($object->chmt_doksorubicin_yes_no_id) && $object->chmt_doksorubicin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_doksorubicin_yes_no_id" name="chmt_doksorubicin_yes_no_id" value="0" {if isset($object->chmt_doksorubicin_yes_no_id)
							&& $object->chmt_doksorubicin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Топотекан (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_topotekan_yes_no_id" name="chmt_topotekan_yes_no_id" value="1" {if isset($object->chmt_topotekan_yes_no_id) && $object->chmt_topotekan_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_topotekan_yes_no_id" name="chmt_topotekan_yes_no_id" value="0" {if isset($object->chmt_topotekan_yes_no_id) &&
							$object->chmt_topotekan_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Гемцитабин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_gemcitabin_yes_no_id" name="chmt_gemcitabin_yes_no_id" value="1" {if isset($object->chmt_gemcitabin_yes_no_id) && $object->chmt_gemcitabin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_gemcitabin_yes_no_id" name="chmt_gemcitabin_yes_no_id" value="0" {if isset($object->chmt_gemcitabin_yes_no_id)
							&& $object->chmt_gemcitabin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Винорельбин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_vinorelbin_yes_no_id" name="chmt_vinorelbin_yes_no_id" value="1" {if isset($object->chmt_vinorelbin_yes_no_id) && $object->chmt_vinorelbin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_vinorelbin_yes_no_id" name="chmt_vinorelbin_yes_no_id" value="0" {if isset($object->chmt_vinorelbin_yes_no_id)
							&& $object->chmt_vinorelbin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Иринотекан (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_irinotekan_yes_no_id" name="chmt_irinotekan_yes_no_id" value="1" {if isset($object->chmt_irinotekan_yes_no_id) && $object->chmt_irinotekan_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_irinotekan_yes_no_id" name="chmt_irinotekan_yes_no_id" value="0" {if isset($object->chmt_irinotekan_yes_no_id)
							&& $object->chmt_irinotekan_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Этопозид (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_jetopozid_yes_no_id" name="chmt_jetopozid_yes_no_id" value="1" {if isset($object->chmt_jetopozid_yes_no_id) && $object->chmt_jetopozid_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_jetopozid_yes_no_id" name="chmt_jetopozid_yes_no_id" value="0" {if isset($object->chmt_jetopozid_yes_no_id) &&
							$object->chmt_jetopozid_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Эпирубицин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_jepirubicin_yes_no_id" name="chmt_jepirubicin_yes_no_id" value="1" {if isset($object->chmt_jepirubicin_yes_no_id) && $object->chmt_jepirubicin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_jepirubicin_yes_no_id" name="chmt_jepirubicin_yes_no_id" value="0" {if isset($object->chmt_jepirubicin_yes_no_id)
							&& $object->chmt_jepirubicin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Доцетаксел (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_docetaksel_yes_no_id" name="chmt_docetaksel_yes_no_id" value="1" {if isset($object->chmt_docetaksel_yes_no_id) && $object->chmt_docetaksel_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_docetaksel_yes_no_id" name="chmt_docetaksel_yes_no_id" value="0" {if isset($object->chmt_docetaksel_yes_no_id)
							&& $object->chmt_docetaksel_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Оксалиплатин (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_oksaliplatin_yes_no_id" name="chmt_oksaliplatin_yes_no_id" value="1" {if isset($object->chmt_oksaliplatin_yes_no_id) && $object->chmt_oksaliplatin_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_oksaliplatin_yes_no_id" name="chmt_oksaliplatin_yes_no_id" value="0" {if isset($object->chmt_oksaliplatin_yes_no_id)
							&& $object->chmt_oksaliplatin_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Другое (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} id="chmt_other_yes_no_id" name="chmt_other_yes_no_id" value="1" {if isset($object->chmt_other_yes_no_id) && $object->chmt_other_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} id="chmt_other_yes_no_id" name="chmt_other_yes_no_id" value="0" {if isset($object->chmt_other_yes_no_id) && $object->chmt_other_yes_no_id ==
							0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Другое (описание)</td>
						<td><input {$class_req_input} type="text" {$readonly} name="chmt_other_descr" size="50" value="{$object->chmt_other_descr}" /></td>
					</tr>
					<tr>
						<td>Дата начала лечения</td>
						<td><input {$class_req_input} type="text" {$readonly} name="chmt_date_start" size="50" value="{if $object->chmt_date_start}{date('d/m/Y',strtotime($object->chmt_date_start))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
					</tr>
					<tr>
						<td>Дата окончания лечения</td>
						<td><input {$class_req_input} type="text" {$readonly} name="chmt_date_finish" size="50" value="{if $object->chmt_date_finish}{date('d/m/Y',strtotime($object->chmt_date_finish))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
					</tr>

					<tr class="tr_open_close">
						<td colspan="2">Результаты лучевой диагностики</td>
					</tr>

					<tr>
						<td class='td_label_form'>КТ</td>
						<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_kt_yes_no_id" size="50" value="1" {if isset($object->instr_kt_yes_no_id) && $object->instr_kt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_kt_yes_no_id" size="50" value="0" {if isset($object->instr_kt_yes_no_id) && $object->instr_kt_yes_no_id == 0} checked {/if}/> Дата
							<input type="text" {$readonly} name="instr_kt_date" id="instr_kt_date" size="10" value="{if isset($object->instr_kt_date)}{$object->instr_kt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input type="radio" {$disabled} name="instr_kt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_kt_norm_yes_no_id) &&
							$object->instr_kt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_kt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_kt_norm_yes_no_id) && $object->instr_kt_norm_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>

					<tr>
						<td class='td_label_form'>КТ Заключение</td>
						<td><textarea {$disabled} rows="3" cols="45" name="instr_kt_descr">{$object->instr_kt_descr}</textarea></td>
					</tr>

					<tr>
						<td class='td_label_form'>МРТ</td>
						<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_mrt_yes_no_id" size="50" value="1" {if isset($object->instr_mrt_yes_no_id) && $object->instr_mrt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_mrt_yes_no_id" size="50" value="0" {if isset($object->instr_mrt_yes_no_id) && $object->instr_mrt_yes_no_id == 0} checked {/if}/>
							Дата <input type="text" {$readonly} name="instr_mrt_date" id="instr_mrt_date" size="10" value="{if isset($object->instr_mrt_date)}{$object->instr_mrt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input type="radio" {$disabled} name="instr_mrt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_mrt_norm_yes_no_id) &&
							$object->instr_mrt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_mrt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_mrt_norm_yes_no_id) && $object->instr_mrt_norm_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td class='td_label_form'>МРТ Заключение</td>
						<td><textarea {$disabled} rows="3" cols="45" name="instr_mrt_descr">{$object->instr_mrt_descr}</textarea></td>
					</tr>

					<tr>
						<td class='td_label_form'>ПЭТ-КТ</td>
						<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_petkt_yes_no_id" size="50" value="1" {if isset($object->instr_petkt_yes_no_id) && $object->instr_petkt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_petkt_yes_no_id" size="50" value="0" {if isset($object->instr_petkt_yes_no_id) && $object->instr_petkt_yes_no_id == 0}
							checked {/if}/> Дата <input type="text" {$readonly} name="instr_petkt_date" id="instr_petkt_date" size="10" value="{if isset($object->instr_petkt_date)}{$object->instr_petkt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input type="radio" {$disabled} name="instr_petkt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_petkt_norm_yes_no_id)
							&& $object->instr_petkt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_petkt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_petkt_norm_yes_no_id) && $object->instr_petkt_norm_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td class='td_label_form'>ПЭТ-КТ Заключение</td>
						<td><textarea {$disabled} rows="3" cols="45" name="instr_petkt_descr">{$object->instr_petkt_descr}</textarea></td>
					</tr>
					
					<tr class="tr_open_close">
						<td colspan="2">Таргетная терапия</td>
					</tr>
					<tr>
						<td>таргетная терапия (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} name="targeted_therapy_yes_no_id" value="1" {if isset($object->targeted_therapy_yes_no_id) && $object->targeted_therapy_yes_no_id == 1} checked {/if}/> 
						Нет <input required type="radio" {$disabled} name="targeted_therapy_yes_no_id" value="0" {if isset($object->targeted_therapy_yes_no_id)
							&& $object->targeted_therapy_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>эрлотиниб (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} name="targeted_therapy_erlotinib_yes_no_id" value="1" {if isset($object->targeted_therapy_erlotinib_yes_no_id) && $object->targeted_therapy_erlotinib_yes_no_id == 1} checked {/if}/> 
						Нет <input required type="radio" {$disabled} name="targeted_therapy_erlotinib_yes_no_id" value="0" {if isset($object->targeted_therapy_erlotinib_yes_no_id) &&
							$object->targeted_therapy_erlotinib_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>гефитиниб (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} name="targeted_therapy_gefitinib_yes_no_id" value="1" {if isset($object->targeted_therapy_gefitinib_yes_no_id) && $object->targeted_therapy_gefitinib_yes_no_id == 1} checked {/if}/> 
						Нет <input required type="radio" {$disabled} name="targeted_therapy_gefitinib_yes_no_id" value="0" {if isset($object->targeted_therapy_gefitinib_yes_no_id)
							&& $object->targeted_therapy_gefitinib_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>кризотиниб (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} name="targeted_therapy_cryotinib_yes_no_id" value="1" {if isset($object->targeted_therapy_cryotinib_yes_no_id) && $object->targeted_therapy_cryotinib_yes_no_id == 1} checked {/if}/> 
						Нет <input required type="radio" {$disabled} name="targeted_therapy_cryotinib_yes_no_id" value="0" {if isset($object->targeted_therapy_cryotinib_yes_no_id)
							&& $object->targeted_therapy_cryotinib_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>ниволумаб (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} name="targeted_therapy_nivolumab_yes_no_id" value="1" {if isset($object->targeted_therapy_nivolumab_yes_no_id) && $object->targeted_therapy_nivolumab_yes_no_id == 1} checked {/if}/> 
						Нет <input required type="radio" {$disabled} name="targeted_therapy_nivolumab_yes_no_id" value="0" {if isset($object->targeted_therapy_nivolumab_yes_no_id)
							&& $object->targeted_therapy_nivolumab_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>другое (да, нет)</td>
						<td>Да <input required type="radio" {$disabled} name="targeted_therapy_other_yes_no_id" value="1" {if isset($object->targeted_therapy_other_yes_no_id) && $object->targeted_therapy_other_yes_no_id == 1} checked {/if}/> 
						Нет <input required type="radio" {$disabled} name="targeted_therapy_other_yes_no_id" value="0" {if isset($object->targeted_therapy_other_yes_no_id) &&
							$object->targeted_therapy_other_yes_no_id == 0} checked {/if}/>
						</td>
					</tr>
					<tr>
						<td>Если другое, укажите</td>
						<td><textarea {$disabled} rows="3" cols="45" name="targeted_therapy_descr">{$object->targeted_therapy_descr}</textarea></td>
					</tr>

					<tr class="tr_open_close">
						<td colspan="2">Нежелательные явления</td>
					</tr>
					<tr>
						<td class='td_label_form'>Нежелательные явления</td>
						<td>Да <input {$class_req_input} type="radio" {$disabled} name="side_effects_yes_no_id" size="50" value="1" {if isset($object->side_effects_yes_no_id) && $object->side_effects_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="side_effects_yes_no_id" size="50" value="0" {if isset($object->side_effects_yes_no_id) && $object->side_effects_yes_no_id ==
							0} checked {/if}/> <br />Если «да», описать подробнее с указанием даты и степени токсичности<br /> <textarea {$disabled} rows="3" cols="45" name="side_effects_descr">{$object->side_effects_descr}</textarea>
						</td>
					</tr>

					<tr class="tr_open_close">
						<td colspan="2">Лабораторные исследования перед химиотерапией</td>
					</tr>
					<tr>
						<td>Гемоглобин</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="hb_before_ct" size="10" value="{$object->hb_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="hb_before_ct_date" id="hb_before_ct_date" size="10" value="{if isset($object->hb_before_ct_date)}{$object->hb_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>Эритроциты</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="erythrocytes_before_ct" size="10" value="{$object->erythrocytes_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="erythrocytes_before_ct_date" id="erythrocytes_before_ct_date" size="10" value="{if isset($object->erythrocytes_before_ct_date)}{$object->erythrocytes_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>Лейкоциты</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="leuc_before_ct" size="10" value="{$object->leuc_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="leuc_before_ct_date" id="leuc_before_ct_date" size="10" value="{if isset($object->leuc_before_ct_date)}{$object->leuc_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>Тромбоциты</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="tromb_before_ct" size="10" value="{$object->tromb_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="tromb_before_ct_date" id="tromb_before_ct_date" size="10" value="{if isset($object->tromb_before_ct_date)}{$object->tromb_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>нейтрофилы</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="neutr_before_ct" size="10" value="{$object->neutr_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="neutr_before_ct_date" id="neutr_before_ct_date" size="10" value="{if isset($object->neutr_before_ct_date)}{$object->neutr_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>Общий белок</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="gen_prot_before_ct" size="10" value="{$object->gen_prot_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="gen_prot_before_ct_date" id="gen_prot_before_ct_date" size="10" value="{if isset($object->gen_prot_before_ct_date)}{$object->gen_prot_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>АСТ</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="ast_before_ct" size="10" value="{$object->ast_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="ast_before_ct_date" id="ast_before_ct_date" size="10" value="{if isset($object->ast_before_ct_date)}{$object->ast_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>АЛТ</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="alt_before_ct" size="10" value="{$object->alt_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="alt_before_ct_date" id="alt_before_ct_date" size="10" value="{if isset($object->alt_before_ct_date)}{$object->alt_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>билирубин</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="bilirubin_before_ct" size="10" value="{$object->bilirubin_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="bilirubin_before_ct_date" id="bilirubin_before_ct_date" size="10" value="{if isset($object->bilirubin_before_ct_date)}{$object->bilirubin_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>Креатинин</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="creat_before_ct" size="10" value="{$object->creat_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="creat_before_ct_date" id="creat_before_ct_date" size="10" value="{if isset($object->creat_before_ct_date)}{$object->creat_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					<tr>
						<td>Мочевина</td>
						<td>
						Результат <input {$class_req_input} type="text" {$readonly} name="urea_before_ct" size="10" value="{$object->urea_before_ct}" /> 
						Дата проведения <input type="text" {$readonly} name="urea_before_ct_date" id="urea_before_ct_date" size="10" value="{if isset($object->urea_before_ct_date)}{$object->urea_before_ct_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
						</td>
					</tr>
					
					<tr>
						<td>Нейротоксичность</td>
						<td>Да <input {$class_req_input} type="radio" {$disabled} name="neurotoxicity_yes_no_id" size="50" value="1" {if isset($object->neurotoxicity_yes_no_id) && $object->neurotoxicity_yes_no_id == 1} checked {/if}/> 
						Нет <input {$class_req_input} type="radio" {$disabled} name="neurotoxicity_yes_no_id" size="50" value="0" {if isset($object->neurotoxicity_yes_no_id) && $object->neurotoxicity_yes_no_id == 0} checked {/if}/> <br />
							Если «да», степень токсичности
							<select {$class_req_input} {$disabled} name="neurotoxicity_level_id">
									<option></option> {foreach $neurotoxicity_level_vals as $item}
									<option {if $item->id == $object->neurotoxicity_level_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select>
						</td>
					</tr>
					<tr>
						<td>Кожная токсичность</td>
						<td>Да <input {$class_req_input} type="radio" {$disabled} name="skin_toxicity_yes_no_id" size="50" value="1" {if isset($object->skin_toxicity_yes_no_id) && $object->skin_toxicity_yes_no_id == 1} checked {/if}/> 
						Нет <input {$class_req_input} type="radio" {$disabled} name="skin_toxicity_yes_no_id" size="50" value="0" {if isset($object->skin_toxicity_yes_no_id) && $object->skin_toxicity_yes_no_id == 0} checked {/if}/> <br />
							Если «да», степень токсичности
							<select {$class_req_input} {$disabled} name="skin_toxicity_level_id">
									<option></option> {foreach $skin_toxicity_level_vals as $item}
									<option {if $item->id == $object->skin_toxicity_level_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select>
						</td>
					</tr>
					

					

					{* *} {if $edit}
					<tr>
						<td><input type="submit" value="Сохранить" style="width: 120px; height: 20px"></td>
						<td><input type="reset" value="Сброс" style="width: 120px; height: 20px"></td>
					</tr>
					{/if}

				</table>

			</form>

		</div>

		{include file="footer.tpl"}
	</div>

</body>
</html>
