<?php
// session_start();
include_once 'includes/config.php';
include_once 'includes/class_entity.php';
include_once 'includes/class_patient.php';
include_once 'includes/class_investigation.php';
include_once 'includes/class_therapy.php';
class Dao {
	private $pdo;
	private $user;
	function __construct() {
		$this->connect ();
		// $this->user = $_SESSION["user"]['username_email'];
		$this->user = "test_user";
	}
	function __destruct() {
		// $this->pdo = null;
	}
	public function connect() {
		if ($this->pdo == null) {
			$connect_string = sprintf ( 'mysql:host=%s;dbname=%s', HOST, DB_NAME );
			$this->pdo = new PDO ( $connect_string, DB_USER, DB_PASS, array (
					PDO::ATTR_PERSISTENT => true 
			) );
			$this->pdo->setAttribute ( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
			$this->pdo->query ( "SET NAMES 'utf8'" );
		}
	}
	
	// public function getDicValues($dic_name){
	// $results = array();
	// $query = "SELECT * FROM " . DB_PREFIX . $dic_name;
	// try {
	// $stmt = $this->pdo->query($query);
	// foreach($stmt as $row) {
	// $results[] = new Dictionary($row['id'], $row['name']);
	// }
	// } catch(PDOException $ex) {
	// echo "Ошибка:" . $ex->getMessage();
	// }
	// return $results;
	// }
	public function getDicValues($ref_id) {
		$results = array ();
		if (endsWithYesNoId ( $ref_id )) {
			$results [] = new Dictionary ( '1', 'да' );
			$results [] = new Dictionary ( '0', 'нет' );
			return $results;
		}
		$isNoDataDic = $this->isNoDataDic ( $ref_id );
		$orValueId = "";
		if ($isNoDataDic) {
			$orValueId = " OR t.value_id='-1' ";
		}
		$query = sprintf ( "SELECT t.value_id, t.value_name FROM %sdic_val t
		where t.dic_list_id='%s' %s order by t.value_id", DB_PREFIX, $ref_id, $orValueId );
		try {
			$stmt = $this->pdo->query ( $query );
			foreach ( $stmt as $row ) {
				$results [] = new Dictionary ( $row ['value_id'], $row ['value_name'] );
			}
			// print_r($query);
			// echo "<br/>";
			// print_r($results);
			// echo "<br/>";
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
			$this->log->error ( $ex );
		}
		return $results;
	}
	public function isNoDataDic($ref_id) {
		$result = false;
		$query = "SELECT is_no_data FROM " . DB_PREFIX . "dic_list t where t.id='" . $ref_id . "'";
		try {
			$stmt = $this->pdo->query ( $query );
			$results = $stmt->fetchAll ( PDO::FETCH_ASSOC );
			if (count ( $results ) == 0) {
				throw new Exception ( "Нет такого справочника: " . $ref_id );
			}
			// print_r($results);
			// echo "<br/>";
			$result = ($results [0] ['is_no_data'] == 1);
			// var_dump($result);
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
			$this->log->error ( $ex );
		}
		return $result;
	}
	public function addDicValue($dic_name, $value) {
		$results = array ();
		
		$query = sprintf ( "INSERT INTO %s (id, name) VALUE(null, '%s') ", DB_PREFIX . $dic_name, $value );
		// echo "1:" . $query . "\n<br>";
		try {
			$result = $this->pdo->exec ( $query );
			
			$dic = new Dictionary ( $this->pdo->lastInsertId (), $value );
			// echo $query . "\n<br>";
		} catch ( PDOException $ex ) {
			// echo "Ошибка:" . $ex->getMessage();
			return new Dictionary ( 0, "Такой вариант уже есть" );
		}
		return $dic;
	}
	public function getPatients() {
		$results = array ();
		$query = "SELECT *  FROM " . DB_PREFIX . "patient p";
		/*
		 * DATE_FORMAT(p.date_birth,'%d/%m/%Y') as date_birth,
		 * DATE_FORMAT(p.insert_date,'%d/%m/%Y') as insert_date
		 */
		
		try {
			$stmt = $this->pdo->query ( $query );
			$rows = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if (count ( $rows ) == 0) {
			return null;
		}
		$therArray = $this->getAllTherapies ();
		foreach ( $rows as $row ) {
			$patient = $this->fromRowToPatient ( $row, $therArray );
			
			$results [] = $patient;
		}
		
		return $results;
	}
	public function getTherapyByPatientAndVisit($patient_id, $visit_id) {
		$entity = null;
		$query = "SELECT * FROM " . DB_PREFIX . "therapy t WHERE t.patient_id = :patient_id AND visit_id=:visit_id";
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':patient_id', $patient_id, PDO::PARAM_INT );
			$stmt->bindValue ( ':visit_id', $visit_id, PDO::PARAM_INT );
			$stmt->execute ();
			$rows = $stmt->fetchAll ( PDO::FETCH_ASSOC );
			$entity = $this->fromRowToTherapy ( $rows [0] );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $entity;
	}
	public function isVisitExist($patient_id, $visit_id) {
		$row = array ();
		$query = "SELECT 1 FROM " . DB_PREFIX . "therapy t WHERE t.patient_id = :patient_id AND visit_id=:visit_id";
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':patient_id', $patient_id, PDO::PARAM_INT );
			$stmt->bindValue ( ':visit_id', $visit_id, PDO::PARAM_INT );
			$stmt->execute ();
			$row = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if(count ( $row ) > 1){
			throw new Exception("больше одной строки в таблице " . DB_PREFIX . "therapy с $patient_id и $visit_id" );
		}
		return count ( $row ) == 1;
	}
	public function getAllTherapies() {
		$rows = array ();
		$query = "SELECT * FROM " . DB_PREFIX . "therapy t order by t.patient_id, visit_id";
		try {
			$stmt = $this->pdo->prepare ( $query );
			// $stmt->bindValue(':patient_id', $patient_id, PDO::PARAM_INT);
			// $stmt->bindValue(':visit_id', $visit_id, PDO::PARAM_INT);
			$stmt->execute ();
			$rows = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $rows;
	}
	public function isVisitExistFromArray($patient_id, $visit_id, $therapy_array) {
		foreach ( $therapy_array as $row ) {
			if ($row ['patient_id'] == $patient_id and $row ['visit_id'] == $visit_id) {
				return true;
			}
		}
		return false;
	}
	public function getPatient($id) {
		$rows = array ();
		$query = "SELECT
				  p.* 
				FROM 
				  " . DB_PREFIX . "patient p
				  WHERE p.id = :id";
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':id', $id, PDO::PARAM_INT );
			// $stmt->bindValue(':name', $name, PDO::PARAM_STR);
			$stmt->execute ();
			$rows = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if (count ( $rows ) == 0) {
			return null;
		}
		$entity = $this->fromRowToPatient ( $rows [0] );
		return $entity;
	}
	private function fromRowToPatient($row, $therapy_array = null) {
		$entity = new Patient ();
		$entity->id = $row ['id'];
		$entity->patient_number = $row ['patient_number'];
		$entity->hospital_id = $row ['hospital_id'];
		$entity->date_start_invest = $row ['date_start_invest'];
		$entity->doctor = $row ['doctor'];
		$entity->inclusion_criteria_years_more18_yes_no_id = $row ['inclusion_criteria_years_more18_yes_no_id'];
		$entity->inclusion_criteria_diag_conf_histo_yes_no_id = $row ['inclusion_criteria_diag_conf_histo_yes_no_id'];
		$entity->inclusion_criteria_diag_conf_cyto_yes_no_id = $row ['inclusion_criteria_diag_conf_cyto_yes_no_id'];
		$entity->inclusion_criteria_diag_conf_clin_radio_yes_no_id = $row ['inclusion_criteria_diag_conf_clin_radio_yes_no_id'];
		$entity->inclusion_criteria_got_antitumor_therapy_yes_no_id = $row ['inclusion_criteria_got_antitumor_therapy_yes_no_id'];
		$entity->exclusion_criteria_not_got_antitumor_therapy_yes_no_id = $row ['exclusion_criteria_not_got_antitumor_therapy_yes_no_id'];
		$entity->date_birth = $row ['date_birth'];
		$entity->sex_id = $row ['sex_id'];
		$entity->place_living_id = $row ['place_living_id'];
		$entity->social_status_id = $row ['social_status_id'];
		$entity->diag_cancer_estab_date = $row ['diag_cancer_estab_date'];
		$entity->cytologic_conclusion = $row ['cytologic_conclusion'];
		$entity->diag_cancer_histotype = $row ['diag_cancer_histotype'];
		$entity->diag_cancer_degree_malignancy_id = $row ['diag_cancer_degree_malignancy_id'];
		$entity->immunohistochemical_study_id = $row ['immunohistochemical_study_id'];
		$entity->immunohistochemical_study_descr = $row ['immunohistochemical_study_descr'];
		$entity->genetic_study_yes_no_id = $row ['genetic_study_yes_no_id'];
		$entity->genetic_study_fish = $row ['genetic_study_fish'];
		$entity->genetic_study_pcr = $row ['genetic_study_pcr'];
		$entity->diag_cancer_tnm_stage_t_id = $row ['diag_cancer_tnm_stage_t_id'];
		$entity->diag_cancer_tnm_stage_n_id = $row ['diag_cancer_tnm_stage_n_id'];
		$entity->diag_cancer_tnm_stage_m_id = $row ['diag_cancer_tnm_stage_m_id'];
		$entity->diag_cancer_clin_stage_id = $row ['diag_cancer_clin_stage_id'];
		$entity->diag_cancer_ecog_status_id = $row ['diag_cancer_ecog_status_id'];
		$entity->instr_kt_yes_no_id = $row ['instr_kt_yes_no_id'];
		$entity->instr_kt_date = $row ['instr_kt_date'];
		$entity->instr_kt_norm_yes_no_id = $row ['instr_kt_norm_yes_no_id'];
		$entity->instr_kt_descr = $row ['instr_kt_descr'];
		$entity->instr_mrt_yes_no_id = $row ['instr_mrt_yes_no_id'];
		$entity->instr_mrt_date = $row ['instr_mrt_date'];
		$entity->instr_mrt_norm_yes_no_id = $row ['instr_mrt_norm_yes_no_id'];
		$entity->instr_mrt_descr = $row ['instr_mrt_descr'];
		$entity->instr_petkt_yes_no_id = $row ['instr_petkt_yes_no_id'];
		$entity->instr_petkt_date = $row ['instr_petkt_date'];
		$entity->instr_petkt_norm_yes_no_id = $row ['instr_petkt_norm_yes_no_id'];
		$entity->instr_petkt_descr = $row ['instr_petkt_descr'];
		$entity->instr_radiotherapy_yes_no_id = $row ['instr_radiotherapy_yes_no_id'];
		$entity->instr_radiotherapy_type = $row ['instr_radiotherapy_type'];
		$entity->instr_radiotherapy_start_date = $row ['instr_radiotherapy_start_date'];
		$entity->instr_radiotherapy_end_date = $row ['instr_radiotherapy_end_date'];
		$entity->instr_radiotherapy_kt_yes_no_id = $row ['instr_radiotherapy_kt_yes_no_id'];
		$entity->instr_radiotherapy_kt_date = $row ['instr_radiotherapy_kt_date'];
		$entity->instr_radiotherapy_kt_norm_yes_no_id = $row ['instr_radiotherapy_kt_norm_yes_no_id'];
		$entity->instr_radiotherapy_kt_descr = $row ['instr_radiotherapy_kt_descr'];
		$entity->instr_radiotherapy_mrt_yes_no_id = $row ['instr_radiotherapy_mrt_yes_no_id'];
		$entity->instr_radiotherapy_mrt_date = $row ['instr_radiotherapy_mrt_date'];
		$entity->instr_radiotherapy_mrt_norm_yes_no_id = $row ['instr_radiotherapy_mrt_norm_yes_no_id'];
		$entity->instr_radiotherapy_mrt_descr = $row ['instr_radiotherapy_mrt_descr'];
		$entity->instr_radiotherapy_petkt_yes_no_id = $row ['instr_radiotherapy_petkt_yes_no_id'];
		$entity->instr_radiotherapy_petkt_date = $row ['instr_radiotherapy_petkt_date'];
		$entity->instr_radiotherapy_petkt_norm_yes_no_id = $row ['instr_radiotherapy_petkt_norm_yes_no_id'];
		$entity->instr_radiotherapy_petkt_descr = $row ['instr_radiotherapy_petkt_descr'];
		$entity->patient_status_last_visit_date = $row ['patient_status_last_visit_date'];
		$entity->patient_status_id = $row ['patient_status_id'];
		$entity->patient_if_died_date = $row ['patient_if_died_date'];
		$entity->patient_if_died_cause_id = $row ['patient_if_died_cause_id'];
		$entity->patient_if_died_cause_descr = $row ['patient_if_died_cause_descr'];
		$entity->user = $row ['user'];
		$entity->insert_date = $row ['insert_date'];
		if ($therapy_array != null) {
			foreach ( $entity->visits as $key => $value ) {
				$entity->visits [$key] = $this->isVisitExistFromArray ( $entity->id, $key, $therapy_array );
			}
		}
		return $entity;
	}
	private function fromRowToTherapy($row) {
		$entity = new Therapy ();
		$entity->id=$row['id'];
		$entity->patient_id=$row['patient_id'];
		$entity->visit_id=$row['visit_id'];
		$entity->chmt_karboplatin_yes_no_id=$row['chmt_karboplatin_yes_no_id'];
		$entity->chmt_cisplatin_yes_no_id=$row['chmt_cisplatin_yes_no_id'];
		$entity->chmt_ciklofosfan_yes_no_id=$row['chmt_ciklofosfan_yes_no_id'];
		$entity->chmt_paklitaksel_yes_no_id=$row['chmt_paklitaksel_yes_no_id'];
		$entity->chmt_doksorubicin_yes_no_id=$row['chmt_doksorubicin_yes_no_id'];
		$entity->chmt_topotekan_yes_no_id=$row['chmt_topotekan_yes_no_id'];
		$entity->chmt_gemcitabin_yes_no_id=$row['chmt_gemcitabin_yes_no_id'];
		$entity->chmt_vinorelbin_yes_no_id=$row['chmt_vinorelbin_yes_no_id'];
		$entity->chmt_irinotekan_yes_no_id=$row['chmt_irinotekan_yes_no_id'];
		$entity->chmt_jetopozid_yes_no_id=$row['chmt_jetopozid_yes_no_id'];
		$entity->chmt_jepirubicin_yes_no_id=$row['chmt_jepirubicin_yes_no_id'];
		$entity->chmt_docetaksel_yes_no_id=$row['chmt_docetaksel_yes_no_id'];
		$entity->chmt_oksaliplatin_yes_no_id=$row['chmt_oksaliplatin_yes_no_id'];
		$entity->chmt_other_yes_no_id=$row['chmt_other_yes_no_id'];
		$entity->chmt_other_descr=$row['chmt_other_descr'];
		$entity->chmt_date_start=$row['chmt_date_start'];
		$entity->chmt_date_finish=$row['chmt_date_finish'];
		$entity->instr_kt_yes_no_id=$row['instr_kt_yes_no_id'];
		$entity->instr_kt_date=$row['instr_kt_date'];
		$entity->instr_kt_norm_yes_no_id=$row['instr_kt_norm_yes_no_id'];
		$entity->instr_kt_descr=$row['instr_kt_descr'];
		$entity->instr_mrt_yes_no_id=$row['instr_mrt_yes_no_id'];
		$entity->instr_mrt_date=$row['instr_mrt_date'];
		$entity->instr_mrt_norm_yes_no_id=$row['instr_mrt_norm_yes_no_id'];
		$entity->instr_mrt_descr=$row['instr_mrt_descr'];
		$entity->instr_petkt_yes_no_id=$row['instr_petkt_yes_no_id'];
		$entity->instr_petkt_date=$row['instr_petkt_date'];
		$entity->instr_petkt_norm_yes_no_id=$row['instr_petkt_norm_yes_no_id'];
		$entity->instr_petkt_descr=$row['instr_petkt_descr'];
		$entity->targeted_therapy_yes_no_id=$row['targeted_therapy_yes_no_id'];
		$entity->targeted_therapy_erlotinib_yes_no_id=$row['targeted_therapy_erlotinib_yes_no_id'];
		$entity->targeted_therapy_gefitinib_yes_no_id=$row['targeted_therapy_gefitinib_yes_no_id'];
		$entity->targeted_therapy_cryotinib_yes_no_id=$row['targeted_therapy_cryotinib_yes_no_id'];
		$entity->targeted_therapy_nivolumab_yes_no_id=$row['targeted_therapy_nivolumab_yes_no_id'];
		$entity->targeted_therapy_other_yes_no_id=$row['targeted_therapy_other_yes_no_id'];
		$entity->targeted_therapy_descr=$row['targeted_therapy_descr'];
		$entity->side_effects_yes_no_id=$row['side_effects_yes_no_id'];
		$entity->side_effects_descr=$row['side_effects_descr'];
		$entity->hb_before_ct=$row['hb_before_ct'];
		$entity->hb_before_ct_date=$row['hb_before_ct_date'];
		$entity->erythrocytes_before_ct=$row['erythrocytes_before_ct'];
		$entity->erythrocytes_before_ct_date=$row['erythrocytes_before_ct_date'];
		$entity->leuc_before_ct=$row['leuc_before_ct'];
		$entity->leuc_before_ct_date=$row['leuc_before_ct_date'];
		$entity->tromb_before_ct=$row['tromb_before_ct'];
		$entity->tromb_before_ct_date=$row['tromb_before_ct_date'];
		$entity->neutr_before_ct=$row['neutr_before_ct'];
		$entity->neutr_before_ct_date=$row['neutr_before_ct_date'];
		$entity->gen_prot_before_ct=$row['gen_prot_before_ct'];
		$entity->gen_prot_before_ct_date=$row['gen_prot_before_ct_date'];
		$entity->ast_before_ct=$row['ast_before_ct'];
		$entity->ast_before_ct_date=$row['ast_before_ct_date'];
		$entity->alt_before_ct=$row['alt_before_ct'];
		$entity->alt_before_ct_date=$row['alt_before_ct_date'];
		$entity->bilirubin_before_ct=$row['bilirubin_before_ct'];
		$entity->bilirubin_before_ct_date=$row['bilirubin_before_ct_date'];
		$entity->creat_before_ct=$row['creat_before_ct'];
		$entity->creat_before_ct_date=$row['creat_before_ct_date'];
		$entity->urea_before_ct=$row['urea_before_ct'];
		$entity->urea_before_ct_date=$row['urea_before_ct_date'];
		$entity->neurotoxicity_yes_no_id=$row['neurotoxicity_yes_no_id'];
		$entity->neurotoxicity_level_id=$row['neurotoxicity_level_id'];
		$entity->skin_toxicity_yes_no_id=$row['skin_toxicity_yes_no_id'];
		$entity->skin_toxicity_level_id=$row['skin_toxicity_level_id'];
		$entity->user = $row ['user'];
		$entity->insert_date = $row ['insert_date'];
		return $entity;
	}
	public function getTherapy($id) {
		$row = array ();
		$query = "SELECT
				  id,
				  patient_id,
				  visit_id,
				  chmt_karboplatin_id,
				  chmt_cisplatin_id,
				  chmt_ciklofosfan_id,
				  chmt_paklitaksel_id,
				  chmt_doksorubicin_id,
				  chmt_topotekan_id,
				  chmt_gemcitabin_id,
				  chmt_vinorelbin_id,
				  chmt_irinotekan_id,
				  chmt_jetopozid_id,
				  chmt_jepirubicin_id,
				  chmt_docetaksel_id,
				  chmt_oksaliplatin_id,
				  chmt_trabektedin_id,
				  chmt_other_id,
				  chmt_other_descr,
				  chmt_date_start,
				  chmt_date_finish,
				  diaganem_afterchmt_hb,
				  diaganem_afterchmt_hb_date,
				  diaganem_afterchmt_erythrocytes,
				  diaganem_afterchmt_lab_erythrocytes_date,
				  epoetin_yes_no_id,
				  epoetin_eprex40k_dstart,
				  epoetin_eprex40k_dfinish,
				  epoetin_eprex40k_trfinish_yes_no_id,
				  epoetin_eprex40k_trfinish_cause_id,
				  epoetin_eprex2k5ML_dstart,
				  epoetin_eprex2k5ML_dfinish,
				  epoetin_eprex2k5ML_trfinish_yes_no_id,
				  epoetin_eprex2k5ML_trfinish_cause_id,
				  epoetin_rekormon_dstart,
				  epoetin_rekormon_dfinish,
				  epoetin_rekormon_trfinish_yes_no_id,
				  epoetin_rekormon_trfinish_cause_id,
				  epoetin_other_name,
				  epoetin_other_dstart,
				  epoetin_other_dfinish,
				  epoetin_other_trfinish_yes_no_id,
				  epoetin_other_trfinish_cause_id,
				  ferrum_yes_no_id,
				  ferrum_dstart,
				  ferrum_dfinish,
				  notepoetin_yes_no_id,
				  notepoetin_drug1_name,
				  notepoetin_drug1_dstart,
				  notepoetin_drug1_dfinish,
				  notepoetin_drug1_trfinish_yes_no_id,
				  notepoetin_drug1_trfinish_cause_id,
				  notepoetin_drug2_name,
				  notepoetin_drug2_dstart,
				  notepoetin_drug2_dfinish,
				  notepoetin_drug2_trfinish_yes_no_id,
				  notepoetin_drug2_trfinish_cause_id,
				  notepoetin_drug3_name,
				  notepoetin_drug3_dstart,
				  notepoetin_drug3_dfinish,
				  notepoetin_drug3_trfinish_yes_no_id,
				  notepoetin_drug3_trfinish_cause_id,
				  diaganem_after_correct_hb,
				  diaganem_after_correct_hb_date,
				  diaganem_after_correct_erythrocytes,
				  diaganem_after_correct_lab_erythrocytes_date,
				  user,
				  insert_date
				FROM 
				  " . DB_PREFIX . "therapy
				  WHERE id = :id";
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':id', $id, PDO::PARAM_INT );
			// $stmt->bindValue(':name', $name, PDO::PARAM_STR);
			$stmt->execute ();
			$row = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if (count ( $row ) == 0) {
			return null;
		}
		$entity = new Therapy ();
		$entity->id = $row [0] ['id'];
		$entity->patient_id = $row [0] ['patient_id'];
		$entity->visit_id = $row [0] ['visit_id'];
		$entity->chmt_karboplatin_id = $row [0] ['chmt_karboplatin_id'];
		$entity->chmt_cisplatin_id = $row [0] ['chmt_cisplatin_id'];
		$entity->chmt_ciklofosfan_id = $row [0] ['chmt_ciklofosfan_id'];
		$entity->chmt_paklitaksel_id = $row [0] ['chmt_paklitaksel_id'];
		$entity->chmt_doksorubicin_id = $row [0] ['chmt_doksorubicin_id'];
		$entity->chmt_topotekan_id = $row [0] ['chmt_topotekan_id'];
		$entity->chmt_gemcitabin_id = $row [0] ['chmt_gemcitabin_id'];
		$entity->chmt_vinorelbin_id = $row [0] ['chmt_vinorelbin_id'];
		$entity->chmt_irinotekan_id = $row [0] ['chmt_irinotekan_id'];
		$entity->chmt_jetopozid_id = $row [0] ['chmt_jetopozid_id'];
		$entity->chmt_jepirubicin_id = $row [0] ['chmt_jepirubicin_id'];
		$entity->chmt_docetaksel_id = $row [0] ['chmt_docetaksel_id'];
		$entity->chmt_oksaliplatin_id = $row [0] ['chmt_oksaliplatin_id'];
		$entity->chmt_trabektedin_id = $row [0] ['chmt_trabektedin_id'];
		$entity->chmt_other_id = $row [0] ['chmt_other_id'];
		$entity->chmt_other_descr = $row [0] ['chmt_other_descr'];
		$entity->chmt_date_start = $row [0] ['chmt_date_start'];
		$entity->chmt_date_finish = $row [0] ['chmt_date_finish'];
		$entity->diaganem_afterchmt_hb = $row [0] ['diaganem_afterchmt_hb'];
		$entity->diaganem_afterchmt_hb_date = $row [0] ['diaganem_afterchmt_hb_date'];
		$entity->diaganem_afterchmt_erythrocytes = $row [0] ['diaganem_afterchmt_erythrocytes'];
		$entity->diaganem_afterchmt_lab_erythrocytes_date = $row [0] ['diaganem_afterchmt_lab_erythrocytes_date'];
		$entity->epoetin_yes_no_id = $row [0] ['epoetin_yes_no_id'];
		$entity->epoetin_eprex40k_dstart = $row [0] ['epoetin_eprex40k_dstart'];
		$entity->epoetin_eprex40k_dfinish = $row [0] ['epoetin_eprex40k_dfinish'];
		$entity->epoetin_eprex40k_trfinish_yes_no_id = $row [0] ['epoetin_eprex40k_trfinish_yes_no_id'];
		$entity->epoetin_eprex40k_trfinish_cause_id = $row [0] ['epoetin_eprex40k_trfinish_cause_id'];
		$entity->epoetin_eprex2k5ML_dstart = $row [0] ['epoetin_eprex2k5ML_dstart'];
		$entity->epoetin_eprex2k5ML_dfinish = $row [0] ['epoetin_eprex2k5ML_dfinish'];
		$entity->epoetin_eprex2k5ML_trfinish_yes_no_id = $row [0] ['epoetin_eprex2k5ML_trfinish_yes_no_id'];
		$entity->epoetin_eprex2k5ML_trfinish_cause_id = $row [0] ['epoetin_eprex2k5ML_trfinish_cause_id'];
		$entity->epoetin_rekormon_dstart = $row [0] ['epoetin_rekormon_dstart'];
		$entity->epoetin_rekormon_dfinish = $row [0] ['epoetin_rekormon_dfinish'];
		$entity->epoetin_rekormon_trfinish_yes_no_id = $row [0] ['epoetin_rekormon_trfinish_yes_no_id'];
		$entity->epoetin_rekormon_trfinish_cause_id = $row [0] ['epoetin_rekormon_trfinish_cause_id'];
		$entity->epoetin_other_name = $row [0] ['epoetin_other_name'];
		$entity->epoetin_other_dstart = $row [0] ['epoetin_other_dstart'];
		$entity->epoetin_other_dfinish = $row [0] ['epoetin_other_dfinish'];
		$entity->epoetin_other_trfinish_yes_no_id = $row [0] ['epoetin_other_trfinish_yes_no_id'];
		$entity->epoetin_other_trfinish_cause_id = $row [0] ['epoetin_other_trfinish_cause_id'];
		$entity->ferrum_yes_no_id = $row [0] ['ferrum_yes_no_id'];
		$entity->ferrum_dstart = $row [0] ['ferrum_dstart'];
		$entity->ferrum_dfinish = $row [0] ['ferrum_dfinish'];
		$entity->notepoetin_yes_no_id = $row [0] ['notepoetin_yes_no_id'];
		$entity->notepoetin_drug1_name = $row [0] ['notepoetin_drug1_name'];
		$entity->notepoetin_drug1_dstart = $row [0] ['notepoetin_drug1_dstart'];
		$entity->notepoetin_drug1_dfinish = $row [0] ['notepoetin_drug1_dfinish'];
		$entity->notepoetin_drug1_trfinish_yes_no_id = $row [0] ['notepoetin_drug1_trfinish_yes_no_id'];
		$entity->notepoetin_drug1_trfinish_cause_id = $row [0] ['notepoetin_drug1_trfinish_cause_id'];
		$entity->notepoetin_drug2_name = $row [0] ['notepoetin_drug2_name'];
		$entity->notepoetin_drug2_dstart = $row [0] ['notepoetin_drug2_dstart'];
		$entity->notepoetin_drug2_dfinish = $row [0] ['notepoetin_drug2_dfinish'];
		$entity->notepoetin_drug2_trfinish_yes_no_id = $row [0] ['notepoetin_drug2_trfinish_yes_no_id'];
		$entity->notepoetin_drug2_trfinish_cause_id = $row [0] ['notepoetin_drug2_trfinish_cause_id'];
		$entity->notepoetin_drug3_name = $row [0] ['notepoetin_drug3_name'];
		$entity->notepoetin_drug3_dstart = $row [0] ['notepoetin_drug3_dstart'];
		$entity->notepoetin_drug3_dfinish = $row [0] ['notepoetin_drug3_dfinish'];
		$entity->notepoetin_drug3_trfinish_yes_no_id = $row [0] ['notepoetin_drug3_trfinish_yes_no_id'];
		$entity->notepoetin_drug3_trfinish_cause_id = $row [0] ['notepoetin_drug3_trfinish_cause_id'];
		$entity->diaganem_after_correct_hb = $row [0] ['diaganem_after_correct_hb'];
		$entity->diaganem_after_correct_hb_date = $row [0] ['diaganem_after_correct_hb_date'];
		$entity->diaganem_after_correct_erythrocytes = $row [0] ['diaganem_after_correct_erythrocytes'];
		$entity->diaganem_after_correct_lab_erythrocytes_date = $row [0] ['diaganem_after_correct_lab_erythrocytes_date'];
		$entity->user = $row [0] ['user'];
		$entity->insert_date = $row [0] ['insert_date'];
		return $entity;
	}
	public function getInvestigation($id) {
		$query = "SELECT
				  `id`,
				  `patient_id`,
				  `tumor_another_existence_yes_no_id`,
				  `tumor_another_existence_discr`,
				  `diagnosis`,
				  `intestinum_crassum_part_id`,
				  `colon_part_id`,
				  `rectum_part_id`,
				  `treatment_discr`,
				  `status_gene_kras_id`,
				  `status_gene_kras3_id`,
				  `date_invest`,
				  `depth_of_invasion_id`,
				  `stage_id`,
				  `metastasis_regional_lymph_nodes_yes_no_id`,
				  `metastasis_regional_lymph_nodes_discr`,
				  `tumor_histological_type_id`,
				  `tumor_differentiation_degree_id`,
				  `comments`,
				  `block`,
				  `user`,
				  `insert_date`
				FROM 
				  `kras_investigation` i
				   WHERE i.id = :id";
		
		return $this->getInvestigationWithQuery ( $query, $id );
	}
	public function getAllData() {
		$results = array ();
		$query = "SELECT
  kras_patient.id,
  kras_patient.last_name,
  kras_patient.first_name,
  kras_patient.patronymic_name,
  kras_patient.sex_id,
  kras_patient.date_birth,
  kras_patient.year_birth,
  kras_patient.weight_kg,
  kras_patient.height_sm,
  kras_patient.prof_or_other_hazards_yes_no_id,
  kras_patient.prof_or_other_hazards_discr,
  kras_patient.nationality_id,
  kras_patient.smoke_yes_no_id,
  kras_patient.smoke_discr,
  kras_patient.hospital,
  kras_patient.doctor,
  kras_patient.comments,
  kras_investigation.id,
  kras_investigation.tumor_another_existence_yes_no_id,
  kras_investigation.tumor_another_existence_discr,
  kras_investigation.diagnosis,
  kras_investigation.intestinum_crassum_part_id,
  kras_investigation.colon_part_id,
  kras_investigation.rectum_part_id,
  kras_investigation.treatment_discr,
  kras_investigation.status_gene_kras_id,
  kras_investigation.status_gene_kras3_id,
  kras_investigation.status_gene_kras4_id,
  kras_investigation.status_gene_nras2_id,
  kras_investigation.status_gene_nras3_id,
  kras_investigation.status_gene_nras4_id,
  kras_investigation.date_invest,
  kras_investigation.depth_of_invasion_id,
  kras_investigation.stage_id,
  kras_investigation.metastasis_regional_lymph_nodes_yes_no_id,
  kras_investigation.metastasis_regional_lymph_nodes_discr,
  kras_investigation.tumor_histological_type_id,
  kras_investigation.tumor_differentiation_degree_id,
  kras_investigation.block,
  kras_investigation.comments

FROM
  kras_patient
  LEFT OUTER JOIN kras_investigation ON (kras_patient.id = kras_investigation.patient_id)";
		try {
			$stmt = $this->pdo->query ( $query );
			$results = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if (count ( $results ) == 0) {
			return null;
		}
		return $results;
	}
	public function getInvestigationByPatientId($patient_id) {
		$query = "SELECT
				  `id`,
				  `patient_id`,
				  `tumor_another_existence_yes_no_id`,
				  `tumor_another_existence_discr`,
				  `diagnosis`,
				  `intestinum_crassum_part_id`,
				  `colon_part_id`,
				  `rectum_part_id`,
				  `treatment_discr`,
				  `status_gene_kras_id`,
				  `status_gene_kras3_id`,
				  `status_gene_kras4_id`,
				  `status_gene_nras2_id`,
				  `status_gene_nras3_id`,
				  `status_gene_nras4_id`,
				  `date_invest`,
				  `depth_of_invasion_id`,
				  `stage_id`,
				  `metastasis_regional_lymph_nodes_yes_no_id`,
				  `metastasis_regional_lymph_nodes_discr`,
				  `tumor_histological_type_id`,
				  `tumor_differentiation_degree_id`,
				  `comments`,
				  `block`,
				  `user`,
				  `insert_date`
				FROM 
				  `kras_investigation` i
				   WHERE i.patient_id = :id";
		
		return $this->getInvestigationWithQuery ( $query, $patient_id );
	}
	public function getInvestigationWithQuery($query, $id) {
		$row = array ();
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':id', $id, PDO::PARAM_INT );
			// $stmt->bindValue(':name', $name, PDO::PARAM_STR);
			$stmt->execute ();
			$row = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if (count ( $row ) == 0) {
			return null;
		}
		$investigation = new Investigation ();
		$investigation->id = $row [0] ['id'];
		$investigation->patient_id = $row [0] ['patient_id'];
		$investigation->tumor_another_existence_yes_no_id = $row [0] ['tumor_another_existence_yes_no_id'];
		$investigation->tumor_another_existence_discr = $row [0] ['tumor_another_existence_discr'];
		$investigation->diagnosis = $row [0] ['diagnosis'];
		$investigation->intestinum_crassum_part_id = $row [0] ['intestinum_crassum_part_id'];
		$investigation->colon_part_id = $row [0] ['colon_part_id'];
		$investigation->rectum_part_id = $row [0] ['rectum_part_id'];
		$investigation->treatment_discr = $row [0] ['treatment_discr'];
		$investigation->status_gene_kras_id = $row [0] ['status_gene_kras_id'];
		$investigation->status_gene_kras3_id = $row [0] ['status_gene_kras3_id'];
		$investigation->status_gene_kras4_id = $row [0] ['status_gene_kras4_id'];
		$investigation->status_gene_nras2_id = $row [0] ['status_gene_nras2_id'];
		$investigation->status_gene_nras3_id = $row [0] ['status_gene_nras3_id'];
		$investigation->status_gene_nras4_id = $row [0] ['status_gene_nras4_id'];
		$investigation->setDateFromSqlDate ( $row [0] ['date_invest'] );
		$investigation->depth_of_invasion_id = $row [0] ['depth_of_invasion_id'];
		$investigation->stage_id = $row [0] ['stage_id'];
		$investigation->metastasis_regional_lymph_nodes_yes_no_id = $row [0] ['metastasis_regional_lymph_nodes_yes_no_id'];
		$investigation->metastasis_regional_lymph_nodes_discr = $row [0] ['metastasis_regional_lymph_nodes_discr'];
		$investigation->tumor_histological_type_id = $row [0] ['tumor_histological_type_id'];
		$investigation->tumor_differentiation_degree_id = $row [0] ['tumor_differentiation_degree_id'];
		$investigation->block = $row [0] ['block'];
		$investigation->comments = $row [0] ['comments'];
		return $investigation;
	}
	private function getNullIfStringEmpty($str) {
		$str = strval ( $str );
		// echo strlen ($str) . "<br>";
		if (strlen ( $str ) == 0) {
			return 'null';
		}
		return "'" . $str . "'";
	}
	private function getNullForObjectFieldIfStringEmpty($val) {
		if (! isset ( $val ))
			return null;
		if ($val == null)
			return null;
		$val = trim ( $val );
		$val = strval ( $val );
		if (strlen ( $val ) == 0)
			return null;
		return $val;
	}
	
