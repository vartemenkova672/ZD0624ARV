*&---------------------------------------------------------------------*
*& Include          ZARV4_R_LIBRARY_INFO_SEL
*&---------------------------------------------------------------------*

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
