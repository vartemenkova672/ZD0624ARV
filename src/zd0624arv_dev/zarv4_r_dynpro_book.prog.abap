*&---------------------------------------------------------------------*
*& Report ZARV4_R_DYNPRO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_dynpro_book.

TABLES: zarv4_s_dynpro_book.
PARAMETERS: p_bookid TYPE zarv4_s_dynpro_book-book_id.


DATA: gv_ucomm_0100 TYPE sy-ucomm,
      gs_book type zarv4_d_book..
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT SINGLE *
  FROM zarv4_d_book
  INTO CORRESPONDING FIELDS OF zarv4_s_dynpro_book
  WHERE book_id = p_bookid.
  IF sy-subrc <> 0.
    zarv4_s_dynpro_book-book_id = p_bookid.
  ENDIF.

  CALL SCREEN 0100.

MODULE user_command_0100 INPUT.
  CASE gv_ucomm_0100.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
   WHEN 'SAVE'.
      gs_book = CORRESPONDING #( zarv4_s_dynpro_book ).
      MODIFY zarv4_d_book FROM gs_book.
      IF sy-subrc = 0.
        MESSAGE 'OK' TYPE 'S'.
      ENDIF.
      CLEAR gs_book.
  ENDCASE.
  CLEAR gv_ucomm_0100.
ENDMODULE.
