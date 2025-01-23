*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_0200
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

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

      DATA lv_controller_0300 TYPE REF TO zarv4_cl_controller.
      lv_controller_0300 = NEW #( ).

      TRY.
          lv_controller_0300->check_creation_screen_fields( zarv4_s_nomenclature ).
        CATCH zarv4_cx_exceptions INTO DATA(lr_exception_third_screen).
          PERFORM show_message USING lr_exception_third_screen.
          RETURN.
      ENDTRY.

      lv_controller_0300->change_master_data( mv_entry_type             = zarv4_cl_controller=>change
                                              ms_creation_screen_fields = zarv4_s_nomenclature ).
  ENDCASE.

ENDMODULE.
