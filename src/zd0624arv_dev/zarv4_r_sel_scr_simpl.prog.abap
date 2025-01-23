*&---------------------------------------------------------------------*
*& Report ZARV4_R_SEL_SCR_SIMPL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*=== Task 2 - 5  ===*

REPORT zarv4_r_sel_scr_simpl.

PARAMETERS: p_en RADIOBUTTON GROUP gr1 DEFAULT 'X',
            p_de RADIOBUTTON GROUP gr1.

PARAMETERS p_select TYPE int2.

START-OF-SELECTION.

  CASE abap_true.

    WHEN p_en.

      SELECT *
        FROM t100
        WHERE sprsl = 'E'
        INTO TABLE @DATA(lty_countries_EN)
        UP TO @p_select ROWS.

      cl_salv_table=>factory(
      IMPORTING r_salv_table = DATA(go_salv)
        CHANGING t_table = lty_countries_EN ).

      go_salv->display( ).

    WHEN p_de.

      SELECT *
        FROM t100
        WHERE sprsl = 'D'
        INTO TABLE @DATA(lty_countries_DE)
        UP TO @p_select ROWS.

      cl_salv_table=>factory(
     IMPORTING r_salv_table = go_salv
       CHANGING t_table = lty_countries_DE ).

      go_salv->display( ).


  ENDCASE.
