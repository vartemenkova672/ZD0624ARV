*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_I01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN.

  IF sscrfields-ucomm = 'CREATE_NOM' OR sscrfields-ucomm = 'DELETE_NOM' OR sscrfields-ucomm = 'CHANGE_NOM'.
    nomenclature_change = abap_true.
  ENDIF.

  IF sscrfields-ucomm = 'BOOK_TR' OR sscrfields-ucomm = 'WRITE_OFF_TR'.
    transaction_change = abap_true.
  ENDIF.

  IF nomenclature_change = abap_true OR transaction_change = abap_true.

    DATA lv_controller TYPE REF TO zarv4_cl_controller.
    lv_controller = NEW #( ).

  ENDIF.

  IF transaction_change = abap_true.

    TRY.
        lv_controller->check_filling_date( s_tr_d ).
        gs_screen_fields-field_date = s_tr_d.
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_date).
        PERFORM show_message USING lr_exception_date.
        STOP.
    ENDTRY.

    TRY.
        lv_controller->check_filling_time( s_tr_t ).
        gs_screen_fields-field_time = s_tr_t.
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_time).
        PERFORM show_message USING lr_exception_time.
        STOP.
    ENDTRY.

    TRY.
        lv_controller->check_filling_id( p_nom_id ).
        gs_screen_fields-field_id = p_nom_id.
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_id).
        PERFORM show_message USING lr_exception_id.
        STOP.
    ENDTRY.

    TRY.
        lv_controller->check_filling_quantity( p_tr_q ).
        gs_screen_fields-field_quantity = p_tr_q.
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_quant).
        PERFORM show_message USING lr_exception_quant.
        STOP.
    ENDTRY.
  ENDIF.

  IF sscrfields-ucomm = 'BOOK_TR'.

    DATA(lv_type) = zarv4_cl_nomenclature=>get_type( p_nom_id ).

    IF NOT lv_type = zarv4_cl_nomenclature=>finished_goods.
      TRY.
          lv_controller->check_filling_amount( p_tr_am ).
          gs_screen_fields-field_amount = p_tr_am.
        CATCH zarv4_cx_exceptions INTO DATA(lr_exception_amount).
          PERFORM show_message USING lr_exception_amount.
          STOP.
      ENDTRY.
    ENDIF.

    ##EXCP_UNHANDLED[ZARV4_CX_EXCEPTIONS] lv_controller->make_transaction( mv_entry_type   = zarv4_cl_controller=>book
                                                                           ms_screen_fields = gs_screen_fields ).
  ENDIF.

  IF sscrfields-ucomm = 'WRITE_OFF_TR'.

    TRY.
        lv_controller->check_filling_amount( p_tr_am ).
        gs_screen_fields-field_amount = p_tr_am.
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_amount1).
        PERFORM show_message USING lr_exception_amount1.
        STOP.
    ENDTRY.

    ##EXCP_UNHANDLED[ZARV4_CX_EXCEPTIONS] lv_controller->make_transaction( mv_entry_type     = zarv4_cl_controller=>write_off
                                                                           ms_screen_fields = gs_screen_fields ).

  ENDIF.

  IF sscrfields-ucomm = 'CREATE_NOM'.

    zarv4_s_nomenclature-langu = sy-langu.

    CALL SCREEN 0100.

  ENDIF.

  IF sscrfields-ucomm = 'DELETE_NOM'.

    DATA is_included_in_specification TYPE abap_boolean.

    TRY.
        lv_controller->check_filling_id( p_nom_id ).
        gs_nomenclature-nomenclature_id = p_nom_id.
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_delete).
        PERFORM show_message USING lr_exception_delete.
        STOP.
    ENDTRY.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Warning Message'
        text_question         = 'Delete nomenclature item from the directory?' ##NO_TEXT
        text_button_1         = 'Yes'
        text_button_2         = 'No'
        default_button        = '2'
        display_cancel_button = 'X'
      IMPORTING
        answer                = gv_answer
      EXCEPTIONS ##FM_SUBRC_OK
        text_not_found        = 1
        OTHERS                = 2.

    CASE gv_answer.
      WHEN '2' OR '3'.
        STOP.
    ENDCASE.

    ##EXCP_UNHANDLED[ZARV4_CX_EXCEPTIONS] lv_controller->change_master_data( mv_entry_type             = zarv4_cl_controller=>delete
                                                                             ms_creation_screen_fields = gs_nomenclature ).

  ENDIF.

  IF sscrfields-ucomm = 'CHANGE_NOM'.

    DATA ls_nomenctature TYPE zarv4_s_nomenclature.
    DATA is_nomenclature_exist TYPE boolean.
    DATA lv_error_message TYPE char50.

    TRY.
        lv_controller->check_filling_id( p_nom_id ).
      CATCH zarv4_cx_exceptions INTO DATA(lr_exception_change).
        PERFORM show_message USING lr_exception_change.
        STOP.
    ENDTRY.

    ##EXCP_UNHANDLED[ZARV4_CX_EXCEPTIONS] zarv4_s_nomenclature = lv_controller->get_info_for_nom_change( p_nom_id ).

    IF zarv4_s_nomenclature IS INITIAL.
      STOP.
    ENDIF.

    is_included_in_specification = lv_controller->check_specification_existance( p_nom_id ).

    IF is_included_in_specification = abap_true.
      CALL SCREEN '0200'.
    ELSE.
      CALL SCREEN '0100'.
    ENDIF.

  ENDIF.

  IF sscrfields-ucomm = 'GET_REM'.

    lcl_main=>start_of_selection( lcl_main=>get_remain ).
    lcl_main=>end_of_selection( lcl_main=>get_remain ).

  ENDIF.

  IF sscrfields-ucomm = 'GET_ENTR'.

    lcl_main=>start_of_selection( lcl_main=>get_entries ).
    lcl_main=>end_of_selection( lcl_main=>get_entries ).

  ENDIF.

  IF sscrfields-ucomm = 'GET_SPEC'.

    lcl_main=>start_of_selection( lcl_main=>get_specification ).
    lcl_main=>end_of_selection( lcl_main=>get_specification ).

  ENDIF.
