FILE HANDLE xls_file /NAME='reportdir\05_�������_�������.xls'.
OUTPUT NEW NAME =report_output.
SORT CASES BY id(A).
FREQUENCIES VARIABLES=
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
 /BARCHART=FREQ
 /FORMAT=AVALUE
  /ORDER=ANALYSIS.
  
FREQUENCIES VARIABLES=
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
chmt_other_descr
chmt_days
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
 /BARCHART=FREQ
 /FORMAT=AVALUE
  /ORDER=ANALYSIS.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.