*&---------------------------------------------------------------------*
*& Include          ZARV4_R_LIBRARY_INFO_F01
*&---------------------------------------------------------------------*

FORM get_data
  USING
        ut_author_id TYPE ANY TABLE
        ut_book_id TYPE ANY TABLE
        ut_author_fn TYPE ANY TABLE
        ut_author_ln TYPE ANY TABLE
        ut_author_bd TYPE ANY TABLE
        ut_author_co TYPE ANY TABLE
        ut_author_cn TYPE ANY TABLE
        ut_book_bn TYPE ANY TABLE
  CHANGING
    lty_books TYPE ANY TABLE.

  SELECT DISTINCT b~book_id, b~book_name
    FROM zarv4_d_author AS a
    INNER JOIN zarv4_d_book AS b
    ON a~author_id = b~author_id
     INNER JOIN zarv4_d_author_t AS at
    ON at~author_id = a~author_id
    INNER JOIN t005t AS t
    ON a~country = t~land1
    WHERE a~author_id IN @ut_author_id
    AND a~author_id IN @ut_book_id
    AND at~author_first_name IN @ut_author_fn
    AND at~author_last_name IN @ut_author_ln
    AND a~birth_date IN @ut_author_bd
    AND a~country IN @ut_author_co
    AND t~landx IN @ut_author_cn
    AND b~book_name IN @ut_book_bn
    INTO TABLE @lty_books.

ENDFORM.

FORM show_data

 USING
   ut_data TYPE ANY TABLE.

  cl_salv_table=>factory(
   IMPORTING r_salv_table = DATA(lo_salv)
     CHANGING  t_table = ut_data ).
  lo_salv->display( ).

ENDFORM.
