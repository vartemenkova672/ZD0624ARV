*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_CLD
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION FINAL.

  PUBLIC SECTION.

    CONSTANTS get_remain        TYPE char1 VALUE 6 ##NO_TEXT.
    CONSTANTS get_entries       TYPE char1 VALUE 7 ##NO_TEXT.
    CONSTANTS get_specification TYPE char1 VALUE 8 ##NO_TEXT.

    CLASS-METHODS:
      start_of_selection
        IMPORTING
          !mv_entry_type TYPE char1,
      end_of_selection
        IMPORTING
          !mv_entry_type TYPE char1.

    DATA: mo_view_0300              TYPE REF TO lcl_view,
          mo_view_0400              TYPE REF TO lcl_view,
          mo_view_0500              TYPE REF TO lcl_view,
          mt_outtab_remain          TYPE TABLE OF zarv4_s_nom_remain_alv,
          mt_outtab_transactions    TYPE TABLE OF zarv4_s_transact_show_alv,
          mt_outtab_specifications  TYPE TABLE OF zarv4_s_specification_alv,
          mt_outtab_nom_for_display TYPE TABLE OF zarv4_s_nomenclature_0600.

  PRIVATE SECTION.

    METHODS:
      get_data
        IMPORTING
          !mv_entry_type TYPE char1,
      show_data
        IMPORTING
          !mv_entry_type TYPE char1.

ENDCLASS.

CLASS lcl_view DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      pbo_0300,
      pai_0300,
      pbo_0400,
      pai_0400,
      pbo_0500,
      pai_0500.

     METHODS:
      refresh_alv_0400.

  PRIVATE SECTION.

    METHODS:
      prepare_fcat_0300,
      prepare_layout_0300,
      prepare_sort_0300,

      prepare_fcat_0400,
      prepare_layout_0400,
      prepare_sort_0400,

      prepare_fcat_0500.

    CONSTANTS:
      mc_cont_name_0300  TYPE scrfname VALUE 'ALV_CONT_0300',
      mc_cont_name_0400  TYPE scrfname VALUE 'ALV_CONT_0400',
      mc_cont_name_0500  TYPE scrfname VALUE 'ALV_CONT_0500',

      mc_struc_name_0300 TYPE typename VALUE 'ZARV4_S_NOM_REMAIN_ALV',
      mc_struc_name_0400 TYPE typename VALUE 'ZARV4_S_TRANSACT_SHOW_ALV',
      mc_struc_name_0500 TYPE typename VALUE 'ZARV4_S_SPECIFICATION_ALV',

      mc_s_stable        TYPE lvc_s_stbl VALUE 'XX'.

    DATA:mo_container_0300  TYPE REF TO cl_gui_custom_container,
         mo_container_0400  TYPE REF TO cl_gui_custom_container,
         mo_container_0500  TYPE REF TO cl_gui_custom_container,

         mo_grid_0300       TYPE REF TO cl_gui_alv_grid,
         mo_grid_0400       TYPE REF TO cl_gui_alv_grid,
         mo_grid_0500       TYPE REF TO cl_gui_alv_tree,

         mt_fcat_0300       TYPE lvc_t_fcat,
         mt_fcat_0400       TYPE lvc_t_fcat,
         mt_fcat_0500       TYPE lvc_t_fcat,

         ms_layout_0300     TYPE lvc_s_layo,
         ms_layout_0400     TYPE lvc_s_layo,
         ms_layout_0500     TYPE lvc_s_layo,

         mt_excluding_300   TYPE ui_functions,
         mt_excluding_400   TYPE ui_functions,

         ms_variant_0300    TYPE disvariant,
         ms_variant_0400    TYPE disvariant,

         mt_sort_0300       TYPE lvc_t_sort,
         mt_sort_0400       TYPE lvc_t_sort,

         mo_controller_0400 TYPE REF TO lcl_controller,

         gs_header          TYPE treev_hhdr,
         gv_node_key1       TYPE lvc_nkey,
         gv_node_key2       TYPE lvc_nkey,
         gv_node_text       TYPE lvc_value,

         gv_title_0300      TYPE char70,
         gv_title_0400      TYPE char70.

ENDCLASS.

CLASS lcl_controller DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:

      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column,

      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,

      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

       handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      handle_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.

ENDCLASS.
