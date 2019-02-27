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
years "�������, ���"
diag_cancer_estab_year "���� ���������� �������� ��� (���)"
id "ID"
patient_number "����� �������� (���������� � �������� ������������)"
hospital_id "���. �����"
date_start_invest "���� ��������� � ������������"
doctor "��� �����"
inclusion_criteria_years_more18_yes_no_id "������� 18 ��� � ������, � ������� � ����� ���������� ���� � 2015-2016 �.�. (��, ���)"
inclusion_criteria_diag_conf_histo_yes_no_id "������� ���� ����������� �������������� (��, ���)"
inclusion_criteria_diag_conf_cyto_yes_no_id "������� ���� ����������� ������������� (��, ���)"
inclusion_criteria_diag_conf_clin_radio_yes_no_id "������� ��������� �� ������ �������-������������������ ������ (��, ���)"
inclusion_criteria_got_antitumor_therapy_yes_no_id "�������, ���������� ����� ��� ����������������� ������� � 2015-2017 �.�. (�������������, ��������������������, ���������� �������, ������� �������) (��, ���)"
exclusion_criteria_not_got_antitumor_therapy_yes_no_id "�������� � ������� ���������� ����, �� �� ���������� �� ���� �� ����� ����������������� ������� ��-�� ������� ������������� ��������� ��� ������ �� ���� ��������� (��, ���)"
date_birth "���� ��������"
sex_id "���"
place_living_id "����� ����������"
social_status_id "���������� ������"
diag_cancer_estab_date "���� ���������� �������� ���"
cytologic_conclusion "�������������� ����������"
diag_cancer_histotype "��������������� ��� �������"
diag_cancer_degree_malignancy_id "������� �����������������"
immunohistochemical_study_id "��������������������� ������������"
immunohistochemical_study_descr "��������������������� ������������: ��������"
genetic_study_yes_no_id "������������ ������������ (��, ���)"
genetic_study_fish "FISH ���������"
genetic_study_pcr "��� ���������"
diag_cancer_tnm_stage_t_id "������ ����������� �� ������� TNM - T"
diag_cancer_tnm_stage_n_id "������ ����������� �� ������� TNM - N"
diag_cancer_tnm_stage_m_id "������ ����������� �� ������� TNM - M"
diag_cancer_clin_stage_id "����������� ������ �����������"
diag_cancer_ecog_status_id "ECOG ������ �� ������ ���������� �������� � ������ �������"
instr_kt_yes_no_id "���������������� ������������: �� ��/���"
instr_kt_date "���������������� ������������: �� ����"
instr_kt_norm_yes_no_id "���������������� ������������: �� �����/���������"
instr_kt_descr "���������������� ������������: �� ����������"
instr_mrt_yes_no_id "���������������� ������������: ��� ��/���"
instr_mrt_date "���������������� ������������: ��� ����"
instr_mrt_norm_yes_no_id "���������������� ������������: ��� �����/���������"
instr_mrt_descr "���������������� ������������: ��� ����������"
instr_petkt_yes_no_id "���������������� ������������: ���-�� ��/���"
instr_petkt_date "���������������� ������������: ���-�� ����"
instr_petkt_norm_yes_no_id "���������������� ������������: ���-�� �����/���������"
instr_petkt_descr "���������������� ������������: ���-�� ����������"
surgical_yes_no_id "������������� �������: ��/���"
surgical_date "������������� �������: ����"
surgical_descr "������������� �������: ��� � ����� ������������ �������������"
instr_radiotherapy_yes_no_id "������� ������� ��/���"
instr_radiotherapy_type "������� �������: ���, ���, ��� � ��."
instr_radiotherapy_start_date "������� �������: ���� ������"
instr_radiotherapy_end_date "������� �������: ���� ����������"
instr_radiotherapy_kt_yes_no_id "������� �������: ���������������� ������������: �� ��/���"
instr_radiotherapy_kt_date "������� �������: ���������������� ������������: �� ����"
instr_radiotherapy_kt_norm_yes_no_id "������� �������: ���������������� ������������: �� �����/���������"
instr_radiotherapy_kt_descr "������� �������: ���������������� ������������: �� ����������"
instr_radiotherapy_mrt_yes_no_id "������� �������: ���������������� ������������: ��� ��/���"
instr_radiotherapy_mrt_date "������� �������: ���������������� ������������: ��� ����"
instr_radiotherapy_mrt_norm_yes_no_id "������� �������: ���������������� ������������: ��� �����/���������"
instr_radiotherapy_mrt_descr "������� �������: ���������������� ������������: ��� ����������"
instr_radiotherapy_petkt_yes_no_id "������� �������: ���������������� ������������: ���-�� ��/���"
instr_radiotherapy_petkt_date "������� �������: ���������������� ������������: ���-�� ����"
instr_radiotherapy_petkt_norm_yes_no_id "������� �������: ���������������� ������������: ���-�� �����/���������"
instr_radiotherapy_petkt_descr "������� �������: ���������������� ������������: ���-�� ����������"
patient_status_last_visit_date "���� ��������� ���������� � ��������� �������� ��� ���������� ������"
patient_status_id "������ �������� �� ������ ���������� ������������"
patient_if_died_date "���� ������� ����, ���� ������"
patient_if_died_cause_id "������� ������"
patient_if_died_cause_descr "������� ������, ���� ������"
user "������������"
insert_date "���� ������".

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
1 "��"
0 "���"
-1 "��� ������"
/diag_cancer_clin_stage_id
1 "I"
2 "II"
3 "III"
4 "IV"
-1 "��� ������"
/diag_cancer_degree_malignancy_id
1 "G1 � ������� ������� ���������������"
2 "G2 � ������� ������� ���������������"
3 "G3 � ������ ������� ���������������"
4 "G4 � �������������������� �������"
5 "Gx � ������� ��������������� ���������� ������"
-1 "��� ������"
/diag_cancer_ecog_status_id 
1 "0"
2 "1"
3 "2"
4 "3"
5 "����������"
-1 "��� ������"
/diag_cancer_tnm_stage_m_id
1 "M0"
2 "M1"
3 "Mx"
-1 "��� ������"
/diag_cancer_tnm_stage_n_id
1 "N0"
2 "N1"
3 "N2"
4 "N3"
5 "Nx"
-1 "��� ������"
/diag_cancer_tnm_stage_t_id
1 "T0"
2 "Tis"
3 "T1"
4 "T2"
5 "T3"
6 "T4"
7 "Tx"
-1 "��� ������"
/hospital_id
1 "����������� ��"
2 "�� ���, �. ����-�����������"
3 "���, �. �����"
4 "�������������� ���, �. ��������"
5 "�� ���, �. �������"
6 "����������� ����� ����� ��. �. ��������, ������"
-1 "��� ������"
/immunohistochemical_study_id
0 "���"
1 "��"
2 "���������� EGFR"
3 "���������� ALK"
-1 "��� ������"
/patient_if_died_cause_id
1 "���������������� ��������� �����������"
2 "���������� ����������������� ������� "
3 "������ �������"
-1 "��� ������"
/patient_status_id
0 "����"
1 "���"
3 "����������"
-1 "��� ������"
/place_living_id
1 "�����"
2 "����"
-1 "��� ������"
/sex_id
1 "�������"
2 "�������"
-1 "��� ������"
/social_status_id
1 "�������"
2 "��������"
3 "���������"
4 "������"
-1 "��� ������".

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




