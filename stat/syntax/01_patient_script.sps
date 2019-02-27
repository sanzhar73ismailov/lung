GET DATA /TYPE=XLSX 
  /FILE='lung_patient.xlsx' 
  /SHEET=name 'patient' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
DATASET NAME PatientData WINDOW=FRONT.

DATASET ACTIVATE PatientData.
 * STRING  diag_cancer_estab_month_year (A8).
COMPUTE years=DATEDIFF(insert_date,date_birth,'year').
 * COMPUTE diag_cancer_estab_month_year=CONCAT(STRING(XDATE.MONTH(diag_cancer_estab_date),F2.0),"-",STRING(XDATE.YEAR(diag_cancer_estab_date),F4.0)).
COMPUTE diag_cancer_estab_year=XDATE.YEAR(diag_cancer_estab_date).
formats diag_cancer_estab_year(f4.0).
EXECUTE.

RECODE years (-1=-1) (0 thru 19=1) (20 thru 29=2) (30 thru 39=3) (40 thru 49=4) (50 thru 59=5) (60 thru 69=6) 
(70 thru 79=7) (80 thru Highest=8) INTO age_group. 
EXECUTE.

VARIABLE LABELS
years "Возраст, лет"
diag_cancer_estab_year "Дата постановки диагноза рак (год)"
id "ID"
patient_number "Номер пациента (уникальный в пределах исследования)"
hospital_id "Мед. центр"
date_start_invest "Дата включения в исследование"
doctor "ФИО врача"
inclusion_criteria_years_more18_yes_no_id "Пациент 18 лет и старше, с впервые в жизни выявленным НМРЛ в 2015-2016 г.г. (да, нет)"
inclusion_criteria_diag_conf_histo_yes_no_id "Диагноз НМРЛ подтвержден гистологически (да, нет)"
inclusion_criteria_diag_conf_cyto_yes_no_id "Диагноз НМРЛ подтвержден цитологически (да, нет)"
inclusion_criteria_diag_conf_clin_radio_yes_no_id "Диагноз выставлен на основе клинико-рентгенологических данных (да, нет)"
inclusion_criteria_got_antitumor_therapy_yes_no_id "Пациент, получавший любой вид противоопухолевой терапии в 2015-2017 г.г. (хирургический, химиотерапевтический, таргетрная терапия, лучевая терапия) (да, нет)"
exclusion_criteria_not_got_antitumor_therapy_yes_no_id "Пациенты с впервые выявленным НМРЛ, но не получившие ни один из видов противоопухолевой терапии из-за наличия сопутствующей патологии или взятые на учет посмертно (да, нет)"
date_birth "Дата рождения"
sex_id "Пол"
place_living_id "Место жительства"
social_status_id "Социальный статус"
diag_cancer_estab_date "Дата постановки диагноза рак"
cytologic_conclusion "Цитологическое заключение"
diag_cancer_histotype "Гистологический тип опухоли"
diag_cancer_degree_malignancy_id "Степень злокачественности"
immunohistochemical_study_id "Иммуногистохимическое исследование"
immunohistochemical_study_descr "Иммуногистохимическое исследование: описание"
genetic_study_yes_no_id "Генетические исследования (да, нет)"
genetic_study_fish "FISH результат"
genetic_study_pcr "ПЦР результат"
diag_cancer_tnm_stage_t_id "Стадия заболевания по системе TNM - T"
diag_cancer_tnm_stage_n_id "Стадия заболевания по системе TNM - N"
diag_cancer_tnm_stage_m_id "Стадия заболевания по системе TNM - M"
diag_cancer_clin_stage_id "Клиническая стадия заболевания"
diag_cancer_ecog_status_id "ECOG статус на момент постановки диагноза и начала лечения"
instr_kt_yes_no_id "Инструментальные исследования: КТ да/нет"
instr_kt_date "Инструментальные исследования: КТ дата"
instr_kt_norm_yes_no_id "Инструментальные исследования: КТ норма/патология"
instr_kt_descr "Инструментальные исследования: КТ Заключение"
instr_mrt_yes_no_id "Инструментальные исследования: МРТ да/нет"
instr_mrt_date "Инструментальные исследования: МРТ дата"
instr_mrt_norm_yes_no_id "Инструментальные исследования: МРТ норма/патология"
instr_mrt_descr "Инструментальные исследования: МРТ Заключение"
instr_petkt_yes_no_id "Инструментальные исследования: ПЭТ-КТ да/нет"
instr_petkt_date "Инструментальные исследования: ПЭТ-КТ дата"
instr_petkt_norm_yes_no_id "Инструментальные исследования: ПЭТ-КТ норма/патология"
instr_petkt_descr "Инструментальные исследования: ПЭТ-КТ Заключение"
surgical_yes_no_id "Хирургическое лечение: да/нет"
surgical_date "Хирургическое лечение: дата"
surgical_descr "Хирургическое лечение: Вид и объем оперативного вмешательства"
instr_radiotherapy_yes_no_id "Лучевая терапия да/нет"
instr_radiotherapy_type "ЛУЧЕВАЯ ТЕРАПИЯ: вид, РОД, СОД и пр."
instr_radiotherapy_start_date "Лучевая терапия: дата начала"
instr_radiotherapy_end_date "Лучевая терапия: дата завершения"
instr_radiotherapy_kt_yes_no_id "Лучевая терапия: Инструментальные исследования: КТ да/нет"
instr_radiotherapy_kt_date "Лучевая терапия: Инструментальные исследования: КТ дата"
instr_radiotherapy_kt_norm_yes_no_id "Лучевая терапия: Инструментальные исследования: КТ норма/патология"
instr_radiotherapy_kt_descr "Лучевая терапия: Инструментальные исследования: КТ Заключение"
instr_radiotherapy_mrt_yes_no_id "Лучевая терапия: Инструментальные исследования: МРТ да/нет"
instr_radiotherapy_mrt_date "Лучевая терапия: Инструментальные исследования: МРТ дата"
instr_radiotherapy_mrt_norm_yes_no_id "Лучевая терапия: Инструментальные исследования: МРТ норма/патология"
instr_radiotherapy_mrt_descr "Лучевая терапия: Инструментальные исследования: МРТ Заключение"
instr_radiotherapy_petkt_yes_no_id "Лучевая терапия: Инструментальные исследования: ПЭТ-КТ да/нет"
instr_radiotherapy_petkt_date "Лучевая терапия: Инструментальные исследования: ПЭТ-КТ дата"
instr_radiotherapy_petkt_norm_yes_no_id "Лучевая терапия: Инструментальные исследования: ПЭТ-КТ норма/патология"
instr_radiotherapy_petkt_descr "Лучевая терапия: Инструментальные исследования: ПЭТ-КТ Заключение"
patient_status_last_visit_date "Дата последней информации о состоянии пациента или последнего визита"
patient_status_id "Статус пациента на момент завершения исследования"
patient_if_died_date "Если пациент умер, дата смерти"
patient_if_died_cause_id "Причина смерти"
patient_if_died_cause_descr "Причина смерти, если другие"
user "Пользователь"
insert_date "Дата записи".

