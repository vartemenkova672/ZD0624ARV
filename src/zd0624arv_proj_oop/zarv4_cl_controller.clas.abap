class ZARV4_CL_CONTROLLER definition
  public
  final
  create public .

public section.

  constants WRITE_OFF type CHAR1 value 1 ##NO_TEXT.
  constants BOOK type CHAR1 value 2 ##NO_TEXT.
  constants CREATE type CHAR1 value 3 ##NO_TEXT.
  constants DELETE type CHAR1 value 4 ##NO_TEXT.
  constants CHANGE type CHAR1 value 5 ##NO_TEXT.
  constants GET_REMAIN type CHAR1 value 6 ##NO_TEXT.
  constants GET_ENTRIES type CHAR1 value 7 ##NO_TEXT.
  constants GET_SPECIFICATION type CHAR1 value 8 ##NO_TEXT.
  constants CHANGE_TRANSACTION type CHAR1 value 9 ##NO_TEXT.

  methods CHANGE_MASTER_DATA
    importing
      !MS_CREATION_SCREEN_FIELDS type ZARV4_S_NOMENCLATURE
      !MV_ENTRY_TYPE type CHAR1
    raising
      ZARV4_CX_EXCEPTIONS .
  methods CHECK_CREATION_SCREEN_FIELDS
    importing
      !MS_SECOND_SCREEN_FIELDS type ZARV4_S_NOMENCLATURE
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods CHECK_FILLING_AMOUNT
    importing
      !MV_FIELD_AMOUNT type ZARV4_TRANSACTION_AMOUNT
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods CHECK_FILLING_DATE
    importing
      !MV_FIELD_DATA type ZARV4_TRANSACTION_DATE
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods CHECK_FILLING_ID
    importing
      !MV_FIELD_ID type ZARV4_NOMENCLATURE_ID
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods CHECK_FILLING_QUANTITY
    importing
      !MV_FIELD_QUANTITY type ZARV4_TRANSACTION_QUANTITY
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods CHECK_FILLING_TIME
    importing
      !MV_FIELD_TIME type ZARV4_TRANSACTION_TIME
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods CHECK_SPECIFICATION_EXISTANCE
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(IS_INCLUDED_IN_SPECIFICATION) type BOOLEAN .
  methods GET_INFO_FOR_NOM_CHANGE
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(MS_NOMENCLATURE_INFORMATION) type ZARV4_S_NOMENCLATURE
    raising
      ZARV4_CX_EXCEPTIONS .
  methods MAKE_TRANSACTION
    importing
      !MV_ENTRY_TYPE type CHAR1
      !MS_SCREEN_FIELDS type ZARV4_S_SCREEN_FIELDS
    raising
      resumable(ZARV4_CX_EXCEPTIONS) .
  methods GET_INFORMATION_FOR_REPORTS
    importing
      !MT_NOMENCTATURE_ID type ZARV4_T_NOMENCLATURE_ID optional
      !MV_DATE_RANGE type ZARV4_T_DATE_RANGE optional
      !MV_ENTRY_TYPE type CHAR1
    changing
      !MT_LIST_OF_REMAINS type ZARV4_T_NOMENCLATURE_REMAIN optional
      !MT_TRANSACT_SHOW type ZARV4_T_TRANSACT_SHOW optional
      !MT_SPECIFICATIONS type ZARV4_T_SPECIFICATION optional .
  methods GET_NOMENCLATURE_FOR_DISPLAY
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID
    returning
      value(MS_NOM_FOR_DISPLAY) type ZARV4_S_NOMENCLATURE_0600 .
  methods CHANGE_TRANSACTION_DATA
    importing
      !MS_TRANSACTION_DATA type ZARV4_S_TRANSACT .
  PROTECTED SECTION.
private section.

  data MR_NOMENCLATURE type ref to ZARV4_CL_NOMENCLATURE .

  methods CREATE_NOMENCLATURE_INSTANCE
    importing
      !MV_NOMENCTATURE_ID type ZARV4_NOMENCLATURE_ID .
ENDCLASS.



