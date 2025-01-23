*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bn1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS: s_tr_d  LIKE gv_date,
              s_tr_t  LIKE gv_time,
              s_tr_rp LIKE gv_resp_p MATCHCODE OBJECT zarv4_sh_rp,
              p_lang  TYPE spras.
  SELECTION-SCREEN SKIP.

  PARAMETERS: p_pur AS CHECKBOX USER-COMMAND p_pur_f,
              p_exp AS CHECKBOX USER-COMMAND p_exp_f,
              p_rel AS CHECKBOX USER-COMMAND p_rel_f,
              p_cha AS CHECKBOX USER-COMMAND p_cha_f.
  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK bn11 WITH FRAME TITLE TEXT-t11.
    SELECTION-SCREEN BEGIN OF BLOCK bn12 WITH FRAME TITLE TEXT-t12.
      PARAMETERS: s_nom_id LIKE gv_nom_id MATCHCODE OBJECT zarv4_sh_material MODIF ID gr1,
                  s_tr_q   LIKE gv_quantity MODIF ID gr1,
                  s_tr_am  LIKE gv_amount MODIF ID gr1.
    SELECTION-SCREEN END OF BLOCK bn12.
    SELECTION-SCREEN PUSHBUTTON 1(20)  TEXT-t02 USER-COMMAND add_tr1 MODIF ID gr1.
    SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t06 USER-COMMAND save_data1 MODIF ID gr1.
    SELECTION-SCREEN PUSHBUTTON 43(20) TEXT-t03 USER-COMMAND add_nom MODIF ID gr1.
  SELECTION-SCREEN END OF BLOCK bn11.

  SELECTION-SCREEN BEGIN OF BLOCK bn13 WITH FRAME TITLE TEXT-t13.
    SELECTION-SCREEN BEGIN OF BLOCK bn14 WITH FRAME TITLE TEXT-t14.
      PARAMETERS: s_tr_n LIKE gv_nom_id MATCHCODE OBJECT zarv4_sh_expanse MODIF ID gr2,
                  s_tram LIKE gv_amount MODIF ID gr2,
                  s_tr_r LIKE gv_salary_res MATCHCODE OBJECT zarv4_sh_rp MODIF ID gr2.
    SELECTION-SCREEN END OF BLOCK bn14.
    SELECTION-SCREEN PUSHBUTTON 1(20)  TEXT-t02 USER-COMMAND add_tr2 MODIF ID gr2.
    SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t06 USER-COMMAND save_data2 MODIF ID gr2.
    SELECTION-SCREEN PUSHBUTTON 43(20) TEXT-t03 USER-COMMAND add_nom MODIF ID gr2.
    SELECTION-SCREEN PUSHBUTTON 64(20) TEXT-t04 USER-COMMAND add_rec MODIF ID gr2.
  SELECTION-SCREEN END OF BLOCK bn13.

  SELECTION-SCREEN BEGIN OF BLOCK bn15 WITH FRAME TITLE TEXT-t15.
    SELECTION-SCREEN BEGIN OF BLOCK bn16 WITH FRAME TITLE TEXT-t16.
      PARAMETERS: s_tr_n1 LIKE gv_nom_id MATCHCODE OBJECT zarv4_sh_fg MODIF ID gr3,
                  s_trq   LIKE gv_quantity MODIF ID gr3.
    SELECTION-SCREEN END OF BLOCK bn16.
    SELECTION-SCREEN PUSHBUTTON 1(20)  TEXT-t18 USER-COMMAND release MODIF ID gr3.
    SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t03 USER-COMMAND add_nom MODIF ID gr3.
  SELECTION-SCREEN END OF BLOCK bn15.

  SELECTION-SCREEN BEGIN OF BLOCK bn17 WITH FRAME TITLE TEXT-t17.
    SELECTION-SCREEN BEGIN OF BLOCK bn18 WITH FRAME TITLE TEXT-t18.
      PARAMETERS: s_tr_id LIKE gv_transact_id MODIF ID gr4.
    SELECTION-SCREEN END OF BLOCK bn18.
    SELECTION-SCREEN PUSHBUTTON 1(20)  TEXT-t05 USER-COMMAND change MODIF ID gr4.
    SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t07 USER-COMMAND delite MODIF ID gr4.
  SELECTION-SCREEN END OF BLOCK bn17.
SELECTION-SCREEN END OF BLOCK bn1.

*Data definition
INITIALIZATION.
  s_tr_d = sy-datum.
  s_tr_t = sy-uzeit.
  p_lang = sy-langu.
  s_tr_rp = '1'.
