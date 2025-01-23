CLASS zarv4_cl_nomenclature DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS raw_material TYPE char1 VALUE 1 ##NO_TEXT.
    CONSTANTS inventory TYPE char1 VALUE 2 ##NO_TEXT.
    CONSTANTS finished_goods TYPE char1 VALUE 3 ##NO_TEXT.

    CLASS-METHODS get_type
      IMPORTING
        !mv_nomenctature_id   TYPE zarv4_nomenclature_id
      RETURNING
        VALUE(mv_type_of_use) TYPE char1 .
    METHODS book
      IMPORTING
        !ms_transaction_data TYPE zarv4_s_transact
      RAISING
        zarv4_cx_exceptions .
    METHODS change
      IMPORTING
        !ms_nomenclature_information TYPE zarv4_s_nomenclature .
    METHODS check_nomenclature_existance
      IMPORTING
        !mv_nomenctature_id          TYPE zarv4_nomenclature_id
      RETURNING
        VALUE(is_nomenclatute_exist) TYPE boolean
      RAISING
        zarv4_cx_exceptions .
    METHODS check_specification_existance
      IMPORTING
        !mv_nomenctature_id                 TYPE zarv4_nomenclature_id
      RETURNING
        VALUE(is_included_in_specification) TYPE boolean .
    METHODS create
      IMPORTING
        !ms_creation_screen_fields TYPE zarv4_s_nomenclature .
    METHODS delete
      IMPORTING
        !mv_nomenctature_id     TYPE zarv4_nomenclature_id
      RETURNING
        VALUE(mv_error_message) TYPE char50 .
    METHODS get_entries
      IMPORTING
        !mt_nomenctature_id_range TYPE zarv4_t_nomenclature_id
        !mt_date_range            TYPE zarv4_t_date_range
      RETURNING
        VALUE(mt_transact_show)   TYPE zarv4_t_transact_show .
    METHODS get_nomenclature_information
      IMPORTING
        !mv_nomenctature_id                TYPE zarv4_nomenclature_id
      RETURNING
        VALUE(ms_nomenclature_information) TYPE zarv4_s_nomenclature .
    METHODS get_remain
      IMPORTING
        !mt_nomenctature_id_range TYPE zarv4_t_nomenclature_id
        !mv_period_end            TYPE zarv4_transaction_date
      RETURNING
        VALUE(mt_list_of_remains) TYPE zarv4_t_nomenclature_remain .
    METHODS get_specification
      RETURNING
        VALUE(mt_specifications) TYPE zarv4_t_specification .
    METHODS write_off
      IMPORTING
        !ms_transaction_data TYPE zarv4_s_transact
      RAISING
        zarv4_cx_exceptions .
    METHODS get_nomenclature_for_display
      IMPORTING
        !mv_nomenctature_id       TYPE zarv4_nomenclature_id
      RETURNING
        VALUE(ms_nom_for_display) TYPE zarv4_s_nomenclature_0600 .
    METHODS change_transaction
      IMPORTING
        !ms_transaction_data TYPE zarv4_s_transact .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA mv_error_message TYPE char50 .
ENDCLASS.



