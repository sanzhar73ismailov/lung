
ALTER TABLE `lung_therapy` ADD INDEX `visit_id` (`visit_id`);
ALTER TABLE `lung_therapy` ADD UNIQUE `patient_id` (`patient_id`, `visit_id`);

CREATE TABLE `lung_dic_list` (
  `id` VARCHAR(50) COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'Идентификатор справочника',
  `name` VARCHAR(100) COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'Название справочника',
  `rownum` INTEGER(11) NOT NULL AUTO_INCREMENT COMMENT 'счетчик',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `rownum` (`rownum`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

CREATE TABLE `lung_dic_val` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `dic_list_id` VARCHAR(50) COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'внеш ключ к dic_list',
  `value_id` INTEGER(11) NOT NULL COMMENT 'ключ',
  `value_name` VARCHAR(100) COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'описание',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dic_list_value_id` (`dic_list_id`, `value_id`),
  KEY `dic_list_id` (`dic_list_id`),
  KEY `value_id` (`value_id`)
)ENGINE=InnoDB
AUTO_INCREMENT=629 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

SELECT concat( 
'INSERT INTO lung_dic_list (id, name) VALUES (\'',col.column_name,'\',\'', col.COLUMN_COMMENT,'\');')
FROM INFORMATION_SCHEMA.COLUMNS col
WHERE col.TABLE_SCHEMA = 'lung' 
AND col.TABLE_NAME = 'lung_therapy'
and col.column_name like '%_id'
and col.column_name not like '%yes_no_id'
order by ordinal_position
;

INSERT INTO lung_dic_list (id, name) VALUES ('hospital_id','Мед. центра откуда материл (справочник)');
INSERT INTO lung_dic_list (id, name) VALUES ('sex_id','Пол');
INSERT INTO lung_dic_list (id, name) VALUES ('place_living_id','Место жительства');
INSERT INTO lung_dic_list (id, name) VALUES ('social_status_id','Социальный статус');
INSERT INTO lung_dic_list (id, name) VALUES ('diag_cancer_degree_malignancy_id','Степень злокачественности');
INSERT INTO lung_dic_list (id, name) VALUES ('immunohistochemical_study_id','Иммуногистохимическое исследование');
INSERT INTO lung_dic_list (id, name) VALUES ('diag_cancer_tnm_stage_t_id','Стадия заболевания по системе TNM - T');
INSERT INTO lung_dic_list (id, name) VALUES ('diag_cancer_tnm_stage_n_id','Стадия заболевания по системе TNM - N');
INSERT INTO lung_dic_list (id, name) VALUES ('diag_cancer_tnm_stage_m_id','Стадия заболевания по системе TNM - M');
INSERT INTO lung_dic_list (id, name) VALUES ('diag_cancer_clin_stage_id','Клиническая стадия заболевания');
INSERT INTO lung_dic_list (id, name) VALUES ('diag_cancer_ecog_status_id','ECOG статус на момент постановки диагноза и начала лечения');
INSERT INTO lung_dic_list (id, name) VALUES ('patient_status_id','Статус пациента на момент завершения исследования');
INSERT INTO lung_dic_list (id, name) VALUES ('patient_if_died_cause_id','Причина смерти');


INSERT INTO lung_dic_list (id, name) VALUES ('patient_id','Пациент');
INSERT INTO lung_dic_list (id, name) VALUES ('visit_id','Номер визита');
INSERT INTO lung_dic_list (id, name) VALUES ('neurotoxicity_level_id','Степень нейротоксичности');
INSERT INTO lung_dic_list (id, name) VALUES ('skin_toxicity_level_id','Степень кожной токсичности');

INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('no_data_id',-1,'нет данных');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('hospital_id',1,'Алматинский ОЦ');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('hospital_id',2,'ВК ООД, г. Усть-Каменогорск');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('hospital_id',3,'Алматинский ООД, г. Талдыкорган');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('hospital_id',4,'Кызылординский ООД, г. Кзылорда');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('hospital_id',5,'ЮК ООД, г. Шымкент');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('sex_id',1,'Мужской');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('sex_id',2,'Женский');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('place_living_id',1,'город');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('place_living_id',2,'село');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('social_status_id',1,'Студент');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('social_status_id',2,'Работает');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('social_status_id',3,'Пенсионер');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('social_status_id',4,'Другое');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('immunohistochemical_study_id',0,'нет');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('immunohistochemical_study_id',1,'да');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('immunohistochemical_study_id',2,'экспрессия EGFR');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('immunohistochemical_study_id',3,'экспрессия ALK');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',1,'T0');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',2,'Tis');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',3,'T1');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',4,'T2');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',5,'T3');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',6,'T4');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_t_id',7,'Tx');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_n_id',1,'N0');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_n_id',2,'N1');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_n_id',3,'N2');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_n_id',4,'N3');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_n_id',5,'Nx');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_m_id',1,'M0');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_m_id',2,'M1');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_tnm_stage_m_id',3,'Mx');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_clin_stage_id',1,'I');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_clin_stage_id',2,'II');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_clin_stage_id',3,'III');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_clin_stage_id',4,'IV');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_ecog_status_id',1,'0');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_ecog_status_id',2,'1');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_ecog_status_id',3,'2');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_ecog_status_id',4,'3');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('diag_cancer_ecog_status_id',5,'неизвестно');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('patient_status_id',1,'жив');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('patient_status_id',0,'умер');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('patient_status_id',3,'неизвестно');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('patient_if_died_cause_id',1,'прогрессирование основного заболевания');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('patient_if_died_cause_id',2,'осложнения противоопухолевой терапии ');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('patient_if_died_cause_id',3,'другие причины');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('neurotoxicity_level_id',1,'1 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('neurotoxicity_level_id',2,'2 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('neurotoxicity_level_id',3,'3 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('neurotoxicity_level_id',4,'4 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('skin_toxicity_level_id',1,'1 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('skin_toxicity_level_id',2,'2 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('skin_toxicity_level_id',3,'3 степень токсичности');
INSERT INTO lung_dic_val (dic_list_id,value_id,value_name) VALUE ('skin_toxicity_level_id',4,'4 степень токсичности');


CREATE TABLE `lung_user` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `username_email` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `password` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `active` INTEGER(11) DEFAULT '0',
  `last_name` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `first_name` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `patronymic_name` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `sex_id` INTEGER(11) DEFAULT '-1' COMMENT 'Пол',
  `date_birth` DATE DEFAULT NULL COMMENT 'Дата рождения',
  `project` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL,
  `comments` VARCHAR(100) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Примечание',
  `user` VARCHAR(25) COLLATE utf8_general_ci DEFAULT NULL,
  `insert_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_email` (`username_email`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

CREATE TABLE `lung_user_visit` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(40) COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `date_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`, `date_time`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'

/* Data for the `anemia_user` table  (Records 1 - 7) */

INSERT INTO `lung_user` (`id`, `username_email`, `password`, `active`, `last_name`, `first_name`, `patronymic_name`, `sex_id`, `date_birth`, `project`, `comments`, `user`, `insert_date`) VALUES 
  (30, 'sanzhar73@mail.ru', 'd8578edf8458ce06fbc5bb76a58c5ca4', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2014-05-07 08:37:11'),
  (39, 'sanzhar73@gmail.com', 'd8578edf8458ce06fbc5bb76a58c5ca4', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2014-06-05 15:54:50'),
  (40, 'surya_esentay@mail.ru', '652c68312240e6e3b5ce66d3238ca8b3', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2014-06-06 02:13:08'),
  (41, 'gulsum_smagulova@mail.ru', '3e1fcaf6d5289b672b2cf4550c47143c', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2014-09-19 19:33:38'),
  (42, 'test@test.kz', 'd8578edf8458ce06fbc5bb76a58c5ca4', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-02-21 03:39:35'),
  (43, 'maliwka8970@gmail.com', '03e896bb6f287260e7f7dd3c52d19962', 1, 'maliwka8970qwerty', 'Гульжан', '', NULL, NULL, NULL, NULL, NULL, '2017-05-15 08:04:02'),
  (44, 'akaldygul@mail.ru', '7eee16cbccfcd2e8aac25f8db75e7346', 1, 'akaldygul@mail.ru', 'Калдыгуль', '', 0, NULL, NULL, NULL, NULL, '2017-05-15 08:04:02');

COMMIT;

ALTER TABLE `lung_user` ADD COLUMN `role_id` VARCHAR(20) DEFAULT NULL COMMENT 'Роль пользователя' AFTER `comments`;
ALTER TABLE `lung_user` ADD COLUMN `hospital_id` INTEGER(11) DEFAULT NULL COMMENT 'Мед центр (сайт), к которому относится пользователь (в случае, если роль investigator)' AFTER `role_id`;
commit;


CREATE TABLE `lung_patient` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `patient_number` varchar(10) NOT NULL DEFAULT '' COMMENT 'Номер пациента (уникальный в пределах исследования)',
  `hospital_id` int(11) NOT NULL COMMENT 'Мед. центра откуда материл (справочник)',
  `date_start_invest` date NOT NULL COMMENT 'Дата включения в исследование',
  `doctor` varchar(100) NOT NULL DEFAULT '' COMMENT 'ФИО врача',
  `inclusion_criteria_years_more18_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Пациент 18 лет и старше, с впервые в жизни выявленным НМРЛ в 2015-2016 г.г. (да, нет)',
  `inclusion_criteria_diag_conf_histo_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Диагноз НМРЛ подтвержден гистологически (да, нет)',
  `inclusion_criteria_diag_conf_cyto_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Диагноз НМРЛ подтвержден цитологически (да, нет)',
  `inclusion_criteria_diag_conf_clin_radio_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Диагноз выставлен на основе клинико-рентгенологических данных (да, нет)',
  `inclusion_criteria_got_antitumor_therapy_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Пациент, получавший любой вид противоопухолевой терапии в 2015-2017 г.г. (хирургический, химиотерапевтический, таргетрная терапия, лучевая терапия) (да, нет)',
  `exclusion_criteria_not_got_antitumor_therapy_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Пациенты с впервые выявленным НМРЛ, но не получившие ни один из видов противоопухолевой терапии из-за наличия сопутствующей патологии или взятые на учет посмертно (да, нет)',
  `date_birth` date NOT NULL COMMENT 'Дата рождения',
  `sex_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Пол',
  `place_living_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Место жительства',
  `social_status_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Социальный статус',
  `diag_cancer_estab_date` date NOT NULL COMMENT 'Дата постановки диагноза рак',
  `cytologic_conclusion` varchar(255) NOT NULL DEFAULT '' COMMENT 'Цитологическое заключение',
  `diag_cancer_histotype` varchar(100) NOT NULL DEFAULT '' COMMENT 'Гистологический тип опухоли',
  `diag_cancer_degree_malignancy_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Степень злокачественности',
  `immunohistochemical_study_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Иммуногистохимическое исследование',
  `immunohistochemical_study_descr` varchar(255) NOT NULL DEFAULT '' COMMENT 'Иммуногистохимическое исследование: описание',
  
  `genetic_study_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Генетические исследования (да, нет)',
  `genetic_study_fish` varchar(255) NOT NULL DEFAULT '' COMMENT 'FISH результат',
  `genetic_study_pcr` varchar(255) NOT NULL DEFAULT '' COMMENT 'ПЦР результат',
  
  `diag_cancer_tnm_stage_t_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Стадия заболевания по системе TNM - T',
  `diag_cancer_tnm_stage_n_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Стадия заболевания по системе TNM - N',
  `diag_cancer_tnm_stage_m_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Стадия заболевания по системе TNM - M',
  `diag_cancer_clin_stage_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Клиническая стадия заболевания',
  `diag_cancer_ecog_status_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'ECOG статус на момент постановки диагноза и начала лечения',
  
  `instr_kt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: КТ да/нет',
  `instr_kt_date` DATE DEFAULT NULL COMMENT 'Инструментальные исследования: КТ дата',
  `instr_kt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: КТ норма/патология',
  `instr_kt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Инструментальные исследования: КТ Заключение',
  
  `instr_mrt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: МРТ да/нет',
  `instr_mrt_date` DATE DEFAULT NULL COMMENT 'Инструментальные исследования: МРТ дата',
  `instr_mrt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: МРТ норма/патология',
  `instr_mrt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Инструментальные исследования: МРТ Заключение',
  
  `instr_petkt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: ПЭТ-КТ да/нет',
  `instr_petkt_date` DATE DEFAULT NULL COMMENT 'Инструментальные исследования: ПЭТ-КТ дата',
  `instr_petkt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: ПЭТ-КТ норма/патология',
  `instr_petkt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Инструментальные исследования: ПЭТ-КТ Заключение',

  `instr_radiotherapy_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия да/нет',
  `instr_radiotherapy_type` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ЛУЧЕВАЯ ТЕРАПИЯ: вид, РОД, СОД и пр.',
  `instr_radiotherapy_start_date` DATE DEFAULT NULL COMMENT 'Лучевая терапия: дата начала',
  `instr_radiotherapy_end_date` DATE DEFAULT NULL COMMENT 'Лучевая терапия: дата завершения',
  
  `instr_radiotherapy_kt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия: Инструментальные исследования: КТ да/нет',
  `instr_radiotherapy_kt_date` DATE DEFAULT NULL COMMENT 'Лучевая терапия: Инструментальные исследования: КТ дата',
  `instr_radiotherapy_kt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия: Инструментальные исследования: КТ норма/патология',
  `instr_radiotherapy_kt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Лучевая терапия: Инструментальные исследования: КТ Заключение',
  
  `instr_radiotherapy_mrt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия: Инструментальные исследования: МРТ да/нет',
  `instr_radiotherapy_mrt_date` DATE DEFAULT NULL COMMENT 'Лучевая терапия: Инструментальные исследования: МРТ дата',
  `instr_radiotherapy_mrt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия: Инструментальные исследования: МРТ норма/патология',
  `instr_radiotherapy_mrt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Лучевая терапия: Инструментальные исследования: МРТ Заключение',
  
  `instr_radiotherapy_petkt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия: Инструментальные исследования: ПЭТ-КТ да/нет',
  `instr_radiotherapy_petkt_date` DATE DEFAULT NULL COMMENT 'Лучевая терапия: Инструментальные исследования: ПЭТ-КТ дата',
  `instr_radiotherapy_petkt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Лучевая терапия: Инструментальные исследования: ПЭТ-КТ норма/патология',
  `instr_radiotherapy_petkt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Лучевая терапия: Инструментальные исследования: ПЭТ-КТ Заключение',
  
  `patient_status_last_visit_date` DATE DEFAULT NULL COMMENT 'Дата последней информации о состоянии пациента или последнего визита',
  `patient_status_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Статус пациента на момент завершения исследования',
  
  `patient_if_died_date` DATE DEFAULT NULL COMMENT 'Если пациент умер, дата смерти',
  `patient_if_died_cause_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Причина смерти',
  `patient_if_died_cause_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Причина смерти, если другие',
  
  
  `user` varchar(25) DEFAULT NULL,
  `insert_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `lung_patient` MODIFY COLUMN `patient_if_died_cause_id` INTEGER(11) DEFAULT '-1' COMMENT 'Причина смерти';

CREATE TABLE `lung_therapy` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL COMMENT 'Пациент',
  `visit_id` int(11) NOT NULL COMMENT 'Номер визита',
  `chmt_karboplatin_yes_no_id` int(11) DEFAULT '-1' COMMENT 'Химиотерапия: Карбоплатин (да, нет)',
  `chmt_cisplatin_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Цисплатин (да, нет)',
  `chmt_ciklofosfan_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Циклофосфан (да, нет)',
  `chmt_paklitaksel_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Паклитаксел (да, нет)',
  `chmt_doksorubicin_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Доксорубицин (да, нет)',
  `chmt_topotekan_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Топотекан (да, нет)',
  `chmt_gemcitabin_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Гемцитабин (да, нет)',
  `chmt_vinorelbin_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Винорельбин (да, нет)',
  `chmt_irinotekan_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Иринотекан (да, нет)',
  `chmt_jetopozid_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Этопозид (да, нет)',
  `chmt_jepirubicin_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Эпирубицин (да, нет)',
  `chmt_docetaksel_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Доцетаксел (да, нет)',
  `chmt_oksaliplatin_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Оксалиплатин (да, нет)',
  `chmt_other_yes_no_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Химиотерапия: Другое (да, нет)',
  `chmt_other_descr` varchar(50) DEFAULT NULL COMMENT 'Химиотерапия: Другое (описание)',
  `chmt_date_start` date DEFAULT NULL COMMENT 'Химиотерапия: Дата начала лечения',
  `chmt_date_finish` date DEFAULT NULL COMMENT 'Химиотерапия: Дата окончания лечения',
    
  `instr_kt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: КТ да/нет',
  `instr_kt_date` DATE DEFAULT NULL COMMENT 'Инструментальные исследования: КТ дата',
  `instr_kt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: КТ норма/патология',
  `instr_kt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Инструментальные исследования: КТ Заключение',
  
  `instr_mrt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: МРТ да/нет',
  `instr_mrt_date` DATE DEFAULT NULL COMMENT 'Инструментальные исследования: МРТ дата',
  `instr_mrt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: МРТ норма/патология',
  `instr_mrt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Инструментальные исследования: МРТ Заключение',
  
  `instr_petkt_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: ПЭТ-КТ да/нет',
  `instr_petkt_date` DATE DEFAULT NULL COMMENT 'Инструментальные исследования: ПЭТ-КТ дата',
  `instr_petkt_norm_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Инструментальные исследования: ПЭТ-КТ норма/патология',
  `instr_petkt_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Инструментальные исследования: ПЭТ-КТ Заключение',
  
  `targeted_therapy_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Таргетная терапия да/нет',
  `targeted_therapy_erlotinib_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Таргетная терапия: Эрлотиниб да/нет',
  `targeted_therapy_gefitinib_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Таргетная терапия: Гефитиниб да/нет',
  `targeted_therapy_cryotinib_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Таргетная терапия: Кризотиниб да/нет',
  `targeted_therapy_nivolumab_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Таргетная терапия: Ниволумаб да/нет',
  `targeted_therapy_other_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Таргетная терапия: Другое да/нет',
  `targeted_therapy_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Если «да», описать подробнее с указанием даты и степени токсичности',
  
  `side_effects_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Нежелательные явления да/нет',
  `side_effects_descr` VARCHAR(255) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Если «да», описать подробнее с указанием даты и степени токсичности',
  
  `hb_before_ct` DOUBLE DEFAULT NULL COMMENT 'Гемоглобин',
  `hb_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения гемоглобина',
  `erythrocytes_before_ct` DOUBLE DEFAULT NULL COMMENT 'Эритроциты',
  `erythrocytes_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения Эритроциты',
  `leuc_before_ct` DOUBLE DEFAULT NULL COMMENT 'Лейкоциты',
  `leuc_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения Лейкоциты',
  `tromb_before_ct` DOUBLE DEFAULT NULL COMMENT 'Тромбоциты',
  `tromb_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения Тромбоциты',
  `neutr_before_ct` DOUBLE DEFAULT NULL COMMENT 'нейтрофилы',
  `neutr_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения нейтрофилы',
  
  `gen_prot_before_ct` DOUBLE DEFAULT NULL COMMENT 'Общий белок',
  `gen_prot_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения Общий белок',
  `ast_before_ct` DOUBLE DEFAULT NULL COMMENT 'АСТ',
  `ast_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения АСТ',
  `alt_before_ct` DOUBLE DEFAULT NULL COMMENT 'АЛТ',
  `alt_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения АЛТ',
  `bilirubin_before_ct` DOUBLE DEFAULT NULL COMMENT 'билирубин',
  `bilirubin_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения билирубин',
  `creat_before_ct` DOUBLE DEFAULT NULL COMMENT 'Креатинин',
  `creat_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения Креатинин',
  `urea_before_ct` DOUBLE DEFAULT NULL COMMENT 'Мочевина',
  `urea_before_ct_date` DATE DEFAULT NULL COMMENT 'Дата проведения Мочевина',
  
  
  `neurotoxicity_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Нейротоксичность да/нет',
  `neurotoxicity_level_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Степень нейротоксичности',
  
  `skin_toxicity_yes_no_id` INTEGER(11) NOT NULL DEFAULT '-1' COMMENT 'Кожная токсичность  да/нет',
  `skin_toxicity_level_id` int(11) NOT NULL DEFAULT '-1' COMMENT 'Степень кожной токсичности',
  
  `user` varchar(25) DEFAULT NULL,
  `insert_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   UNIQUE KEY `patient_id` (`patient_id`, `visit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;