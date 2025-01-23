CLASS zcl_zarv4_09_class_singleton DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZARV4_09_CLASS_SINGLETON IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA connection TYPE REF TO lcl_connection.

* Debug the method to show that the class always returns the same object
* for the same combination of airline and flight number

    DATA(result) = lcl_connection=>get_connection( airlineid = '01' connectionnumber = '0400' ).
*    connection = lcl_connection=>get_connection( airlineid = '02' connectionnumber = '0400' ).

  ENDMETHOD.
ENDCLASS.
