CLASS zarv4_cl_finished_goods DEFINITION
  PUBLIC
  INHERITING FROM zarv4_cl_nomenclature
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS book
        REDEFINITION .
    METHODS write_off
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS book_add
      IMPORTING
        !ms_transaction_data TYPE zarv4_s_transact
      RAISING
        zarv4_cx_exceptions .
    METHODS write_off_add
      IMPORTING
        !ms_transaction_data               TYPE zarv4_s_transact
      RETURNING
        VALUE(ms_transaction_data_changed) TYPE zarv4_s_transact .
ENDCLASS.



CLASS ZARV4_CL_FINISHED_GOODS IMPLEMENTATION.


  METHOD book.
    book_add( ms_transaction_data ).
  ENDMETHOD.


  METHOD book_add.

    DATA: lv_DAO                   TYPE REF TO zarv4_cl_madagement_database,
          lv_finished_good         TYPE zarv4_nomenclature_id,
          lv_fg_quantity           TYPE zarv4_transaction_quantity,
          lv_fg_amount             TYPE zarv4_transaction_amount,
          reflect_entries          TYPE abap_boolean VALUE 'X',
          lv_message_text          TYPE char10,
          ls_transaction_data      TYPE zarv4_s_transact,
          lt_spec_with_remaining   TYPE zarv4_t_spec_with_reaining,
          lt_prepared_transactions TYPE zarv4_t_transacts.

    lv_finished_good = ms_transaction_data-nomenclature_id.
    lv_fg_quantity   = ms_transaction_data-transaction_quantity.
    lv_fg_amount     = 0.
    ls_transaction_data = ms_transaction_data.

    lv_DAO = zarv4_cl_madagement_database=>get_instance( ).

    TRY.
        lt_spec_with_remaining = lv_DAO->get_spec_with_remaining( ms_transaction_data-nomenclature_id ).
      CATCH zarv4_cx_exceptions INTO DATA(lr_no_specification).
        DATA(lv_message) = lr_no_specification->if_message~get_longtext( ).
        MESSAGE lv_message TYPE 'S'.
        RETURN.
    ENDTRY.

    LOOP AT lt_spec_with_remaining ASSIGNING FIELD-SYMBOL(<ls_prepared_data>).
      IF <ls_prepared_data>-raw_material_quantity * lv_fg_quantity >  <ls_prepared_data>-remaining_quantity
        OR <ls_prepared_data>-raw_material_amount * lv_fg_quantity >  <ls_prepared_data>-remaining_amount.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <ls_prepared_data>-raw_material_id
          IMPORTING
            output = lv_message_text.

        RAISE EXCEPTION TYPE zarv4_cx_exceptions
          EXPORTING
            textid    = zarv4_cx_exceptions=>shortage_of_remainder
            iv_field1 = lv_message_text.
      ELSE.
        ls_transaction_data-nomenclature_id      = <ls_prepared_data>-raw_material_id.
        ls_transaction_data-transaction_description = 'Write-off of expenses at cost' ##NO_TEXT.

        IF <ls_prepared_data>-raw_material_quantity > 0.
          ls_transaction_data-transaction_quantity = - <ls_prepared_data>-raw_material_quantity * lv_fg_quantity.
          ls_transaction_data-transaction_price    = - ( <ls_prepared_data>-remaining_amount / <ls_prepared_data>-remaining_quantity ).
          ls_transaction_data-transaction_amount   = - ( ms_transaction_data-transaction_quantity * ms_transaction_data-transaction_price ).
        ELSE.
          ls_transaction_data-transaction_price    = 0.
          ls_transaction_data-transaction_quantity = 0.
          ls_transaction_data-transaction_amount   = - ( lv_fg_quantity * <ls_prepared_data>-raw_material_amount ).
        ENDIF.

        lv_fg_amount = lv_fg_amount + ls_transaction_data-transaction_amount.
        INSERT ls_transaction_data INTO TABLE lt_prepared_transactions.
      ENDIF.
    ENDLOOP.

    IF reflect_entries = 'X'.
      ls_transaction_data-nomenclature_id      =   lv_finished_good.
      ls_transaction_data-transaction_quantity =   lv_fg_quantity.
      ls_transaction_data-transaction_amount   = - lv_fg_amount.
      ls_transaction_data-transaction_price    = - lv_fg_amount / lv_fg_quantity.
      ls_transaction_data-transaction_description = 'Release of finished products' ##NO_TEXT.

      INSERT ls_transaction_data INTO TABLE lt_prepared_transactions.
    ENDIF.

    lv_DAO->add_entry( lt_prepared_transactions ).

  ENDMETHOD.


  METHOD write_off.
    CALL METHOD super->write_off( write_off_add( ms_transaction_data ) ).
  ENDMETHOD.


  METHOD write_off_add.

    ms_transaction_data_changed = ms_transaction_data.

    ms_transaction_data_changed-transaction_description =  'Write-off of finished goods' ##NO_TEXT.
    ms_transaction_data_changed-transaction_price = ms_transaction_data-transaction_amount / ms_transaction_data-transaction_quantity.

  ENDMETHOD.
ENDCLASS.
