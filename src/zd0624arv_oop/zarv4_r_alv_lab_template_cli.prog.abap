*&---------------------------------------------------------------------*
*& Include          ZTSM_R_ALV_LAB_TEMPLATE_CLI
*&---------------------------------------------------------------------*
CLASS lcl_main IMPLEMENTATION.
  METHOD start_of_selection.

    IF go_main IS NOT BOUND.
      go_main = NEW #( ).
    ENDIF.

    go_main->get_data( ).
  ENDMETHOD.

  METHOD end_of_selection.
    CHECK go_main IS BOUND.

    IF go_main->mt_outtab IS NOT INITIAL.
      go_main->show_data( ).
    ELSE.
      MESSAGE 'No data' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.

  METHOD get_data.
    DATA: ls_outtab LIKE LINE OF mt_outtab.

    CLEAR mt_outtab.

    SELECT bg~booking_id,
           bg~book_id,
           bk~book_name,
           bg~person_id,
           rr~person_first_name,
           rr~person_last_name,
           bg~booking_status,
           bg~booking_beg_date,
           bg~booking_beg_time,
           bg~booking_end_date,
           bg~booking_end_time
      FROM zkua3_d_booking  AS bg
      JOIN zkua3_d_book     AS bk ON bk~book_id = bg~book_id
      JOIN zkua3_d_reader_t AS rr ON rr~person_id = bg~person_id
                                AND rr~langu = @sy-langu
      INTO TABLE @DATA(lt_booking).
    IF sy-subrc = 0.
      LOOP AT lt_booking ASSIGNING FIELD-SYMBOL(<ls_booking>).
        ls_outtab = CORRESPONDING #( <ls_booking> ).

        IF ls_outtab-booking_end_date < sy-datum.
          ls_outtab-row_color = 'C300'.
        ELSE.
          ls_outtab-row_color = 'C500'.
        ENDIF.

        CASE ls_outtab-booking_status.
          WHEN 1.
            APPEND VALUE lvc_s_scol( fname = 'BOOKING_STATUS' color-col = 5 ) TO ls_outtab-color_tab.
          WHEN 2.
            APPEND VALUE lvc_s_scol( fname = 'BOOKING_STATUS' color-col = 3 ) TO ls_outtab-color_tab.
          WHEN 3.
            APPEND VALUE lvc_s_scol( fname = 'BOOKING_STATUS' color-col = 6 ) TO ls_outtab-color_tab.
          WHEN 4.
            APPEND VALUE lvc_s_scol( fname = 'BOOKING_STATUS' color-col = 7 ) TO ls_outtab-color_tab.
          WHEN 5.
            APPEND VALUE lvc_s_scol( fname = 'BOOKING_STATUS' color-col = 2 color-int = 1 ) TO ls_outtab-color_tab.
        ENDCASE.

        APPEND ls_outtab TO mt_outtab.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD show_data.
    IF mo_view IS NOT BOUND.
      mo_view = NEW #( ).
    ENDIF.
    CALL SCREEN 0100.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_view IMPLEMENTATION.
  METHOD prepare_fcat.
*Generating the field catalog from dictionary structure name
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = mc_struc_name
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = mt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    LOOP AT mt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CASE <ls_fcat>-fieldname.
        WHEN 'BOOKING_ID'.
          <ls_fcat>-key = abap_true.
        WHEN 'BOOK_NAME'.
          <ls_fcat>-just = 'R'.
        WHEN 'BOOKING_BEG_TIME' OR 'BOOKING_END_TIME'.
          <ls_fcat>-tech = abap_true.
        WHEN 'PERSON_ID'.
          <ls_fcat>-no_out = abap_true.
        WHEN 'BOOK_ID'.
          <ls_fcat>-scrtext_m = 'BOOK_NUMBER'.
          <ls_fcat>-scrtext_l = 'BOOK_NUMBER'.
          <ls_fcat>-scrtext_s = 'BOOK_NUMBER'.
        WHEN 'BOOKING_BEG_DATE'.
          <ls_fcat>-scrtext_s = 'Start Date'.
*        WHEN 'PERSON_FIRST_NAME' OR 'PERSON_LAST_NAME'.
*          <ls_fcat>-hotspot = abap_true.

        WHEN 'PERSON_FIRST_NAME'.
          <ls_fcat>-emphasize = 'C300'.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.                          "prepare_fcat

  METHOD prepare_layout.
    ms_layout-cwidth_opt = abap_true. "Columns optimization
    ms_layout-zebra = abap_true.
    ms_layout-sel_mode = 'A'.
    ms_layout-grid_title = 'DA BOOKINS!'.

    ms_layout-info_fname = 'ROW_COLOR'.

    ms_layout-ctab_fname = 'COLOR_TAB'.
  ENDMETHOD.
  METHOD prepare_sort.
    mt_sort = VALUE #(
*    ( spos = '1'
*    fieldname = 'PERSON_FIRST_NAME'
*    up = abap_true
*    down = abap_false )
*    ( spos = '2'
*    fieldname = 'PERSON_LAST_NAME'
*    up = abap_true
*    down = abap_false )
    ( spos = '1'
    fieldname = 'BOOK_NAME'
    up = abap_true
    down = abap_false )
    ).
  ENDMETHOD.
  METHOD prepare_filter.
    mt_filter = VALUE #( ( fieldname = 'BOOKING_STATUS'
    sign = 'I'
    option = 'BT'
    low = '2'
    high = '4' ) ).
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
    IF mo_grid IS NOT BOUND.
*     Initializing container
      CREATE OBJECT mo_container
        EXPORTING
          container_name              = mc_cont_name
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
      CREATE OBJECT mo_grid
        EXPORTING
          i_parent          = mo_container
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
*     Generate fieldcatalog
      prepare_fcat( ).

*     Prepare layout structure
      prepare_layout( ).
      prepare_sort( ).
      prepare_filter( ).
      APPEND: cl_gui_alv_grid=>mc_fc_info TO mt_excluding,
      cl_gui_alv_grid=>mc_fc_print TO mt_excluding,
      cl_gui_alv_grid=>mc_fc_detail TO mt_excluding.

      ms_variant-report = sy-cprog.
      ms_variant-handle = sy-dynnr.
      ms_variant-username = sy-uname.


*     Display data
      CALL METHOD mo_grid->set_table_for_first_display
        EXPORTING
          is_layout                     = ms_layout
          it_toolbar_excluding          = mt_excluding
          is_variant                    = ms_variant
          i_save                        = 'A'
        CHANGING
          it_outtab                     = go_main->mt_outtab
          it_fieldcatalog               = mt_fcat
          it_sort                       = mt_sort
          it_filter                     = mt_filter
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
      CALL METHOD mo_grid->refresh_table_display
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
  METHOD pai_0100.
    CASE gv_0100_ucomm.
      WHEN gc_ucomm-back OR gc_ucomm-cancel.
        LEAVE TO SCREEN 0.
      WHEN gc_ucomm-exit.
        LEAVE PROGRAM.
    ENDCASE.
  ENDMETHOD.
                                                            "pai_0100


ENDCLASS.

CLASS lcl_controller IMPLEMENTATION.

ENDCLASS.