VALUE LABELS
inclusion_criteria_years_more18_yes_no_id
inclusion_criteria_diag_conf_histo_yes_no_id
inclusion_criteria_diag_conf_cyto_yes_no_id
inclusion_criteria_diag_conf_clin_radio_yes_no_id
inclusion_criteria_got_antitumor_therapy_yes_no_id
exclusion_criteria_not_got_antitumor_therapy_yes_no_id
genetic_study_yes_no_id
instr_kt_yes_no_id
instr_kt_norm_yes_no_id
instr_mrt_yes_no_id
instr_mrt_norm_yes_no_id
instr_petkt_yes_no_id
instr_petkt_norm_yes_no_id
surgical_yes_no_id
instr_radiotherapy_yes_no_id
instr_radiotherapy_kt_yes_no_id
instr_radiotherapy_kt_norm_yes_no_id
instr_radiotherapy_mrt_yes_no_id
instr_radiotherapy_mrt_norm_yes_no_id
instr_radiotherapy_petkt_yes_no_id
instr_radiotherapy_petkt_norm_yes_no_id
1 "Да"
0 "Нет"
-1 "Нет данных"
/diag_cancer_clin_stage_id
1 "I"
2 "II"
3 "III"
4 "IV"
-1 "Нет данных"
/diag_cancer_degree_malignancy_id
1 "G1 – высокая степень дифференцировки"
2 "G2 – средняя степень дифференцировки"
3 "G3 – низкая степень дифференцировки"
4 "G4 – недифференцированная опухоль"
5 "Gx – степень дифференцировки установить нельзя"
-1 "Нет данных"
/diag_cancer_ecog_status_id 
1 "0"
2 "1"
3 "2"
4 "3"
5 "неизвестно"
-1 "Нет данных"
/diag_cancer_tnm_stage_m_id
1 "M0"
2 "M1"
3 "Mx"
-1 "Нет данных"
/diag_cancer_tnm_stage_n_id
1 "N0"
2 "N1"
3 "N2"
4 "N3"
5 "Nx"
-1 "Нет данных"
/diag_cancer_tnm_stage_t_id
1 "T0"
2 "Tis"
3 "T1"
4 "T2"
5 "T3"
6 "T4"
7 "Tx"
-1 "Нет данных"
/hospital_id
1 "Алматинский ОЦ"
2 "ВК ООД, г. Усть-Каменогорск"
3 "ООД, г. Тараз"
4 "Кызылординский ООД, г. Кзылорда"
5 "ЮК ООД, г. Шымкент"
6 "Медицинский центр ЗКГМУ им. М. Оспанова, Актобе"
-1 "Нет данных"
/immunohistochemical_study_id
0 "нет"
1 "да"
2 "экспрессия EGFR"
3 "экспрессия ALK"
-1 "Нет данных"
/patient_if_died_cause_id
1 "прогрессирование основного заболевания"
2 "осложнения противоопухолевой терапии "
3 "другие причины"
-1 "Нет данных"
/patient_status_id
0 "умер"
1 "жив"
3 "неизвестно"
-1 "Нет данных"
/place_living_id
1 "город"
2 "село"
-1 "Нет данных"
/sex_id
1 "Мужской"
2 "Женский"
-1 "Нет данных"
/social_status_id
1 "Студент"
2 "Работает"
3 "Пенсионер"
4 "Другое"
-1 "Нет данных".

