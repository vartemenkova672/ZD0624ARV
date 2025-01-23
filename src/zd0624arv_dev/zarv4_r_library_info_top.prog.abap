*&---------------------------------------------------------------------*
*& Include ZARV4_R_LIBRARY_INFO_TOP                 - Report ZARV4_R_LIBRARY_INFO
*&---------------------------------------------------------------------*
REPORT zarv4_r_library_info.

TABLES: zarv4_d_author,
        zarv4_d_author_t,
        zarv4_d_book,
        t005t,
        sscrfields.

TYPES:
  BEGIN OF gty_s_books,
    BOOK_ID TYPE ZARV4_D_BOOK-BOOK_ID,
    BOOK_NAME  TYPE  ZARV4_D_BOOK-BOOK_NAME,
  END OF gty_s_books.

  DATA: gt_book TYPE TABLE OF gty_s_books.