	public function getValFromRequest($request, $attr){
		if(!isset($request[$attr])){
			if(endsWithId($attr))
				return '-1';
			else
				return null;
		}
		return $request[$attr];
	}
	public function parse_form_to_patient($request) {
		$entity = new Patient ();
		$entity->id = $this->getNullForObjectFieldIfStringEmpty ( $request ['id'] );
		$entity->patient_number = $this->getNullForObjectFieldIfStringEmpty ( $request ['patient_number'] );
		$entity->hospital_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['hospital_id'] );
		$entity->date_start_invest = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['date_start_invest'] ));
		$entity->doctor = $this->getNullForObjectFieldIfStringEmpty ( $request ['doctor'] );
		$entity->inclusion_criteria_years_more18_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['inclusion_criteria_years_more18_yes_no_id'] );
		$entity->inclusion_criteria_diag_conf_histo_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['inclusion_criteria_diag_conf_histo_yes_no_id'] );
		$entity->inclusion_criteria_diag_conf_cyto_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['inclusion_criteria_diag_conf_cyto_yes_no_id'] );
		$entity->inclusion_criteria_diag_conf_clin_radio_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['inclusion_criteria_diag_conf_clin_radio_yes_no_id'] );
		$entity->inclusion_criteria_got_antitumor_therapy_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['inclusion_criteria_got_antitumor_therapy_yes_no_id'] );
		$entity->exclusion_criteria_not_got_antitumor_therapy_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['exclusion_criteria_not_got_antitumor_therapy_yes_no_id'] );
		$entity->date_birth = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['date_birth'] ) );
		$entity->sex_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['sex_id'] );
		$entity->place_living_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['place_living_id'] );
		$entity->social_status_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['social_status_id'] );
		$entity->diag_cancer_estab_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_estab_date'] ) );
		$entity->cytologic_conclusion = $this->getNullForObjectFieldIfStringEmpty ( $request ['cytologic_conclusion'] );
		$entity->diag_cancer_histotype = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_histotype'] );
		$entity->diag_cancer_degree_malignancy_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_degree_malignancy_id'] );
		$entity->immunohistochemical_study_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['immunohistochemical_study_id'] );
		$entity->immunohistochemical_study_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['immunohistochemical_study_descr'] );
		$entity->genetic_study_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['genetic_study_yes_no_id'] );
		$entity->genetic_study_fish = $this->getNullForObjectFieldIfStringEmpty ( $request ['genetic_study_fish'] );
		$entity->genetic_study_pcr = $this->getNullForObjectFieldIfStringEmpty ( $request ['genetic_study_pcr'] );
		$entity->diag_cancer_tnm_stage_t_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_tnm_stage_t_id'] );
		$entity->diag_cancer_tnm_stage_n_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_tnm_stage_n_id'] );
		$entity->diag_cancer_tnm_stage_m_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_tnm_stage_m_id'] );
		$entity->diag_cancer_clin_stage_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_clin_stage_id'] );
		$entity->diag_cancer_ecog_status_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['diag_cancer_ecog_status_id'] );
		$entity->instr_kt_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_kt_yes_no_id'] );
		$entity->instr_kt_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_kt_date'] ) );
		$entity->instr_kt_norm_yes_no_id = $this->getValFromRequest ( $request, 'instr_kt_norm_yes_no_id');
		$entity->instr_kt_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_kt_descr'] );
		$entity->instr_mrt_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_mrt_yes_no_id'] );
		$entity->instr_mrt_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_mrt_date'] ) );
		$entity->instr_mrt_norm_yes_no_id = $this->getValFromRequest ( $request, 'instr_mrt_norm_yes_no_id' );
		$entity->instr_mrt_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_mrt_descr'] );
		$entity->instr_petkt_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_petkt_yes_no_id'] );
		$entity->instr_petkt_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_petkt_date'] ) );
		$entity->instr_petkt_norm_yes_no_id = $this->getValFromRequest ( $request, 'instr_petkt_norm_yes_no_id' );
		$entity->instr_petkt_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_petkt_descr'] );
		$entity->instr_radiotherapy_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_yes_no_id'] );
		$entity->instr_radiotherapy_type = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_type'] );
		$entity->instr_radiotherapy_start_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_start_date'] ) );
		$entity->instr_radiotherapy_end_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_end_date'] ) );
		$entity->instr_radiotherapy_kt_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_kt_yes_no_id'] );
		$entity->instr_radiotherapy_kt_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_kt_date'] ) );
		$entity->instr_radiotherapy_kt_norm_yes_no_id = $this->getValFromRequest ( $request, 'instr_radiotherapy_kt_norm_yes_no_id' );
		$entity->instr_radiotherapy_kt_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_kt_descr'] );
		$entity->instr_radiotherapy_mrt_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_mrt_yes_no_id'] );
		$entity->instr_radiotherapy_mrt_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_mrt_date'] ) );
		$entity->instr_radiotherapy_mrt_norm_yes_no_id = $this->getValFromRequest ( $request, 'instr_radiotherapy_mrt_norm_yes_no_id' );
		$entity->instr_radiotherapy_mrt_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_mrt_descr'] );
		$entity->instr_radiotherapy_petkt_yes_no_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_petkt_yes_no_id'] );
		$entity->instr_radiotherapy_petkt_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_petkt_date'] ) );
		$entity->instr_radiotherapy_petkt_norm_yes_no_id = $this->getValFromRequest ( $request, 'instr_radiotherapy_petkt_norm_yes_no_id' );
		$entity->instr_radiotherapy_petkt_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['instr_radiotherapy_petkt_descr'] );
		$entity->patient_status_last_visit_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['patient_status_last_visit_date'] ) );
		$entity->patient_status_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['patient_status_id'] );
		$entity->patient_if_died_date = russianDateToMysqlDate ( $this->getNullForObjectFieldIfStringEmpty ( $request ['patient_if_died_date'] ) );
		$entity->patient_if_died_cause_id = $this->getNullForObjectFieldIfStringEmpty ( $request ['patient_if_died_cause_id'] );
		$entity->patient_if_died_cause_descr = $this->getNullForObjectFieldIfStringEmpty ( $request ['patient_if_died_cause_descr'] );
		$entity->user = $this->user;
		return $entity;
	}
	public function parse_form_to_investigation($request) {
		$investigation = new Investigation ();
		$investigation->id = $this->getNullForObjectFieldIfStringEmpty ( isset ( $request ['id'] ) == true ? $request ['id'] : null );
		$investigation->patient_id = intval ( $request ['patient_id'] );
		$investigation->tumor_another_existence_yes_no_id = intval ( $request ['tumor_another_existence_yes_no_id'] );
		$investigation->tumor_another_existence_discr = $this->getNullForObjectFieldIfStringEmpty ( $request ['tumor_another_existence_discr'] );
		$investigation->diagnosis = $this->getNullForObjectFieldIfStringEmpty ( $request ['diagnosis'] );
		$investigation->intestinum_crassum_part_id = intval ( $request ['intestinum_crassum_part_id'] );
		$investigation->colon_part_id = intval ( $request ['colon_part_id'] );
		$investigation->rectum_part_id = intval ( $request ['rectum_part_id'] );
		$investigation->treatment_discr = $this->getNullForObjectFieldIfStringEmpty ( $request ['treatment_discr'] );
		$investigation->status_gene_kras_id = intval ( $request ['status_gene_kras_id'] );
		$investigation->status_gene_kras3_id = intval ( $request ['status_gene_kras3_id'] );
		$investigation->status_gene_kras4_id = intval ( $request ['status_gene_kras4_id'] );
		$investigation->status_gene_nras2_id = intval ( $request ['status_gene_nras2_id'] );
		$investigation->status_gene_nras3_id = intval ( $request ['status_gene_nras3_id'] );
		$investigation->status_gene_nras4_id = intval ( $request ['status_gene_nras4_id'] );
		$investigation->setDateFromFormatDate ( $request ['date_invest'] );
		$investigation->depth_of_invasion_id = intval ( $request ['depth_of_invasion_id'] );
		$investigation->stage_id = intval ( $request ['stage_id'] );
		$investigation->metastasis_regional_lymph_nodes_yes_no_id = intval ( $request ['metastasis_regional_lymph_nodes_yes_no_id'] );
		$investigation->metastasis_regional_lymph_nodes_discr = $this->getNullForObjectFieldIfStringEmpty ( $request ['metastasis_regional_lymph_nodes_discr'] );
		$investigation->tumor_histological_type_id = intval ( $request ['tumor_histological_type_id'] );
		$investigation->tumor_differentiation_degree_id = intval ( $request ['tumor_differentiation_degree_id'] );
		$investigation->block = $this->getNullForObjectFieldIfStringEmpty ( $request ['block'] );
		$investigation->comments = $this->getNullForObjectFieldIfStringEmpty ( $request ['comments'] );
		$investigation->user = $this->user;
		;
		return $investigation;
	}
	public function parse_form_to_therapy($request) {
		$entity = new Therapy ();
		// echo "<h1>in parse_form_to_therapy start</h1>";
		// var_dump($request['id']);
		// echo "<h1>in parse_form_to_therapy end</h1>";
		$entity->id= $this->getNullForObjectFieldIfStringEmpty($request['id']);
		$entity->patient_id= $this->getNullForObjectFieldIfStringEmpty($request['patient_id']);
		$entity->visit_id= $this->getNullForObjectFieldIfStringEmpty($request['visit_id']);
		$entity->chmt_karboplatin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_karboplatin_yes_no_id']);
		$entity->chmt_cisplatin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_cisplatin_yes_no_id']);
		$entity->chmt_ciklofosfan_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_ciklofosfan_yes_no_id']);
		$entity->chmt_paklitaksel_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_paklitaksel_yes_no_id']);
		$entity->chmt_doksorubicin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_doksorubicin_yes_no_id']);
		$entity->chmt_topotekan_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_topotekan_yes_no_id']);
		$entity->chmt_gemcitabin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_gemcitabin_yes_no_id']);
		$entity->chmt_vinorelbin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_vinorelbin_yes_no_id']);
		$entity->chmt_irinotekan_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_irinotekan_yes_no_id']);
		$entity->chmt_jetopozid_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_jetopozid_yes_no_id']);
		$entity->chmt_jepirubicin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_jepirubicin_yes_no_id']);
		$entity->chmt_docetaksel_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_docetaksel_yes_no_id']);
		$entity->chmt_oksaliplatin_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_oksaliplatin_yes_no_id']);
		$entity->chmt_other_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['chmt_other_yes_no_id']);
		$entity->chmt_other_descr= $this->getNullForObjectFieldIfStringEmpty($request['chmt_other_descr']);
		$entity->chmt_date_start= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['chmt_date_start']));
		$entity->chmt_date_finish= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['chmt_date_finish']));
		$entity->instr_kt_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['instr_kt_yes_no_id']);
		$entity->instr_kt_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['instr_kt_date']));
		$entity->instr_kt_norm_yes_no_id= $this->getValFromRequest($request, 'instr_kt_norm_yes_no_id');
		$entity->instr_kt_descr= $this->getNullForObjectFieldIfStringEmpty($request['instr_kt_descr']);
		$entity->instr_mrt_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['instr_mrt_yes_no_id']);
		$entity->instr_mrt_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['instr_mrt_date']));
		$entity->instr_mrt_norm_yes_no_id= $this->getValFromRequest($request, 'instr_mrt_norm_yes_no_id');
		$entity->instr_mrt_descr= $this->getNullForObjectFieldIfStringEmpty($request['instr_mrt_descr']);
		$entity->instr_petkt_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['instr_petkt_yes_no_id']);
		$entity->instr_petkt_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['instr_petkt_date']));
		$entity->instr_petkt_norm_yes_no_id= $this->getValFromRequest($request, 'instr_petkt_norm_yes_no_id');
		$entity->instr_petkt_descr= $this->getNullForObjectFieldIfStringEmpty($request['instr_petkt_descr']);
		$entity->targeted_therapy_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_yes_no_id']);
		$entity->targeted_therapy_erlotinib_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_erlotinib_yes_no_id']);
		$entity->targeted_therapy_gefitinib_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_gefitinib_yes_no_id']);
		$entity->targeted_therapy_cryotinib_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_cryotinib_yes_no_id']);
		$entity->targeted_therapy_nivolumab_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_nivolumab_yes_no_id']);
		$entity->targeted_therapy_other_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_other_yes_no_id']);
		$entity->targeted_therapy_descr= $this->getNullForObjectFieldIfStringEmpty($request['targeted_therapy_descr']);
		$entity->side_effects_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['side_effects_yes_no_id']);
		$entity->side_effects_descr= $this->getNullForObjectFieldIfStringEmpty($request['side_effects_descr']);
		$entity->hb_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['hb_before_ct']);
		$entity->hb_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['hb_before_ct_date']));
		$entity->erythrocytes_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['erythrocytes_before_ct']);
		$entity->erythrocytes_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['erythrocytes_before_ct_date']));
		$entity->leuc_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['leuc_before_ct']);
		$entity->leuc_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['leuc_before_ct_date']));
		$entity->tromb_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['tromb_before_ct']);
		$entity->tromb_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['tromb_before_ct_date']));
		$entity->neutr_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['neutr_before_ct']);
		$entity->neutr_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['neutr_before_ct_date']));
		$entity->gen_prot_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['gen_prot_before_ct']);
		$entity->gen_prot_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['gen_prot_before_ct_date']));
		$entity->ast_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['ast_before_ct']);
		$entity->ast_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['ast_before_ct_date']));
		$entity->alt_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['alt_before_ct']);
		$entity->alt_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['alt_before_ct_date']));
		$entity->bilirubin_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['bilirubin_before_ct']);
		$entity->bilirubin_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['bilirubin_before_ct_date']));
		$entity->creat_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['creat_before_ct']);
		$entity->creat_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['creat_before_ct_date']));
		$entity->urea_before_ct= $this->getNullForObjectFieldIfStringEmpty($request['urea_before_ct']);
		$entity->urea_before_ct_date= russianDateToMysqlDate ($this->getNullForObjectFieldIfStringEmpty($request['urea_before_ct_date']));
		$entity->neurotoxicity_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['neurotoxicity_yes_no_id']);
		$entity->neurotoxicity_level_id= $this->getNullForObjectFieldIfStringEmpty($request['neurotoxicity_level_id']);
		$entity->skin_toxicity_yes_no_id= $this->getNullForObjectFieldIfStringEmpty($request['skin_toxicity_yes_no_id']);
		$entity->skin_toxicity_level_id= $this->getNullForObjectFieldIfStringEmpty($request['skin_toxicity_level_id']);
		$entity->user = $this->user;
		return $entity;
	}
	public function save_patient($patient) {
		if ($patient->id == null) {
			return $this->insert_patient ( $patient );
		} else {
			return $this->update_patient ( $patient );
		}
	}
	public function save_investigation($investigation) {
		if ($investigation->id == null) {
			return $this->insert_investigation ( $investigation );
		} else {
			return $this->update_investigation ( $investigation );
		}
	}
	public function save_therapy($entity) {
		// var_dump($entity->id);
		if ($entity->id == null) {
			// echo "<h1>insert</h1>";
			return $this->insert_therapy ( $entity );
		} else {
			// echo "<h1>update</h1>";
			return $this->update_therapy ( $entity );
		}
	}
	public function getUserByLogin($username) {
		$row = array ();
		$query = "SELECT * FROM " . DB_PREFIX . "user WHERE username_email = :username_email";
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':username_email', $username, PDO::PARAM_STR );
			
			$stmt->execute ();
			$row = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if ($stmt->rowCount () == 0) {
			return null;
		}
		$object = new User ();
		$object->id = $row [0] ['id'];
		$object->username_email = $row [0] ['username_email'];
		$object->password = $row [0] ['password'];
		$object->last_name = $row [0] ['last_name'];
		$object->first_name = $row [0] ['first_name'];
		$object->patronymic_name = $row [0] ['patronymic_name'];
		$object->sex_id = $row [0] ['sex_id'];
		$object->date_birth = $row [0] ['date_birth'];
		$object->project = $row [0] ['project'];
		$object->comments = $row [0] ['comments'];
		return $object;
	}
	public function is_user_exist($username, $pass = null) {
		$row = array ();
		$query = "SELECT * FROM " . DB_PREFIX . "user WHERE username_email = :username_email AND active=1";
		if ($pass != null) {
			// echo "<h1>asdasd</h1>";
			$query .= " AND password = :password";
		}
		try {
			$stmt = $this->pdo->prepare ( $query );
			$stmt->bindValue ( ':username_email', $username, PDO::PARAM_STR );
			if ($pass != null) {
				$stmt->bindValue ( ':password', $pass, PDO::PARAM_STR );
			}
			$stmt->execute ();
			$row = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if ($stmt->rowCount () == 0) {
			return false;
		}
		return true;
	}
	public function activate_user($user_name) {
		$query = "UPDATE
			  `" . DB_PREFIX . "user`  
			SET 
			  `active` = 1
			  WHERE 
			  `username_email` = :username_email
			;";
		
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue ( ':username_email', $user_name, PDO::PARAM_STR );
		
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' строка добавлена';
			if ($affected_rows > 0) {
				return true;
			}
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return false;
	}
	public function insert_user($object) {
		$query = "INSERT INTO
		  `" . DB_PREFIX . "user`
		(
		  `id`,
		  `username_email`,
		   `password`,
		  `last_name`,
		  `first_name`,
		  `patronymic_name`,
		  `sex_id`,
		  `date_birth`,
		  `project`,
		  `comments`
		  ) 
		VALUE (
		  null,
		  :username_email,
		  :password,
		  :last_name,
		  :first_name,
		  :patronymic_name,
		  :sex_id,
		  :date_birth,
		  :project,
		  :comments
		);";
		
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue ( ':username_email', $object->username_email, PDO::PARAM_STR );
		$stmt->bindValue ( ':password', $object->password, PDO::PARAM_STR );
		$stmt->bindValue ( ':last_name', $object->last_name, PDO::PARAM_STR );
		$stmt->bindValue ( ':first_name', $object->first_name, PDO::PARAM_STR );
		$stmt->bindValue ( ':patronymic_name', $object->patronymic_name, PDO::PARAM_STR );
		$stmt->bindValue ( ':sex_id', $object->sex_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':date_birth', $object->date_birth, PDO::PARAM_STR );
		$stmt->bindValue ( ':project', $object->project, PDO::PARAM_STR );
		$stmt->bindValue ( ':comments', $object->comments, PDO::PARAM_STR );
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' пациент добавлен';
			if ($affected_rows < 1) {
				die ( "Ошибка, объект не сохранен" );
			}
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $this->pdo->lastInsertId ();
	}
	public function insert_user_visit($object) {
		$query = "INSERT INTO
		  `" . DB_PREFIX . "user_visit`
		(
		  `id`,
		  `username`
		   		  ) 
		VALUE (
		  null,
		  :username
		);";
		
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue ( ':username', $object->username_email, PDO::PARAM_STR );
		
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' пациент добавлен';
			if ($affected_rows < 1) {
				die ( "Ошибка, объект не сохранен" );
			}
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $this->pdo->lastInsertId ();
	}
	
	public function insert_patient($entity) {
		$query = "INSERT INTO
				  " . DB_PREFIX . "patient
				(
  `id`,
  `patient_number`,
  `hospital_id`,
  `date_start_invest`,
  `doctor`,
  `inclusion_criteria_years_more18_yes_no_id`,
  `inclusion_criteria_diag_conf_histo_yes_no_id`,
  `inclusion_criteria_diag_conf_cyto_yes_no_id`,
  `inclusion_criteria_diag_conf_clin_radio_yes_no_id`,
  `inclusion_criteria_got_antitumor_therapy_yes_no_id`,
  `exclusion_criteria_not_got_antitumor_therapy_yes_no_id`,
  `date_birth`,
  `sex_id`,
  `place_living_id`,
  `social_status_id`,
  `diag_cancer_estab_date`,
  `cytologic_conclusion`,
  `diag_cancer_histotype`,
  `diag_cancer_degree_malignancy_id`,
  `immunohistochemical_study_id`,
  `immunohistochemical_study_descr`,
  `genetic_study_yes_no_id`,
  `genetic_study_fish`,
  `genetic_study_pcr`,
  `diag_cancer_tnm_stage_t_id`,
  `diag_cancer_tnm_stage_n_id`,
  `diag_cancer_tnm_stage_m_id`,
  `diag_cancer_clin_stage_id`,
  `diag_cancer_ecog_status_id`,
  `instr_kt_yes_no_id`,
  `instr_kt_date`,
  `instr_kt_norm_yes_no_id`,
  `instr_kt_descr`,
  `instr_mrt_yes_no_id`,
  `instr_mrt_date`,
  `instr_mrt_norm_yes_no_id`,
  `instr_mrt_descr`,
  `instr_petkt_yes_no_id`,
  `instr_petkt_date`,
  `instr_petkt_norm_yes_no_id`,
  `instr_petkt_descr`,
  `instr_radiotherapy_yes_no_id`,
  `instr_radiotherapy_type`,
  `instr_radiotherapy_start_date`,
  `instr_radiotherapy_end_date`,
  `instr_radiotherapy_kt_yes_no_id`,
  `instr_radiotherapy_kt_date`,
  `instr_radiotherapy_kt_norm_yes_no_id`,
  `instr_radiotherapy_kt_descr`,
  `instr_radiotherapy_mrt_yes_no_id`,
  `instr_radiotherapy_mrt_date`,
  `instr_radiotherapy_mrt_norm_yes_no_id`,
  `instr_radiotherapy_mrt_descr`,
  `instr_radiotherapy_petkt_yes_no_id`,
  `instr_radiotherapy_petkt_date`,
  `instr_radiotherapy_petkt_norm_yes_no_id`,
  `instr_radiotherapy_petkt_descr`,
  `patient_status_last_visit_date`,
  `patient_status_id`,
  `patient_if_died_date`,
  `patient_if_died_cause_id`,
  `patient_if_died_cause_descr`,
  `user`
) 
VALUE (
  :id,
  :patient_number,
  :hospital_id,
  :date_start_invest,
  :doctor,
  :inclusion_criteria_years_more18_yes_no_id,
  :inclusion_criteria_diag_conf_histo_yes_no_id,
  :inclusion_criteria_diag_conf_cyto_yes_no_id,
  :inclusion_criteria_diag_conf_clin_radio_yes_no_id,
  :inclusion_criteria_got_antitumor_therapy_yes_no_id,
  :exclusion_criteria_not_got_antitumor_therapy_yes_no_id,
  :date_birth,
  :sex_id,
  :place_living_id,
  :social_status_id,
  :diag_cancer_estab_date,
  :cytologic_conclusion,
  :diag_cancer_histotype,
  :diag_cancer_degree_malignancy_id,
  :immunohistochemical_study_id,
  :immunohistochemical_study_descr,
  :genetic_study_yes_no_id,
  :genetic_study_fish,
  :genetic_study_pcr,
  :diag_cancer_tnm_stage_t_id,
  :diag_cancer_tnm_stage_n_id,
  :diag_cancer_tnm_stage_m_id,
  :diag_cancer_clin_stage_id,
  :diag_cancer_ecog_status_id,
  :instr_kt_yes_no_id,
  :instr_kt_date,
  :instr_kt_norm_yes_no_id,
  :instr_kt_descr,
  :instr_mrt_yes_no_id,
  :instr_mrt_date,
  :instr_mrt_norm_yes_no_id,
  :instr_mrt_descr,
  :instr_petkt_yes_no_id,
  :instr_petkt_date,
  :instr_petkt_norm_yes_no_id,
  :instr_petkt_descr,
  :instr_radiotherapy_yes_no_id,
  :instr_radiotherapy_type,
  :instr_radiotherapy_start_date,
  :instr_radiotherapy_end_date,
  :instr_radiotherapy_kt_yes_no_id,
  :instr_radiotherapy_kt_date,
  :instr_radiotherapy_kt_norm_yes_no_id,
  :instr_radiotherapy_kt_descr,
  :instr_radiotherapy_mrt_yes_no_id,
  :instr_radiotherapy_mrt_date,
  :instr_radiotherapy_mrt_norm_yes_no_id,
  :instr_radiotherapy_mrt_descr,
  :instr_radiotherapy_petkt_yes_no_id,
  :instr_radiotherapy_petkt_date,
  :instr_radiotherapy_petkt_norm_yes_no_id,
  :instr_radiotherapy_petkt_descr,
  :patient_status_last_visit_date,
  :patient_status_id,
  :patient_if_died_date,
  :patient_if_died_cause_id,
  :patient_if_died_cause_descr,
  :user
)";
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue ( ':id', $entity->id, PDO::PARAM_STR );
		$stmt->bindValue ( ':patient_number', $entity->patient_number, PDO::PARAM_STR );
		$stmt->bindValue ( ':hospital_id', $entity->hospital_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':date_start_invest', $entity->date_start_invest, PDO::PARAM_STR );
		$stmt->bindValue ( ':doctor', $entity->doctor, PDO::PARAM_STR );
		$stmt->bindValue ( ':inclusion_criteria_years_more18_yes_no_id', $entity->inclusion_criteria_years_more18_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':inclusion_criteria_diag_conf_histo_yes_no_id', $entity->inclusion_criteria_diag_conf_histo_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':inclusion_criteria_diag_conf_cyto_yes_no_id', $entity->inclusion_criteria_diag_conf_cyto_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':inclusion_criteria_diag_conf_clin_radio_yes_no_id', $entity->inclusion_criteria_diag_conf_clin_radio_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':inclusion_criteria_got_antitumor_therapy_yes_no_id', $entity->inclusion_criteria_got_antitumor_therapy_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':exclusion_criteria_not_got_antitumor_therapy_yes_no_id', $entity->exclusion_criteria_not_got_antitumor_therapy_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':date_birth', $entity->date_birth, PDO::PARAM_STR );
		$stmt->bindValue ( ':sex_id', $entity->sex_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':place_living_id', $entity->place_living_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':social_status_id', $entity->social_status_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_estab_date', $entity->diag_cancer_estab_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':cytologic_conclusion', $entity->cytologic_conclusion, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_histotype', $entity->diag_cancer_histotype, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_degree_malignancy_id', $entity->diag_cancer_degree_malignancy_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':immunohistochemical_study_id', $entity->immunohistochemical_study_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':immunohistochemical_study_descr', $entity->immunohistochemical_study_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':genetic_study_yes_no_id', $entity->genetic_study_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':genetic_study_fish', $entity->genetic_study_fish, PDO::PARAM_STR );
		$stmt->bindValue ( ':genetic_study_pcr', $entity->genetic_study_pcr, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_tnm_stage_t_id', $entity->diag_cancer_tnm_stage_t_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_tnm_stage_n_id', $entity->diag_cancer_tnm_stage_n_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_tnm_stage_m_id', $entity->diag_cancer_tnm_stage_m_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_clin_stage_id', $entity->diag_cancer_clin_stage_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':diag_cancer_ecog_status_id', $entity->diag_cancer_ecog_status_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_kt_yes_no_id', $entity->instr_kt_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_kt_date', $entity->instr_kt_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_kt_norm_yes_no_id', $entity->instr_kt_norm_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_kt_descr', $entity->instr_kt_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_mrt_yes_no_id', $entity->instr_mrt_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_mrt_date', $entity->instr_mrt_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_mrt_norm_yes_no_id', $entity->instr_mrt_norm_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_mrt_descr', $entity->instr_mrt_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_petkt_yes_no_id', $entity->instr_petkt_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_petkt_date', $entity->instr_petkt_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_petkt_norm_yes_no_id', $entity->instr_petkt_norm_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_petkt_descr', $entity->instr_petkt_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_yes_no_id', $entity->instr_radiotherapy_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_type', $entity->instr_radiotherapy_type, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_start_date', $entity->instr_radiotherapy_start_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_end_date', $entity->instr_radiotherapy_end_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_kt_yes_no_id', $entity->instr_radiotherapy_kt_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_kt_date', $entity->instr_radiotherapy_kt_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_kt_norm_yes_no_id', $entity->instr_radiotherapy_kt_norm_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_kt_descr', $entity->instr_radiotherapy_kt_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_mrt_yes_no_id', $entity->instr_radiotherapy_mrt_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_mrt_date', $entity->instr_radiotherapy_mrt_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_mrt_norm_yes_no_id', $entity->instr_radiotherapy_mrt_norm_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_mrt_descr', $entity->instr_radiotherapy_mrt_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_petkt_yes_no_id', $entity->instr_radiotherapy_petkt_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_petkt_date', $entity->instr_radiotherapy_petkt_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_petkt_norm_yes_no_id', $entity->instr_radiotherapy_petkt_norm_yes_no_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':instr_radiotherapy_petkt_descr', $entity->instr_radiotherapy_petkt_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':patient_status_last_visit_date', $entity->patient_status_last_visit_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':patient_status_id', $entity->patient_status_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':patient_if_died_date', $entity->patient_if_died_date, PDO::PARAM_STR );
		$stmt->bindValue ( ':patient_if_died_cause_id', $entity->patient_if_died_cause_id, PDO::PARAM_STR );
		$stmt->bindValue ( ':patient_if_died_cause_descr', $entity->patient_if_died_cause_descr, PDO::PARAM_STR );
		$stmt->bindValue ( ':user', $entity->user, PDO::PARAM_STR );
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' пациент добавлен';
			if ($affected_rows < 1) {
				die ( "Ошибка, объект не сохранен" );
			}
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $this->pdo->lastInsertId ();
	}
	public function insert_therapy($entity) {
		$query = "INSERT INTO
				  " . DB_PREFIX . "therapy
				(
				  id,
				  patient_id,
				  visit_id,
				  chmt_karboplatin_yes_no_id,
				  chmt_cisplatin_yes_no_id,
				  chmt_ciklofosfan_yes_no_id,
				  chmt_paklitaksel_yes_no_id,
				  chmt_doksorubicin_yes_no_id,
				  chmt_topotekan_yes_no_id,
				  chmt_gemcitabin_yes_no_id,
				  chmt_vinorelbin_yes_no_id,
				  chmt_irinotekan_yes_no_id,
				  chmt_jetopozid_yes_no_id,
				  chmt_jepirubicin_yes_no_id,
				  chmt_docetaksel_yes_no_id,
				  chmt_oksaliplatin_yes_no_id,
				  chmt_other_yes_no_id,
				  chmt_other_descr,
				  chmt_date_start,
				  chmt_date_finish,
				  instr_kt_yes_no_id,
				  instr_kt_date,
				  instr_kt_norm_yes_no_id,
				  instr_kt_descr,
				  instr_mrt_yes_no_id,
				  instr_mrt_date,
				  instr_mrt_norm_yes_no_id,
				  instr_mrt_descr,
				  instr_petkt_yes_no_id,
				  instr_petkt_date,
				  instr_petkt_norm_yes_no_id,
				  instr_petkt_descr,
				  targeted_therapy_yes_no_id,
				  targeted_therapy_erlotinib_yes_no_id,
				  targeted_therapy_gefitinib_yes_no_id,
				  targeted_therapy_cryotinib_yes_no_id,
				  targeted_therapy_nivolumab_yes_no_id,
				  targeted_therapy_other_yes_no_id,
				  targeted_therapy_descr,
				  side_effects_yes_no_id,
				  side_effects_descr,
				  hb_before_ct,
				  hb_before_ct_date,
				  erythrocytes_before_ct,
				  erythrocytes_before_ct_date,
				  leuc_before_ct,
				  leuc_before_ct_date,
				  tromb_before_ct,
				  tromb_before_ct_date,
				  neutr_before_ct,
				  neutr_before_ct_date,
				  gen_prot_before_ct,
				  gen_prot_before_ct_date,
				  ast_before_ct,
				  ast_before_ct_date,
				  alt_before_ct,
				  alt_before_ct_date,
				  bilirubin_before_ct,
				  bilirubin_before_ct_date,
				  creat_before_ct,
				  creat_before_ct_date,
				  urea_before_ct,
				  urea_before_ct_date,
				  neurotoxicity_yes_no_id,
				  neurotoxicity_level_id,
				  skin_toxicity_yes_no_id,
				  skin_toxicity_level_id,
				  user
				) 
				VALUE (
				  :id,
				  :patient_id,
				  :visit_id,
				  :chmt_karboplatin_yes_no_id,
				  :chmt_cisplatin_yes_no_id,
				  :chmt_ciklofosfan_yes_no_id,
				  :chmt_paklitaksel_yes_no_id,
				  :chmt_doksorubicin_yes_no_id,
				  :chmt_topotekan_yes_no_id,
				  :chmt_gemcitabin_yes_no_id,
				  :chmt_vinorelbin_yes_no_id,
				  :chmt_irinotekan_yes_no_id,
				  :chmt_jetopozid_yes_no_id,
				  :chmt_jepirubicin_yes_no_id,
				  :chmt_docetaksel_yes_no_id,
				  :chmt_oksaliplatin_yes_no_id,
				  :chmt_other_yes_no_id,
				  :chmt_other_descr,
				  :chmt_date_start,
				  :chmt_date_finish,
				  :instr_kt_yes_no_id,
				  :instr_kt_date,
				  :instr_kt_norm_yes_no_id,
				  :instr_kt_descr,
				  :instr_mrt_yes_no_id,
				  :instr_mrt_date,
				  :instr_mrt_norm_yes_no_id,
				  :instr_mrt_descr,
				  :instr_petkt_yes_no_id,
				  :instr_petkt_date,
				  :instr_petkt_norm_yes_no_id,
				  :instr_petkt_descr,
				  :targeted_therapy_yes_no_id,
				  :targeted_therapy_erlotinib_yes_no_id,
				  :targeted_therapy_gefitinib_yes_no_id,
				  :targeted_therapy_cryotinib_yes_no_id,
				  :targeted_therapy_nivolumab_yes_no_id,
				  :targeted_therapy_other_yes_no_id,
				  :targeted_therapy_descr,
				  :side_effects_yes_no_id,
				  :side_effects_descr,
				  :hb_before_ct,
				  :hb_before_ct_date,
				  :erythrocytes_before_ct,
				  :erythrocytes_before_ct_date,
				  :leuc_before_ct,
				  :leuc_before_ct_date,
				  :tromb_before_ct,
				  :tromb_before_ct_date,
				  :neutr_before_ct,
				  :neutr_before_ct_date,
				  :gen_prot_before_ct,
				  :gen_prot_before_ct_date,
				  :ast_before_ct,
				  :ast_before_ct_date,
				  :alt_before_ct,
				  :alt_before_ct_date,
				  :bilirubin_before_ct,
				  :bilirubin_before_ct_date,
				  :creat_before_ct,
				  :creat_before_ct_date,
				  :urea_before_ct,
				  :urea_before_ct_date,
				  :neurotoxicity_yes_no_id,
				  :neurotoxicity_level_id,
				  :skin_toxicity_yes_no_id,
				  :skin_toxicity_level_id,
				  :user
				)";
		
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue(':id', $entity->id, PDO::PARAM_STR);
		$stmt->bindValue(':patient_id', $entity->patient_id, PDO::PARAM_STR);
		$stmt->bindValue(':visit_id', $entity->visit_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_karboplatin_yes_no_id', $entity->chmt_karboplatin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_cisplatin_yes_no_id', $entity->chmt_cisplatin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_ciklofosfan_yes_no_id', $entity->chmt_ciklofosfan_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_paklitaksel_yes_no_id', $entity->chmt_paklitaksel_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_doksorubicin_yes_no_id', $entity->chmt_doksorubicin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_topotekan_yes_no_id', $entity->chmt_topotekan_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_gemcitabin_yes_no_id', $entity->chmt_gemcitabin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_vinorelbin_yes_no_id', $entity->chmt_vinorelbin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_irinotekan_yes_no_id', $entity->chmt_irinotekan_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_jetopozid_yes_no_id', $entity->chmt_jetopozid_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_jepirubicin_yes_no_id', $entity->chmt_jepirubicin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_docetaksel_yes_no_id', $entity->chmt_docetaksel_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_oksaliplatin_yes_no_id', $entity->chmt_oksaliplatin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_other_yes_no_id', $entity->chmt_other_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_other_descr', $entity->chmt_other_descr, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_date_start', $entity->chmt_date_start, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_date_finish', $entity->chmt_date_finish, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_yes_no_id', $entity->instr_kt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_date', $entity->instr_kt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_norm_yes_no_id', $entity->instr_kt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_descr', $entity->instr_kt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_yes_no_id', $entity->instr_mrt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_date', $entity->instr_mrt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_norm_yes_no_id', $entity->instr_mrt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_descr', $entity->instr_mrt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_yes_no_id', $entity->instr_petkt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_date', $entity->instr_petkt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_norm_yes_no_id', $entity->instr_petkt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_descr', $entity->instr_petkt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_yes_no_id', $entity->targeted_therapy_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_erlotinib_yes_no_id', $entity->targeted_therapy_erlotinib_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_gefitinib_yes_no_id', $entity->targeted_therapy_gefitinib_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_cryotinib_yes_no_id', $entity->targeted_therapy_cryotinib_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_nivolumab_yes_no_id', $entity->targeted_therapy_nivolumab_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_other_yes_no_id', $entity->targeted_therapy_other_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_descr', $entity->targeted_therapy_descr, PDO::PARAM_STR);
		$stmt->bindValue(':side_effects_yes_no_id', $entity->side_effects_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':side_effects_descr', $entity->side_effects_descr, PDO::PARAM_STR);
		$stmt->bindValue(':hb_before_ct', $entity->hb_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':hb_before_ct_date', $entity->hb_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':erythrocytes_before_ct', $entity->erythrocytes_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':erythrocytes_before_ct_date', $entity->erythrocytes_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':leuc_before_ct', $entity->leuc_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':leuc_before_ct_date', $entity->leuc_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':tromb_before_ct', $entity->tromb_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':tromb_before_ct_date', $entity->tromb_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':neutr_before_ct', $entity->neutr_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':neutr_before_ct_date', $entity->neutr_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':gen_prot_before_ct', $entity->gen_prot_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':gen_prot_before_ct_date', $entity->gen_prot_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':ast_before_ct', $entity->ast_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':ast_before_ct_date', $entity->ast_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':alt_before_ct', $entity->alt_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':alt_before_ct_date', $entity->alt_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':bilirubin_before_ct', $entity->bilirubin_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':bilirubin_before_ct_date', $entity->bilirubin_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':creat_before_ct', $entity->creat_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':creat_before_ct_date', $entity->creat_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':urea_before_ct', $entity->urea_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':urea_before_ct_date', $entity->urea_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':neurotoxicity_yes_no_id', $entity->neurotoxicity_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':neurotoxicity_level_id', $entity->neurotoxicity_level_id, PDO::PARAM_STR);
		$stmt->bindValue(':skin_toxicity_yes_no_id', $entity->skin_toxicity_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':skin_toxicity_level_id', $entity->skin_toxicity_level_id, PDO::PARAM_STR);$stmt->bindValue ( ':user', $entity->user, PDO::PARAM_STR );
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' исследований добавлено';
			// if($affected_rows < 1){
			// die("Ошибка, объект не сохранен");
			// }
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $this->pdo->lastInsertId ();
	}
	public function update_patient($entity) {
		$query = "UPDATE
				  " . DB_PREFIX . "patient  
				SET 
				  `patient_number` = :patient_number,
				  `hospital_id` = :hospital_id,
				  `date_start_invest` = :date_start_invest,
				  `doctor` = :doctor,
				  `inclusion_criteria_years_more18_yes_no_id` = :inclusion_criteria_years_more18_yes_no_id,
				  `inclusion_criteria_diag_conf_histo_yes_no_id` = :inclusion_criteria_diag_conf_histo_yes_no_id,
				  `inclusion_criteria_diag_conf_cyto_yes_no_id` = :inclusion_criteria_diag_conf_cyto_yes_no_id,
				  `inclusion_criteria_diag_conf_clin_radio_yes_no_id` = :inclusion_criteria_diag_conf_clin_radio_yes_no_id,
				  `inclusion_criteria_got_antitumor_therapy_yes_no_id` = :inclusion_criteria_got_antitumor_therapy_yes_no_id,
				  `exclusion_criteria_not_got_antitumor_therapy_yes_no_id` = :exclusion_criteria_not_got_antitumor_therapy_yes_no_id,
				  `date_birth` = :date_birth,
				  `sex_id` = :sex_id,
				  `place_living_id` = :place_living_id,
				  `social_status_id` = :social_status_id,
				  `diag_cancer_estab_date` = :diag_cancer_estab_date,
				  `cytologic_conclusion` = :cytologic_conclusion,
				  `diag_cancer_histotype` = :diag_cancer_histotype,
                  `diag_cancer_degree_malignancy_id` = :diag_cancer_degree_malignancy_id,
				  `immunohistochemical_study_id` = :immunohistochemical_study_id,
				  `immunohistochemical_study_descr` = :immunohistochemical_study_descr,
				  `genetic_study_yes_no_id` = :genetic_study_yes_no_id,
				  `genetic_study_fish` = :genetic_study_fish,
				  `genetic_study_pcr` = :genetic_study_pcr,
				  `diag_cancer_tnm_stage_t_id` = :diag_cancer_tnm_stage_t_id,
				  `diag_cancer_tnm_stage_n_id` = :diag_cancer_tnm_stage_n_id,
				  `diag_cancer_tnm_stage_m_id` = :diag_cancer_tnm_stage_m_id,
				  `diag_cancer_clin_stage_id` = :diag_cancer_clin_stage_id,
				  `diag_cancer_ecog_status_id` = :diag_cancer_ecog_status_id,
				  `instr_kt_yes_no_id` = :instr_kt_yes_no_id,
				  `instr_kt_date` = :instr_kt_date,
				  `instr_kt_norm_yes_no_id` = :instr_kt_norm_yes_no_id,
				  `instr_kt_descr` = :instr_kt_descr,
				  `instr_mrt_yes_no_id` = :instr_mrt_yes_no_id,
				  `instr_mrt_date` = :instr_mrt_date,
				  `instr_mrt_norm_yes_no_id` = :instr_mrt_norm_yes_no_id,
				  `instr_mrt_descr` = :instr_mrt_descr,
				  `instr_petkt_yes_no_id` = :instr_petkt_yes_no_id,
				  `instr_petkt_date` = :instr_petkt_date,
				  `instr_petkt_norm_yes_no_id` = :instr_petkt_norm_yes_no_id,
				  `instr_petkt_descr` = :instr_petkt_descr,
				  `instr_radiotherapy_yes_no_id` = :instr_radiotherapy_yes_no_id,
				  `instr_radiotherapy_type` = :instr_radiotherapy_type,
				  `instr_radiotherapy_start_date` = :instr_radiotherapy_start_date,
				  `instr_radiotherapy_end_date` = :instr_radiotherapy_end_date,
				  `instr_radiotherapy_kt_yes_no_id` = :instr_radiotherapy_kt_yes_no_id,
				  `instr_radiotherapy_kt_date` = :instr_radiotherapy_kt_date,
				  `instr_radiotherapy_kt_norm_yes_no_id` = :instr_radiotherapy_kt_norm_yes_no_id,
				  `instr_radiotherapy_kt_descr` = :instr_radiotherapy_kt_descr,
				  `instr_radiotherapy_mrt_yes_no_id` = :instr_radiotherapy_mrt_yes_no_id,
				  `instr_radiotherapy_mrt_date` = :instr_radiotherapy_mrt_date,
				  `instr_radiotherapy_mrt_norm_yes_no_id` = :instr_radiotherapy_mrt_norm_yes_no_id,
				  `instr_radiotherapy_mrt_descr` = :instr_radiotherapy_mrt_descr,
				  `instr_radiotherapy_petkt_yes_no_id` = :instr_radiotherapy_petkt_yes_no_id,
				  `instr_radiotherapy_petkt_date` = :instr_radiotherapy_petkt_date,
				  `instr_radiotherapy_petkt_norm_yes_no_id` = :instr_radiotherapy_petkt_norm_yes_no_id,
				  `instr_radiotherapy_petkt_descr` = :instr_radiotherapy_petkt_descr,
				  `patient_status_last_visit_date` = :patient_status_last_visit_date,
				  `patient_status_id` = :patient_status_id,
				  `patient_if_died_date` = :patient_if_died_date,
				  `patient_if_died_cause_id` = :patient_if_died_cause_id,
				  `patient_if_died_cause_descr` = :patient_if_died_cause_descr,
				  `user` = :user 
				WHERE 
				  `id` = :id
				";
		
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue(':id', $entity->id, PDO::PARAM_STR);
		$stmt->bindValue(':patient_number', $entity->patient_number, PDO::PARAM_STR);
		$stmt->bindValue(':hospital_id', $entity->hospital_id, PDO::PARAM_STR);
		$stmt->bindValue(':date_start_invest', $entity->date_start_invest, PDO::PARAM_STR);
		$stmt->bindValue(':doctor', $entity->doctor, PDO::PARAM_STR);
		$stmt->bindValue(':inclusion_criteria_years_more18_yes_no_id', $entity->inclusion_criteria_years_more18_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':inclusion_criteria_diag_conf_histo_yes_no_id', $entity->inclusion_criteria_diag_conf_histo_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':inclusion_criteria_diag_conf_cyto_yes_no_id', $entity->inclusion_criteria_diag_conf_cyto_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':inclusion_criteria_diag_conf_clin_radio_yes_no_id', $entity->inclusion_criteria_diag_conf_clin_radio_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':inclusion_criteria_got_antitumor_therapy_yes_no_id', $entity->inclusion_criteria_got_antitumor_therapy_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':exclusion_criteria_not_got_antitumor_therapy_yes_no_id', $entity->exclusion_criteria_not_got_antitumor_therapy_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':date_birth', $entity->date_birth, PDO::PARAM_STR);
		$stmt->bindValue(':sex_id', $entity->sex_id, PDO::PARAM_STR);
		$stmt->bindValue(':place_living_id', $entity->place_living_id, PDO::PARAM_STR);
		$stmt->bindValue(':social_status_id', $entity->social_status_id, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_estab_date', $entity->diag_cancer_estab_date, PDO::PARAM_STR);
		$stmt->bindValue(':cytologic_conclusion', $entity->cytologic_conclusion, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_histotype', $entity->diag_cancer_histotype, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_degree_malignancy_id', $entity->diag_cancer_degree_malignancy_id, PDO::PARAM_STR);
		$stmt->bindValue(':immunohistochemical_study_id', $entity->immunohistochemical_study_id, PDO::PARAM_STR);
		$stmt->bindValue(':immunohistochemical_study_descr', $entity->immunohistochemical_study_descr, PDO::PARAM_STR);
		$stmt->bindValue(':genetic_study_yes_no_id', $entity->genetic_study_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':genetic_study_fish', $entity->genetic_study_fish, PDO::PARAM_STR);
		$stmt->bindValue(':genetic_study_pcr', $entity->genetic_study_pcr, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_tnm_stage_t_id', $entity->diag_cancer_tnm_stage_t_id, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_tnm_stage_n_id', $entity->diag_cancer_tnm_stage_n_id, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_tnm_stage_m_id', $entity->diag_cancer_tnm_stage_m_id, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_clin_stage_id', $entity->diag_cancer_clin_stage_id, PDO::PARAM_STR);
		$stmt->bindValue(':diag_cancer_ecog_status_id', $entity->diag_cancer_ecog_status_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_yes_no_id', $entity->instr_kt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_date', $entity->instr_kt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_norm_yes_no_id', $entity->instr_kt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_descr', $entity->instr_kt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_yes_no_id', $entity->instr_mrt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_date', $entity->instr_mrt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_norm_yes_no_id', $entity->instr_mrt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_descr', $entity->instr_mrt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_yes_no_id', $entity->instr_petkt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_date', $entity->instr_petkt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_norm_yes_no_id', $entity->instr_petkt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_descr', $entity->instr_petkt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_yes_no_id', $entity->instr_radiotherapy_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_type', $entity->instr_radiotherapy_type, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_start_date', $entity->instr_radiotherapy_start_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_end_date', $entity->instr_radiotherapy_end_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_kt_yes_no_id', $entity->instr_radiotherapy_kt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_kt_date', $entity->instr_radiotherapy_kt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_kt_norm_yes_no_id', $entity->instr_radiotherapy_kt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_kt_descr', $entity->instr_radiotherapy_kt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_mrt_yes_no_id', $entity->instr_radiotherapy_mrt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_mrt_date', $entity->instr_radiotherapy_mrt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_mrt_norm_yes_no_id', $entity->instr_radiotherapy_mrt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_mrt_descr', $entity->instr_radiotherapy_mrt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_petkt_yes_no_id', $entity->instr_radiotherapy_petkt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_petkt_date', $entity->instr_radiotherapy_petkt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_petkt_norm_yes_no_id', $entity->instr_radiotherapy_petkt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_radiotherapy_petkt_descr', $entity->instr_radiotherapy_petkt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':patient_status_last_visit_date', $entity->patient_status_last_visit_date, PDO::PARAM_STR);
		$stmt->bindValue(':patient_status_id', $entity->patient_status_id, PDO::PARAM_STR);
		$stmt->bindValue(':patient_if_died_date', $entity->patient_if_died_date, PDO::PARAM_STR);
		$stmt->bindValue(':patient_if_died_cause_id', $entity->patient_if_died_cause_id, PDO::PARAM_STR);
		$stmt->bindValue(':patient_if_died_cause_descr', $entity->patient_if_died_cause_descr, PDO::PARAM_STR);
		$stmt->bindValue(':user', $entity->user, PDO::PARAM_STR);
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' пациент добавлен';
			if ($affected_rows < 1) {
				// die("Ошибка, объект не обновлен");
			}
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $entity->id;
	}
	public function update_therapy($entity) {
		// echo "in update_therapy<br/>";
		$query = "UPDATE
		  " . DB_PREFIX . "therapy  
		SET 
		  patient_id = :patient_id,
		  visit_id = :visit_id,
		  chmt_karboplatin_yes_no_id = :chmt_karboplatin_yes_no_id,
		  chmt_cisplatin_yes_no_id = :chmt_cisplatin_yes_no_id,
		  chmt_ciklofosfan_yes_no_id = :chmt_ciklofosfan_yes_no_id,
		  chmt_paklitaksel_yes_no_id = :chmt_paklitaksel_yes_no_id,
		  chmt_doksorubicin_yes_no_id = :chmt_doksorubicin_yes_no_id,
		  chmt_topotekan_yes_no_id = :chmt_topotekan_yes_no_id,
		  chmt_gemcitabin_yes_no_id = :chmt_gemcitabin_yes_no_id,
		  chmt_vinorelbin_yes_no_id = :chmt_vinorelbin_yes_no_id,
		  chmt_irinotekan_yes_no_id = :chmt_irinotekan_yes_no_id,
		  chmt_jetopozid_yes_no_id = :chmt_jetopozid_yes_no_id,
		  chmt_jepirubicin_yes_no_id = :chmt_jepirubicin_yes_no_id,
		  chmt_docetaksel_yes_no_id = :chmt_docetaksel_yes_no_id,
		  chmt_oksaliplatin_yes_no_id = :chmt_oksaliplatin_yes_no_id,
		  chmt_other_yes_no_id = :chmt_other_yes_no_id,
		  chmt_other_descr = :chmt_other_descr,
		  chmt_date_start = :chmt_date_start,
		  chmt_date_finish = :chmt_date_finish,
		  instr_kt_yes_no_id = :instr_kt_yes_no_id,
		  instr_kt_date = :instr_kt_date,
		  instr_kt_norm_yes_no_id = :instr_kt_norm_yes_no_id,
		  instr_kt_descr = :instr_kt_descr,
		  instr_mrt_yes_no_id = :instr_mrt_yes_no_id,
		  instr_mrt_date = :instr_mrt_date,
		  instr_mrt_norm_yes_no_id = :instr_mrt_norm_yes_no_id,
		  instr_mrt_descr = :instr_mrt_descr,
		  instr_petkt_yes_no_id = :instr_petkt_yes_no_id,
		  instr_petkt_date = :instr_petkt_date,
		  instr_petkt_norm_yes_no_id = :instr_petkt_norm_yes_no_id,
		  instr_petkt_descr = :instr_petkt_descr,
		  targeted_therapy_yes_no_id = :targeted_therapy_yes_no_id,
		  targeted_therapy_erlotinib_yes_no_id = :targeted_therapy_erlotinib_yes_no_id,
		  targeted_therapy_gefitinib_yes_no_id = :targeted_therapy_gefitinib_yes_no_id,
		  targeted_therapy_cryotinib_yes_no_id = :targeted_therapy_cryotinib_yes_no_id,
		  targeted_therapy_nivolumab_yes_no_id = :targeted_therapy_nivolumab_yes_no_id,
		  targeted_therapy_other_yes_no_id = :targeted_therapy_other_yes_no_id,
		  targeted_therapy_descr = :targeted_therapy_descr,
		  side_effects_yes_no_id = :side_effects_yes_no_id,
		  side_effects_descr = :side_effects_descr,
		  hb_before_ct = :hb_before_ct,
		  hb_before_ct_date = :hb_before_ct_date,
		  erythrocytes_before_ct = :erythrocytes_before_ct,
		  erythrocytes_before_ct_date = :erythrocytes_before_ct_date,
		  leuc_before_ct = :leuc_before_ct,
		  leuc_before_ct_date = :leuc_before_ct_date,
		  tromb_before_ct = :tromb_before_ct,
		  tromb_before_ct_date = :tromb_before_ct_date,
		  neutr_before_ct = :neutr_before_ct,
		  neutr_before_ct_date = :neutr_before_ct_date,
		  gen_prot_before_ct = :gen_prot_before_ct,
		  gen_prot_before_ct_date = :gen_prot_before_ct_date,
		  ast_before_ct = :ast_before_ct,
		  ast_before_ct_date = :ast_before_ct_date,
		  alt_before_ct = :alt_before_ct,
		  alt_before_ct_date = :alt_before_ct_date,
		  bilirubin_before_ct = :bilirubin_before_ct,
		  bilirubin_before_ct_date = :bilirubin_before_ct_date,
		  creat_before_ct = :creat_before_ct,
		  creat_before_ct_date = :creat_before_ct_date,
		  urea_before_ct = :urea_before_ct,
		  urea_before_ct_date = :urea_before_ct_date,
		  neurotoxicity_yes_no_id = :neurotoxicity_yes_no_id,
		  neurotoxicity_level_id = :neurotoxicity_level_id,
		  skin_toxicity_yes_no_id = :skin_toxicity_yes_no_id,
		  skin_toxicity_level_id = :skin_toxicity_level_id,
		  user = :user 
		WHERE 
		  id = :id";
		$stmt = $this->pdo->prepare ( $query );
		$stmt->bindValue(':id', $entity->id, PDO::PARAM_STR);
		$stmt->bindValue(':patient_id', $entity->patient_id, PDO::PARAM_STR);
		$stmt->bindValue(':visit_id', $entity->visit_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_karboplatin_yes_no_id', $entity->chmt_karboplatin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_cisplatin_yes_no_id', $entity->chmt_cisplatin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_ciklofosfan_yes_no_id', $entity->chmt_ciklofosfan_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_paklitaksel_yes_no_id', $entity->chmt_paklitaksel_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_doksorubicin_yes_no_id', $entity->chmt_doksorubicin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_topotekan_yes_no_id', $entity->chmt_topotekan_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_gemcitabin_yes_no_id', $entity->chmt_gemcitabin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_vinorelbin_yes_no_id', $entity->chmt_vinorelbin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_irinotekan_yes_no_id', $entity->chmt_irinotekan_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_jetopozid_yes_no_id', $entity->chmt_jetopozid_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_jepirubicin_yes_no_id', $entity->chmt_jepirubicin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_docetaksel_yes_no_id', $entity->chmt_docetaksel_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_oksaliplatin_yes_no_id', $entity->chmt_oksaliplatin_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_other_yes_no_id', $entity->chmt_other_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_other_descr', $entity->chmt_other_descr, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_date_start', $entity->chmt_date_start, PDO::PARAM_STR);
		$stmt->bindValue(':chmt_date_finish', $entity->chmt_date_finish, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_yes_no_id', $entity->instr_kt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_date', $entity->instr_kt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_norm_yes_no_id', $entity->instr_kt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_kt_descr', $entity->instr_kt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_yes_no_id', $entity->instr_mrt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_date', $entity->instr_mrt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_norm_yes_no_id', $entity->instr_mrt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_mrt_descr', $entity->instr_mrt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_yes_no_id', $entity->instr_petkt_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_date', $entity->instr_petkt_date, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_norm_yes_no_id', $entity->instr_petkt_norm_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':instr_petkt_descr', $entity->instr_petkt_descr, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_yes_no_id', $entity->targeted_therapy_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_erlotinib_yes_no_id', $entity->targeted_therapy_erlotinib_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_gefitinib_yes_no_id', $entity->targeted_therapy_gefitinib_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_cryotinib_yes_no_id', $entity->targeted_therapy_cryotinib_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_nivolumab_yes_no_id', $entity->targeted_therapy_nivolumab_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_other_yes_no_id', $entity->targeted_therapy_other_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':targeted_therapy_descr', $entity->targeted_therapy_descr, PDO::PARAM_STR);
		$stmt->bindValue(':side_effects_yes_no_id', $entity->side_effects_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':side_effects_descr', $entity->side_effects_descr, PDO::PARAM_STR);
		$stmt->bindValue(':hb_before_ct', $entity->hb_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':hb_before_ct_date', $entity->hb_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':erythrocytes_before_ct', $entity->erythrocytes_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':erythrocytes_before_ct_date', $entity->erythrocytes_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':leuc_before_ct', $entity->leuc_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':leuc_before_ct_date', $entity->leuc_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':tromb_before_ct', $entity->tromb_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':tromb_before_ct_date', $entity->tromb_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':neutr_before_ct', $entity->neutr_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':neutr_before_ct_date', $entity->neutr_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':gen_prot_before_ct', $entity->gen_prot_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':gen_prot_before_ct_date', $entity->gen_prot_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':ast_before_ct', $entity->ast_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':ast_before_ct_date', $entity->ast_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':alt_before_ct', $entity->alt_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':alt_before_ct_date', $entity->alt_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':bilirubin_before_ct', $entity->bilirubin_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':bilirubin_before_ct_date', $entity->bilirubin_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':creat_before_ct', $entity->creat_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':creat_before_ct_date', $entity->creat_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':urea_before_ct', $entity->urea_before_ct, PDO::PARAM_STR);
		$stmt->bindValue(':urea_before_ct_date', $entity->urea_before_ct_date, PDO::PARAM_STR);
		$stmt->bindValue(':neurotoxicity_yes_no_id', $entity->neurotoxicity_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':neurotoxicity_level_id', $entity->neurotoxicity_level_id, PDO::PARAM_STR);
		$stmt->bindValue(':skin_toxicity_yes_no_id', $entity->skin_toxicity_yes_no_id, PDO::PARAM_STR);
		$stmt->bindValue(':skin_toxicity_level_id', $entity->skin_toxicity_level_id, PDO::PARAM_STR);
		$stmt->bindValue ( ':user', $this->user, PDO::PARAM_STR );
		// echo "<br>".$stmt->queryString . "<br>";
		try {
			$stmt->execute ();
			$affected_rows = $stmt->rowCount ();
			// echo $affected_rows.' пациент добавлен';
			if ($affected_rows < 1) {
				// die("Ошибка, объект не обновлен");
			}
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		return $entity->id;
	}
	public function getYearDateFromRussianString($dateRus) {
		if (strlen ( $dateRus ) == 0) {
			return "null";
		}
		$parts = explode ( '/', $dateRus );
		return "'$parts[2]'";
	}
	public function getUniqueDoctorNames() {
		return $this->getUniqueNames ( "doctor" );
	}
	public function getUniqueHospitalNames() {
		return $this->getUniqueNames ( "hospital" );
	}
	public function getUniqueNames($column) {
		$results = array ();
		$arrayReturn = array ();
		$query = sprintf ( 'SELECT DISTINCT(%1$s) as name from kras_patient WHERE %1$s is not null ORDER BY %1$s', $column );
		try {
			$stmt = $this->pdo->query ( $query );
			$results = $stmt->fetchAll ( PDO::FETCH_ASSOC );
		} catch ( PDOException $ex ) {
			echo "Ошибка:" . $ex->getMessage ();
		}
		if (count ( $results ) == 0) {
			return "";
		}
		foreach ( $results as $key => $value ) {
			$arrayReturn [] = $value ['name'];
		}
		
		return $arrayReturn;
	}
}

?>