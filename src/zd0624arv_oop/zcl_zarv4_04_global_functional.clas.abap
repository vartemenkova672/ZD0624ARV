class ZCL_ZARV4_04_GLOBAL_FUNCTIONAL definition
  public
  final
  create public .

public section.

  interfaces IF_OO_ADT_CLASSRUN .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZARV4_04_GLOBAL_FUNCTIONAL IMPLEMENTATION.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.

    DATA connection TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

* Create Instance
**********************************************************************

    connection = NEW #(  ).

    connection->set_attributes(
      EXPORTING
        i_carrier_id    = 'LH'
        i_connection_id = '0400'
    ).

    APPEND connection TO connections.


* Calling Functional Method
**********************************************************************
    " in a value assignment (with inline declaration for result)
    DATA(result) = connection->get_output( ).

    " in logical expression
    IF connection->get_output(  ) IS NOT INITIAL.

      " as operand in a statement
      LOOP AT connection->get_output(  ) INTO DATA(line).

      ENDLOOP.

      "  to supply input parameter of another method
      out->write( data = connection->get_output( )
                  name = `  ` ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
