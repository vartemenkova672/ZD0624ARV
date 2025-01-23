*&---------------------------------------------------------------------*
*& Report ZARV4_R_UPDATE_SYNCH
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_update_synch.

TABLES: zarv4_s_author,
        zarv4_s_author_t,
        sscrfields.

DATA: gs_author   TYPE zarv4_d_author,
      gs_author_t TYPE zarv4_d_author_t.

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.

MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0200'.
ENDMODULE.

SELECTION-SCREEN BEGIN OF BLOCK bn1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS: p_au_ID TYPE zarv4_d_author-author_id,
              p_lang  TYPE spras,
              p_ch_a  AS CHECKBOX USER-COMMAND p_ch_a,
              p_ch_at AS CHECKBOX USER-COMMAND p_ch_at.

SELECTION-SCREEN END OF BLOCK bn1.

INITIALIZATION.
  p_lang = sy-langu.

START-OF-SELECTION.
  IF p_au_ID IS INITIAL.
    MESSAGE 'Author ID not selected' TYPE 'S'.
    STOP.
  ELSEIF p_ch_a <> 'X' AND p_ch_at <> 'X'.
    MESSAGE 'No table selected for editing' TYPE 'S'.
    STOP.
  ENDIF.

  IF p_ch_a = abap_true
    AND p_ch_at = abap_true.
    PERFORM select_author.
    CALL SCREEN 0100.
    PERFORM select_author_t.
    CALL SCREEN 0200.
  ELSEIF p_ch_a = abap_true.
    PERFORM select_author.
    CALL SCREEN 0100.
  ELSEIF p_ch_at = abap_true.
    PERFORM select_author_t.
    CALL SCREEN 0200.
  ENDIF.

FORM select_author.
  SELECT SINGLE *
    FROM zarv4_d_author
    INTO CORRESPONDING FIELDS OF zarv4_s_author
    WHERE author_id = p_au_ID.
  IF sy-subrc <> 0.
    zarv4_s_author-author_id = p_au_ID.
  ENDIF.
ENDFORM.

FORM select_author_t.
  SELECT SINGLE *
     FROM zarv4_d_author_t
     INTO CORRESPONDING FIELDS OF zarv4_s_author_t
     WHERE author_id = p_au_ID
      AND langu = p_lang.
  IF sy-subrc <> 0.
    zarv4_s_author_t-author_id = p_au_ID.
    zarv4_s_author_t-langu = p_lang.
  ENDIF.
ENDFORM.


MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL'.
      COMMIT WORK AND WAIT.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      COMMIT WORK AND WAIT.
      LEAVE PROGRAM.
    WHEN 'SAVE' .
      CALL FUNCTION 'ENQUEUE_EZARV4_AUTHOR'
        EXPORTING
          mode_zarv4_d_author   = 'X'
          mode_zarv4_d_author_t = 'S'
          mandt                 = sy-mandt
          author_ID             = p_au_ID
          langu                 = sy-langu
          _scope                = '2'
        EXCEPTIONS
          foreign_lock          = 1
          system_failure        = 2
          OTHERS                = 3.

      PERFORM messages_lock.

      gs_author = CORRESPONDING #( zarv4_s_author ).

      CALL FUNCTION 'ZARV4_UPDATE_AUTHOR' IN UPDATE TASK
        EXPORTING
          is_author       = gs_author
          change_author   = abap_true
          change_author_t = abap_false.
      CLEAR gs_author.
  ENDCASE.

ENDMODULE.

MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL'.
      COMMIT WORK AND WAIT.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      COMMIT WORK AND WAIT.
      LEAVE PROGRAM.
    WHEN 'SAVE'.
      CALL FUNCTION 'ENQUEUE_EZARV4_AUTHOR'
        EXPORTING
          mode_zarv4_d_author   = 'S'
          mode_zarv4_d_author_t = 'X'
          mandt                 = sy-mandt
          author_ID             = p_au_ID
          langu                 = p_lang
          _scope                = '2'
        EXCEPTIONS
          foreign_lock          = 1
          system_failure        = 2
          OTHERS                = 3.

      PERFORM messages_lock.

      gs_author_t = CORRESPONDING #( zarv4_s_author_t ).

      CALL FUNCTION 'ZARV4_UPDATE_AUTHOR' IN UPDATE TASK
        EXPORTING
          is_author_t     = gs_author_t
          change_author   = abap_false
          change_author_t = abap_true.
      CLEAR gs_author_t.
  ENDCASE.

ENDMODULE.

FORM messages_lock.
  CASE sy-subrc.
    WHEN 1.
      MESSAGE |Record is already locked by { sy-msgv1 }|  TYPE 'E'.
      STOP.
    WHEN 3.
      MESSAGE 'Error in enqueue operation' TYPE 'E'.
      STOP.
  ENDCASE.
ENDFORM.
