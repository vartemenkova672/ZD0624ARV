*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_0400
*&---------------------------------------------------------------------*

MODULE status_0400 OUTPUT.

  SET PF-STATUS '0400'.
  SET TITLEBAR '0400'.

  CHECK go_main IS BOUND.
  go_main->mo_view_0400->pbo_0400( ).
ENDMODULE.

MODULE user_command_0400 INPUT.

  CHECK go_main IS BOUND.
  go_main->mo_view_0400->pai_0400( ).
ENDMODULE.
