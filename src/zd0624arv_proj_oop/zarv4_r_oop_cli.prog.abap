*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_CLI
*&---------------------------------------------------------------------*

CLASS lcl_main IMPLEMENTATION.

  METHOD start_of_selection.

    IF go_main IS NOT BOUND.
      go_main = NEW #( ).
    ENDIF.

    go_main->get_data( mv_entry_type ).

  ENDMETHOD.

  METHOD end_of_selection.
    CHECK go_main IS BOUND.

    IF mv_entry_type = lcl_main=>get_remain
      AND go_main->mt_outtab_remain IS NOT INITIAL.
      go_main->show_data( mv_entry_type ).

    ELSEIF mv_entry_type = lcl_main=>get_entries
    AND go_main->mt_outtab_transactions IS NOT INITIAL.
      go_main->show_data( mv_entry_type ).

    ELSEIF mv_entry_type = lcl_main=>get_specification
    AND go_main->mt_outtab_specifications IS NOT INITIAL.
      go_main->show_data( mv_entry_type ).

    ELSE.
      gv_eror = 'No data' ##NO_TEXT .
      MESSAGE  gv_eror TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.

  METHOD get_data.

    DATA ls_outtab_remain        LIKE LINE OF mt_outtab_remain.
    DATA ls_outtab_transact      LIKE LINE OF mt_outtab_transactions.
    DATA ls_outtab_specification LIKE LINE OF mt_outtab_specifications.

    DATA lt_list_of_remains        TYPE zarv4_t_nomenclature_remain.
    DATA lt_list_of_transactions   TYPE zarv4_t_transact_show.
    DATA lt_list_of_specifications TYPE zarv4_t_specification.

    DATA lv_balance_date TYPE zarv4_transaction_date.

    DATA lv_controller TYPE REF TO zarv4_cl_controller.
    lv_controller = NEW #( ).

    CASE mv_entry_type.

      WHEN lcl_main=>get_remain.
        CLEAR mt_outtab_remain.
        lv_controller->get_information_for_reports(
        EXPORTING
        mt_nomenctature_id = p_inf_id[]
        mv_date_range = p_period[]
        mv_entry_type = lv_controller->get_remain
        CHANGING
          mt_list_of_remains = lt_list_of_remains ).

        IF sy-subrc = 0.
          LOOP AT lt_list_of_remains ASSIGNING FIELD-SYMBOL(<ls_nomenclature_remain>).
            ls_outtab_remain = CORRESPONDING #( <ls_nomenclature_remain> ).
            APPEND ls_outtab_remain TO mt_outtab_remain.
          ENDLOOP.
        ENDIF.

      WHEN lcl_main=>get_entries.
        CLEAR mt_outtab_transactions.

        lv_controller->get_information_for_reports(
        EXPORTING
        mt_nomenctature_id = p_inf_id[]
        mv_date_range = p_period[]
        mv_entry_type = lv_controller->get_entries
        CHANGING
          mt_transact_show = lt_list_of_transactions ).

        IF sy-subrc = 0.
          LOOP AT lt_list_of_transactions ASSIGNING FIELD-SYMBOL(<ls_transaction>).
            ls_outtab_transact = CORRESPONDING #( <ls_transaction> ).
            APPEND ls_outtab_transact TO mt_outtab_transactions.
          ENDLOOP.
        ENDIF.

      WHEN lcl_main=>get_specification.
        CLEAR mt_outtab_specifications.

        lv_controller->get_information_for_reports(
       EXPORTING
       mv_entry_type = lv_controller->get_specification
       CHANGING
         mt_specifications = lt_list_of_specifications ).

        IF sy-subrc = 0.
          LOOP AT lt_list_of_specifications ASSIGNING FIELD-SYMBOL(<ls_specification>).
            ls_outtab_specification = CORRESPONDING #( <ls_specification> ).
            APPEND ls_outtab_specification TO mt_outtab_specifications.
          ENDLOOP.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD show_data.

    CASE mv_entry_type.
      WHEN lcl_main=>get_remain.

        IF mo_view_0300 IS NOT BOUND.
          mo_view_0300 = NEW #( ).
        ENDIF.
        CALL SCREEN 0300.

      WHEN lcl_main=>get_entries.

        IF mo_view_0400 IS NOT BOUND.
          mo_view_0400 = NEW #( ).
        ENDIF.
        CALL SCREEN 0400.

      WHEN lcl_main=>get_specification.

        IF mo_view_0500 IS NOT BOUND.
          mo_view_0500 = NEW #( ).
        ENDIF.
        CALL SCREEN 0500.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_view IMPLEMENTATION.

  METHOD pbo_0300.

    IF mo_grid_0300 IS NOT BOUND.

      CREATE OBJECT mo_container_0300
        EXPORTING
          container_name              = mc_cont_name_0300
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      "Initializing GRID object
      CREATE OBJECT mo_grid_0300
        EXPORTING
          i_parent          = mo_container_0300
        EXCEPTIONS
          error_cntl_create = 1
          error_cntl_init   = 2
          error_cntl_link   = 3
          error_dp_create   = 4
          OTHERS            = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      prepare_fcat_0300( ).
      prepare_sort_0300( ).
      prepare_layout_0300( ).

      APPEND: cl_gui_alv_grid=>mc_fc_info TO mt_excluding_300,
     cl_gui_alv_grid=>mc_fc_print TO mt_excluding_300,
     cl_gui_alv_grid=>mc_fc_detail TO mt_excluding_300.

      ms_variant_0300-report = sy-cprog.
      ms_variant_0300-handle = sy-dynnr.
      ms_variant_0300-username = sy-uname.

