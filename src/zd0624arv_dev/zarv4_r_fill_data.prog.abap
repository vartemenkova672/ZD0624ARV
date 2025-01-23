*&---------------------------------------------------------------------*
*& Report ZSAPLAB_PATTERN_FILL_DATA
*&---------------------------------------------------------------------*
*& This is a pattern program
*& Please use needed parts of the program for your tasks
*&---------------------------------------------------------------------*
REPORT zarv4_r_fill_data.

DATA gv_count TYPE int4.

*&---------------------------------------------------------------------*
*& Select data from the XXX table READER
*&---------------------------------------------------------------------*
SELECT *
  FROM zxxx_d_reader
  INTO TABLE @DATA(gt_reader).
*&---------------------------------------------------------------------*
*& Insert data into your own table READER
*&---------------------------------------------------------------------*
MODIFY zarv4_d_reader FROM TABLE gt_reader.

*&---------------------------------------------------------------------*
*& Check number of entries in your own table READER
*&---------------------------------------------------------------------*
CLEAR gv_count.
SELECT COUNT(*) FROM zarv4_d_reader INTO gv_count.
WRITE: 'Number of entries in ZARV4_D_READER: ', gv_count.

*&---------------------------------------------------------------------*
*& Select data from the XXX table READER_T
*&---------------------------------------------------------------------*
*Write your code:
SELECT *
  FROM zxxx_d_reader_t
  INTO TABLE @DATA(gt_reader_t).

*&---------------------------------------------------------------------*
*& Insert data into your own table READER_T
*&---------------------------------------------------------------------*
*Write your code:
MODIFY ZARV4_D_READER_T FROM TABLE gt_reader_t.

*Check number of entries:
CLEAR gv_count.
SELECT COUNT(*) FROM ZARV4_D_READER_T INTO gv_count.
WRITE: 'Number of entries in ZARV4_D_READER_T: ', gv_count.

*&---------------------------------------------------------------------*
*& Select data from the XXX table AUTHOR
*&---------------------------------------------------------------------*
*Write your code:
SELECT *
  FROM zxxx_d_AUTHOR
  INTO TABLE @DATA(gt_author).

*&---------------------------------------------------------------------*
*& Insert data into your own table AUTHOR
*&---------------------------------------------------------------------*
*Write your code:
MODIFY ZARV4_D_AUTHOR FROM TABLE gt_author.

*Check number of entries:
CLEAR gv_count.
SELECT COUNT(*) FROM ZARV4_D_AUTHOR INTO gv_count.
WRITE: 'Number of entries in ZARV4_D_AUTHOR: ', gv_count.

*&---------------------------------------------------------------------*
*& Select data from the XXX table AUTHOR_T
*&---------------------------------------------------------------------*
*Write your code:
SELECT *
  FROM zxxx_d_AUTHOR_T
  INTO TABLE @DATA(gt_author_t).

*&---------------------------------------------------------------------*
*& Insert data into your own table AUTHOR_T
*&---------------------------------------------------------------------*
*Write your code:
MODIFY ZARV4_D_AUTHOR_T FROM TABLE gt_author_t.

*Check number of entries:
CLEAR gv_count.
SELECT COUNT(*) FROM ZARV4_D_AUTHOR_T INTO gv_count.
WRITE: 'Number of entries in ZARV4_D_AUTHOR_T: ', gv_count.

*&---------------------------------------------------------------------*
*& Select data from the XXX table BOOK
*&---------------------------------------------------------------------*
*Write your code:
SELECT *
  FROM zxxx_d_BOOK
  INTO TABLE @DATA(gt_book).

*&---------------------------------------------------------------------*
*& Insert data into your own table BOOK
*&---------------------------------------------------------------------*
*Write your code:
MODIFY ZARV4_D_BOOK FROM TABLE gt_book.

*Check number of entries:
CLEAR gv_count.
SELECT COUNT(*) FROM ZARV4_D_BOOK INTO gv_count.
WRITE: 'Number of entries in ZARV4_D_BOOK: ', gv_count.

*&---------------------------------------------------------------------*
*& Select data from the XXX table BOOKING
*&---------------------------------------------------------------------*
*Write your code:
SELECT *
  FROM zxxx_d_BOOKING
  INTO TABLE @DATA(gt_booking).

*&---------------------------------------------------------------------*
*& Insert data into your own table BOOKING
*&---------------------------------------------------------------------*
*Write your code:
MODIFY ZARV4_D_BOOKING FROM TABLE gt_booking.

*Check number of entries:
CLEAR gv_count.
SELECT COUNT(*) FROM ZARV4_D_BOOKING INTO gv_count.
WRITE: 'Number of entries in ZARV4_D_BOOKING: ', gv_count.
