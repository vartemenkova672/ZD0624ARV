class ZARV4_CL_MADAGEMENT_DATABASE definition
  public
  final
  create private .

public section.

  methods ADD_ENTRY
    importing
      !MT_PREPARED_TRANSACTIONS type ZARV4_T_TRANSACTS .
  methods ADD_NOMENCLATURE
    importing
      !MS_PREPARED_NOMENCLATURE type ZARV4_S_NOMENCLATURE .
  methods DELETE_NOMENCLATURE
    importing
      !MS_PREPARED_NOMENCLATURE type ZARV4_S_NOMENCLATURE .
  methods GET_TRANSACTIONS
    importing
      !MT_PERIOD type ZARV4_T_DATE_RANGE
      !MT_NOMENCTATURE_RANGE type ZARV4_T_NOMENCLATURE_ID
    returning
      value(MT_LIST_OF_TRANSACTIONS) type ZARV4_T_TRANSACT_SHOW .
  class-methods GET_TYPE
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(MV_TYPE_OF_USE) type CHAR1 .
  methods GET_SPECIFICATION
    returning
      value(MT_SPECIFICATIONS) type ZARV4_T_SPECIFICATION .
  class-methods GET_INSTANCE
    returning
      value(MV_CONNECTION) type ref to ZARV4_CL_MADAGEMENT_DATABASE .
  methods GET_REMAIN
    importing
      !MT_NOMENCTATURE_ID_RANGE type ZARV4_T_NOMENCLATURE_ID
      !MV_PERIOD_END type ZARV4_TRANSACTION_DATE
    returning
      value(MT_LIST_OF_REMAINS) type ZARV4_T_NOMENCLATURE_REMAIN .
  methods GET_SPEC_WITH_REMAINING
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(MT_SPECIFIC_WITH_REMAINING) type ZARV4_T_SPEC_WITH_REAINING
    raising
      ZARV4_CX_EXCEPTIONS .
  methods CHECK_NOMENCLATURE_ITEM
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    raising
      ZARV4_CX_EXCEPTIONS .
  methods CHECK_INDICATOR_OF_USE
    importing
      !MV_INDICATOR_OF_USE type ZARV4_INDICATOR_OF_USE
    raising
      ZARV4_CX_EXCEPTIONS .
  methods CHECK_UNIT_TYPE_ID
    importing
      !MV_UNIT_TYPE_ID type ZARV4_UNIT_TYPE_ID
    raising
      ZARV4_CX_EXCEPTIONS .
  methods CHECK_SPECIFICATION_EXISTANCE
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    raising
      ZARV4_CX_EXCEPTIONS .
  methods GET_NOMENCLATURE_INFORMATION
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(MS_NOMENCLATURE_INFORMATION) type ZARV4_S_NOMENCLATURE .
  methods CHANGE_NOMENCLATURE
    importing
      !MS_PREPARED_NOMENCLATURE type ZARV4_S_NOMENCLATURE .
  methods GET_NOMENCLATURE_FOR_DISPLAY
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(MS_NOM_FOR_DISPLAY) type ZARV4_S_NOMENCLATURE_0600 .
  methods GET_REMAIN_BY_NOM_ID
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
      !MV_DATE type ZARV4_TRANSACTION_DATE
    returning
      value(MV_REMAINING_QUANTITY) type ZARV4_TRANSACTION_QUANTITY .
  methods CHANGE_ENTRY
    importing
      !MS_TRANSACTION_DATA type ZARV4_S_TRANSACT .
  PROTECTED SECTION.
private section.

  class-data MV_DAO_INSTANCE type ref to ZARV4_CL_MADAGEMENT_DATABASE .
  class-data MV_INDICATOR_IN_TEXT type CHAR10 .

  class-methods SET_LOCKS .
ENDCLASS.



