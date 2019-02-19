CD 'C:\OSPanel\domains\localhost\lung\stat'.

INSERT FILE ='syntax\01_patient_script.sps'.
INSERT FILE ='syntax\02_therapy_script.sps'.


*-- DESCRIPTIVES VARIABLES=years

DATASET ACTIVATE PatientData.
* Описательная статистика - возраст.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\01_пациенты_опис_стат_кол_показатели_(возраст).xls'.
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
DATASET ACTIVATE PatientData.
INSERT FILE ='syntax\03_patient_freq_script.sps'.
* >>>>>>>>>>>>>>BLOCK END.

* Описательная статистика(Колич. показатели)- терапия.
DATASET ACTIVATE TherapyData.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\03_терапия_опис_стат_кол_показатели_(анал_крови).xls'.
OUTPUT NEW NAME =report_output.
*Без разделения на пол.
DESCRIPTIVES VARIABLES=hb_before_ct erythrocytes_before_ct leuc_before_ct tromb_before_ct 
    neutr_before_ct gen_prot_before_ct ast_before_ct alt_before_ct bilirubin_before_ct creat_before_ct 
    urea_before_ct
  /STATISTICS=MEAN STDDEV MIN MAX SEMEAN.
NPAR TESTS
  /K-S(NORMAL)=hb_before_ct erythrocytes_before_ct leuc_before_ct tromb_before_ct 
    neutr_before_ct gen_prot_before_ct ast_before_ct alt_before_ct bilirubin_before_ct creat_before_ct 
    urea_before_ct
  /MISSING ANALYSIS.

OUTPUT EXPORT
  /CONTENTS EXPORT=VISIBLE  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLS  DOCUMENTFILE=xls_file
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.
OUTPUT CLOSE NAME =report_output.
* >>>>>>>>>>>>>>BLOCK END.



* Частотный анализ (терапия).
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE TherapyData.
INSERT FILE ='syntax\05_therapy_freq_script.sps'.
* >>>>>>>>>>>>>>BLOCK END.



