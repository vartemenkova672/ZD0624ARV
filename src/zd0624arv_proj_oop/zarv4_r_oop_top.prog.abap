*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_TOP
*&---------------------------------------------------------------------*

CLASS: lcl_main        DEFINITION DEFERRED,
       lcl_view        DEFINITION DEFERRED,
       lcl_controller  DEFINITION DEFERRED.

CONSTANTS: BEGIN OF gc_ucomm,
             back   TYPE sy-ucomm VALUE 'BACK',
             exit   TYPE sy-ucomm VALUE 'EXIT',
             cancel TYPE sy-ucomm VALUE 'CANCEL',
           END OF gc_ucomm.

CONSTANTS: BEGIN OF gc_ucomm_addition,
             back   TYPE sy-ucomm VALUE 'BACK',
             exit   TYPE sy-ucomm VALUE 'EXIT',
             cancel TYPE sy-ucomm VALUE 'CANCEL',
             button TYPE sy-ucomm VALUE 'BUTTON',
END OF gc_ucomm_addition.

TABLES: zarv4_d_transact,
        zarv4_d_nom,
        zarv4_d_nom_t,
        zarv4_s_transact,
        zarv4_s_nomenclature,
        sscrfields.

DATA: gv_time             TYPE zarv4_d_transact-transaction_time,
      gv_date             TYPE zarv4_d_transact-transaction_date,
      gv_nom_id           TYPE zarv4_d_transact-nomenclature_id,
      gv_quantity         TYPE zarv4_d_transact-transaction_quantity,
      gv_amount           TYPE zarv4_d_transact-transaction_amount,
      gv_nom_name         TYPE zarv4_d_nom_t-nomenclature_name,
      nomenclature_change TYPE abap_boolean VALUE abap_false,
      transaction_change  TYPE abap_boolean VALUE abap_false,
      gs_screen_fields    TYPE zarv4_s_screen_fields,
      gs_nomenclature     TYPE zarv4_s_nomenclature,
      gv_answer           TYPE string,
      gv_eror             TYPE char50,
      go_main             TYPE REF TO lcl_main,
      gv_0100_ucomm       TYPE sy-ucomm.
