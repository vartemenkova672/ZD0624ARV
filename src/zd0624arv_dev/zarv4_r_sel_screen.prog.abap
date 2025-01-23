*&---------------------------------------------------------------------*
*& REPORT ZARV4_R_SEL_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zarv4_r_sel_screen.


TABLES: zarv4_d_author,
        zarv4_d_author_t,
        zarv4_d_book,
        t005t,
        sscrfields.

SELECT-OPTIONS: s_a_id FOR zarv4_d_author-author_id,
                s_b_id FOR zarv4_d_book-book_id.

PARAMETERS: p_lang TYPE spras,
            p_add  AS CHECKBOX USER-COMMAND p_fields.

SELECTION-SCREEN BEGIN OF BLOCK bn1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: s_at_fn FOR zarv4_d_author_t-author_first_name MODIF ID gr1,
                  s_at_ln FOR zarv4_d_author_t-author_last_name MODIF ID gr1,
                  s_a_bd FOR zarv4_d_author-birth_date MODIF ID gr1,
                  s_a_co FOR zarv4_d_author-country MODIF ID gr1,
                  s_t_cn FOR t005t-landx MODIF ID gr1,
                  s_b_bn FOR zarv4_d_book-book_name MODIF ID gr1.

SELECTION-SCREEN END OF BLOCK bn1.

SELECTION-SCREEN PUSHBUTTON 10(15)  TEXT-t02 USER-COMMAND inf  VISIBLE LENGTH 30.

*Data definition

INITIALIZATION.
  p_lang = 'E'.

*When: Process before output
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'GR1' AND p_add = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR1'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


* When: Process after input / After user input data /
* Popuse of using: Check what user press, filled
AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'INF'.
    CALL TRANSACTION 'ZARV4_ADD_INFO'.
  ENDIF.



START-OF-SELECTION.
*Select all books for defined selection criteria

  SELECT DISTINCT b~book_id, b~book_name
    FROM zarv4_d_author AS a
    INNER JOIN zarv4_d_book AS b
    ON a~author_id = b~author_id
     INNER JOIN zarv4_d_author_t AS at
    ON at~author_id = a~author_id
    INNER JOIN t005t AS t
    ON a~country = t~land1
    WHERE a~author_id IN @s_a_id
    AND a~author_id IN @s_b_id
    AND at~author_first_name IN @s_at_fn
    AND at~author_last_name IN @s_at_ln
    AND a~birth_date IN @s_a_bd
    AND a~country IN @s_a_co
    AND t~landx IN @s_t_cn
    AND b~book_name IN @s_b_bn
    INTO TABLE @DATA(gty_books).

END-OF-SELECTION.


*Write data
  cl_salv_table=>factory(
  IMPORTING r_salv_table = DATA(go_salv)
    CHANGING  t_table = gty_books ).
  go_salv->display( ).
