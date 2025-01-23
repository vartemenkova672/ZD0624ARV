*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_0100
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
    WHEN 'OK'.
      PERFORM remove_locks
      USING zarv4_s_transact.

      COMMIT WORK.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL1'.
      PERFORM remove_locks
      USING zarv4_s_transact.

      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
