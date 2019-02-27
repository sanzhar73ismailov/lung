CD 'C:\OSPanel\domains\localhost\lung\stat'.

INSERT FILE ='syntax\01_patient_script.sps'.
INSERT FILE ='syntax\02_therapy_script.sps'.


*-- DESCRIPTIVES VARIABLES=years

DATASET ACTIVATE PatientData.
SPLIT FILE OFF.
* ������������ ���������� - �������.
* <<<<<<<<<<<BLOCK START.
FILE HANDLE xls_file /NAME='reportdir\01_��������_����_����_���_����������_(�������).xls'.
INSERT FILE ='syntax\02a_patient_quant_script.sps'.
* >>>>>>>>>>>>>>BLOCK END.

DATASET ACTIVATE PatientData.
SPLIT FILE OFF.
* ������������ ���������� - ������� �� ��������.
* <<<<<<<<<<<BLOCK START.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
FILE HANDLE xls_file /NAME='reportdir\01_��������_����_����_���_����������_(�������)_��_��������.xls'.
INSERT FILE ='syntax\02a_patient_quant_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.

* ��������� ������.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE PatientData.
SPLIT FILE OFF.
EXECUTE.
FILE HANDLE xls_file /NAME='reportdir\02_��������_�������.xls'.
INSERT FILE ='syntax\03_patient_freq_script.sps'.
*������� ������.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.

* ��������� ������ �� ��������.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE PatientData.
FILE HANDLE xls_file /NAME='reportdir\02_��������_�������_��_��������.xls'.
*� ����������� �� ���. �������.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
EXECUTE.
INSERT FILE ='syntax\03_patient_freq_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.


* <<<<<<<<<<<BLOCK START.
* ������������ ����������(�����. ����������)- �������.
DATASET ACTIVATE TherapyData.
SPLIT FILE OFF.
FILE HANDLE xls_file /NAME='reportdir\03_�������_����_����_���_����������_(����_�����).xls'.
INSERT FILE ='syntax\04_therapy_quant_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.

* <<<<<<<<<<<BLOCK START.
* ������������ ����������(�����. ����������)- �������.
DATASET ACTIVATE TherapyData.
SPLIT FILE OFF.
*� ����������� �� ���. �������.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
EXECUTE.
FILE HANDLE xls_file /NAME='reportdir\03_�������_����_����_���_����������_(����_�����)_��_��������.xls'.
INSERT FILE ='syntax\04_therapy_quant_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.


* ��������� ������ (�������).
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE TherapyData.
FILE HANDLE xls_file /NAME='reportdir\04_�������_�������.xls'.
*������� ������.
SPLIT FILE OFF.
INSERT FILE ='syntax\05_therapy_freq_script.sps'.
* >>>>>>>>>>>>>>BLOCK END.


* ��������� ������ (�������), ���������� �� ��������.
* <<<<<<<<<<<BLOCK START.
DATASET ACTIVATE TherapyData.
FILE HANDLE xls_file /NAME='reportdir\04_�������_�������_��_��������.xls'.
*������� ������.
SPLIT FILE OFF.
*� ����������� �� ���. �������.
SORT CASES  BY hospital_id.
SPLIT FILE LAYERED BY hospital_id.
INSERT FILE ='syntax\05_therapy_freq_script.sps'.
SPLIT FILE OFF.
* >>>>>>>>>>>>>>BLOCK END.







