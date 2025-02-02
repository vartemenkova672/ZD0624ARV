*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_TOP
*&---------------------------------------------------------------------*

CLASS: lcl_main        DEFINITION DEFERRED,
       lcl_view        DEFINITION DEFERRED,
       lcl_controller  DEFINITION DEFERRED.

CONSTANTS: BEGIN OF gc_ucomm,
             back   TYPE sy-ucomm VALUE 'BACK',
             exit   TYPE sy-ucomm VALUE 'EXIT',
             cancel TYPE sy-ucomm VALUE 'CANCEL',
           END OF gc_ucomm.

DATA: go_main       TYPE REF TO lcl_main,
      gv_0100_ucomm TYPE sy-ucomm.
