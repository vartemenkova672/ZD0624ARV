*&---------------------------------------------------------------------*
*& Include          ZARV4_R_GET_INFORMATION_O01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1  = 'GR2' AND p_spec = ''.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF  screen-group1  = 'GR3' AND p_rem_n = ''.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF  screen-group1  = 'GR4' AND p_work = ''.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.
