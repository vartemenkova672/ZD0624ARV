*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_0500
*&---------------------------------------------------------------------*

MODULE status_0500 OUTPUT.

  SET PF-STATUS '0500'.
  SET TITLEBAR '0500'.

  CHECK go_main IS BOUND.
  go_main->mo_view_0500->pbo_0500( ).
ENDMODULE.

MODULE user_command_0500 INPUT.

  CHECK go_main IS BOUND.
  go_main->mo_view_0500->pai_0500( ).
ENDMODULE.
