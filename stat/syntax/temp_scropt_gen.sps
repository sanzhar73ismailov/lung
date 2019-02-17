INSERT FILE ='syntax\02_chem_script.sps'.
INSERT FILE ='syntax\03_therapy_script.sps'.
INSERT FILE ='syntax\04_anemia_drug_script.sps'.
INSERT FILE ='syntax\05_blood_script.sps'.


*-- DESCRIPTIVES VARIABLES=weight_kg height_sm years
--  /STATISTICS=MEAN STDDEV MIN MAX.
DATASET ACTIVATE PatientData.
* Описательная статистика - возраст.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\01_описательная_стат_количественные_показатели (возраст, эритроциты, гемоглобин).xls'.
OUTPUT NEW NAME =report_output.
*Без разделения на пол.
DESCRIPTIVES VARIABLES=years lab_hb lab_erythrocytes
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.
NPAR TESTS
  /K-S(NORMAL)=years lab_hb lab_erythrocytes
  /MISSING ANALYSIS.

*С разделением на пол.
SORT CASES  BY sex_id.
SPLIT FILE LAYERED BY sex_id.

DESCRIPTIVES VARIABLES=years lab_hb lab_erythrocytes
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.
NPAR TESTS
  /K-S(NORMAL)=years lab_hb lab_erythrocytes
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
visit_count
sex_id
age_group
place_living_id
social_status_id
diag_cancer_localization_id
diag_cancer_histotype
diag_cancer_degree_malignancy_id
diag_cancer_tnm_stage_t_id
diag_cancer_tnm_stage_n_id
diag_cancer_tnm_stage_m_id
diag_cancer_clin_stage_id
diag_cancer_ecog_status_id
doctor
insert_date_str
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
visit_count
age_group
place_living_id
social_status_id
diag_cancer_localization_id
diag_cancer_histotype
diag_cancer_degree_malignancy_id
diag_cancer_tnm_stage_t_id
diag_cancer_tnm_stage_n_id
diag_cancer_tnm_stage_m_id
diag_cancer_clin_stage_id
diag_cancer_ecog_status_id
doctor
insert_date_str
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

