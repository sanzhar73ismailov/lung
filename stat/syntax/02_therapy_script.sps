GET DATA /TYPE=XLSX 
  /FILE='lung_patient.xlsx' 
  /SHEET=name 'therapy' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
DATASET NAME TherapyData WINDOW=FRONT.

DATASET ACTIVATE TherapyData.
EXECUTE.

VARIABLE LABELS
id "ID"
patient_id "�������"
visit_id "����� ������"
chmt_karboplatin_yes_no_id "������������: ����������� (��, ���)"
chmt_cisplatin_yes_no_id "������������: ��������� (��, ���)"
chmt_ciklofosfan_yes_no_id "������������: ����������� (��, ���)"
chmt_paklitaksel_yes_no_id "������������: ����������� (��, ���)"
chmt_doksorubicin_yes_no_id "������������: ������������ (��, ���)"
chmt_topotekan_yes_no_id "������������: ��������� (��, ���)"
chmt_gemcitabin_yes_no_id "������������: ���������� (��, ���)"
chmt_vinorelbin_yes_no_id "������������: ����������� (��, ���)"
chmt_irinotekan_yes_no_id "������������: ���������� (��, ���)"
chmt_jetopozid_yes_no_id "������������: �������� (��, ���)"
chmt_jepirubicin_yes_no_id "������������: ���������� (��, ���)"
chmt_docetaksel_yes_no_id "������������: ���������� (��, ���)"
chmt_oksaliplatin_yes_no_id "������������: ������������ (��, ���)"
chmt_other_yes_no_id "������������: ������ (��, ���)"
chmt_other_descr "������������: ������ (��������)"
chmt_date_start "������������: ���� ������ �������"
chmt_date_finish "������������: ���� ��������� �������"
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
targeted_therapy_yes_no_id "��������� ������� ��/���"
targeted_therapy_erlotinib_yes_no_id "��������� �������: ��������� ��/���"
targeted_therapy_gefitinib_yes_no_id "��������� �������: ��������� ��/���"
targeted_therapy_cryotinib_yes_no_id "��������� �������: ���������� ��/���"
targeted_therapy_nivolumab_yes_no_id "��������� �������: ��������� ��/���"
targeted_therapy_other_yes_no_id "��������� �������: ������ ��/���"
targeted_therapy_descr "���� ���, ������� ��������� � ��������� ���� � ������� �����������"
side_effects_yes_no_id "������������� ������� ��/���"
side_effects_descr "���� ���, ������� ��������� � ��������� ���� � ������� �����������"
hb_before_ct "����������"
hb_before_ct_date "���� ���������� �����������"
erythrocytes_before_ct "����������"
erythrocytes_before_ct_date "���� ���������� ����������"
leuc_before_ct "���������"
leuc_before_ct_date "���� ���������� ���������"
tromb_before_ct "����������"
tromb_before_ct_date "���� ���������� ����������"
neutr_before_ct "����������"
neutr_before_ct_date "���� ���������� ����������"
gen_prot_before_ct "����� �����"
gen_prot_before_ct_date "���� ���������� ����� �����"
ast_before_ct "���"
ast_before_ct_date "���� ���������� ���"
alt_before_ct "���"
alt_before_ct_date "���� ���������� ���"
bilirubin_before_ct "���������"
bilirubin_before_ct_date "���� ���������� ���������"
creat_before_ct "���������"
creat_before_ct_date "���� ���������� ���������"
urea_before_ct "��������"
urea_before_ct_date "���� ���������� ��������"
neurotoxicity_yes_no_id "���������������� ��/���"
neurotoxicity_level_id "������� ����������������"
skin_toxicity_yes_no_id "������ �����������  ��/���"
skin_toxicity_level_id "������� ������ �����������"
user "������������"
insert_date "���� �������".

VALUE LABELS
/neurotoxicity_level_id
1 "1 ������� �����������"
2 "2 ������� �����������"
3 "3 ������� �����������"
4 "4 ������� �����������"
/skin_toxicity_level_id
1 "1 ������� �����������"
2 "2 ������� �����������"
3 "3 ������� �����������"
4 "4 ������� �����������".

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
(-1) .