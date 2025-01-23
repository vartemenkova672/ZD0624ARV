*&---------------------------------------------------------------------*
*& Report ZARV4_R_SELECT_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_select_data.

*&---------------------------------------------------------------------*
* *===task_1===*
* Show on the screen the first and last names of the authors
* whose last names start with the Latin letter H. (AUTHOR_T, langu='E')
*&---------------------------------------------------------------------*

SELECT FROM zarv4_d_author_t
  FIELDS author_first_name, author_last_name
  WHERE author_last_name LIKE 'H%'
AND langu = 'E'
  INTO TABLE @DATA(dt_author_h).

WRITE: 'Task 1. Show on the screen the first and last names of the authors whose last names start with the Latin letter H'.
SKIP.
LOOP AT dt_author_h ASSIGNING FIELD-SYMBOL(<dt_author_h>).
  WRITE: / 'first_name: ', <dt_author_h>-author_first_name, 'last_name: ', <dt_author_h>-author_last_name.
ENDLOOP.

*&---------------------------------------------------------------------*
* *===task_2===*
* Show on the screen the full name and phone number of the youngest reader.
*  (READER, READER_T langu='E')
*&---------------------------------------------------------------------*

SELECT concat_with_space( rt~person_first_name, rt~person_last_name, 1 ) AS fn, r~phone_number AS pn
  FROM zarv4_d_reader AS r
  INNER JOIN zarv4_d_reader_t AS rt
  ON r~person_id = rt~person_id
  WHERE rt~langu = 'E'
  ORDER BY r~birth_date DESCENDING
   INTO TABLE @DATA(gt_reader)
    UP TO 1 ROWS.

SKIP.
WRITE: 'Task 2. Show on the screen the full name and phone number of the youngest reader'.
SKIP.
LOOP AT gt_reader ASSIGNING FIELD-SYMBOL(<gt_reader>).
  WRITE: /'full name: ', <gt_reader>-fn,
         / 'phone number: ', <gt_reader>-pn.
ENDLOOP.

*&---------------------------------------------------------------------*
* *===task_3===*
* Show on the screen the first and last names of all authors under 50*.
* (AUTHOR, AUTHOR_T, langu='E' Sy-datum)
*&---------------------------------------------------------------------*

DATA : new_date TYPE sy-datum.

CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
  EXPORTING
    date      = sy-datum
    days      = '00'
    months    = '00'
    signum    = '-'
    years     = '50'
  IMPORTING
    calc_date = new_date.

SELECT at~author_first_name AS fn, at~author_last_name AS ln
  FROM zarv4_d_author_t AS at
  INNER JOIN zarv4_d_author AS a
  ON a~author_id = at~author_id
     INTO TABLE @DATA(gt_author_b)
  WHERE at~langu = 'E'
  AND a~birth_date > @new_date.

SKIP.
WRITE: 'Task 3. Show on the screen the first and last names of all authors under 50'.
SKIP.
LOOP AT gt_author_b ASSIGNING FIELD-SYMBOL(<gt_author_b>).
  WRITE: / 'first name: ', <gt_author_b>-fn,
  'last_name: ', <gt_author_b>-ln.
ENDLOOP.

*&---------------------------------------------------------------------*
* *===task_4===*
* Show on the screen the first and last names of the readers who currently have books
* and the count of these books.
*  (READER_T langu='E', BOOKING, BOOKING_STATUS = 2)
*&---------------------------------------------------------------------*

SELECT rt~person_first_name AS fn, rt~person_last_name AS ln, COUNT( b~book_id ) AS c
  FROM zarv4_d_reader_t AS rt
    INNER JOIN zarv4_d_booking AS b
  ON b~person_id = rt~person_id
  WHERE b~booking_status = 2
  AND rt~langu = 'E'
    GROUP BY rt~person_first_name, rt~person_last_name
  ORDER BY rt~person_first_name, rt~person_last_name
   INTO TABLE @DATA(gt_books_taken).

SKIP.
WRITE: 'Task 4. Show on the screen the first and last names of the readers who currently have books and the count of these books'.
SKIP.
LOOP AT gt_books_taken ASSIGNING FIELD-SYMBOL(<gt_books_taken>).
  WRITE: / 'first name: ', <gt_books_taken>-fn,
   'last_name: ', <gt_books_taken>-ln,
   'count of books: ', <gt_books_taken>-c.
ENDLOOP.

*&---------------------------------------------------------------------*
* *===task_5===*
* Show on the screen the names of the authors' home countries
* in alphabetical order, as well as the number of authors from each country.
* (AUTHOR, T005)
*&---------------------------------------------------------------------*

SELECT country, landx as country_name, COUNT( * ) AS count
  FROM zarv4_d_author AS a
  INNER JOIN t005t as t
  ON a~country = t~land1
 WHERE t~spras = 'E'
    GROUP BY country, landx
  ORDER BY landx
   INTO TABLE @DATA(gt_authors_country).

SKIP.
WRITE: 'Task 5. Show on the screen the names of the authors home countries in alphabetical order, as well as the number of authors from each country'.
SKIP.
LOOP AT gt_authors_country ASSIGNING FIELD-SYMBOL(<gt_authors_country>).
  WRITE: / 'country: ', <gt_authors_country>-country_name,
   'lnumber of authors: ', <gt_authors_country>-count.
ENDLOOP.