* Сравнительная статистика - количественные переменные.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\04_сравнительная_стат_количественные_показатели_между_муж_и_жен(возраст, эритроциты, гемоглобин).xls'.
OUTPUT NEW NAME =report_output.
*Без разделения на пол.
*Т-критерий - сравнение возраста между мужчинами и женщинами.
T-TEST GROUPS=sex_id(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=years
  /CRITERIA=CI(.95).

NPAR TESTS
  /M-W= lab_hb lab_erythrocytes BY sex_id(1 2)
  /MISSING ANALYSIS.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
* >>>>>>>>>>>>>>BLOCK END.




*  <p/>ChemData********************************* - частоты по химпрепратам.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE ChemData.
FILTER OFF.
USE ALL.
EXECUTE.

FILE HANDLE xls_file /NAME='reportdir\05_химпрепар.xls'.
OUTPUT NEW NAME =report_output.

FREQUENCIES VARIABLES=chem from_list
  /FORMAT=DFREQ
  /ORDER=ANALYSIS.
EXECUTE.

* Поиск дублирующихся наблюдений.
SORT CASES BY patient_id(A) chem(A).
MATCH FILES
  /FILE=*
  /BY patient_id chem
  /FIRST=PrimaryFirst
  /LAST=PrimaryLastChem.
DO IF (PrimaryFirst).
COMPUTE  MatchSequenceChem=1-PrimaryLastChem.
ELSE.
COMPUTE  MatchSequenceChem=MatchSequenceChem+1.
END IF.
LEAVE  MatchSequenceChem.
FORMATS  MatchSequenceChem (f7).
COMPUTE  InDupGrp=MatchSequenceChem>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp.
VARIABLE LABELS  PrimaryLastChem 'Индикатор каждого первого дублирующегося наблюдения в качестве '+
    'первичного' MatchSequenceChem 'Счетчик дублирующихся наблюдений'.
VALUE LABELS  PrimaryLastChem 0 'Дублирующееся наблюдение' 1 'Первичное наблюдение'.
VARIABLE LEVEL  PrimaryLastChem (ORDINAL) /MatchSequenceChem (SCALE).
FREQUENCIES VARIABLES=PrimaryLastChem MatchSequenceChem.
FILTER  BY PrimaryLastChem.
EXECUTE.

FREQUENCIES VARIABLES=chem
  /FORMAT=DFREQ
  /ORDER=ANALYSIS.
EXECUTE.

FILTER OFF.
USE ALL.
EXECUTE.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
* >>>>>>>>>>>>>>BLOCK END.


*<p/>TherapyData 6. сколько пациентов получили лечение по поводу анемии.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE PatientData.
FILTER OFF.
USE ALL.
EXECUTE.
SPLIT FILE OFF.
EXECUTE.

FILE HANDLE xls_file /NAME='reportdir\06_сколько_пациентов_получили_лечение_по_поводу_анемии.xls'.
OUTPUT NEW NAME =report_output.

FREQUENCIES VARIABLES=anemia_treat
  /FORMAT=DFREQ
  /ORDER=ANALYSIS.
EXECUTE.

SORT CASES  BY sex_id.
SPLIT FILE LAYERED BY sex_id.

FREQUENCIES VARIABLES=anemia_treat
  /FORMAT=DFREQ
  /ORDER=ANALYSIS.
EXECUTE.

FILTER OFF.
USE ALL.
EXECUTE.
SPLIT FILE OFF.
EXECUTE.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
* >>>>>>>>>>>>>>BLOCK END.




*<p/>AnemiaDrugData 7. какие препараты против анемии были применены.
DATASET ACTIVATE AnemiaDrugData.
FILE HANDLE xls_file /NAME='reportdir\07_препараты_против_анемии.xls'.
OUTPUT NEW NAME =report_output.
FILTER OFF.
USE ALL.
EXECUTE.
SPLIT FILE OFF.

FREQUENCIES VARIABLES=drug_group
  /ORDER=ANALYSIS.

SORT CASES  BY drug_group.
SPLIT FILE LAYERED BY drug_group.
FREQUENCIES VARIABLES=drug
  /ORDER=ANALYSIS.

SPLIT FILE OFF.

SORT CASES  BY drug_group visit_id.
SPLIT FILE LAYERED BY drug_group visit_id.
FREQUENCIES VARIABLES=drug
  /ORDER=ANALYSIS.

FILTER OFF.
USE ALL.
EXECUTE.
SPLIT FILE OFF.
EXECUTE.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.

DATASET CLOSE ALL.




*<p/>BloodData 8. динамика изменений гемоглобина и эритрцитов на фоне антианемической терапии.
CD 'S:\GDnew\DOCS\КазНИИОиР_СекторБиостат\Сурия_анемии\stat'.
INSERT FILE ='syntax\05_blood_script.sps'.

*- посмотреть какая степень токсичности чаще наблюдалась (уровни анемии).
DATASET ACTIVATE BloodData.
FILE HANDLE xls_file /NAME='reportdir\08_уровни анемии_.xls'.
OUTPUT NEW NAME =report_output.
FILTER OFF.
USE ALL.
EXECUTE.
SPLIT FILE OFF.

SORT CASES  BY visit_id.
SPLIT FILE LAYERED BY visit_id.

FREQUENCIES VARIABLES=anemia_level
  /BARCHART FREQ
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=lab_erythrocytes lab_hb
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.

SORT CASES  BY visit_id sex_id.
SPLIT FILE LAYERED BY visit_id sex_id.
DESCRIPTIVES VARIABLES=lab_erythrocytes lab_hb
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.
SPLIT FILE OFF.

SORT CASES  BY sex_id.
SPLIT FILE LAYERED BY sex_id.

GRAPH
  /LINE(SIMPLE)=MEAN(lab_erythrocytes) BY visit_id
  /INTERVAL CI(95.0).

GRAPH
  /LINE(SIMPLE)=MEAN(lab_hb) BY visit_id
  /INTERVAL CI(95.0).

SPLIT FILE OFF.
OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.

*<p/>   - в каких случаях назначался эритропоэтин (при каких показателях Нв), в каких препараты железа.
DATASET ACTIVATE BloodData.
FILE HANDLE xls_file /NAME='reportdir\09_в каких случаях_эритропоэтин, в каких_преп_железа.xls'.
OUTPUT NEW NAME =report_output.
FILTER OFF.
USE ALL.
EXECUTE.

SPLIT FILE OFF.
SORT CASES  BY anemia_level.
SPLIT FILE LAYERED BY anemia_level.

FREQUENCIES VARIABLES=anemia_treat
  /BARCHART PERCENT
  /ORDER=ANALYSIS.

SPLIT FILE OFF.
OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.

*<p/>  - посмотреть изменения гемоглобина после лечения  (после эритропоэтина и препаратов железа), есть ли динамика?/.
DATASET ACTIVATE BloodData.
FILE HANDLE xls_file /NAME='reportdir\10_изменения гемоглобина после лечения.xls'.
OUTPUT NEW NAME =report_output.
FILTER OFF.
USE ALL.
SPLIT FILE OFF.
EXECUTE.

USE ALL.
COMPUTE filter_$=(visit_id>0).
VARIABLE LABEL filter_$ 'visit_id>0 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

SORT CASES  BY visit_id. 
SPLIT FILE LAYERED BY visit_id.

NPAR TESTS
  /K-S(NORMAL)=lab_hb diaganem_after_correct_hb
  /MISSING ANALYSIS.

USE ALL.
COMPUTE filter_$=(visit_id=1).
VARIABLE LABEL filter_$ 'visit_id=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


NPAR TESTS
  /WILCOXON=lab_hb WITH diaganem_after_correct_hb (PAIRED)
  /MISSING ANALYSIS.

USE ALL.
COMPUTE filter_$=(visit_id>1).
VARIABLE LABEL filter_$ 'visit_id>1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

T-TEST PAIRS=lab_hb WITH diaganem_after_correct_hb (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.




FILTER OFF.
USE ALL.
SPLIT FILE OFF.
EXECUTE.
OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.