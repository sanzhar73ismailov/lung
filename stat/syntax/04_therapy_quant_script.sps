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