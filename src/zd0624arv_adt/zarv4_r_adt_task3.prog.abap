*&---------------------------------------------------------------------*
*& Report ZARV4_R_ADT_TASK3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_adt_task3.

SELECT *
  FROM t100
  WHERE text LIKE '%Error%'
  OR text LIKE '%error%'
  AND text IN (
                SELECT text
                FROM t100
                WHERE text LIKE '%ABAP%')
INTO TABLE @DATA(it_messages)
  BYPASSING BUFFER .

LOOP AT it_messages ASSIGNING FIELD-SYMBOL(<gs_it_messages>).

    REPLACE 'error' IN <gs_it_messages>-text WITH 'success'.
    REPLACE 'Error' IN <gs_it_messages>-text WITH 'success'.

ENDLOOP.

      cl_salv_table=>factory(
  IMPORTING r_salv_table = DATA(go_salv)
    CHANGING  t_table = it_messages ).
  go_salv->display( ).
