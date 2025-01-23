*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_F01
*&---------------------------------------------------------------------*

FORM show_message
     USING lr_exception TYPE REF TO zarv4_cx_exceptions.

  DATA(gv_eror) = lr_exception->if_message~get_longtext( ) .
  MESSAGE gv_eror TYPE 'S'.

ENDFORM.
