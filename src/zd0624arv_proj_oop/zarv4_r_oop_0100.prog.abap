*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_0100
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

    WHEN gc_ucomm-back OR gc_ucomm-cancel.
      CLEAR  zarv4_s_nomenclature.
      LEAVE TO SCREEN 0.
    WHEN gc_ucomm-exit.
      CLEAR  zarv4_s_nomenclature.
      LEAVE PROGRAM.

    WHEN 'CANCEL_CREATION'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Warning Message'
          text_question         = 'Cancel creation?' ##NO_TEXT
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
        WHEN '1'.
          CLEAR  zarv4_s_nomenclature.
          LEAVE TO SCREEN 0.
      ENDCASE.

    WHEN 'CREATE'.

      DATA lv_eror TYPE char50.
      DATA lv_controller_0100 TYPE REF TO zarv4_cl_controller.
      lv_controller_0100 = NEW #( ).

      TRY.
          lv_controller_0100->check_creation_screen_fields( zarv4_s_nomenclature ).
        CATCH zarv4_cx_exceptions INTO DATA(lr_exception_second_screen).
          PERFORM show_message USING lr_exception_second_screen.
          RETURN.
      ENDTRY.

      IF zarv4_s_nomenclature-nomenclature_id <> 0. " nomenclature exists

        lv_controller_0100->change_master_data( mv_entry_type             = zarv4_cl_controller=>change
                                           ms_creation_screen_fields = zarv4_s_nomenclature ).
      ELSE.

        " should be created
        lv_controller_0100->change_master_data( mv_entry_type             = zarv4_cl_controller=>create
                                           ms_creation_screen_fields = zarv4_s_nomenclature ).
      ENDIF.
  ENDCASE.

ENDMODULE.
