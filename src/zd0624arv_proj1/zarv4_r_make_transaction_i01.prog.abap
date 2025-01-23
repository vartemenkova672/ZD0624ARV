*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_I01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'ADD_NOM'.
    CALL TRANSACTION 'ZARV4_NOM_CREATE'.

  ELSEIF sscrfields-ucomm = 'ADD_REC'.
    CALL TRANSACTION 'ZARV4_EMP_CREATE'.
  ENDIF.

  IF sscrfields-ucomm = 'ADD_TR1'.

    PERFORM check_transaction
    USING s_tr_rp
           s_tr_d
           s_tr_t.

    PERFORM check_purchase
    USING s_nom_id
           s_tr_q
           s_tr_am.

    PERFORM fill_transaction_inf
    USING s_tr_rp
           s_tr_d
           s_tr_t
           CHANGING zarv4_s_transact.

    PERFORM add_purchase
    USING s_nom_id
          s_tr_q
          s_tr_am
          CHANGING zarv4_s_transact.

    CLEAR s_nom_id.
    CLEAR s_tr_q.
    CLEAR s_tr_am.

  ENDIF.

  IF sscrfields-ucomm = 'SAVE_DATA1'.
    IF s_nom_id IS NOT INITIAL
      AND s_tr_q IS NOT INITIAL
      AND s_tr_am IS NOT INITIAL.

      PERFORM check_transaction
      USING s_tr_rp
             s_tr_d
             s_tr_t.

      PERFORM fill_transaction_inf
      USING s_tr_rp
            s_tr_d
            s_tr_t
            CHANGING zarv4_s_transact.

      PERFORM add_purchase
      USING s_nom_id
            s_tr_q
            s_tr_am
            CHANGING zarv4_s_transact.

      CLEAR s_nom_id.
      CLEAR s_tr_q.
      CLEAR s_tr_am.
    ENDIF.

    PERFORM set_locks
    USING 1
          0
          zarv4_s_transact.

    COMMIT WORK.
  ENDIF.

  IF sscrfields-ucomm = 'ADD_TR2'.

    PERFORM check_transaction
    USING s_tr_rp
           s_tr_d
           s_tr_t.

    PERFORM check_expense
    USING s_tr_n
          s_tram.

    PERFORM fill_transaction_inf
    USING s_tr_rp
          s_tr_d
          s_tr_t
          CHANGING zarv4_s_transact.

    PERFORM add_expense
    USING s_tr_n
          s_tram
          s_tr_r
          CHANGING zarv4_s_transact.

    CLEAR s_tr_n.
    CLEAR s_tram.
    CLEAR s_tr_r.
  ENDIF.

  IF sscrfields-ucomm = 'SAVE_DATA2'.

    IF s_tr_n IS NOT INITIAL
      AND s_tram IS NOT INITIAL
      AND s_tr_r IS NOT INITIAL.

      PERFORM check_transaction
      USING s_tr_rp
            s_tr_d
            s_tr_t.

      PERFORM fill_transaction_inf
      USING s_tr_rp
            s_tr_d
            s_tr_t
            CHANGING zarv4_s_transact.

      PERFORM add_expense
      USING s_tr_n
            s_tram
            s_tr_r
           CHANGING zarv4_s_transact.

      CLEAR s_tr_n.
      CLEAR s_tram.
      CLEAR s_tr_r.

    ENDIF.

    PERFORM set_locks
    USING 1
          0
          zarv4_s_transact.
    COMMIT WORK.

  ENDIF.

  IF sscrfields-ucomm = 'RELEASE'.

    PERFORM check_transaction
    USING s_tr_rp
           s_tr_d
           s_tr_t.

    PERFORM check_release
    USING s_tr_n1
          s_trq.

    PERFORM fill_transaction_inf
    USING s_tr_rp
          s_tr_d
          s_tr_t
          CHANGING zarv4_s_transact.

    PERFORM add_release
    USING s_tr_n1
          s_trq
          CHANGING zarv4_s_transact.

  ENDIF.

  IF sscrfields-ucomm = 'DELITE'.

    PERFORM  check_deletion
    USING s_tr_id.

    PERFORM select_entry_data
    USING s_tr_id.

    PERFORM set_locks
        USING 3
              s_tr_id
              zarv4_s_transact.

    PERFORM set_update
        USING 3
           s_tr_id.

    CALL SCREEN 0100
    STARTING AT 5 5
    ENDING AT 40 7.
  ENDIF.

  IF sscrfields-ucomm = 'CHANGE'.

    PERFORM  check_deletion
    USING s_tr_id.

    PERFORM select_entry_data
    USING s_tr_id.

    PERFORM set_locks
    USING 2
          s_tr_id
          zarv4_s_transact.

    IF zarv4_s_transact-transaction_quantity < 0
      OR zarv4_s_transact-transaction_amount < 0.
      MESSAGE 'Cost write-off transactions cannot be adjusted.' TYPE 'S'.

      PERFORM remove_locks
      USING
          zarv4_s_transact.
    ELSE.
      CALL SCREEN 0200.
    ENDIF.

  ENDIF.
