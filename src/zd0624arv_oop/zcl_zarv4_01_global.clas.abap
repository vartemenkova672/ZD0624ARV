CLASS zcl_zarv4_01_global DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZARV4_01_GLOBAL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA connection TYPE ref to lcl_connection.
    connection = NEW #( ).
    connection->carrier_id = 'LH'.
    connection->connection_id = '0400'.
  ENDMETHOD.
ENDCLASS.
