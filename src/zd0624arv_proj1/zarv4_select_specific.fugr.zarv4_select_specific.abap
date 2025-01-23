FUNCTION zarv4_select_specific.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(LV_NOMENCLATURE_ID) TYPE  ZARV4_NOMENCLATURE_ID
*"  EXPORTING
*"     REFERENCE(LT_SPECIFICATION) TYPE  ANY TABLE
*"  EXCEPTIONS
*"      NO_DATA
*"----------------------------------------------------------------------

  SELECT *
    FROM zarv4_d_specific
    WHERE zarv4_d_specific~finished_goods_id = @lv_nomenclature_id
    ORDER BY zarv4_d_specific~raw_material_id
    INTO TABLE @lt_specification.

  IF sy-subrc <> 0.
    RAISE no_data.
  ENDIF.

ENDFUNCTION.
