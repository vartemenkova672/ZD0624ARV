*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_CLD
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      start_of_selection,
      end_of_selection.

    DATA: mo_view   TYPE REF TO lcl_view,
          mt_outtab TYPE TABLE OF zkua3_s_booking_alv. "zkua3_d_booking.

  PRIVATE SECTION.
    METHODS:
      get_data,
      show_data.
ENDCLASS.

CLASS lcl_view DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      pbo_0100,
      pai_0100.

  PRIVATE SECTION.
    METHODS:
      prepare_layout,
      prepare_fcat.

    CONSTANTS:
      mc_cont_name  TYPE scrfname VALUE 'ALV_CONT',
      mc_struc_name TYPE typename VALUE 'ZKUA3_S_BOOKING_ALV',
      mc_s_stable   TYPE lvc_s_stbl VALUE 'XX'.

    DATA:mo_container TYPE REF TO cl_gui_custom_container,
         mo_grid      TYPE REF TO cl_gui_alv_grid.

*    DATA: mt_fcat   TYPE lvc_t_fcat,
*          ms_layout TYPE lvc_s_layo.
*    DATA: mt_excluding TYPE ui_functions.
*    DATA: mt_sort TYPE lvc_t_sort.
*    METHODS: prepare_sort.
*
*    DATA: mt_filter TYPE lvc_t_filt.
*    METHODS: prepare_filter.
*
*    DATA: ms_variant TYPE disvariant.

ENDCLASS.

CLASS lcl_controller DEFINITION FINAL.

ENDCLASS.
