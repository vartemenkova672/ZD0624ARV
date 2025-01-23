*&---------------------------------------------------------------------*
*& Report ZARV4_R_RANGES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_ranges.

TABLES ZARV4_d_book.

SELECT-OPTIONS:
so_book FOR zarv4_d_book-book_id,
so_auth FOR zarv4_d_book-author_id.

*Types definition
TYPES:
  BEGIN OF gty_s_book,
    book_id           TYPE zarv4_book_id,
    book_name         TYPE zarv4_book_name,
    author_first_name TYPE  zarv4_first_name,
    author_last_name  TYPE zarv4_last_name,
    copy_qty          TYPE zarv4_copy_qty,
    booked_qty        TYPE Int2,
    in_stock_qty      TYPE Int2,
  END OF gty_s_book.


*Data definition
DATA: gt_book1 TYPE TABLE OF gty_s_book.
DATA: gt_book2 TYPE TABLE OF gty_s_book.

*Select all books for defined ids and authors

SELECT book_id, book_name, author_first_name, author_last_name
  FROM zarv4_d_book AS b
    INNER JOIN zarv4_d_author_t AS a
      ON b~author_id = a~author_id
  WHERE b~book_id IN @so_book
    AND a~author_id IN @so_auth
 AND a~langu = @sy-langu
     INTO TABLE @gt_book1.

*    AND a~langu = 'E'.

*Write data

LOOP AT gt_book1 ASSIGNING FIELD-SYMBOL(<gs_book>).
  WRITE: / <gs_book>-book_id,
           <gs_book>-book_name,
           <gs_book>-author_first_name,
           <gs_book>-author_last_name.
ENDLOOP.

SKIP.
ULINE.
SKIP.

*Select all books for defined ids and authors and their total and booked quantity
SELECT b~book_id , book_name, author_first_name, author_last_name, b~copy_QTY AS copy_qty,
COUNT( booked~book_id ) AS booked_qty
  FROM zarv4_d_book AS b
  INNER JOIN zarv4_d_author_t AS a
  ON b~author_id = a~author_id
  LEFT JOIN zarv4_d_booking AS booked
  ON booked~book_ID = b~book_ID AND booked~booking_status = '2'
  WHERE b~book_id IN @so_book
  AND a~author_id IN @so_auth
  AND a~langu = @sy-langu
  GROUP BY b~book_id, book_name, author_first_name, author_last_name, copy_qty
  INTO TABLE @gt_book2.

*Write data
LOOP AT gt_book2 ASSIGNING <gs_book>.
  <gs_book>-in_stock_qty = <gs_book>-copy_qty - <gs_book>-booked_qty.
  WRITE: / <gs_book>-book_id,
           <gs_book>-book_name,
           <gs_book>-author_first_name,
           <gs_book>-author_last_name,
           <gs_book>-in_stock_qty.
ENDLOOP.
