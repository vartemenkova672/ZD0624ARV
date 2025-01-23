*&---------------------------------------------------------------------*
*& Report ZDARV4_INVOICE_ITEMS_EURO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdarv4_invoice_items_euro.

CLASS lcl_main DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_main.

    METHODS run.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT r_result.
  ENDMETHOD.

  METHOD run.
    DATA(invoices) = NEW ZDARV4_invoice_retrieval( ).
    DATA(invoice_items) = invoices->get_items_from_db( ).

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   =     DATA(alv_table)
       CHANGING
         t_table        = invoice_items ).

    alv_table->display(  ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_main=>create( )->run( ).
