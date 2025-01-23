*&---------------------------------------------------------------------*
*& Report ZARV4_R_SELECT_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_data_definition.

TYPES gty_names TYPE c LENGTH 30.
DATA gv_date TYPE datum.
DATA gv_year TYPE int4.

*Task 1 variables
TYPES:
  BEGIN OF gty_s_author,
    author_first_name TYPE gty_names,
    author_last_name  TYPE gty_names,
  END OF gty_s_author.

DATA: gt_author TYPE TABLE OF gty_s_author.
FIELD-SYMBOLS: <gt_author> TYPE gty_s_author.

*Task 2 variables
TYPES:
  BEGIN OF gty_s_reader,
    birth_date        TYPE d,
    person_first_name TYPE gty_names,
    person_last_name  TYPE gty_names,
    phone_number      TYPE c LENGTH 20,
  END OF gty_s_reader.

DATA: gt_reader TYPE TABLE OF gty_s_reader.
FIELD-SYMBOLS: <gt_reader> TYPE gty_s_reader.

*Task 3 variables
TYPES:
  BEGIN OF gty_s_author_date,
    author_first_name TYPE gty_names,
    author_last_name  TYPE gty_names,
    birth_date        TYPE d,
  END OF gty_s_author_date.

DATA: gt_author_date TYPE TABLE OF gty_s_author_date.
FIELD-SYMBOLS: <gt_author_date> TYPE gty_s_author_date.

*Task 4 variables
TYPES:
  BEGIN OF gty_s_booking,
    person_id         TYPE n LENGTH 6,
    person_first_name TYPE gty_names,
    person_last_name  TYPE gty_names,
    book_cnt          TYPE i,
  END OF gty_s_booking.

DATA: gt_bookinge TYPE TABLE OF gty_s_booking.
FIELD-SYMBOLS: <gt_bookinge> TYPE gty_s_booking.

*Task 5 variables
TYPES:
  BEGIN OF gt_s_country,
   country TYPE c LENGTH 3,
   country_name TYPE c LENGTH 3,
   author_cnt  TYPE i,
  END OF gt_s_country.

DATA: gt_country TYPE TABLE OF gt_s_country.
FIELD-SYMBOLS: <gt_country> TYPE gt_s_country.



*Task 1
SELECT author_first_name, author_last_name
  FROM zarv4_d_author_t
  INTO TABLE @gt_author
  WHERE author_last_name LIKE 'H%'
  AND langu = 'E'.

WRITE: 'Task 1'.
SKIP.

LOOP AT gt_author ASSIGNING FIELD-SYMBOL(<gs_author>).
  WRITE: / <gs_author>-author_first_name, <gs_author>-author_last_name.
ENDLOOP.

ULINE.

*Task 2
SELECT
  birth_date  AS birth_date,
  person_first_name  AS person_first_name,
  person_last_name  AS person_last_name,
  phone_number  AS phone_number
  FROM zarv4_d_reader INNER JOIN zarv4_d_reader_t ON
   zarv4_d_reader~person_id = zarv4_d_reader_t~person_id
  WHERE langu = 'E'
  AND birth_date IN ( SELECT  MAX( birth_date ) AS birth_date FROM zarv4_d_reader )
  INTO TABLE @gt_reader.

WRITE: 'Task 2'.
SKIP.

LOOP AT gt_reader ASSIGNING FIELD-SYMBOL(<gs_reader>).
  WRITE: / <gs_reader>-person_first_name, <gs_reader>-person_last_name, <gs_reader>-phone_number.
ENDLOOP.

ULINE.

*Task 3
gv_date = sy-datum.
gv_year = gv_date+0(4).
gv_year = gv_year - 50.
gv_date+0(4) = gv_year.

SELECT author_first_name, author_last_name, birth_date
  FROM zarv4_d_author INNER JOIN zarv4_d_author_t ON
  zarv4_d_author~author_id = zarv4_d_author_t~author_id
  WHERE langu = 'E'
  AND birth_date > @gv_date
  INTO TABLE @gt_author_date.

WRITE: 'Task 3'.
SKIP.

LOOP AT gt_author_date ASSIGNING FIELD-SYMBOL(<gs_author_date>).
  WRITE: / <gs_author_date>-author_first_name, <gs_author_date>-author_last_name.
ENDLOOP.

ULINE.

*Task4
SELECT
  zarv4_d_booking~person_id AS person_id,
  MIN( person_first_name )  AS person_first_name,
  MIN( person_last_name )  AS person_last_name,
  COUNT( * ) AS book_cnt
  FROM zarv4_d_booking INNER JOIN zarv4_d_reader_t ON
   zarv4_d_booking~person_id = zarv4_d_reader_t~person_id
  WHERE langu = 'E'
  AND booking_status = 2
  GROUP BY zarv4_d_booking~person_id
  INTO TABLE @gt_bookinge.

WRITE: 'Task 4'.
SKIP.

LOOP AT gt_bookinge ASSIGNING FIELD-SYMBOL(<gs_bookinge>).
  WRITE: / <gs_bookinge>-person_first_name, <gs_bookinge>-person_last_name, <gs_bookinge>-book_cnt.
ENDLOOP.

ULINE.

*Task 5
SELECT
  country,
  landx AS country_name,
  COUNT( * ) AS author_cnt
  FROM zarv4_d_author INNER JOIN t005t ON
  zarv4_d_author~country = t005t~land1
  WHERE spras = 'E'
  GROUP BY country, landx
  ORDER BY landx
  INTO TABLE @gt_country.

WRITE: 'Task 5'.
SKIP.

LOOP AT gt_country ASSIGNING FIELD-SYMBOL(<gs_country>).
  WRITE: / <gs_country>-country_name, <gs_country>-author_cnt.
ENDLOOP.

ULINE.
