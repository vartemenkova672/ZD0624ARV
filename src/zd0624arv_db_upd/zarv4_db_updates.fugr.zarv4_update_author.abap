FUNCTION zarv4_update_author.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_AUTHOR) TYPE  ZARV4_D_AUTHOR
*"     VALUE(IS_AUTHOR_T) TYPE  ZARV4_D_AUTHOR_T
*"     VALUE(CHANGE_AUTHOR) TYPE  BOOLEAN
*"     VALUE(CHANGE_AUTHOR_T) TYPE  BOOLEAN
*"----------------------------------------------------------------------
  IF change_author <> abap_false.
    UPDATE zarv4_d_author FROM is_author.
  ENDIF.

  IF change_author_t <> abap_false.
    UPDATE zarv4_d_author_t FROM is_author_t.
  ENDIF.

  IF sy-subrc = 0.
    MESSAGE 'Changes have been made' TYPE 'S'.
  ENDIF.

  IF sy-subrc <> 0.
    MESSAGE 'Error occurred during author update' TYPE 'A'.
  ENDIF.

ENDFUNCTION.
