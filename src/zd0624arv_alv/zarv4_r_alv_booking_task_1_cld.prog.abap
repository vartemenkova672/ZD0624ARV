*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_CLD
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION FINAL.

  PUBLIC SECTION.
    CLASS-METHODS:
      start_of_selection,
      end_of_selection.

    DATA: mo_view   TYPE REF TO lcl_view,
          mt_outtab TYPE TABLE OF zarv4_s_alv_grid_booking. "zkua3_d_booking.

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
      prepare_fcat,
      prepare_layout.

    CONSTANTS:
      mc_cont_name  TYPE scrfname VALUE 'ALV_CONT',
      mc_struc_name TYPE typename VALUE 'ZARV4_S_ALV_GRID_BOOKING',
      mc_s_stable   TYPE lvc_s_stbl VALUE 'XX'.

    DATA:mo_container TYPE REF TO cl_gui_custom_container,
         mo_grid      TYPE REF TO cl_gui_alv_grid,
         mt_fcat      TYPE lvc_t_fcat,
         ms_layout    TYPE lvc_s_layo.


ENDCLASS.

CLASS lcl_controller DEFINITION FINAL.

ENDCLASS.
