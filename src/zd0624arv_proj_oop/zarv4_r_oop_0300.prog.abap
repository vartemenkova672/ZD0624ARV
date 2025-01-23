*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_0300
*&---------------------------------------------------------------------*

MODULE status_0300 OUTPUT.

  SET PF-STATUS '0300'.
  SET TITLEBAR '0300'.

  CHECK go_main IS BOUND.
  go_main->mo_view_0300->pbo_0300( ).
ENDMODULE.

MODULE user_command_0300 INPUT.

  CHECK go_main IS BOUND.
  go_main->mo_view_0300->pai_0300( ).
ENDMODULE.
