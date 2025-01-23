*&---------------------------------------------------------------------*
*& Report ZARV4_R_DYNPRO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_dynpro.

DATA: gv_ucomm_0100 TYPE sy-ucomm.
DATA: gv_ucomm_0200 TYPE sy-ucomm.

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
START-OF-SELECTION.
  CALL SCREEN 0100.

MODULE user_command_0100 INPUT.
  CASE gv_ucomm_0100.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'PRESS'.
      CALL SCREEN 200
      STARTING AT  5 5
      ending at 50 10.
    WHEN 'HELLO'.
      MESSAGE 'Hello button!' TYPE 'S'.
    WHEN 'DONOTPRESS'.
      MESSAGE 'Do not press this button!'
      TYPE 'I'
      DISPLAY LIKE 'E'.
  ENDCASE.
  CLEAR gv_ucomm_0100.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE gv_ucomm_0200.
    WHEN 'OK'.
      LEAVE SCREEN.
    WHEN 'CANCEL'.
      LEAVE SCREEN.
  ENDCASE.
  CLEAR gv_ucomm_0200.
ENDMODULE.
