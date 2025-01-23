*&---------------------------------------------------------------------*
*& Report ZARV4_R_LOOP_COND_TRAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_loop_cond_train.

* === Task 2===*
* Find the youngest and oldest author.

DATA: lv_linno   TYPE i.

SELECT author_id
  FROM zarv4_d_author
  ORDER BY birth_date
  INTO TABLE @DATA(lty_all_authors).

READ TABLE lty_all_authors INDEX 1 INTO DATA(oldest_author).

DESCRIBE TABLE lty_all_authors LINES lv_linno.

READ TABLE lty_all_authors INDEX lv_linno INTO DATA(youngest_author).

* === Task 3===*
* Find the average year of birth of the authors.
DATA:
  lv_count        TYPE i,
  lv_years        LIKE lv_count,
  lv_average_year LIKE lv_count.


SELECT birth_date
  FROM zarv4_d_author
  INTO TABLE @DATA(lty_birth_dates).

LOOP AT lty_birth_dates ASSIGNING FIELD-SYMBOL(<gs_birth_dates>).
  lv_years = lv_years + <gs_birth_dates>-birth_date+0(4).
  lv_count = lv_count + 1.
ENDLOOP.

lv_average_year = lv_years / lv_count.

* === Task 4===*
* Find the average date of birth.

DATA:
  lv_youngest  TYPE sy-datum,
  lv_oldest    LIKE lv_youngest,
  lv_months(2) TYPE n,
  lv_date      TYPE d.

SELECT birth_date
  FROM zarv4_d_author
  ORDER BY birth_date
  INTO TABLE @DATA(lty_birth_dates1).

READ TABLE lty_birth_dates1 INDEX 1 INTO lv_oldest .

DESCRIBE TABLE lty_birth_dates1 LINES lv_linno.

READ TABLE lty_birth_dates1 INDEX lv_linno INTO lv_youngest.

DATA(diffDays) = lv_youngest - lv_oldest.
lv_months = diffDays / 2.

CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
  EXPORTING
    date      = lv_oldest
    days      = '00'
    months    = lv_months
    signum    = '+'
    years     = '00'
  IMPORTING
    calc_date = lv_date.

* === Task 5===*
* Display the names of authors and their dates of birth by date of birth.

SELECT author_first_name, author_last_name, birth_date
  FROM zarv4_d_author_t AS at
  INNER JOIN zarv4_d_author AS a
  ON a~author_id = at~author_id
  WHERE langu = @sy-langu
  ORDER BY birth_date
  INTO TABLE @DATA(ity_authors_bd).

WRITE:'Task 5. Display the names of authors and their dates of birth by date of birth '.
SKIP.
LOOP AT ity_authors_bd ASSIGNING FIELD-SYMBOL(<gs_authors_bd>).
  WRITE: /, 'First name: ', <gs_authors_bd>-author_first_name,
        'Last name: ' , <gs_authors_bd>-author_last_name,
        'Birth date: ' , <gs_authors_bd>-birth_date.
ENDLOOP.
ULINE.
SKIP.

* === Task 6===*
* Display readers' names and dates of birth by date of birth.

SELECT person_first_name, person_last_name, birth_date
  FROM zarv4_d_reader_t AS rt
  INNER JOIN zarv4_d_reader AS r
  ON r~person_id = rt~person_id
  WHERE langu = @sy-langu
  ORDER BY birth_date
  INTO TABLE @DATA(ity_readers_bd).

WRITE:'Task 6. Display readers names and dates of birth by date of birth '.
SKIP.
LOOP AT ity_readers_bd ASSIGNING FIELD-SYMBOL(<gs_readers_bd>).
  WRITE: /, 'First name: ', <gs_readers_bd>-person_first_name,
         'Last name: ' , <gs_readers_bd>-person_last_name,
         'Birth date: ' , <gs_readers_bd>-birth_date.
ENDLOOP.
ULINE.
SKIP.

* === Task 7===*
*  Display the reader who read the most books.

SELECT person_first_name, person_last_name, count( bing~booking_id ) as book_amount
  FROM zarv4_d_reader_t AS rt
  INNER JOIN zarv4_d_reader AS r
  ON r~person_id = rt~person_id
  INNER JOIN ZARV4_D_BOOKING AS bing
  ON bing~person_id = r~person_id
  WHERE langu = @sy-langu
  group by person_first_name, person_last_name
  order by book_amount DESCENDING
  INTO TABLE @DATA(ity_readers_count)
  UP TO 1 ROWS.

WRITE:'Task 7. Display the reader who read the most books'.
SKIP.
LOOP AT ity_readers_count ASSIGNING FIELD-SYMBOL(<gs_readers_count>).
  WRITE: /, 'First name: ', <gs_readers_count>-person_first_name,
         'Last name: ' , <gs_readers_count>-person_last_name.
  ULINE.
ENDLOOP.
