*&---------------------------------------------------------------------*
*& Report ZARV4_R_ADD_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_add_info.

SELECT COUNT(*)
  FROM ZARV4_d_booking
  WHERE booking_status ='2'
  INTO @DATA(gv_on_hand).

WRITE: / 'How many books are on hand:', gv_on_hand.
SKIP.

SELECT COUNT(*)
  FROM ZARV4_d_booking
  WHERE booking_status ='1'
  INTO @DATA(gv_free).

WRITE: / 'How many books are in the library (free):', gv_free.
SKIP.

SELECT author_first_name, author_last_name, COUNT( bing~booking_id ) AS number
  FROM ZARV4_d_booking AS bing
  JOIN ZARV4_d_book AS b
  ON bing~book_id = b~book_id
  JOIN ZARV4_d_author_t AS at
  ON b~author_id = at~author_id
  WHERE langu = @sy-langu
  GROUP BY author_first_name, author_last_name
  ORDER BY number DESCENDING
  INTO TABLE @DATA(gt_most_author)
  UP TO 1 ROWS.

LOOP AT gt_most_author ASSIGNING FIELD-SYMBOL(<gs_most_author>).
  WRITE: / 'The most-read author:', <gs_most_author>-author_first_name,
  <gs_most_author>-author_last_name.
ENDLOOP.
SKIP.

SELECT person_first_name, person_last_name, COUNT( bing~booking_id ) AS number
  FROM ZARV4_d_booking AS bing
  JOIN ZARV4_d_reader_t AS rt
  ON bing~person_id = rt~person_id
  WHERE langu = @sy-langu
  GROUP BY person_first_name, person_last_name
  ORDER BY number DESCENDING
  INTO TABLE @DATA(gt_most_reader)
  UP TO 1 ROWS.

LOOP AT gt_most_reader ASSIGNING FIELD-SYMBOL(<gs_most_reader>).
  WRITE: / 'The reader who read the most books:',
  <gs_most_reader>-person_first_name,
  <gs_most_reader>-person_last_name.
ENDLOOP.
SKIP.
