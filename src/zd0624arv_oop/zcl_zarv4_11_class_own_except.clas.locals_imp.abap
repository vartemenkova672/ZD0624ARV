*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

DATA connection TYPE REF TO lcl_connection.
DATA exception TYPE REF TO lcx_no_connection.

TRY.
    connection = NEW #( i_airlineid = 'XX' i_connectionnumber = '0000' ).
  CATCH lcx_no_connection INTO exception.
    out->write( exception->get_text( ) ).
ENDTRY.
