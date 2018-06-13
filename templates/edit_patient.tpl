<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="style.css">
<link rel="stylesheet" type="text/css" href="jquery-ui.min.css">
<title>{$title}</title> {include file="js_include.tpl"}
<script type="text/javascript">
/*
$(function() {
   
    var availableDoctorTags = [
                               {$doctorNames}
                         ];
    $( "#doctor" ).autocomplete({
        source: availableDoctorTags
      });
    var availableHospitalTags = [
                               {$hospitalNames}
                         ];
    $( "#hospital" ).autocomplete({
        source: availableHospitalTags
      });
    
  });
  */
  </script>
</head>
<body>


	<div id="wrap">
		{include file="header.tpl"}
		<div id="content">
			<div id="wrap">
				{include file="panel.tpl"}
				<div class="center_title">Пациент</div>

				<form method="post" action="edit.php" onsubmit="return checkform(this)">
					<input type="hidden" name="do" value="save" /> <input type="hidden" name="entity" value="{$entity}" />

					<table class="form">
						{if $edit}
						<tr>
							<td><input type="submit" value="Сохранить" style="width: 120px; height: 20px"></td>
							<td class="req_input">Обязательные поля выделены этим цветом, <br /> без их заполнения данные не сохранятся!
							</td>
						</tr>
						{else}
						<tr>
							<td><a href="edit.php?entity={$entity}&id={$object->id}&do=edit"> <img width="20" height="20" alt="Править" src="images/edit.jpg" /></a></td>
							<td></td>
						</tr>
						{/if}
						<tr style="display: none;">
							<td>ID записи</td>
							<td>{if $object->id} {$object->id} {else}
								<div style="background-color: #d14836">Новый</div> {/if}
							</td>
							<input type="hidden" name="investigation_id" value="1" />
							<input type="hidden" name="id" value="{$object->id}" />
						</tr>
						<tr>
							<td>Номер пациента</td>
							<td><input {$class_req_input} type="text" {$readonly} name="patient_number" size="50" value="{$object->patient_number}" /></td>
						</tr>
						<tr>
							<td>Медицинский центр</td>
							<td><select {$class_req_input} {$disabled} name="hospital_id">
									<option></option> {foreach $hospital_vals as $item}
									<option {if $item->id == $object->hospital_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>Дата включения в исследование (дд/мм/гггг)</td>
							<td><input {$class_req_input} type="text" {$readonly} name="date_start_invest" id="date_start_invest" size="50" value="{if $object->date_start_invest}{date('d/m/Y',strtotime($object->date_start_invest))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
						</tr>
						<tr>
							<td>ФИО врача</td>
							<td><input id="doctor" {$class_req_input} type="text" {$readonly} name="doctor" size="50" value="{$object->doctor}" /></td>
						</tr>
						<tr class="tr_open_close">
							<td colspan="2">Критерии включения</td>
						</tr>
						<tr>
							<td>Пациент 18 лет и старше, с впервые<br />в жизни выявленным НМРЛ в 2015-2016 г.г. (да, нет)
							</td>
							<td>Да <input required type="radio" {$disabled} name="inclusion_criteria_years_more18_yes_no_id" value="1" {if isset($object->inclusion_criteria_years_more18_yes_no_id) && $object->inclusion_criteria_years_more18_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="inclusion_criteria_years_more18_yes_no_id" value="0" {if isset($object->inclusion_criteria_years_more18_yes_no_id)
								&& $object->inclusion_criteria_years_more18_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td>Диагноз НМРЛ подтвержден гистологически (да, нет)</td>
							<td>Да <input required type="radio" {$disabled} name="inclusion_criteria_diag_conf_histo_yes_no_id" value="1" {if isset($object->inclusion_criteria_diag_conf_histo_yes_no_id) && $object->inclusion_criteria_diag_conf_histo_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="inclusion_criteria_diag_conf_histo_yes_no_id" value="0" {if isset($object->inclusion_criteria_diag_conf_histo_yes_no_id)
								&& $object->inclusion_criteria_diag_conf_histo_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td>Диагноз НМРЛ подтвержден цитологически (да, нет)</td>
							<td>Да <input required type="radio" {$disabled} name="inclusion_criteria_diag_conf_cyto_yes_no_id" value="1" {if isset($object->inclusion_criteria_diag_conf_cyto_yes_no_id) && $object->inclusion_criteria_diag_conf_cyto_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="inclusion_criteria_diag_conf_cyto_yes_no_id" value="0" {if isset($object->inclusion_criteria_diag_conf_cyto_yes_no_id)
								&& $object->inclusion_criteria_diag_conf_cyto_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td>Диагноз выставлен на основе<br />клинико-рентгенологических данных (да, нет)
							</td>
							<td>Да <input required type="radio" {$disabled} name="inclusion_criteria_diag_conf_clin_radio_yes_no_id" value="1" {if isset($object->inclusion_criteria_diag_conf_clin_radio_yes_no_id) && $object->inclusion_criteria_diag_conf_clin_radio_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="inclusion_criteria_diag_conf_clin_radio_yes_no_id" value="0" {if
								isset($object->inclusion_criteria_diag_conf_clin_radio_yes_no_id) && $object->inclusion_criteria_diag_conf_clin_radio_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td>Пациент, получавший любой вид <br />противоопухолевой терапии в 2015-2017 г.г. <br />(хирургический, химиотерапевтический, таргетрная терапия, лучевая терапия) (да, нет)
							</td>
							<td>Да <input required type="radio" {$disabled} name="inclusion_criteria_got_antitumor_therapy_yes_no_id" value="1" {if isset($object->inclusion_criteria_got_antitumor_therapy_yes_no_id) && $object->inclusion_criteria_got_antitumor_therapy_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="inclusion_criteria_got_antitumor_therapy_yes_no_id" value="0" {if
								isset($object->inclusion_criteria_got_antitumor_therapy_yes_no_id) && $object->inclusion_criteria_got_antitumor_therapy_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr class="tr_open_close">
							<td colspan="2">Критерии исключения</td>
						</tr>
						<tr>
							<td>Пациенты с впервые выявленным НМРЛ,<br />но не получившие ни один из видов противоопухолевой терапии<br />из-за наличия сопутствующей патологии или взятые на учет посмертно (да, нет)
							</td>
							<td>Да <input required type="radio" {$disabled} name="exclusion_criteria_not_got_antitumor_therapy_yes_no_id" value="1" {if isset($object->exclusion_criteria_not_got_antitumor_therapy_yes_no_id) && $object->exclusion_criteria_not_got_antitumor_therapy_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="exclusion_criteria_not_got_antitumor_therapy_yes_no_id"
								value="0" {if isset($object->exclusion_criteria_not_got_antitumor_therapy_yes_no_id) && $object->exclusion_criteria_not_got_antitumor_therapy_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr class="tr_open_close">
							<td colspan="2">Данные пациента</td>
						</tr>
						<tr>
							<td>Дата рождения (дд/мм/гггг)</td>
							<td><input {$class_req_input} type="text" {$readonly} name="date_birth" id="date_birth" size="50" value="{if $object->date_birth}{date('d/m/Y',strtotime($object->date_birth))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
						</tr>
						<tr>
							<td>Пол</td>
							<td><select {$class_req_input} {$disabled} name="sex_id">
									<option></option> {foreach $sex_vals as $item}
									<option {if $item->id == $object->sex_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>Место жительства</td>
							<td><select {$class_req_input} {$disabled} name="place_living_id">
									<option></option> {foreach $place_living_vals as $item}
									<option {if $item->id == $object->place_living_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>Социальный статус</td>
							<td><select {$class_req_input} {$disabled} name="social_status_id">
									<option></option> {foreach $social_status_vals as $item}
									<option {if $item->id == $object->social_status_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>

						<tr>
							<td>Дата постановки диагноза рак (дд/мм/гггг)</td>
							<td><input {$class_req_input} type="text" {$readonly} name="diag_cancer_estab_date" id="diag_cancer_estab_date" size="50" value="{if $object->diag_cancer_estab_date}{date('d/m/Y',strtotime($object->diag_cancer_estab_date))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
						</tr>
						<tr>
							<td>Цитологическое заключение</td>
							<td><textarea {$disabled} rows="3" cols="45" name="cytologic_conclusion" id="cytologic_conclusion">{$object->cytologic_conclusion}</textarea></td>
						</tr>
						<tr>
							<td>Гистологический тип опухоли</td>
							<td><input id="diag_cancer_histotype" {$class_req_input} type="text" {$readonly} name="diag_cancer_histotype" size="50" value="{$object->diag_cancer_histotype}" /></td>
						</tr>
						<tr>
							<td>Степень злокачественности</td>
							<td><select {$class_req_input} {$disabled} name="diag_cancer_degree_malignancy_id">
									<option></option> {foreach $diag_cancer_degree_malignancy_vals as $item}
									<option {if $item->id == $object->diag_cancer_degree_malignancy_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>Иммуногистохимическое исследование</td>
							<td><select {$class_req_input} {$disabled} name="immunohistochemical_study_id">
									<option></option> {foreach $immunohistochemical_study_vals as $item}
									<option {if $item->id == $object->immunohistochemical_study_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>Иммуногистохимическое исследование: описание</td>
							<td><textarea {$disabled} rows="3" cols="45" name="immunohistochemical_study_descr" id="immunohistochemical_study_descr">{$object->immunohistochemical_study_descr}</textarea></td>
						</tr>
						<tr>
							<td>Генетические исследования (да, нет)</td>
							<td>Да <input required type="radio" {$disabled} name="genetic_study_yes_no_id" value="1" {if isset($object->genetic_study_yes_no_id) && $object->genetic_study_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="genetic_study_yes_no_id" value="0" {if isset($object->genetic_study_yes_no_id) && $object->genetic_study_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td>FISH результат</td>
							<td><textarea {$disabled} rows="3" cols="45" name="genetic_study_fish" id="genetic_study_fish">{$object->genetic_study_fish}</textarea></td>
						</tr>
						<tr>
							<td>ПЦР результат</td>
							<td><textarea {$disabled} rows="3" cols="45" name="genetic_study_pcr" id="genetic_study_pcr">{$object->genetic_study_pcr}</textarea></td>
						</tr>
						<td>Стадия заболевания по системе TNM</td>
						<td>

							<table>
								<tr>
									<td>T - <select {$class_req_input} {$disabled} name="diag_cancer_tnm_stage_t_id">
											<option></option> {foreach $diag_cancer_tnm_stage_t_vals as $item}
											<option {if $item->id == $object->diag_cancer_tnm_stage_t_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
									</select>
									</td>
									<td>N - <select {$class_req_input} {$disabled} name="diag_cancer_tnm_stage_n_id">
											<option></option> {foreach $diag_cancer_tnm_stage_n_vals as $item}
											<option {if $item->id == $object->diag_cancer_tnm_stage_n_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
									</select></td>
									<td>M - <select {$class_req_input} {$disabled} name="diag_cancer_tnm_stage_m_id">
											<option></option> {foreach $diag_cancer_tnm_stage_m_vals as $item}
											<option {if $item->id == $object->diag_cancer_tnm_stage_m_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
									</select></td>
								</tr>
							</table>
						</td>
						</tr>
						<tr>
							<td>Клиническая стадия заболевания</td>
							<td><select {$class_req_input} {$disabled} name="diag_cancer_clin_stage_id">
									<option></option> {foreach $diag_cancer_clin_stage_vals as $item}
									<option {if $item->id == $object->diag_cancer_clin_stage_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>ECOG статус</td>
							<td><select {$class_req_input} {$disabled} name="diag_cancer_ecog_status_id">
									<option></option> {foreach $diag_cancer_ecog_status_vals as $item}
									<option {if $item->id == $object->diag_cancer_ecog_status_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr class="tr_open_close">
							<td colspan="2">Инструментальные исследования</td>
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
							<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_mrt_yes_no_id" size="50" value="1" {if isset($object->instr_mrt_yes_no_id) && $object->instr_mrt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_mrt_yes_no_id" size="50" value="0" {if isset($object->instr_mrt_yes_no_id) && $object->instr_mrt_yes_no_id == 0} checked
								{/if}/> Дата <input type="text" {$readonly} name="instr_mrt_date" id="instr_mrt_date" size="10" value="{if isset($object->instr_mrt_date)}{$object->instr_mrt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input type="radio" {$disabled} name="instr_mrt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_mrt_norm_yes_no_id)
								&& $object->instr_mrt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_mrt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_mrt_norm_yes_no_id) && $object->instr_mrt_norm_yes_no_id == 0} checked {/if}/>
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
							<td colspan="2">Лучевая терапия</td>
						</tr>
						<tr>
							<td>Лучевая терапия да/нет</td>
							<td>Да <input required type="radio" {$disabled} name="instr_radiotherapy_yes_no_id" value="1" {if isset($object->instr_radiotherapy_yes_no_id) && $object->instr_radiotherapy_yes_no_id == 1} checked {/if}/> Нет <input required type="radio" {$disabled} name="instr_radiotherapy_yes_no_id" value="0" {if isset($object->instr_radiotherapy_yes_no_id) && $object->instr_radiotherapy_yes_no_id == 0}
								checked {/if}/>
							</td>
						</tr>

						<tr>
							<td>Лучевая терапия: вид, РОД, СОД и пр.</td>
							<td><input id="instr_radiotherapy_type" {$class_req_input} type="text" {$readonly} name="instr_radiotherapy_type" size="50" value="{$object->instr_radiotherapy_type}" /></td>
						</tr>
						<tr>
							<td>Лучевая терапия: даты</td>
							<td>Дата начала <input type="text" {$readonly} name="instr_radiotherapy_start_date" id="instr_radiotherapy_start_date" size="10" value="{if isset($object->instr_radiotherapy_start_date)}{$object->instr_radiotherapy_start_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Дата завершения<input type="text"
								{$readonly} name="instr_radiotherapy_end_date" id="instr_radiotherapy_end_date" size="10" value="{if isset($object->instr_radiotherapy_end_date)}{$object->instr_radiotherapy_end_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" />
							</td>
						</tr>
						<tr class="tr_open_close">
							<td colspan="2">Инструментальные исследования после лучевой терапии</td>
						</tr>
						<tr>
							<td class='td_label_form'>КТ после ЛТ</td>
							<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_radiotherapy_kt_yes_no_id" size="50" value="1" {if isset($object->instr_radiotherapy_kt_yes_no_id) && $object->instr_radiotherapy_kt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_radiotherapy_kt_yes_no_id" size="50" value="0" {if isset($object->instr_radiotherapy_kt_yes_no_id)
								&& $object->instr_radiotherapy_kt_yes_no_id == 0} checked {/if}/> Дата <input type="text" {$readonly} name="instr_radiotherapy_kt_date" id="instr_radiotherapy_kt_date" size="10" value="{if isset($object->instr_radiotherapy_kt_date)}{$object->instr_radiotherapy_kt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input type="radio"
								{$disabled} name="instr_radiotherapy_kt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_radiotherapy_kt_norm_yes_no_id) && $object->instr_radiotherapy_kt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_radiotherapy_kt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_radiotherapy_kt_norm_yes_no_id) &&
								$object->instr_radiotherapy_kt_norm_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td class='td_label_form'>КТ Заключение</td>
							<td><textarea {$disabled} rows="3" cols="45" name="instr_radiotherapy_kt_descr">{$object->instr_radiotherapy_kt_descr}</textarea></td>
						</tr>

						<tr>
							<td class='td_label_form'>МРТ после ЛТ</td>
							<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_radiotherapy_mrt_yes_no_id" size="50" value="1" {if isset($object->instr_radiotherapy_mrt_yes_no_id) && $object->instr_radiotherapy_mrt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_radiotherapy_mrt_yes_no_id" size="50" value="0" {if isset($object->instr_radiotherapy_mrt_yes_no_id)
								&& $object->instr_radiotherapy_mrt_yes_no_id == 0} checked {/if}/> Дата <input type="text" {$readonly} name="instr_radiotherapy_mrt_date" id="instr_radiotherapy_mrt_date" size="10" value="{if isset($object->instr_radiotherapy_mrt_date)}{$object->instr_radiotherapy_mrt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input
								type="radio" {$disabled} name="instr_radiotherapy_mrt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_radiotherapy_mrt_norm_yes_no_id) && $object->instr_radiotherapy_mrt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_radiotherapy_mrt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_radiotherapy_mrt_norm_yes_no_id) &&
								$object->instr_radiotherapy_mrt_norm_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td class='td_label_form'>МРТ Заключение</td>
							<td><textarea {$disabled} rows="3" cols="45" name="instr_radiotherapy_mrt_descr">{$object->instr_radiotherapy_mrt_descr}</textarea></td>
						</tr>
						<tr>
							<td class='td_label_form'>ПЭТ-КТ после ЛТ</td>
							<td>Да <input {$class_req_input} type="radio" {$disabled} name="instr_radiotherapy_petkt_yes_no_id" size="50" value="1" {if isset($object->instr_radiotherapy_petkt_yes_no_id) && $object->instr_radiotherapy_petkt_yes_no_id == 1} checked {/if}/> Нет <input {$class_req_input} type="radio" {$disabled} name="instr_radiotherapy_petkt_yes_no_id" size="50" value="0" {if isset($object->instr_radiotherapy_petkt_yes_no_id)
								&& $object->instr_radiotherapy_petkt_yes_no_id == 0} checked {/if}/> Дата <input type="text" {$readonly} name="instr_radiotherapy_petkt_date" id="instr_radiotherapy_petkt_date" size="10" value="{if isset($object->instr_radiotherapy_petkt_date)}{$object->instr_radiotherapy_petkt_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /> Норма <input
								type="radio" {$disabled} name="instr_radiotherapy_petkt_norm_yes_no_id" size="50" value="1" {if isset($object->instr_radiotherapy_petkt_norm_yes_no_id) && $object->instr_radiotherapy_petkt_norm_yes_no_id == 1} checked {/if}/> Патология <input type="radio" {$disabled} name="instr_radiotherapy_petkt_norm_yes_no_id" size="50" value="0" {if isset($object->instr_radiotherapy_petkt_norm_yes_no_id)
								&& $object->instr_radiotherapy_petkt_norm_yes_no_id == 0} checked {/if}/>
							</td>
						</tr>
						<tr>
							<td class='td_label_form'>КТ Заключение</td>
							<td><textarea {$disabled} rows="3" cols="45" name="instr_radiotherapy_petkt_descr">{$object->instr_radiotherapy_petkt_descr}</textarea></td>
						</tr>

						<tr class="tr_open_close">
							<td colspan="2">Состояние пациента</td>
						</tr>
						<tr>
							<td class='td_label_form'>Дата последней информации о состоянии пациента или последнего визит</td>
							<td><input type="text" {$readonly} name="patient_status_last_visit_date" id="patient_status_last_visit_date" size="10" value="{if isset($object->patient_status_last_visit_date)}{$object->patient_status_last_visit_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
						</tr>
						<tr>
							<td>Статус пациента на момент завершения исследования</td>
							<td><select {$class_req_input} {$disabled} name="patient_status_id">
									<option></option> {foreach $patient_status_vals as $item}
									<option {if $item->id == $object->patient_status_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td class='td_label_form'>Если пациент умер, дата смерти</td>
							<td><input type="text" {$readonly} name="patient_if_died_date" id="patient_if_died_date" size="10" value="{if isset($object->patient_if_died_date)}{$object->patient_if_died_date|date_format:'%d/%m/%Y'}{else}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td>
						</tr>
						<tr>
							<td>Причина смерти</td>
							<td><select {$class_req_input} {$disabled} name="patient_if_died_cause_id">
									<option></option> {foreach $patient_if_died_cause_vals as $item}
									<option {if $item->id == $object->patient_if_died_cause_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach}
							</select></td>
						</tr>
						<tr>
							<td>Причина смерти, если другие</td>
							<td><input {$class_req_input} type="text" {$readonly} name="patient_if_died_cause_descr" size="50" value="{$object->patient_if_died_cause_descr}" /></td>
						</tr>


						{* <tr> <td>Степень злокачественности</td> <td><select {$class_req_input} {$disabled} name="diag_cancer_degree_malignancy_id"> <option></option> {foreach $diag_cancer_degree_malignancy_vals as $item} <option {if $item->id == $object->diag_cancer_degree_malignancy_id} selected="selected" {/if} value="{$item->id}">{$item->value}</option> {/foreach} </select></td> </tr> <tr> <tr>
						<td>Гемоглобин</td> <td><input {$class_req_input} type="text" {$readonly} name="lab_hb" id="lab_hb" size="10" value="{$object->lab_hb}" />Дата провед. <input {$class_req_input} type="text" {$readonly} name="lab_hb_date" id="lab_hb_date" size="10" value="{if $object->lab_hb_date}{date('d/m/Y',strtotime($object->lab_hb_date))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);"
						/></td> </tr> <tr> <td>Эритроциты</td> <td><input {$class_req_input} type="text" {$readonly} name="lab_erythrocytes" id="lab_erythrocytes" size="10" value="{$object->lab_erythrocytes}" />Дата провед. <input {$class_req_input} type="text" {$readonly} name="lab_erythrocytes_date" id="lab_erythrocytes_date" size="10" value="{if
						$object->lab_erythrocytes_date}{date('d/m/Y',strtotime($object->lab_erythrocytes_date))}{/if}" onblur="IsObjDate(this);" onkeyup="TempDt(event,this);" /></td> </tr> *} {if $edit}
						<tr>
							<td><input type="submit" value="Сохранить" style="width: 120px; height: 20px"></td>
							<td><input type="reset" value="Сброс" style="width: 120px; height: 20px"></td>
						</tr>
						{else} {/if}

					</table>

				</form>

			</div>

			{include file="footer.tpl"}
		</div>

</body>
</html>
