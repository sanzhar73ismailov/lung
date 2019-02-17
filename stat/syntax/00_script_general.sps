CD 'C:\OSPanel\domains\localhost\lung\stat'.

INSERT FILE ='syntax\01_patient_script.sps'.
*INSERT FILE ='syntax\02_therapy_script.sps'.


*-- DESCRIPTIVES VARIABLES=years

DATASET ACTIVATE PatientData.
* Описательная статистика - возраст.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\01_описательная_стат_количественные_показатели (возраст).xls'.
OUTPUT NEW NAME =report_output.
*Без разделения на пол.
DESCRIPTIVES VARIABLES=years
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.
NPAR TESTS
  /K-S(NORMAL)=years
  /MISSING ANALYSIS.

*С разделением на пол.
SORT CASES  BY sex_id.
SPLIT FILE LAYERED BY sex_id.

DESCRIPTIVES VARIABLES=years
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.
NPAR TESTS
  /K-S(NORMAL)=years
  /MISSING ANALYSIS.
*Снимаем фильтр.
SPLIT FILE OFF.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
* >>>>>>>>>>>>>>BLOCK END.

* Частотный анализ.
* <<<<<<<<<<<BLOCK START.
SORT CASES BY id(A).
FILE HANDLE xls_file /NAME='reportdir\02_частоты.xls'.
OUTPUT NEW NAME =report_output.
FREQUENCIES VARIABLES=
hospital_id
doctor
inclusion_criteria_years_more18_yes_no_id
inclusion_criteria_diag_conf_histo_yes_no_id
inclusion_criteria_diag_conf_cyto_yes_no_id
inclusion_criteria_diag_conf_clin_radio_yes_no_id
inclusion_criteria_got_antitumor_therapy_yes_no_id
exclusion_criteria_not_got_antitumor_therapy_yes_no_id
sex_id
place_living_id
social_status_id
cytologic_conclusion
diag_cancer_histotype
diag_cancer_degree_malignancy_id
immunohistochemical_study_id
immunohistochemical_study_descr
genetic_study_yes_no_id
genetic_study_fish
genetic_study_pcr
diag_cancer_tnm_stage_t_id
diag_cancer_tnm_stage_n_id
diag_cancer_tnm_stage_m_id
diag_cancer_clin_stage_id
diag_cancer_ecog_status_id
instr_kt_yes_no_id
instr_kt_norm_yes_no_id
instr_kt_descr
instr_mrt_yes_no_id
instr_mrt_norm_yes_no_id
instr_mrt_descr
instr_petkt_yes_no_id
instr_petkt_norm_yes_no_id
instr_petkt_descr
surgical_yes_no_id
surgical_descr
instr_radiotherapy_yes_no_id
instr_radiotherapy_type
instr_radiotherapy_end_date
instr_radiotherapy_kt_yes_no_id
instr_radiotherapy_kt_norm_yes_no_id
instr_radiotherapy_kt_descr
instr_radiotherapy_mrt_yes_no_id
instr_radiotherapy_mrt_norm_yes_no_id
instr_radiotherapy_mrt_descr
instr_radiotherapy_petkt_yes_no_id
instr_radiotherapy_petkt_norm_yes_no_id
instr_radiotherapy_petkt_descr
patient_status_id
patient_if_died_date
patient_if_died_cause_id
patient_if_died_cause_descr
user
 /BARCHART=FREQ
 /FORMAT=AVALUE
  /ORDER=ANALYSIS.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.

*С разделением на пол.
SORT CASES  BY sex_id.
SPLIT FILE LAYERED BY sex_id.
FILE HANDLE xls_file /NAME='reportdir\03_частоты_по_полу.xls'.
OUTPUT NEW NAME =report_output.
FREQUENCIES VARIABLES=
hospital_id
doctor
inclusion_criteria_years_more18_yes_no_id
inclusion_criteria_diag_conf_histo_yes_no_id
inclusion_criteria_diag_conf_cyto_yes_no_id
inclusion_criteria_diag_conf_clin_radio_yes_no_id
inclusion_criteria_got_antitumor_therapy_yes_no_id
exclusion_criteria_not_got_antitumor_therapy_yes_no_id
place_living_id
social_status_id
cytologic_conclusion
diag_cancer_histotype
diag_cancer_degree_malignancy_id
immunohistochemical_study_id
immunohistochemical_study_descr
genetic_study_yes_no_id
genetic_study_fish
genetic_study_pcr
diag_cancer_tnm_stage_t_id
diag_cancer_tnm_stage_n_id
diag_cancer_tnm_stage_m_id
diag_cancer_clin_stage_id
diag_cancer_ecog_status_id
instr_kt_yes_no_id
instr_kt_norm_yes_no_id
instr_kt_descr
instr_mrt_yes_no_id
instr_mrt_norm_yes_no_id
instr_mrt_descr
instr_petkt_yes_no_id
instr_petkt_norm_yes_no_id
instr_petkt_descr
surgical_yes_no_id
surgical_descr
instr_radiotherapy_yes_no_id
instr_radiotherapy_type
instr_radiotherapy_end_date
instr_radiotherapy_kt_yes_no_id
instr_radiotherapy_kt_norm_yes_no_id
instr_radiotherapy_kt_descr
instr_radiotherapy_mrt_yes_no_id
instr_radiotherapy_mrt_norm_yes_no_id
instr_radiotherapy_mrt_descr
instr_radiotherapy_petkt_yes_no_id
instr_radiotherapy_petkt_norm_yes_no_id
instr_radiotherapy_petkt_descr
patient_status_id
patient_if_died_date
patient_if_died_cause_id
patient_if_died_cause_descr
user
 /BARCHART=FREQ
 /FORMAT=AVALUE
  /ORDER=ANALYSIS.
OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
*Снимаем фильтр.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.


