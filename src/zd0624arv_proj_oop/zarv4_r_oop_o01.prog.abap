*&---------------------------------------------------------------------*
*& Include          ZARV4_R_OOP_O01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'GR1' AND p_change = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR1'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF screen-group1 = 'GR2' AND p_inf = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR2'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.