*     Display data
      CALL METHOD mo_grid_0300->set_table_for_first_display
        EXPORTING
          is_layout                     = ms_layout_0300
          it_toolbar_excluding          = mt_excluding_300
          i_save                        = 'A'
          is_variant                    = ms_variant_0300
        CHANGING
          it_outtab                     = go_main->mt_outtab_remain
          it_fieldcatalog               = mt_fcat_0300
          it_sort                       = mt_sort_0300
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.

      prepare_layout_0300( ).

      CALL METHOD mo_grid_0300->set_gridtitle( gv_title_0300 ).

      CALL METHOD mo_grid_0300->refresh_table_display
        EXPORTING
          is_stable = mc_s_stable
        EXCEPTIONS
          finished  = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD pai_0300.
    CASE sy-ucomm.
      WHEN gc_ucomm-back OR gc_ucomm-cancel.
        LEAVE TO SCREEN 0.
      WHEN gc_ucomm-exit.
        LEAVE PROGRAM.
    ENDCASE.
  ENDMETHOD.

  METHOD prepare_fcat_0300.
*Generating the field catalog from dictionary structure name
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = mc_struc_name_0300
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = mt_fcat_0300
      EXCEPTIONS ##FM_SUBRC_OK
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    LOOP AT mt_fcat_0300 ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CASE <ls_fcat>-fieldname.
        WHEN 'NOMENCLATURE_ID'.
          <ls_fcat>-key = abap_true.
          <ls_fcat>-scrtext_l = 'Nomenclature ID' ##NO_TEXT .
          <ls_fcat>-scrtext_s = 'ID' ##NO_TEXT.
        WHEN 'LANGU'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'NOMENCLATURE_NAME'.
          <ls_fcat>-scrtext_l = 'Nomenclature name' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Name' ##NO_TEXT.