CLASS ZARV4_CL_MADAGEMENT_DATABASE IMPLEMENTATION.


  METHOD add_entry.

    zarv4_cl_madagement_database=>set_locks( ).
    DATA ls_transact      TYPE zarv4_d_transact.


    LOOP AT mt_prepared_transactions ASSIGNING FIELD-SYMBOL(<ls_transaction>).

      ls_transact = CORRESPONDING  #( <ls_transaction> ).

      SET UPDATE TASK LOCAL.

      CALL FUNCTION 'ZARV4_UPDATES'
        EXPORTING
          is_transact     = ls_transact
          add_transact    = abap_true
          change_transact = abap_false
          delete_transact = abap_false.

    ENDLOOP.

  ENDMETHOD.


  METHOD add_nomenclature.

    DATA ls_nomenclature TYPE zarv4_s_nomenclature.

    ls_nomenclature = CORRESPONDING  #( ms_prepared_nomenclature ).

    SET UPDATE TASK LOCAL.

    CALL FUNCTION 'ZARV4_NOM_UPDATES'
      EXPORTING
        is_nomenclature = ls_nomenclature
        create          = abap_true
        delete          = abap_false
        change          = abap_false.

  ENDMETHOD.


  METHOD change_entry.

    zarv4_cl_madagement_database=>set_locks( ).
    DATA ls_transact      TYPE zarv4_d_transact.

    ls_transact = CORRESPONDING  #( ms_transaction_data ).

    SET UPDATE TASK LOCAL.

    CALL FUNCTION 'ZARV4_UPDATES'
      EXPORTING
        is_transact     = ls_transact
        add_transact    = abap_false
        change_transact = abap_true
        delete_transact = abap_false.

  ENDMETHOD.


  METHOD change_nomenclature.

    DATA ls_nomenclature TYPE zarv4_s_nomenclature.

    ls_nomenclature = CORRESPONDING  #( ms_prepared_nomenclature ).

    SET UPDATE TASK LOCAL.

    CALL FUNCTION 'ZARV4_NOM_UPDATES'
      EXPORTING
        is_nomenclature = ls_nomenclature
        create          = abap_false
        delete          = abap_false
        change          = abap_true.

  ENDMETHOD.


  METHOD check_indicator_of_use.

    SELECT SINGLE * "#EC CI_ALL_FIELDS_NEEDED
    FROM zarv4_d_nom
    WHERE zarv4_d_nom~indicator_of_use = @mv_indicator_of_use AND
      zarv4_d_nom~indicator_of_use <> '4'
    INTO @DATA(lv_id).

    IF sy-subrc <> 0.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = mv_indicator_of_use
        IMPORTING
          output = mv_indicator_in_text.

      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid    = zarv4_cx_exceptions=>iofuse_not_found
          iv_field1 = mv_indicator_in_text.
    ENDIF.

  ENDMETHOD.


  METHOD check_nomenclature_item.

    SELECT SINGLE * "#EC CI_ALL_FIELDS_NEEDED
      FROM zarv4_d_nom
      WHERE zarv4_d_nom~nomenclature_id = @mv_nomenctature_id
      INTO @DATA(lv_id).

    IF sy-subrc <> 0.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = mv_nomenctature_id
        IMPORTING
          output = mv_indicator_in_text.

      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid    = zarv4_cx_exceptions=>no_nomenclature_item
          iv_field1 = mv_indicator_in_text.
    ENDIF.

  ENDMETHOD.


  METHOD check_specification_existance.

    SELECT SINGLE * "#EC CI_ALL_FIELDS_NEEDED
     FROM zarv4_d_specific
     WHERE zarv4_d_specific~finished_goods_id = @mv_nomenctature_id
      OR zarv4_d_specific~raw_material_id = @mv_nomenctature_id
     INTO @DATA(lv_id).

    IF sy-subrc = 0.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = mv_nomenctature_id
        IMPORTING
          output = mv_indicator_in_text.

      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid    = zarv4_cx_exceptions=>included_in_specification
          iv_field1 = mv_indicator_in_text.
    ENDIF.

  ENDMETHOD.


  METHOD check_unit_type_id.

    SELECT SINGLE * "#EC CI_ALL_FIELDS_NEEDED
     FROM zarv4_d_u_types
     WHERE zarv4_d_u_types~unit_type_id = @mv_unit_type_id
     INTO @DATA(lv_id).

    IF sy-subrc <> 0.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = mv_unit_type_id
        IMPORTING
          output = mv_indicator_in_text.

      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid    = zarv4_cx_exceptions=>utid_not_found
          iv_field1 = mv_indicator_in_text.
    ENDIF.

  ENDMETHOD.


  METHOD delete_nomenclature.

    DATA ls_nomenclature TYPE zarv4_s_nomenclature.

    ls_nomenclature = CORRESPONDING  #( ms_prepared_nomenclature ).

    SET UPDATE TASK LOCAL.

    CALL FUNCTION 'ZARV4_NOM_UPDATES'
      EXPORTING
        is_nomenclature = ls_nomenclature
        create          = abap_false
        delete          = abap_true
        change          = abap_false.

  ENDMETHOD.


  METHOD get_instance.

    IF mv_dao_instance IS INITIAL.
      mv_connection = NEW #( ).
      mv_dao_instance = mv_connection.
    ELSE.
      mv_connection = mv_dao_instance .
    ENDIF.

  ENDMETHOD.


  METHOD get_nomenclature_for_display.

    SELECT n~nomenclature_id AS id,
      n~article AS art,
      nt~nomenclature_name AS name,
      iou~name_of_type AS iou,
      ut~unit_type_name AS utn
     FROM zarv4_d_nom AS n
     INNER JOIN ZARV4_D_NOM_t AS nt
     ON nt~nomenclature_id = n~nomenclature_id
     INNER JOIN zarv4_d_tofuse AS iou
     ON iou~indicator_of_use = n~indicator_of_use
     INNER JOIN zarv4_d_u_types AS ut
     ON ut~unit_type_id = n~unit_type_id
     WHERE n~nomenclature_id = @mv_nomenctature_id
     AND nt~langu = @sy-langu
     INTO TABLE @DATA(lt_information_for_dicplay)
     UP TO 1 ROWS.

    TRY.
        ms_nom_for_display-nomenclature_id   = lt_information_for_dicplay[ 1 ]-id.
        ms_nom_for_display-article           = lt_information_for_dicplay[ 1 ]-art.
        ms_nom_for_display-nomenclature_name = lt_information_for_dicplay[ 1 ]-name.
        ms_nom_for_display-type_of_use_name  = lt_information_for_dicplay[ 1 ]-iou.
        ms_nom_for_display-unit_type_name    = lt_information_for_dicplay[ 1 ]-utn.
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    SELECT SINGLE * "#EC CI_ALL_FIELDS_NEEDED
   FROM zarv4_d_specific
   WHERE zarv4_d_specific~finished_goods_id = @mv_nomenctature_id
    OR zarv4_d_specific~raw_material_id = @mv_nomenctature_id
   INTO @DATA(lv_id).

    IF sy-subrc = 0.
      ms_nom_for_display-included_in_specifications = 'Yes'.
    ELSE.
      ms_nom_for_display-included_in_specifications = 'No'.
    ENDIF.

  ENDMETHOD.


  METHOD get_nomenclature_information.

    SELECT n~nomenclature_id, n~unit_type_id, n~indicator_of_use, nt~langu, nt~nomenclature_name, n~article "#EC CI_NOORDER
      FROM zarv4_d_nom AS n
      INNER JOIN zarv4_d_nom_t AS nt
      ON n~nomenclature_id = nt~nomenclature_id
      WHERE n~nomenclature_id = @mv_nomenctature_id
        AND nt~langu = @sy-langu
      INTO @DATA(ls_nomenclature_information)
      UP TO 1 ROWS.
    ENDSELECT.

    ms_nomenclature_information = ls_nomenclature_information.

  ENDMETHOD.


  METHOD get_remain.

    SELECT tr~nomenclature_id AS nomenclature_id,
           nt~nomenclature_name AS nomenclature_name,
           nt~langu AS langu,
           SUM( tr~transaction_quantity )  AS nomenclature_quantity,
           SUM( tr~transaction_amount )  AS nomenclature_amount,
           ut~unit_type_name AS unit_type_name
    FROM zarv4_d_transact AS tr
    INNER JOIN zarv4_d_nom AS n
    ON n~nomenclature_id = tr~nomenclature_id
    INNER JOIN zarv4_d_nom_t AS nt
    ON nt~nomenclature_id = n~nomenclature_id
    INNER JOIN zarv4_d_u_types AS ut
    ON ut~unit_type_id = n~unit_type_id
    WHERE tr~transaction_date <= @mv_period_end
    AND tr~nomenclature_id IN @mt_nomenctature_id_range
    AND nt~langu = @sy-langu
    GROUP BY tr~nomenclature_id,
    nt~nomenclature_name,
    nt~langu,
    ut~unit_type_name
    INTO TABLE @mt_list_of_remains.

  ENDMETHOD.


  METHOD get_remain_by_nom_id.

    SELECT SUM( tr~transaction_quantity ) AS quantity
      FROM zarv4_d_transact AS tr
      WHERE tr~nomenclature_id = @mv_nomenctature_id
      AND tr~transaction_date <= @mv_date
      INTO @mv_remaining_quantity
      UP TO 1 ROWS.

  ENDMETHOD.


  METHOD get_specification.

    SELECT zarv4_d_nom_t~nomenclature_id, zarv4_d_nom_t~nomenclature_name
      FROM zarv4_d_nom_t
      WHERE zarv4_d_nom_t~langu = @sy-langu
      INTO TABLE @DATA(lv_nomenclature_name).

    SELECT s~finished_goods_id AS fg_id, nn~nomenclature_name AS fg_n, nt~langu, s~raw_material_id AS rm_id, nt~nomenclature_name AS rm_name,
      s~raw_material_quantity AS rw_q, s~raw_material_amount AS rw_a, u~unit_type_name AS un
      FROM zarv4_d_specific AS s
      INNER JOIN zarv4_d_nom_t AS nt
      ON s~raw_material_id = nt~nomenclature_id
      INNER JOIN @lv_nomenclature_name AS nn
      ON s~finished_goods_id = nn~nomenclature_id
      INNER JOIN zarv4_d_nom AS n
      ON n~nomenclature_id = s~raw_material_id
      INNER JOIN zarv4_d_u_types AS u
      ON u~unit_type_id = n~unit_type_id
      AND nt~langu = @sy-langu
    ORDER BY s~finished_goods_id
    INTO TABLE @mt_specifications.

  ENDMETHOD.


  METHOD get_spec_with_remaining.

    SELECT zarv4_d_nom_t~nomenclature_id, zarv4_d_nom_t~nomenclature_name
      FROM zarv4_d_nom_t
      WHERE zarv4_d_nom_t~nomenclature_id = @mv_nomenctature_id
        AND zarv4_d_nom_t~langu = @sy-langu
      INTO TABLE @DATA(lv_nomenclature_name).

    SELECT s~finished_goods_id AS fg_id, nn~nomenclature_name AS fg_n, nt~langu, s~raw_material_id AS rm_id, nt~nomenclature_name AS rm_name,
      s~raw_material_quantity AS rw_q, s~raw_material_amount AS rw_a, u~unit_type_name AS un, SUM( t~transaction_quantity ) AS tq,
      SUM( t~transaction_amount ) AS ta

      FROM zarv4_d_specific AS s
      INNER JOIN zarv4_d_nom_t AS nt
      ON s~raw_material_id = nt~nomenclature_id
      INNER JOIN @lv_nomenclature_name AS nn
      ON s~finished_goods_id = nn~nomenclature_id
      INNER JOIN zarv4_d_nom AS n
      ON n~nomenclature_id = s~raw_material_id
      INNER JOIN zarv4_d_u_types AS u
      ON u~unit_type_id = n~unit_type_id
      INNER JOIN zarv4_d_transact AS t
      ON t~nomenclature_id = s~raw_material_id

    WHERE s~finished_goods_id = @mv_nomenctature_id
      AND nt~langu = @sy-langu
    GROUP BY s~finished_goods_id, nn~nomenclature_name, nt~langu, s~raw_material_id, nt~nomenclature_name, s~raw_material_quantity,
    s~raw_material_amount, u~unit_type_name
    ORDER BY s~finished_goods_id
    INTO TABLE @mt_specific_with_remaining.

    IF sy-subrc <> 0.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = mv_nomenctature_id
        IMPORTING
          output = mv_indicator_in_text.

      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid    = zarv4_cx_exceptions=>no_specification
          iv_field1 = mv_indicator_in_text.
    ENDIF.

  ENDMETHOD.


  METHOD get_transactions.

    SELECT tr~transaction_date,
      tr~transaction_time,
      tr~nomenclature_id,
      nt~nomenclature_name,
      tr~transaction_quantity,
      tr~transaction_price,
      tr~transaction_amount,
      tr~transaction_description,
      nt~langu,
      tr~transaction_salary_recipient,
      tr~responsible_person,
      tr~record_ID
      FROM zarv4_d_transact AS tr
      INNER JOIN zarv4_d_nom AS n
      ON n~nomenclature_id = tr~nomenclature_id
      INNER JOIN zarv4_d_nom_t AS nt
      ON nt~nomenclature_id = n~nomenclature_id
      INNER JOIN zarv4_d_u_types AS ut
      ON ut~unit_type_id = n~unit_type_id
      WHERE tr~transaction_date IN @mt_period
      AND tr~nomenclature_id IN @mt_nomenctature_range
      AND nt~langu = @sy-langu
      INTO TABLE @mt_list_of_transactions.

  ENDMETHOD.


  METHOD get_type.

    SELECT indicator_of_use
      FROM zarv4_d_nom
      WHERE zarv4_d_nom~nomenclature_id = @mv_nomenctature_id
      INTO  @mv_type_of_use.
    ENDSELECT.

  ENDMETHOD.


  METHOD set_locks.

    CALL FUNCTION 'ENQUEUE_EZARV4_TRANSACT'
      EXPORTING
        mode_zarv4_d_transact = 'X'
        mandt                 = sy-mandt
        _scope                = '2'
      EXCEPTIONS ##FM_SUBRC_OK
        foreign_lock          = 1
        system_failure        = 2
        OTHERS                = 3.

  ENDMETHOD.
ENDCLASS.
