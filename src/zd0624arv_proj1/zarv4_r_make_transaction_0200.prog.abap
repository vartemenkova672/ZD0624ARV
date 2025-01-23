*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_0200
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

  DATA: answer   TYPE string,
        lv_leave TYPE abap_boolean.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL'.

      PERFORM remove_locks
      USING
          zarv4_s_transact.

      COMMIT WORK.
      LEAVE TO SCREEN 0.

    WHEN 'EXIT'.

      PERFORM remove_locks
      USING
          zarv4_s_transact.

      COMMIT WORK.
      LEAVE PROGRAM.

    WHEN 'SAVE'.

      CLEAR lv_leave.

      PERFORM check_type_0200
      USING zarv4_s_transact
            CHANGING lv_leave.

      IF lv_leave = ''.
        IF zarv4_s_transact-transaction_quantity <> 0.
          zarv4_s_transact-transaction_price = zarv4_s_transact-transaction_amount / zarv4_s_transact-transaction_quantity.
        ENDIF.

        PERFORM set_update
        USING 2 0.
      ENDIF.

    WHEN 'DELETE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Warning Message'
          text_question         = 'Do you confirm deletion of the entry?'
          text_button_1         = 'Yes'
          text_button_2         = 'No'
          default_button        = '2'
          display_cancel_button = 'X'
        IMPORTING
          answer                = answer
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.

      IF sy-subrc <> 0.
        MESSAGE |Error during Order confirmation screen generation. SY-SUBRC: { sy-subrc }| TYPE 'I' DISPLAY LIKE 'E'##NO_TEXT.
      ENDIF.

      CASE answer.
        WHEN '1'.

          PERFORM set_update
            USING 3
                  s_tr_id.
      ENDCASE.

  ENDCASE.

ENDMODULE.