*          <ls_fcat>-just = 'R'.
        WHEN 'NOMENCLATURE_QUANTITY'.
          <ls_fcat>-scrtext_l = 'Quantity' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Quantity' ##NO_TEXT.
        WHEN 'NOMENCLATURE_AMOUNT'.
          <ls_fcat>-scrtext_l = 'Amount' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Amount' ##NO_TEXT.
        WHEN 'UNIT_TYPE_NAME'.
          <ls_fcat>-scrtext_l = 'Unit type name' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Unit type' ##NO_TEXT.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.                          "prepare_fcat

  METHOD prepare_layout_0300.

    DATA: lv_char_date    TYPE char10,
          lv_char_id      TYPE char100,
          lv_char_id_low  TYPE char10,
          lv_char_id_high TYPE char10,
          lv_text         TYPE char50.

    gv_title_0300 = ''.

    TRY.
        lv_char_date = p_period[ 1 ]-high.

        CONCATENATE lv_char_date+6(2) '.' lv_char_date+4(2) '.' lv_char_date+0(4) INTO lv_char_date.
        lv_text = 'Balance date: ' ##NO_TEXT.
        CONCATENATE lv_text lv_char_date INTO gv_title_0300 SEPARATED BY space.

      CATCH cx_sy_itab_line_not_found.

        CONCATENATE sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) INTO lv_char_date.
        lv_text = 'Balance date: ' ##NO_TEXT.
        CONCATENATE lv_text lv_char_date INTO gv_title_0300 SEPARATED BY space.

    ENDTRY.

    TRY.
        lv_char_id_low  = p_inf_id[ 1 ]-low.
        lv_char_id_high = p_inf_id[ 1 ]-high.
        lv_text = 'ID range:' ##NO_TEXT.
        CONCATENATE lv_text lv_char_id_low '-'  lv_char_id_high INTO lv_char_id SEPARATED BY space.
        CONCATENATE gv_title_0300 lv_char_id  INTO gv_title_0300 SEPARATED BY '         '.

      CATCH cx_sy_itab_line_not_found.
        lv_text = 'ID range: full list ' ##NO_TEXT.
        CONCATENATE gv_title_0300 lv_text INTO gv_title_0300 SEPARATED BY '         '.

    ENDTRY.
    ms_layout_0300-grid_title  = gv_title_0300.
    ms_layout_0300-zebra      = abap_true.
    ms_layout_0300-cwidth_opt = abap_true. "Columns optimization
  ENDMETHOD.

  METHOD prepare_sort_0300.
    mt_sort_0300 = VALUE #(
    ( spos = '1'
    fieldname = 'NOMENCLATURE_ID'
    up = abap_true
    down = abap_false )
    ).
  ENDMETHOD.

  METHOD pbo_0400.

    IF mo_grid_0400 IS NOT BOUND.
      CREATE OBJECT mo_container_0400
        EXPORTING
          container_name              = mc_cont_name_0400
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      "Initializing GRID object
      CREATE OBJECT mo_grid_0400
        EXPORTING
          i_parent          = mo_container_0400
        EXCEPTIONS
          error_cntl_create = 1
          error_cntl_init   = 2
          error_cntl_link   = 3
          error_dp_create   = 4
          OTHERS            = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      prepare_fcat_0400( ).
      prepare_sort_0400( ).
      prepare_layout_0400( ).

      CREATE OBJECT mo_controller_0400.
      SET HANDLER: mo_controller_0400->handle_double_click          FOR mo_grid_0400,
                   mo_controller_0400->handle_toolbar               FOR mo_grid_0400,
                   mo_controller_0400->handle_user_command          FOR mo_grid_0400,
                   mo_controller_0400->handle_data_changed          FOR mo_grid_0400,
                   mo_controller_0400->handle_data_changed_finished FOR mo_grid_0400.

      APPEND: cl_gui_alv_grid=>mc_fc_info TO mt_excluding_400,
            cl_gui_alv_grid=>mc_fc_print TO mt_excluding_400,
            cl_gui_alv_grid=>mc_fc_detail TO mt_excluding_400.

      ms_variant_0400-report = sy-cprog.
      ms_variant_0400-handle = sy-dynnr.
      ms_variant_0400-username = sy-uname.

*     Display data
      CALL METHOD mo_grid_0400->set_table_for_first_display
        EXPORTING
          is_layout                     = ms_layout_0400
          it_toolbar_excluding          = mt_excluding_400
          i_save                        = 'A'
          is_variant                    = ms_variant_0400
        CHANGING
          it_outtab                     = go_main->mt_outtab_transactions
          it_fieldcatalog               = mt_fcat_0400
          it_sort                       = mt_sort_0400
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.

      prepare_layout_0400( ).

      CALL METHOD mo_grid_0400->set_gridtitle( gv_title_0400 ).

      refresh_alv_0400( ).
    ENDIF.
  ENDMETHOD.

  METHOD pai_0400.
    CASE sy-ucomm.
      WHEN gc_ucomm-back OR gc_ucomm-cancel.
        LEAVE TO SCREEN 0.
      WHEN gc_ucomm-exit.
        LEAVE PROGRAM.
    ENDCASE.
  ENDMETHOD.

  METHOD prepare_fcat_0400.
