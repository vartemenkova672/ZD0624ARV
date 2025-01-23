*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_SCR
*&---------------------------------------------------------------------*

TABLES: zarv4_d_booking.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_bookng FOR zarv4_d_booking-booking_id,
                  s_book   FOR zarv4_d_booking-book_id,
                  s_person FOR zarv4_d_booking-person_id,
                  s_status FOR zarv4_d_booking-booking_status.
SELECTION-SCREEN END OF BLOCK b01.
