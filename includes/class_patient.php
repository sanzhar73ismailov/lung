<?php

class Patient extends Entity{
	public $id;
	public $patient_number;
	public $hospital_id;
	public $date_start_invest;
	public $doctor;
	public $inclusion_criteria_years_more18_yes_no_id;
	public $inclusion_criteria_diag_conf_histo_yes_no_id;
	public $inclusion_criteria_diag_conf_cyto_yes_no_id;
	public $inclusion_criteria_diag_conf_clin_radio_yes_no_id;
	public $inclusion_criteria_got_antitumor_therapy_yes_no_id;
	public $exclusion_criteria_not_got_antitumor_therapy_yes_no_id;
	public $date_birth;
	public $sex_id;
	public $place_living_id;
	public $social_status_id;
	public $diag_cancer_estab_date;
	public $cytologic_conclusion;
	public $diag_cancer_histotype;
	public $diag_cancer_degree_malignancy_id;
	public $immunohistochemical_study_id;
	public $immunohistochemical_study_descr;
	public $genetic_study_yes_no_id;
	public $genetic_study_fish;
	public $genetic_study_pcr;
	public $diag_cancer_tnm_stage_t_id;
	public $diag_cancer_tnm_stage_n_id;
	public $diag_cancer_tnm_stage_m_id;
	public $diag_cancer_clin_stage_id;
	public $diag_cancer_ecog_status_id;
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
	
	public $surgical_yes_no_id;
	public $surgical_date;
	public $surgical_descr;
	
	public $instr_radiotherapy_yes_no_id;
	public $instr_radiotherapy_type;
	public $instr_radiotherapy_start_date;
	public $instr_radiotherapy_end_date;
	public $instr_radiotherapy_kt_yes_no_id;
	public $instr_radiotherapy_kt_date;
	public $instr_radiotherapy_kt_norm_yes_no_id;
	public $instr_radiotherapy_kt_descr;
	public $instr_radiotherapy_mrt_yes_no_id;
	public $instr_radiotherapy_mrt_date;
	public $instr_radiotherapy_mrt_norm_yes_no_id;
	public $instr_radiotherapy_mrt_descr;
	public $instr_radiotherapy_petkt_yes_no_id;
	public $instr_radiotherapy_petkt_date;
	public $instr_radiotherapy_petkt_norm_yes_no_id;
	public $instr_radiotherapy_petkt_descr;
	public $patient_status_last_visit_date;
	public $patient_status_id;
	public $patient_if_died_date;
	public $patient_if_died_cause_id;
	public $patient_if_died_cause_descr;
	public $user;
	public $insert_date;
	public $visits = array(1=>false, 2=>false, 3=>false ,4=>false, 5=>false, 6=>false, 7=>false, 8=>false, 9=>false, 10=>false); // массив визитов ключ - номер визита, значение - проводили (true) или нет (false) до этого
 
	public  function set_date_birth($date_birth){
		$this->date_birth = $date_birth;
		$this->date_birth_sql = parent::getSqlDateFromDate($date_birth);
		$this->date_birth_string=parent::getFormatStringFromDate($date_birth);
	}

	public  function get_date_birth(){
		return $this->date_birth;
	}

	public  function setDateFromSqlDate($input_val){
		$this->set_date_birth(parent::getDateFromSqlDate($input_val));
	}

	public  function setDateFromFormatDate($input_val){
		$this->set_date_birth(parent::getDateFromFormatDate($input_val));
	}

	public  function getYearDateFromRussianString($dateRus){
		if(strlen($dateRus) == 0){
			return "null";
		}
		$parts = explode('/', $dateRus);
		return  "'$parts[2]'";
	}
}
?>