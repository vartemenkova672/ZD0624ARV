CLASS zcl_zarv4_07_class_interface DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZARV4_07_CLASS_INTERFACE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA car_rental TYPE REF TO lcl_car_rental.
    DATA airline TYPE REF TO lcl_airline.
    DATA agency TYPE REF TO lcl_travel_agency.
    DATA partners TYPE TABLE OF REF TO lif_partner.

*    agency = NEW #( ).
*    car_rental = NEW #( iv_name = 'ABAP Autos' iv_contact_person = 'Mr Jones' iv_has_hgv = abap_true ).

*    agency->add_partner( car_rental ).

*    airline = NEW #( iv_name = 'Fly Happy' iv_contact_person = 'Ms Meyer' iv_city = 'Frankfurt' ).
*    agency->add_partner( airline ).

*    LOOP AT agency->get_partners( ) INTO DATA(partner).
*
*      out->write( partner->get_partner_attributes( ) ).
*
*    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
