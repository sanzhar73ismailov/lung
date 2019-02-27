CD 'C:\OSPanel\domains\localhost\lung\stat'.

INSERT FILE ='syntax\01_patient_script.sps'.
INSERT FILE ='syntax\02_therapy_script.sps'.


*-- DESCRIPTIVES VARIABLES=years

DATASET ACTIVATE PatientData.
SPLIT FILE OFF.
* ќписательна€ статистика - возраст.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\01_пациенты_опис_стат_кол_показатели_(возраст).xls'.
INSERT FILE ='syntax\02a_patient_quant_script.sps'.
* >>>>>>>>>>>>>>BLOCK END.

DATASET ACTIVATE PatientData.
SPLIT FILE OFF.
* ќписательна€ статистика - возраст по регионам.
* <<<<<<<<<<<BLOCK START.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
FILE HANDLE xls_file /NAME='reportdir\01_пациенты_опис_стат_кол_показатели_(возраст)_по_регионам.xls'.
INSERT FILE ='syntax\02a_patient_quant_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.

* „астотный анализ.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE PatientData.
SPLIT FILE OFF.
EXECUTE.
FILE HANDLE xls_file /NAME='reportdir\02_пациенты_частоты.xls'.
INSERT FILE ='syntax\03_patient_freq_script.sps'.
*—нимаем фильтр.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.

* „астотный анализ по регионам.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE PatientData.
FILE HANDLE xls_file /NAME='reportdir\02_пациенты_частоты_по_регионам.xls'.
*— разделением по мед. центрам.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
EXECUTE.
INSERT FILE ='syntax\03_patient_freq_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.


* <<<<<<<<<<<BLOCK START.
* ќписательна€ статистика( олич. показатели)- терапи€.
DATASET ACTIVATE TherapyData.
SPLIT FILE OFF.
FILE HANDLE xls_file /NAME='reportdir\03_терапи€_опис_стат_кол_показатели_(анал_крови).xls'.
INSERT FILE ='syntax\04_therapy_quant_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.

* <<<<<<<<<<<BLOCK START.
* ќписательна€ статистика( олич. показатели)- терапи€.
DATASET ACTIVATE TherapyData.
SPLIT FILE OFF.
*— разделением по мед. центрам.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
EXECUTE.
FILE HANDLE xls_file /NAME='reportdir\03_терапи€_опис_стат_кол_показатели_(анал_крови)_по_регионам.xls'.
INSERT FILE ='syntax\04_therapy_quant_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.


* „астотный анализ (терапи€).
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE TherapyData.
FILE HANDLE xls_file /NAME='reportdir\04_терапи€_частоты.xls'.
*—нимаем фильтр.
SPLIT FILE OFF.
INSERT FILE ='syntax\05_therapy_freq_script.sps'.
* >>>>>>>>>>>>>>BLOCK END.


* „астотный анализ (терапи€), разделение по регионам.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE TherapyData.
FILE HANDLE xls_file /NAME='reportdir\04_терапи€_частоты_по_регионам.xls'.
*—нимаем фильтр.
SPLIT FILE OFF.
*— разделением по мед. центрам.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
INSERT FILE ='syntax\05_therapy_freq_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.







