GET DATA /TYPE=XLSX 
  /FILE='lung_patient.xlsx' 
  /SHEET=name 'therapy' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
DATASET NAME TherapyData WINDOW=FRONT.

DATASET ACTIVATE TherapyData.
EXECUTE.

COMPUTE chmt_days=DATEDIFF(chmt_date_finish,chmt_date_start,'days').
*COMPUTE d=DATEDIFF(v1,v2,'days').
RECODE chmt_days (Lowest thru -1=-1).
formats hb_before_ct erythrocytes_before_ct leuc_before_ct tromb_before_ct 
    neutr_before_ct gen_prot_before_ct ast_before_ct alt_before_ct bilirubin_before_ct creat_before_ct 
    urea_before_ct(f4.0).
EXECUTE.


VARIABLE LABELS
hospital_id "Мед. центр"
chmt_days "Химиотерапия, длительность (дней)"
id "ID"
patient_id "Пациент"
visit_id "Номер визита"
chmt_karboplatin_yes_no_id "Химиотерапия: Карбоплатин (да, нет)"
chmt_cisplatin_yes_no_id "Химиотерапия: Цисплатин (да, нет)"
chmt_ciklofosfan_yes_no_id "Химиотерапия: Циклофосфан (да, нет)"
chmt_paklitaksel_yes_no_id "Химиотерапия: Паклитаксел (да, нет)"
chmt_doksorubicin_yes_no_id "Химиотерапия: Доксорубицин (да, нет)"
chmt_topotekan_yes_no_id "Химиотерапия: Топотекан (да, нет)"
chmt_gemcitabin_yes_no_id "Химиотерапия: Гемцитабин (да, нет)"
chmt_vinorelbin_yes_no_id "Химиотерапия: Винорельбин (да, нет)"
chmt_irinotekan_yes_no_id "Химиотерапия: Иринотекан (да, нет)"
chmt_jetopozid_yes_no_id "Химиотерапия: Этопозид (да, нет)"
chmt_jepirubicin_yes_no_id "Химиотерапия: Эпирубицин (да, нет)"
chmt_docetaksel_yes_no_id "Химиотерапия: Доцетаксел (да, нет)"
chmt_oksaliplatin_yes_no_id "Химиотерапия: Оксалиплатин (да, нет)"
chmt_other_yes_no_id "Химиотерапия: Другое (да, нет)"
chmt_other_descr "Химиотерапия: Другое (описание)"
chmt_date_start "Химиотерапия: Дата начала лечения"
chmt_date_finish "Химиотерапия: Дата окончания лечения"
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
targeted_therapy_yes_no_id "Таргетная терапия да/нет"
targeted_therapy_erlotinib_yes_no_id "Таргетная терапия: Эрлотиниб да/нет"
targeted_therapy_gefitinib_yes_no_id "Таргетная терапия: Гефитиниб да/нет"
targeted_therapy_cryotinib_yes_no_id "Таргетная терапия: Кризотиниб да/нет"
targeted_therapy_nivolumab_yes_no_id "Таргетная терапия: Ниволумаб да/нет"
targeted_therapy_other_yes_no_id "Таргетная терапия: Другое да/нет"
targeted_therapy_descr "Если «да», описать подробнее с указанием даты и степени токсичности"
side_effects_yes_no_id "Нежелательные явления да/нет"
side_effects_descr "Если «да», описать подробнее с указанием даты и степени токсичности"
hb_before_ct "Гемоглобин"
hb_before_ct_date "Дата проведения гемоглобина"
erythrocytes_before_ct "Эритроциты"
erythrocytes_before_ct_date "Дата проведения Эритроциты"
leuc_before_ct "Лейкоциты"
leuc_before_ct_date "Дата проведения Лейкоциты"
tromb_before_ct "Тромбоциты"
tromb_before_ct_date "Дата проведения Тромбоциты"
neutr_before_ct "нейтрофилы"
neutr_before_ct_date "Дата проведения нейтрофилы"
gen_prot_before_ct "Общий белок"
gen_prot_before_ct_date "Дата проведения Общий белок"
ast_before_ct "АСТ"
ast_before_ct_date "Дата проведения АСТ"
alt_before_ct "АЛТ"
alt_before_ct_date "Дата проведения АЛТ"
bilirubin_before_ct "билирубин"
bilirubin_before_ct_date "Дата проведения билирубин"
creat_before_ct "Креатинин"
creat_before_ct_date "Дата проведения Креатинин"
urea_before_ct "Мочевина"
urea_before_ct_date "Дата проведения Мочевина"
neurotoxicity_yes_no_id "Нейротоксичность да/нет"
neurotoxicity_level_id "Степень нейротоксичности"
skin_toxicity_yes_no_id "Кожная токсичность  да/нет"
skin_toxicity_level_id "Степень кожной токсичности"
user "Пользователь"
insert_date "Дата вставки".