*Generating the field catalog from dictionary structure name
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = mc_struc_name_0400
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = mt_fcat_0400
      EXCEPTIONS ##FM_SUBRC_OK
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    LOOP AT mt_fcat_0400 ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CASE <ls_fcat>-fieldname.
        WHEN 'TRANSACTION_DATE'.
          <ls_fcat>-scrtext_l = 'Transaction date' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Date' ##NO_TEXT.
          <ls_fcat>-no_merging = 'X'.
        WHEN 'LANGU'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'TRANSACTION_TIME'.
          <ls_fcat>-scrtext_l = 'Transaction time' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Time' ##NO_TEXT.
          <ls_fcat>-no_merging = 'X'.
        WHEN 'NOMENCLATURE_ID'.
          <ls_fcat>-scrtext_l = 'Nomenclature ID' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'ID' ##NO_TEXT.
        WHEN 'NOMENCLATURE_NAME'.
          <ls_fcat>-scrtext_l = 'Nomenclature name' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Name' ##NO_TEXT.
        WHEN 'TRANSACTION_QUANTITY'.
          <ls_fcat>-scrtext_l = 'Quantity' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Quantity' ##NO_TEXT.
        WHEN 'TRANSACTION_PRICE'.
          <ls_fcat>-scrtext_l = 'Price per unit' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Price' ##NO_TEXT.
        WHEN 'TRANSACTION_AMOUNT'.
          <ls_fcat>-scrtext_l = 'Amount' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Amount' ##NO_TEXT.
        WHEN 'TRANSACTION_DESCRIPTION'.
          <ls_fcat>-scrtext_l = 'Operation contents' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Contents' ##NO_TEXT.
          <ls_fcat>-edit = abap_true.
        WHEN 'RECORD_ID'.
          <ls_fcat>-tech = abap_true.
        WHEN 'RESPONSIBLE_PERSON'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'TRANSACTION_SALARY_RECIPIENT'.
          <ls_fcat>-no_out = abap_true.

      ENDCASE.
    ENDLOOP.

  ENDMETHOD.                          "prepare_fcat

  METHOD prepare_layout_0400.

    DATA: lv_char_date_start TYPE char10,
          lv_char_date_end   TYPE char10,
          lv_char_date_full  TYPE char10,
          lv_char_id         TYPE char100,
          lv_char_id_low     TYPE char10,
          lv_char_id_high    TYPE char10,
          lv_text            TYPE char50.

    gv_title_0400 = ''.

    TRY.
        lv_char_date_end   = p_period[ 1 ]-high.
        lv_char_date_start = p_period[ 1 ]-low.

        CONCATENATE lv_char_date_end+6(2) '.' lv_char_date_end+4(2) '.' lv_char_date_end+0(4) INTO lv_char_date_end.
        CONCATENATE lv_char_date_start+6(2) '.' lv_char_date_start+4(2) '.' lv_char_date_start+0(4) INTO lv_char_date_start.
        lv_text ='Period:' ##NO_TEXT.
        CONCATENATE lv_text lv_char_date_start '-' lv_char_date_end INTO gv_title_0400 SEPARATED BY space.

      CATCH cx_sy_itab_line_not_found.
        lv_text = 'Period: entire period' ##NO_TEXT.
        CONCATENATE lv_text gv_title_0400 INTO gv_title_0400 SEPARATED BY space.
    ENDTRY.

    TRY.
        lv_char_id_low  = p_inf_id[ 1 ]-low.
        lv_char_id_high = p_inf_id[ 1 ]-high.

        lv_text = 'ID range:' ##NO_TEXT.
        CONCATENATE lv_text lv_char_id_low '-'  lv_char_id_high INTO lv_char_id SEPARATED BY space.
        CONCATENATE gv_title_0400 lv_char_id  INTO gv_title_0400 SEPARATED BY '         '.

      CATCH cx_sy_itab_line_not_found.
        lv_text =  'ID range: full list ' ##NO_TEXT.
        CONCATENATE gv_title_0400 lv_text INTO gv_title_0400 SEPARATED BY '         '.
    ENDTRY.

    ms_layout_0400-grid_title  = gv_title_0400.
    ms_layout_0400-cwidth_opt   = abap_true. "Columns optimization

  ENDMETHOD.

  METHOD prepare_sort_0400.

    mt_sort_0400 = VALUE #(
    ( spos = '1'
    fieldname = 'TRANSACTION_DATE'
    up = abap_true
    down = abap_false )
    ( spos = '2'
    fieldname = 'TRANSACTION_TIME'
    up = abap_true
    down = abap_false )
    ).

  ENDMETHOD.

  METHOD refresh_alv_0400.
    CALL METHOD mo_grid_0400->refresh_table_display
      EXPORTING
        is_stable = mc_s_stable
      EXCEPTIONS
        finished  = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.

  METHOD pbo_0500.

    CREATE OBJECT mo_container_0500
      EXPORTING
        container_name              = mc_cont_name_0500
        repid                       = sy-repid
        dynnr                       = sy-dynnr
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    "Initializing GRID object
    CREATE OBJECT mo_grid_0500
      EXPORTING
        parent                      = mo_container_0500
        node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
        item_selection              = 'X' " Can Individual Items be Selected?
        no_toolbar                  = ' ' " no_toolbar
        no_html_header              = 'X' " no_html_header
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        illegal_node_selection_mode = 5
        failed                      = 6
        illegal_column_name         = 7
        OTHERS                      = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    prepare_fcat_0500( ).