MISSING VALUES
inclusion_criteria_years_more18_yes_no_id
inclusion_criteria_diag_conf_histo_yes_no_id
inclusion_criteria_diag_conf_cyto_yes_no_id
inclusion_criteria_diag_conf_clin_radio_yes_no_id
inclusion_criteria_got_antitumor_therapy_yes_no_id
exclusion_criteria_not_got_antitumor_therapy_yes_no_id
genetic_study_yes_no_id
instr_kt_yes_no_id
instr_kt_norm_yes_no_id
instr_mrt_yes_no_id
instr_mrt_norm_yes_no_id
instr_petkt_yes_no_id
instr_petkt_norm_yes_no_id
surgical_yes_no_id
instr_radiotherapy_yes_no_id
instr_radiotherapy_kt_yes_no_id
instr_radiotherapy_kt_norm_yes_no_id
instr_radiotherapy_mrt_yes_no_id
instr_radiotherapy_mrt_norm_yes_no_id
instr_radiotherapy_petkt_yes_no_id
instr_radiotherapy_petkt_norm_yes_no_id
hospital_id
sex_id
place_living_id
social_status_id
diag_cancer_degree_malignancy_id
immunohistochemical_study_id
diag_cancer_tnm_stage_t_id
diag_cancer_tnm_stage_n_id
diag_cancer_tnm_stage_m_id
diag_cancer_clin_stage_id
diag_cancer_ecog_status_id
patient_status_id
patient_if_died_cause_id
(-1) .