VALUE LABELS
chmt_karboplatin_yes_no_id
chmt_cisplatin_yes_no_id
chmt_ciklofosfan_yes_no_id
chmt_paklitaksel_yes_no_id
chmt_doksorubicin_yes_no_id
chmt_topotekan_yes_no_id
chmt_gemcitabin_yes_no_id
chmt_vinorelbin_yes_no_id
chmt_irinotekan_yes_no_id
chmt_jetopozid_yes_no_id
chmt_jepirubicin_yes_no_id
chmt_docetaksel_yes_no_id
chmt_oksaliplatin_yes_no_id
chmt_other_yes_no_id
instr_kt_yes_no_id
instr_kt_norm_yes_no_id
instr_mrt_yes_no_id
instr_mrt_norm_yes_no_id
instr_petkt_yes_no_id
instr_petkt_norm_yes_no_id
targeted_therapy_yes_no_id
targeted_therapy_erlotinib_yes_no_id
targeted_therapy_gefitinib_yes_no_id
targeted_therapy_cryotinib_yes_no_id
targeted_therapy_nivolumab_yes_no_id
targeted_therapy_other_yes_no_id
side_effects_yes_no_id
neurotoxicity_yes_no_id
skin_toxicity_yes_no_id
1 "Да"
0 "Нет"
-1 "Нет данных"
/neurotoxicity_level_id
0 "Токсичности нет"
1 "1 степень токсичности"
2 "2 степень токсичности"
3 "3 степень токсичности"
4 "4 степень токсичности"
-1 "Нет данных"
/skin_toxicity_level_id
0 "Токсичности нет"
1 "1 степень токсичности"
2 "2 степень токсичности"
3 "3 степень токсичности"
4 "4 степень токсичности"
-1 "Нет данных"
/hospital_id
1 "Алматинский ОЦ"
2 "ВК ООД, г. Усть-Каменогорск"
3 "ООД, г. Тараз"
4 "Кызылординский ООД, г. Кзылорда"
5 "ЮК ООД, г. Шымкент"
6 "Медицинский центр ЗКГМУ им. М. Оспанова, Актобе".

MISSING VALUES
patient_id
visit_id
chmt_karboplatin_yes_no_id
chmt_cisplatin_yes_no_id
chmt_ciklofosfan_yes_no_id
chmt_paklitaksel_yes_no_id
chmt_doksorubicin_yes_no_id
chmt_topotekan_yes_no_id
chmt_gemcitabin_yes_no_id
chmt_vinorelbin_yes_no_id
chmt_irinotekan_yes_no_id
chmt_jetopozid_yes_no_id
chmt_jepirubicin_yes_no_id
chmt_docetaksel_yes_no_id
chmt_oksaliplatin_yes_no_id
chmt_other_yes_no_id
instr_kt_yes_no_id
instr_kt_norm_yes_no_id
instr_mrt_yes_no_id
instr_mrt_norm_yes_no_id
instr_petkt_yes_no_id
instr_petkt_norm_yes_no_id
targeted_therapy_yes_no_id
targeted_therapy_erlotinib_yes_no_id
targeted_therapy_gefitinib_yes_no_id
targeted_therapy_cryotinib_yes_no_id
targeted_therapy_nivolumab_yes_no_id
targeted_therapy_other_yes_no_id
side_effects_yes_no_id
neurotoxicity_yes_no_id
neurotoxicity_level_id
skin_toxicity_yes_no_id
skin_toxicity_level_id
chmt_days
hospital_id
(-1).