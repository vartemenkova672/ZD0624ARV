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
      FROM zarv4_d_booking  AS bg
      JOIN zarv4_d_book     AS bk ON bk~book_id = bg~book_id
      JOIN zkua3_d_reader_t AS rr ON rr~person_id = bg~person_id
                                AND rr~langu = @sy-langu
      WHERE bg~booking_id IN @s_bookng
      AND bg~book_id IN @s_book
      AND bg~person_id IN @s_person
      AND bg~booking_status IN @s_status
      INTO TABLE @DATA(lt_booking).
    IF sy-subrc = 0.
      LOOP AT lt_booking ASSIGNING FIELD-SYMBOL(<ls_booking>).
        ls_outtab = CORRESPONDING #( <ls_booking> ).
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

  METHOD pbo_0100.

    IF mo_grid IS NOT BOUND.
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

*     Display data
      CALL METHOD mo_grid->set_table_for_first_display
        EXPORTING
          is_layout                     = ms_layout
        CHANGING
          it_outtab                     = go_main->mt_outtab
          it_fieldcatalog               = mt_fcat
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
  ENDMETHOD.                          "prepare_fcat

  METHOD prepare_layout.
    ms_layout-cwidth_opt = abap_true. "Columns optimization
  ENDMETHOD.

ENDCLASS.

CLASS lcl_controller IMPLEMENTATION.

ENDCLASS.
