*&---------------------------------------------------------------------*
*& Include          ZARV4_R_GET_INFORMATION_EVT
*&---------------------------------------------------------------------*

START-OF-SELECTION.
  IF p_spec = 'X'.

    PERFORM check_transaction
    USING  s_tr_d
           p_lang.

    PERFORM check_fg_ID
    USING  p_fm_id.

    CALL FUNCTION 'ZARV4_SELECT_SPECIFIC'
      EXPORTING
        lv_nomenclature_id = p_fm_id
      IMPORTING
        lt_specification   = gt_specific
      EXCEPTIONS
        no_data            = 1
        OTHERS             = 2.

    IF sy-subrc <> 0.
      MESSAGE 'There is no specification for the product.' TYPE 'S'.
      STOP.
    ENDIF.

    PERFORM select_additional_information
    USING  gt_specific
           p_fm_id
           p_lang
           CHANGING gt_spec_with_inf
                    gv_nom_name.

    PERFORM show_result_spec
    USING  gt_spec_with_inf
           gv_nom_name
           p_fm_id.

  ENDIF.

  IF p_rem_n = 'X'.

    PERFORM check_transaction
    USING  s_tr_d
           p_lang.

    IF p_raw_m = 'X'.
      line-type = '1'.
      INSERT line INTO TABLE gt_list_types.
    ENDIF.

    IF p_in_m = 'X'.
      line-type = '2'.
      INSERT line INTO TABLE gt_list_types.
    ENDIF.

    IF p_fg_m = 'X'.
      line-type = '3'.
      INSERT line INTO TABLE gt_list_types.
    ENDIF.

    IF p_ex_m = 'X'.
      line-type = '4'.
      INSERT line INTO TABLE gt_list_types.
    ENDIF.

    PERFORM select_stock_information
    USING  p_no_id[]
           gt_list_types
           s_tr_d
           p_lang
           CHANGING gt_stock.

    PERFORM show_result_stock
     USING  gt_stock
            s_tr_d.

  ENDIF.

  IF p_work = 'X'.

    PERFORM check_transaction
    USING  s_tr_d
           p_lang.

    PERFORM select_employes
    USING  p_emp[]
           p_empm[]
           p_act
           p_lang
           CHANGING gt_employes.

    PERFORM show_result_employes
     USING  gt_employes.

  ENDIF.
