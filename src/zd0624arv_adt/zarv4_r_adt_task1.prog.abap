*&---------------------------------------------------------------------*
*& Report ZARV4_R_ADT_TASK1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_adt_task1.

SELECT *
  FROM t100
  WHERE text LIKE '%ABAP%'
  INTO TABLE @DATA(it_messages)
  BYPASSING BUFFER .
