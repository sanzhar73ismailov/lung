*� ����������� �� ���.
SORT CASES  BY sex_id.
SPLIT FILE LAYERED BY sex_id.
FILE HANDLE xls_file /NAME='reportdir\03_�������_��_����.xls'.
OUTPUT NEW NAME =report_output.
FREQUENCIES VARIABLES=
social_status_id
diag_cancer_estab_year
cytologic_conclusion
diag_cancer_histotype
diag_cancer_degree_malignancy_id
immunohistochemical_study_id
genetic_study_yes_no_id
genetic_study_fish
genetic_study_pcr
diag_cancer_tnm_stage_t_id
diag_cancer_tnm_stage_n_id
diag_cancer_tnm_stage_m_id
diag_cancer_clin_stage_id
diag_cancer_ecog_status_id
instr_kt_yes_no_id
instr_kt_date
instr_kt_norm_yes_no_id
instr_mrt_yes_no_id
instr_mrt_date
instr_mrt_norm_yes_no_id
instr_petkt_yes_no_id
instr_petkt_date
instr_petkt_norm_yes_no_id
surgical_yes_no_id
surgical_date
instr_radiotherapy_yes_no_id
instr_radiotherapy_type
instr_radiotherapy_start_date
instr_radiotherapy_end_date
instr_radiotherapy_kt_yes_no_id
instr_radiotherapy_kt_date
instr_radiotherapy_kt_norm_yes_no_id
instr_radiotherapy_mrt_yes_no_id
instr_radiotherapy_mrt_date
instr_radiotherapy_mrt_norm_yes_no_id
instr_radiotherapy_petkt_yes_no_id
instr_radiotherapy_petkt_date
instr_radiotherapy_petkt_norm_yes_no_id
patient_status_last_visit_date
patient_status_id
patient_if_died_date
patient_if_died_cause_id
 /BARCHART=FREQ
 /FORMAT=AVALUE
  /ORDER=ANALYSIS.
OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
*������� ������.
SPLIT FILE OFF.