CLASS ZARV4_CL_CONTROLLER IMPLEMENTATION.


  METHOD check_filling_amount.
    IF NOT mv_field_amount > 0.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>amount_field_empty.
    ENDIF.
  ENDMETHOD.


  METHOD check_filling_date.
    IF mv_field_data  IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>date_field_empty.
    ENDIF.
  ENDMETHOD.


  METHOD check_filling_id.
    IF mv_field_id IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>id_field_empty.
    ENDIF.
  ENDMETHOD.


  METHOD check_filling_quantity.
    IF NOT mv_field_quantity > 0.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>quantity_field_empty.
    ENDIF.
  ENDMETHOD.


  METHOD check_filling_time.
    IF mv_field_time IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>time_field_empty.
    ENDIF.
  ENDMETHOD.


  METHOD create_nomenclature_instance.

    DATA(lv_type) = zarv4_cl_nomenclature=>get_type( mv_nomenctature_id ).

    CASE lv_type.

      WHEN zarv4_cl_nomenclature=>raw_material.
        DATA lv_raw_material TYPE REF TO zarv4_cl_raw_material.
        lv_raw_material = NEW #( ).
        mr_nomenclature = lv_raw_material.

      WHEN zarv4_cl_nomenclature=>inventory.
        DATA lv_inventory TYPE REF TO zarv4_cl_inventory.
        lv_inventory = NEW #( ).
        mr_nomenclature = lv_inventory.

      WHEN zarv4_cl_nomenclature=>finished_goods.
        DATA lv_finished_goods TYPE REF TO zarv4_cl_finished_goods.
        lv_finished_goods = NEW #( ).
        mr_nomenclature = lv_finished_goods.

    ENDCASE.

  ENDMETHOD.


  METHOD change_master_data.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).
    DATA is_nomenclatute_exist TYPE boolean.
    DATA is_included_in_specification TYPE boolean.

    CASE mv_entry_type.
      WHEN zarv4_cl_controller=>create.
        lr_nomenclature->create( ms_creation_screen_fields  ).
      WHEN zarv4_cl_controller=>delete.

        is_nomenclatute_exist = lr_nomenclature->check_nomenclature_existance( ms_creation_screen_fields-nomenclature_id  ).
        IF is_nomenclatute_exist = abap_false.
          RETURN.
        ENDIF.

        is_included_in_specification = lr_nomenclature->check_specification_existance( ms_creation_screen_fields-nomenclature_id ).
        IF is_included_in_specification = abap_true.
          RETURN.
        ENDIF.

        lr_nomenclature->delete( ms_creation_screen_fields-nomenclature_id  ).

        WHEN zarv4_cl_controller=>change.
          lr_nomenclature->change( ms_creation_screen_fields ).

    ENDCASE.

  ENDMETHOD.


  METHOD change_transaction_data.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).
    lr_nomenclature->change_transaction( ms_transaction_data ).

  ENDMETHOD.


  METHOD check_creation_screen_fields.

    IF ms_second_screen_fields-article IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>article_empty.

    ELSEIF ms_second_screen_fields-unit_type_id IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>utid_empty.

    ELSEIF ms_second_screen_fields-indicator_of_use IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>iofuse_empty.

    ELSEIF ms_second_screen_fields-nomenclature_name IS INITIAL.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions
        EXPORTING
          textid = zarv4_cx_exceptions=>nomname_empty.
    ENDIF.

  ENDMETHOD.


  METHOD check_specification_existance.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).

    is_included_in_specification = lr_nomenclature->check_specification_existance( mv_nomenctature_id ).

  ENDMETHOD.


  METHOD get_information_for_reports.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).

    CASE mv_entry_type.

      WHEN get_remain.
        DATA: lv_balance_date TYPE zarv4_transaction_date.
        TRY.
            lv_balance_date = mv_date_range[ 1 ]-high.
          CATCH cx_sy_itab_line_not_found.
            lv_balance_date = sy-datum.
        ENDTRY.

        mt_list_of_remains = lr_nomenclature->get_remain( mt_nomenctature_id_range = mt_nomenctature_id
                                                          mv_period_end = lv_balance_date ).

      WHEN get_entries.

        mt_transact_show = lr_nomenclature->get_entries( mt_nomenctature_id_range = mt_nomenctature_id
                                                        mt_date_range = mv_date_range ).

      WHEN get_specification.

        mt_specifications = lr_nomenclature->get_specification( ).

    ENDCASE.
  ENDMETHOD.


  METHOD get_info_for_nom_change.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).
    DATA is_nomenclatute_exist TYPE boolean.

    is_nomenclatute_exist = lr_nomenclature->check_nomenclature_existance( mv_nomenctature_id ).

    IF is_nomenclatute_exist = abap_true.
      ms_nomenclature_information = lr_nomenclature->get_nomenclature_information( mv_nomenctature_id ).
    ELSE.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_nomenclature_for_display.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).

    ms_nom_for_display = lr_nomenclature->get_nomenclature_for_display( mv_nomenctature_id ).

  ENDMETHOD.


  METHOD make_transaction.

    DATA lr_nomenclature TYPE REF TO zarv4_cl_nomenclature.
    lr_nomenclature = NEW #( ).
    DATA is_nomenclatute_exist TYPE boolean.

    is_nomenclatute_exist = lr_nomenclature->check_nomenclature_existance( ms_screen_fields-field_id ).

    IF is_nomenclatute_exist = abap_false.
      RETURN.
    ENDIF.

    create_nomenclature_instance( ms_screen_fields-field_id ).

    DATA ls_transaction_data TYPE zarv4_s_transact.

    ls_transaction_data-nomenclature_id      = ms_screen_fields-field_id.
    ls_transaction_data-transaction_date     = ms_screen_fields-field_date.
    ls_transaction_data-transaction_time     = ms_screen_fields-field_time.
    ls_transaction_data-transaction_quantity = ms_screen_fields-field_quantity.
    ls_transaction_data-transaction_amount   = ms_screen_fields-field_amount.

    CASE mv_entry_type.
      WHEN zarv4_cl_controller=>book.
        TRY.
            mr_nomenclature->book( ls_transaction_data ).
          CATCH zarv4_cx_exceptions INTO DATA(lr_shortage_remainder).
            DATA(lv_message) = lr_shortage_remainder->if_message~get_longtext( ).
            MESSAGE lv_message TYPE 'S'.
            RETURN.
        ENDTRY.

      WHEN zarv4_cl_controller=>write_off.
        TRY.
            mr_nomenclature->write_off( ls_transaction_data ).
          CATCH zarv4_cx_exceptions INTO DATA(lr_insufficient_stock).
            DATA(lv_message_1) = lr_insufficient_stock->if_message~get_longtext( ).
            MESSAGE lv_message_1 TYPE 'S'.
            RETURN.
        ENDTRY.

      WHEN zarv4_cl_controller=>change_transaction.
        mr_nomenclature->change_transaction( ls_transaction_data ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
