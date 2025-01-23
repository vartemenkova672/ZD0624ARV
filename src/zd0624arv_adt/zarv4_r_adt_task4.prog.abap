*&---------------------------------------------------------------------*
*& Report ZARV4_R_ADT_TASK3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_adt_task4.

SELECT objectname, objecttype, msgnr
  FROM T100O
  where exists ( SELECT msgnr
                 FROM t100
                 WHERE text LIKE '%ABAP%' and ( text LIKE '%Error%' OR text LIKE '%error%' ) )
  INTO TABLE @DATA(it_objects_t)
    BYPASSING BUFFER .

LOOP AT it_objects_t INTO DATA(ls_objects_t).

      WRITE:  / 'Message code; ', ls_objects_t-msgnr,
      'Object name; ', ls_objects_t-objectname,
      'Object type; ', ls_objects_t-objecttype.

  ENDLOOP.

SKIP.
ULINE.

SELECT name, datum, msgnr
  FROM T100U
  where T100U~msgnr not in (
                        SELECT msgnr
                        FROM t100
                        WHERE text LIKE '%ABAP%' and ( text LIKE '%Error%' OR text LIKE '%error%' ) )
  INTO TABLE @DATA(it_objects_f)
    BYPASSING BUFFER .

  LOOP AT it_objects_f INTO DATA(ls_objects_f).

      WRITE: / 'Message code; ', ls_objects_f-msgnr,
      'User who changed ', ls_objects_f-name,
      'User who changed ', ls_objects_f-datum.

  ENDLOOP.
