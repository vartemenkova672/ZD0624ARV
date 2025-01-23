
FUNCTION zarv4_nom_updates.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_NOMENCLATURE) TYPE  ZARV4_S_NOMENCLATURE
*"     VALUE(CREATE) TYPE  BOOLEAN
*"     VALUE(DELETE) TYPE  BOOLEAN
*"     VALUE(CHANGE) TYPE  BOOLEAN
*"----------------------------------------------------------------------

  IF create = 'X'.
    SELECT nomenclature_id
      FROM zarv4_d_nom
      ORDER BY nomenclature_id DESCENDING
      INTO @DATA(iv_record_id)
       UP TO 1 ROWS.
    ENDSELECT.

    is_nomenclature-nomenclature_id = iv_record_id + 1.
  ENDIF.

  IF create = 'X' OR change = 'X'.

    DATA: ls_nomenclature   TYPE zarv4_d_nom,
          ls_nomenclature_t TYPE zarv4_d_nom_t.

    ls_nomenclature-mandt            = sy-mandt.
    ls_nomenclature-nomenclature_id  = is_nomenclature-nomenclature_id.
    ls_nomenclature-article          = is_nomenclature-article.
    ls_nomenclature-unit_type_id     = is_nomenclature-unit_type_id.
    ls_nomenclature-indicator_of_use = is_nomenclature-indicator_of_use.

    MODIFY zarv4_d_nom FROM ls_nomenclature.

    IF sy-subrc <> 0.
      MESSAGE 'Error occurred during author update' TYPE 'A'.
    ENDIF.

    ls_nomenclature_t-mandt             = sy-mandt.
    ls_nomenclature_t-langu             = is_nomenclature-langu.
    ls_nomenclature_t-nomenclature_id   = is_nomenclature-nomenclature_id.
    ls_nomenclature_t-nomenclature_name = is_nomenclature-nomenclature_name.

    MODIFY zarv4_d_nom_t FROM ls_nomenclature_t.

    IF sy-subrc <> 0.
      MESSAGE 'Error occurred during author update' TYPE 'A'.
    ENDIF.

    IF sy-subrc = 0 AND create = 'X'.
      MESSAGE 'The nomenclature was created' TYPE 'S'.
    ELSEIF sy-subrc = 0 AND change = 'X'.
      MESSAGE 'The nomenclature data has been changed' TYPE 'S'.
    ENDIF.
  ENDIF.

  IF delete = 'X'.

    DELETE FROM zarv4_d_nom
    WHERE nomenclature_id = is_nomenclature-nomenclature_id.

    DELETE FROM zarv4_d_nom_t
    WHERE nomenclature_id = is_nomenclature-nomenclature_id.

    IF sy-subrc = 0.
      MESSAGE 'The nomenclature was deleted' TYPE 'S'.
    ENDIF.

    IF sy-subrc <> 0.
      MESSAGE 'Record not found' TYPE 'S'.
    ENDIF.

  ENDIF.

ENDFUNCTION.
