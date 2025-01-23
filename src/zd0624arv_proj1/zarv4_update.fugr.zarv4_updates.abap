FUNCTION zarv4_updates.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_TRANSACT) TYPE  ZARV4_D_TRANSACT
*"     VALUE(ADD_TRANSACT) TYPE  BOOLEAN
*"     VALUE(CHANGE_TRANSACT) TYPE  BOOLEAN
*"     VALUE(DELETE_TRANSACT) TYPE  BOOLEAN
*"     VALUE(ID_NUMBER) TYPE  ZARV4_RECORD_ID OPTIONAL
*"----------------------------------------------------------------------
  IF add_transact = 'X'.
    SELECT record_id
      FROM zarv4_d_transact
      ORDER BY record_id DESCENDING
      INTO @DATA(iv_record_id)
       UP TO 1 ROWS.
    ENDSELECT.

    is_transact-record_id = iv_record_id + 1.
  ENDIF.

  IF add_transact = 'X' OR change_transact = 'X'.

    MODIFY zarv4_d_transact
        FROM is_transact.

    IF sy-subrc = 0.
      MESSAGE 'Changes have been made' TYPE 'S'.
    ENDIF.

    IF sy-subrc <> 0.
      MESSAGE 'Error occurred during author update' TYPE 'A'.
    ENDIF.

  ENDIF.

  IF delete_transact = 'X'.

    DELETE FROM zarv4_d_transact
    WHERE record_id = id_number.

    IF sy-subrc = 0.
      MESSAGE 'Entry was deleted' TYPE 'S'.
    ENDIF.

    IF sy-subrc <> 0.
      MESSAGE 'Record not found' TYPE 'S'.
    ENDIF.

  ENDIF.

ENDFUNCTION.
