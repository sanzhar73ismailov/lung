<?php
class Therapy extends Entity{
	 public $id;
	 public $patient_id;
	 public $visit_id;
	 public $chmt_karboplatin_yes_no_id;
	 public $chmt_cisplatin_yes_no_id;
	 public $chmt_ciklofosfan_yes_no_id;
	 public $chmt_paklitaksel_yes_no_id;
	 public $chmt_doksorubicin_yes_no_id;
	 public $chmt_topotekan_yes_no_id;
	 public $chmt_gemcitabin_yes_no_id;
	 public $chmt_vinorelbin_yes_no_id;
	 public $chmt_irinotekan_yes_no_id;
	 public $chmt_jetopozid_yes_no_id;
	 public $chmt_jepirubicin_yes_no_id;
	 public $chmt_docetaksel_yes_no_id;
	 public $chmt_oksaliplatin_yes_no_id;
	 public $chmt_other_yes_no_id;
	 public $chmt_other_descr;
	 public $chmt_date_start;
	 public $chmt_date_finish;
	 public $instr_kt_yes_no_id;
	 public $instr_kt_date;
	 public $instr_kt_norm_yes_no_id;
	 public $instr_kt_descr;
	 public $instr_mrt_yes_no_id;
	 public $instr_mrt_date;
	 public $instr_mrt_norm_yes_no_id;
	 public $instr_mrt_descr;
	 

	 
	 public $instr_petkt_yes_no_id;
	 public $instr_petkt_date;
	 public $instr_petkt_norm_yes_no_id;
	 public $instr_petkt_descr;
	 public $targeted_therapy_yes_no_id;
	 public $targeted_therapy_erlotinib_yes_no_id;
	 public $targeted_therapy_gefitinib_yes_no_id;
	 public $targeted_therapy_cryotinib_yes_no_id;
	 public $targeted_therapy_nivolumab_yes_no_id;
	 public $targeted_therapy_other_yes_no_id;
	 public $targeted_therapy_descr;
	 public $side_effects_yes_no_id;
	 public $side_effects_descr;
	 public $hb_before_ct;
	 public $hb_before_ct_date;
	 public $erythrocytes_before_ct;
	 public $erythrocytes_before_ct_date;
	 public $leuc_before_ct;
	 public $leuc_before_ct_date;
	 public $tromb_before_ct;
	 public $tromb_before_ct_date;
	 public $neutr_before_ct;
	 public $neutr_before_ct_date;
	 public $gen_prot_before_ct;
	 public $gen_prot_before_ct_date;
	 public $ast_before_ct;
	 public $ast_before_ct_date;
	 public $alt_before_ct;
	 public $alt_before_ct_date;
	 public $bilirubin_before_ct;
	 public $bilirubin_before_ct_date;
	 public $creat_before_ct;
	 public $creat_before_ct_date;
	 public $urea_before_ct;
	 public $urea_before_ct_date;
	 public $neurotoxicity_yes_no_id;
	 public $neurotoxicity_level_id;
	 public $skin_toxicity_yes_no_id;
	 public $skin_toxicity_level_id;
	 public $user;
	 public $insert_date;
	

}