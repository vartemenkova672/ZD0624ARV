*&---------------------------------------------------------------------*
*& Report ZARV4_R_LOOP_COND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_loop_cond.

TYPES ity_name TYPE c LENGTH 30.

TYPES:
  BEGIN OF ity_s_authors,
    author_first_name TYPE ity_name,
    author_last_name  TYPE ity_name,
    country           TYPE c LENGTH 3,
  END OF ity_s_authors.

DATA: ity_d_authors TYPE TABLE OF ity_s_authors.

TYPES:
  BEGIN OF ity_s_authors_count,
    country       TYPE c LENGTH 3,
    country_name  TYPE c LENGTH 30,
    author_amount TYPE i,
  END OF ity_s_authors_count.

DATA: ity_d_authors_count TYPE TABLE OF ity_s_authors_count.


* === Task 2.a===*

SELECT author_first_name, author_last_name, country
  FROM zarv4_d_author_t AS a
  INNER JOIN zarv4_d_author AS at
  ON a~author_id = at~author_id
  WHERE langu = 'E'
  INTO TABLE @ity_d_authors.

* === Task 2.b=== *

SELECT country, landx AS country_name, COUNT( it~author_first_name ) AS author_amount
  FROM @ity_d_authors AS it
  INNER JOIN t005t AS t
  ON it~country = t~land1 AND t~spras = @sy-langu
  GROUP BY landx,country
  ORDER BY landx
  INTO TABLE @ity_d_authors_count.

* === Task 2.c=== *
WRITE:'Task 2.c'.
SKIP.
LOOP AT ity_d_authors_count ASSIGNING FIELD-SYMBOL(<gs_authors_count>).
  ULINE.
  WRITE:'|', 'Country: ', <gs_authors_count>-country_name,
        '|', 'Number of authors: ' ,<gs_authors_count>-author_amount.
  ULINE.
  LOOP AT ity_d_authors ASSIGNING FIELD-SYMBOL(<gs_ity_d_authors>).
    IF <gs_ity_d_authors>-country = <gs_authors_count>-country.
      WRITE:/ 'First name: ', <gs_ity_d_authors>-author_first_name, 'last name: ', <gs_ity_d_authors>-author_last_name.
    ENDIF.
  ENDLOOP.
  SKIP.
ENDLOOP.

* === Task 3.a=== *

SELECT b~book_name AS name, bing~booking_status AS status
  FROM zarv4_d_booking AS bing
  INNER JOIN zarv4_d_book AS b
  ON bing~book_id = b~book_id
  ORDER BY bing~booking_status
  INTO TABLE @DATA(ity_books).

* === Task 3.b=== *
WRITE:'Task 3.b'.
SKIP.
ULINE.
WRITE:'|', 'Now reading:'.
ULINE.
LOOP AT ity_books ASSIGNING FIELD-SYMBOL(<gs_books>).
  IF <gs_books>-status = '2'.
    WRITE:/ <gs_books>-name.
  ENDIF.
ENDLOOP.
SKIP.

* === Task 3.c=== *
WRITE:'Task 3.c'.
SKIP.
ULINE.
WRITE:'|', 'Already returned:'.
ULINE.
LOOP AT ity_books ASSIGNING <gs_books>.
  IF <gs_books>-status = '1'.
    WRITE:/ <gs_books>-name.
  ENDIF.
ENDLOOP.
SKIP.