* Prepairing Header
    gs_header-width = 30.

    DATA lt_specification TYPE TABLE OF zarv4_s_specification_alv.
    lt_specification = go_main->mt_outtab_specifications.

    CALL METHOD mo_grid_0500->set_table_for_first_display
      EXPORTING
        i_structure_name    = mc_struc_name_0500
        is_hierarchy_header = gs_header
      CHANGING
        it_fieldcatalog     = mt_fcat_0500
        it_outtab           = go_main->mt_outtab_specifications.

    DATA lv_node_text_ch TYPE text128.
    DATA lv_node_key     TYPE lvc_nkey.

* Prepairing Root node
    LOOP AT lt_specification ASSIGNING FIELD-SYMBOL(<ls_spec>).

      IF gv_node_text <> <ls_spec>-finished_goods_name.
        gv_node_text = <ls_spec>-finished_goods_name.

        CALL METHOD mo_grid_0500->add_node
          EXPORTING
            i_relat_node_key     = ''
            i_relationship       = cl_gui_column_tree=>relat_last_child
            i_node_text          = gv_node_text
          IMPORTING
            e_new_node_key       = lv_node_key " GET the root node key
          EXCEPTIONS
            relat_node_not_found = 1
            node_not_found       = 2
            OTHERS               = 3.
      ENDIF.

* Create Hierarchy ( nodes )
      lv_node_text_ch = <ls_spec>-raw_material_name.

      CALL METHOD mo_grid_0500->add_node
        EXPORTING
          i_relat_node_key     = lv_node_key " pass the root node key
          i_relationship       = cl_gui_column_tree=>relat_last_child " How to INSERT Node
          is_outtab_line       = <ls_spec>    " Attributes of Inserted Node
          i_node_text          = lv_node_text_ch  " Hierarchy Node Text
        IMPORTING
          e_new_node_key       = gv_node_key2 " Key of NEW Node Key
        EXCEPTIONS
          relat_node_not_found = 1
          node_not_found       = 2
          OTHERS               = 3.
    ENDLOOP.

    CALL METHOD mo_grid_0500->frontend_update.

  ENDMETHOD.

  METHOD pai_0500.
    CASE sy-ucomm.
      WHEN gc_ucomm-back OR gc_ucomm-cancel.
        LEAVE TO SCREEN 0.
      WHEN gc_ucomm-exit.
        LEAVE PROGRAM.
    ENDCASE.
  ENDMETHOD.

  METHOD prepare_fcat_0500.
*Generating the field catalog from dictionary structure name
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = mc_struc_name_0500
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = mt_fcat_0500
      EXCEPTIONS ##FM_SUBRC_OK
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    LOOP AT mt_fcat_0500 ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CASE <ls_fcat>-fieldname.
        WHEN 'FINISHED_GOODS_ID'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'LANGU'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'FINISHED_GOODS_NAME'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'RAW_MATERIAL_ID'.
          <ls_fcat>-scrtext_l = 'Raw material ID' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'RM ID' ##NO_TEXT.
        WHEN 'RAW_MATERIAL_NAME'.
          <ls_fcat>-scrtext_l = 'Raw material name' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'RM name' ##NO_TEXT.
        WHEN 'RAW_MATERIAL_QUANTITY'.
          <ls_fcat>-scrtext_l = 'Quantity' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Quantity' ##NO_TEXT.
        WHEN 'RAW_MATERIAL_AMOUNT'.
          <ls_fcat>-scrtext_l = 'Amount' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'Amount' ##NO_TEXT.
        WHEN 'UNIT_TYPE_NAME'.
          <ls_fcat>-scrtext_l = 'Unit type name' ##NO_TEXT.
          <ls_fcat>-scrtext_s = 'UT name' ##NO_TEXT.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.                          "prepare_fcat

ENDCLASS.

