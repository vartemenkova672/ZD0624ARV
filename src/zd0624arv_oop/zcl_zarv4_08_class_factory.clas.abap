CLASS zcl_zarv4_08_class_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZARV4_08_CLASS_FACTORY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA connection TYPE REF TO lcl_connection.

* Debug the method to show that the class returns objects, but that there are different
* objects for the same combination of airline and flight number

    connection = lcl_connection=>get_connection( airlineid = '1' connectionnumber = '0400' ).

    connection = lcl_connection=>get_connection( airlineid = '02' connectionnumber = '0400' ).

  ENDMETHOD.
ENDCLASS.
