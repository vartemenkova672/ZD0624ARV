class ZCL_ZARV4_03_GLOBAL_EXCEPTION definition
  public
  final
  create public .

public section.

  interfaces IF_OO_ADT_CLASSRUN .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZARV4_03_GLOBAL_EXCEPTION IMPLEMENTATION.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.

    CONSTANTS c_carrier_id TYPE char2 VALUE 'LH'.
    CONSTANTS c_connection_id TYPE numc4 VALUE '0400'.

    DATA connection TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

* Create Instance
**********************************************************************

    connection = NEW #(  ).

*  Call Method and Handle Exception
**********************************************************************
    out->write(  |i_carrier_id    = '{ c_carrier_id }' | ).
    out->write(  |i_connection_id = '{ c_connection_id }'| ).

    TRY.
        connection->set_attributes(
          EXPORTING
            i_carrier_id    = c_carrier_id
            i_connection_id = c_connection_id
        ).

        APPEND connection TO connections.
        out->write( `Method call successful` ).
      CATCH cx_abap_invalid_value.
        out->write( `Method call failed`     ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
