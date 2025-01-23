*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_PAI
**&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CHECK go_main IS BOUND.
  go_main->mo_view->pai_0100( ).
ENDMODULE.
