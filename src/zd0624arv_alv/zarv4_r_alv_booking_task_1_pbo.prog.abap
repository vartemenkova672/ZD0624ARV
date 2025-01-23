*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_PBO
**&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CHECK go_main IS BOUND.
  go_main->mo_view->pbo_0100( ).
ENDMODULE.
