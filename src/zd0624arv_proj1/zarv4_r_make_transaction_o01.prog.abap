*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_O01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'GR1' AND p_pur = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR1'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF screen-group1 = 'GR2' AND p_exp = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR2'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF screen-group1 = 'GR3' AND p_rel = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR3'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF screen-group1 = 'GR4' AND p_cha = 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1  = 'GR4'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.