CLASS ZARV4_CL_NOMENCLATURE IMPLEMENTATION.


  METHOD book.

    DATA lt_transacts TYPE zarv4_t_transacts.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    INSERT ms_transaction_data INTO TABLE lt_transacts.

    lv_DAO->add_entry( lt_transacts ).

  ENDMETHOD.


  METHOD create.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    TRY.
        lv_DAO->check_unit_type_id( ms_creation_screen_fields-unit_type_id ).
      CATCH zarv4_cx_exceptions INTO DATA(lr_no_unit_type_id).
        mv_error_message = lr_no_unit_type_id->if_message~get_longtext( ).
        MESSAGE mv_error_message TYPE 'S'.
        EXIT.
    ENDTRY.

    TRY.
        lv_DAO->check_indicator_of_use( ms_creation_screen_fields-indicator_of_use ).
      CATCH zarv4_cx_exceptions INTO DATA(lr_no_indicator_of_use).
        mv_error_message = lr_no_indicator_of_use->if_message~get_longtext( ) .
        MESSAGE mv_error_message TYPE 'S'.
        EXIT.
    ENDTRY.

    lv_DAO->add_nomenclature( ms_creation_screen_fields ).

  ENDMETHOD.


  METHOD delete.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    DATA ls_prepared_nomenclature TYPE zarv4_s_nomenclature.
    ls_prepared_nomenclature-nomenclature_id = mv_nomenctature_id.

    lv_DAO->delete_nomenclature( ls_prepared_nomenclature ).

  ENDMETHOD.


  METHOD get_type.
    mv_type_of_use = zarv4_cl_madagement_database=>get_type( mv_nomenctature_id ).
  ENDMETHOD.


  METHOD write_off.

    DATA lv_remaining_quantity TYPE zarv4_transaction_quantity.
    DATA lt_transacts TYPE zarv4_t_transacts.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    lv_remaining_quantity = lv_DAO->get_remain_by_nom_id( mv_nomenctature_id  = ms_transaction_data-nomenclature_id
                                                          mv_date             = ms_transaction_data-transaction_date ).

    IF lv_remaining_quantity < ms_transaction_data-transaction_quantity.
      RAISE EXCEPTION TYPE zarv4_cx_exceptions ##STMNT_EXIT
        EXPORTING
          textid = zarv4_cx_exceptions=>insufficient_stock.
      RETURN.
    ENDIF.

    DATA ls_transaction_data TYPE zarv4_s_transact.
    ls_transaction_data = ms_transaction_data.

    ls_transaction_data-transaction_quantity = - ms_transaction_data-transaction_quantity .
    ls_transaction_data-transaction_amount   = - ms_transaction_data-transaction_amount.

    INSERT ls_transaction_data INTO TABLE lt_transacts.
    lv_DAO->add_entry( lt_transacts ).

  ENDMETHOD.


  METHOD change.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    TRY.
        lv_DAO->check_unit_type_id( ms_nomenclature_information-unit_type_id ).
      CATCH zarv4_cx_exceptions INTO DATA(lr_no_unit_type_id).
        mv_error_message = lr_no_unit_type_id->if_message~get_longtext( ).
        MESSAGE mv_error_message TYPE 'S'.
        EXIT.
    ENDTRY.

    TRY.
        lv_DAO->check_indicator_of_use( ms_nomenclature_information-indicator_of_use ).
      CATCH zarv4_cx_exceptions INTO DATA(lr_no_indicator_of_use).
        mv_error_message = lr_no_indicator_of_use->if_message~get_longtext( ) .
        MESSAGE mv_error_message TYPE 'S'.
        EXIT.
    ENDTRY.

    lv_DAO->change_nomenclature( ms_nomenclature_information ).

  ENDMETHOD.


  METHOD check_nomenclature_existance.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    TRY.
        lv_DAO->check_nomenclature_item( mv_nomenctature_id ).
        is_nomenclatute_exist = abap_true.
      CATCH zarv4_cx_exceptions INTO DATA(lr_no_nomenclature_id).
        mv_error_message = lr_no_nomenclature_id->if_message~get_longtext( ) .
        MESSAGE mv_error_message TYPE 'S'.
        is_nomenclatute_exist = abap_false.
    ENDTRY.

  ENDMETHOD.


  METHOD check_specification_existance.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    TRY.
        lv_DAO->check_specification_existance( mv_nomenctature_id ).
        is_included_in_specification = abap_false.
      CATCH zarv4_cx_exceptions INTO DATA(lr_include_in_specification).
        mv_error_message = lr_include_in_specification->if_message~get_longtext( ) .
        MESSAGE mv_error_message TYPE 'S'.
        is_included_in_specification = abap_true.
    ENDTRY.

  ENDMETHOD.


  METHOD get_entries.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    mt_transact_show = lv_DAO->get_transactions( mt_period = mt_date_range
                                                  mt_nomenctature_range = mt_nomenctature_id_range ).

  ENDMETHOD.


  METHOD get_nomenclature_information.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    ms_nomenclature_information  = lv_DAO->get_nomenclature_information( mv_nomenctature_id ).

  ENDMETHOD.


  METHOD get_remain.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    mt_list_of_remains = lv_DAO->get_remain( mt_nomenctature_id_range = mt_nomenctature_id_range
                                             mv_period_end =  mv_period_end ).

  ENDMETHOD.


  METHOD get_specification.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    mt_specifications = lv_DAO->get_specification( ).

  ENDMETHOD.


  METHOD change_transaction.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    lv_DAO->change_entry( ms_transaction_data ).

  ENDMETHOD.


  METHOD get_nomenclature_for_display.

    DATA lv_DAO TYPE REF TO zarv4_cl_madagement_database.
    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    ms_nom_for_display  = lv_DAO->get_nomenclature_for_display( mv_nomenctature_id ).

  ENDMETHOD.
ENDCLASS.