CLASS lcl_controller IMPLEMENTATION.

  METHOD handle_double_click.

    DATA: lt_nomenclature_for_display TYPE TABLE OF zarv4_s_nomenclature_0600,
          ls_layout                   TYPE slis_layout_alv,
          ls_nomenclature_for_display TYPE zarv4_s_nomenclature_0600.

* In case of clicking on the total subtotal line
    CHECK e_row-rowtype IS INITIAL.

    READ TABLE go_main->mt_outtab_transactions ASSIGNING FIELD-SYMBOL(<ls_outtab>) INDEX e_row-index. "Index of the row

    IF e_column-fieldname = 'NOMENCLATURE_ID' OR e_column-fieldname = 'NOMENCLATURE_NAME'.

      DATA lv_controller TYPE REF TO zarv4_cl_controller.
      lv_controller = NEW #( ).
      ls_nomenclature_for_display = lv_controller->get_nomenclature_for_display( <ls_outtab>-nomenclature_id ).

      IF ls_nomenclature_for_display IS INITIAL.
        RETURN.
      ENDIF.

      IF sy-subrc = 0.

        APPEND ls_nomenclature_for_display TO lt_nomenclature_for_display.
        ls_layout-colwidth_optimize = abap_true.

        CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
          EXPORTING
            i_structure_name      = 'ZARV4_S_NOMENCLATURE_0600'
            is_layout             = ls_layout
            i_screen_start_column = 5
            i_screen_start_line   = 5
            i_screen_end_column   = 100
            i_screen_end_line     = 9
          TABLES
            t_outtab              = lt_nomenclature_for_display
          EXCEPTIONS ##FM_SUBRC_OK
            program_error         = 1
            OTHERS                = 2.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD handle_toolbar.
* Adding separator
    APPEND VALUE #( butn_type = 3 ) TO e_object->mt_toolbar.

* Adding button
    APPEND VALUE #( function = gc_ucomm_addition-button
    icon = icon_information
    text = TEXT-t20
    quickinfo = TEXT-t20 ) TO e_object->mt_toolbar.

  ENDMETHOD. "handle_toolbar

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN gc_ucomm_addition-button.
        lcl_main=>start_of_selection( lcl_main=>get_specification ).
        lcl_main=>end_of_selection( lcl_main=>get_specification ).

    ENDCASE.
  ENDMETHOD. "handle_user_command

  METHOD handle_data_changed.
    DATA: lv_value        TYPE lvc_value,
          lv_value_new    TYPE lvc_value,
          lv_date         TYPE sy-datum,
          ls_table_line   TYPE zarv4_s_transact_show_alv,
          ls_trans_change TYPE zarv4_s_transact.

    LOOP AT er_data_changed->mt_mod_cells ASSIGNING FIELD-SYMBOL(<ls_mod_cells>).
      CASE <ls_mod_cells>-fieldname.
        WHEN 'TRANSACTION_DESCRIPTION'.
*         Getting booking end date from changed row
          er_data_changed->get_cell_value(
            EXPORTING
              i_row_id    = <ls_mod_cells>-row_id    " Row ID
              i_fieldname = 'TRANSACTION_DESCRIPTION'  " Field Name
            IMPORTING
              e_value     = lv_value " Cell Content
          ).

          ls_table_line = go_main->mt_outtab_transactions[ <ls_mod_cells>-row_id ].

          ls_trans_change-nomenclature_id              = ls_table_line-nomenclature_id.
          ls_trans_change-record_id                    = ls_table_line-record_id.
          ls_trans_change-responsible_person           = ls_table_line-responsible_person.
          ls_trans_change-transaction_date             = ls_table_line-transaction_date.
          ls_trans_change-transaction_time             = ls_table_line-transaction_time.
          ls_trans_change-transaction_quantity         = ls_table_line-transaction_quantity.
          ls_trans_change-transaction_amount           = ls_table_line-transaction_amount.
          ls_trans_change-transaction_salary_recipient = ls_table_line-transaction_salary_recipient.
          ls_trans_change-transaction_price            = ls_table_line-transaction_price.
          ls_trans_change-transaction_description      = lv_value.

          DATA lv_controller TYPE REF TO zarv4_cl_controller.
          lv_controller = NEW #( ).
          lv_controller->change_transaction_data( ls_trans_change ).

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD handle_data_changed_finished.
    IF e_modified = abap_true.
      go_main->mo_view_0400->refresh_alv_0400( ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
