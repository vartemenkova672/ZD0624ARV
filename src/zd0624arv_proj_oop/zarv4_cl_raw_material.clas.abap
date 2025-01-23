CLASS zarv4_cl_raw_material DEFINITION
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
        !ms_transaction_data               TYPE zarv4_s_transact
      RETURNING
        VALUE(ms_transaction_data_changed) TYPE zarv4_s_transact .
    METHODS write_off_add
      IMPORTING
        !ms_transaction_data               TYPE zarv4_s_transact
      RETURNING
        VALUE(ms_transaction_data_changed) TYPE zarv4_s_transact .
ENDCLASS.



CLASS ZARV4_CL_RAW_MATERIAL IMPLEMENTATION.


  METHOD book.
    CALL METHOD super->book( book_add( ms_transaction_data ) ).
  ENDMETHOD.


  METHOD book_add.

    ms_transaction_data_changed = ms_transaction_data.

    ms_transaction_data_changed-transaction_description = 'Purchase of raw materials' ##NO_TEXT.
    ms_transaction_data_changed-transaction_price = ms_transaction_data-transaction_amount / ms_transaction_data-transaction_quantity.
  ENDMETHOD.


  METHOD write_off.
    CALL METHOD super->write_off( write_off_add( ms_transaction_data ) ).
  ENDMETHOD.


  METHOD write_off_add.

    ms_transaction_data_changed = ms_transaction_data.

    ms_transaction_data_changed-transaction_description =  'Write-off of raw materials' ##NO_TEXT.
    ms_transaction_data_changed-transaction_price = ms_transaction_data-transaction_amount / ms_transaction_data-transaction_quantity.
  ENDMETHOD.
ENDCLASS.
