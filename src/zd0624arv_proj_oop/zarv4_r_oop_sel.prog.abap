*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bn1 WITH FRAME TITLE TEXT-t01 ##TEXT_POOL.

  PARAMETERS: s_tr_d  LIKE gv_date,
              s_tr_t  LIKE gv_time,
              s_tr_rp LIKE sy-uname,
              p_lang  TYPE spras.
  SELECTION-SCREEN SKIP.

  PARAMETERS: p_change AS CHECKBOX USER-COMMAND p_cha_f,
              p_inf    AS CHECKBOX USER-COMMAND p_get_f.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK bn11 WITH FRAME TITLE TEXT-t11.
    SELECTION-SCREEN BEGIN OF BLOCK bn12 WITH FRAME TITLE TEXT-t12 ##TEXT_POOL.
      PARAMETERS: p_nom_id LIKE gv_nom_id MATCHCODE OBJECT zarv4_sh_rm_i_fg MODIF ID gr1,
                  p_tr_q   LIKE gv_quantity MODIF ID gr1,
                  p_tr_am  LIKE gv_amount MODIF ID gr1.
    SELECTION-SCREEN END OF BLOCK bn12.

    SELECTION-SCREEN PUSHBUTTON 1(20)  TEXT-t02 USER-COMMAND book_tr MODIF ID gr1.
    SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t03 USER-COMMAND write_off_tr MODIF ID gr1.

    SELECTION-SCREEN SKIP.
    SELECTION-SCREEN BEGIN OF BLOCK bn13.
      SELECTION-SCREEN PUSHBUTTON 1(20) TEXT-t05 USER-COMMAND create_nom MODIF ID gr1.
      SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t06 USER-COMMAND delete_nom MODIF ID gr1.
      SELECTION-SCREEN PUSHBUTTON 43(20) TEXT-t15 USER-COMMAND change_nom MODIF ID gr1.
    SELECTION-SCREEN END OF BLOCK bn13.

  SELECTION-SCREEN END OF BLOCK bn11.

  SELECTION-SCREEN BEGIN OF BLOCK bn14 WITH FRAME TITLE TEXT-t14.
    SELECTION-SCREEN BEGIN OF BLOCK bn15 WITH FRAME TITLE TEXT-t15.
      SELECT-OPTIONS: p_inf_id FOR  gv_nom_id MATCHCODE OBJECT zarv4_sh_rm_i_fg MODIF ID gr2,
                      p_period FOR  gv_date MODIF ID gr2.
    SELECTION-SCREEN END OF BLOCK bn15.
    SELECTION-SCREEN PUSHBUTTON 1(20)  TEXT-t07 USER-COMMAND get_rem MODIF ID gr2.
    SELECTION-SCREEN PUSHBUTTON 22(20) TEXT-t08 USER-COMMAND get_entr MODIF ID gr2.
    SELECTION-SCREEN PUSHBUTTON 43(30) TEXT-t10 USER-COMMAND get_spec MODIF ID gr2.
  SELECTION-SCREEN END OF BLOCK bn14.

SELECTION-SCREEN END OF BLOCK bn1.

* Data definition
INITIALIZATION.
  s_tr_d = sy-datum.
  s_tr_t = sy-uzeit.
  p_lang = sy-langu.
  s_tr_rp = sy-uname.
