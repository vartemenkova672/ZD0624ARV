*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Changing data
*&---------------------------------------------------------------------*

FORM fill_transaction_inf
  USING lv_responsible_person LIKE gv_resp_p
        lv_transaction_date   LIKE gv_date
        lv_transaction_time   LIKE gv_time
        CHANGING ls_transact  LIKE zarv4_s_transact.

  ls_transact-mandt              = sy-mandt.
  ls_transact-responsible_person = lv_responsible_person.
  ls_transact-transaction_date   = lv_transaction_date.
  ls_transact-transaction_time   = lv_transaction_time.

ENDFORM.

FORM add_purchase
  USING lv_nomenclature_id      LIKE gv_nom_id
        lv_transaction_quantity LIKE gv_quantity
        lv_transaction_amount   LIKE gv_amount
        CHANGING ls_transact    LIKE zarv4_s_transact.

  ls_transact-nomenclature_id      = lv_nomenclature_id .
  ls_transact-transaction_quantity = lv_transaction_quantity.
  ls_transact-transaction_amount   = lv_transaction_amount.
  ls_transact-transaction_price    = lv_transaction_amount / lv_transaction_quantity.

  PERFORM set_update
  USING 1 0.

ENDFORM.

FORM add_expense
  USING lv_nomenclature_id    LIKE gv_nom_id
        lv_transaction_amount LIKE gv_amount
        lv_salary_recipient   LIKE gv_salary_res
        CHANGING ls_transact  LIKE zarv4_s_transact.

  ls_transact-nomenclature_id              = lv_nomenclature_id.
  ls_transact-transaction_quantity         = 0.
  ls_transact-transaction_price            = 0.
  ls_transact-transaction_amount           = lv_transaction_amount.
  ls_transact-transaction_salary_recipient = lv_salary_recipient.

  PERFORM set_update
  USING 1 0.

ENDFORM.

FORM add_release
  USING lv_nomenclature_id       LIKE gv_nom_id
        lv_transaction_quantity  LIKE gv_quantity
        CHANGING ls_transact     LIKE zarv4_s_transact.

  DATA: lv_cost              TYPE p LENGTH 16 DECIMALS 2,
        lv_price             TYPE p LENGTH 16 DECIMALS 2,
        lv_nomenclature_name LIKE gv_nom_name,
        lt_specification     LIKE gt_specific,
        lt_prepared_data     LIKE gt_prepared_data.

  PERFORM select_information_release
  USING lv_nomenclature_id
        CHANGING lt_specification
                 lv_nomenclature_name
                 lt_prepared_data.

  PERFORM fill_write_off_materials
  USING lt_prepared_data
        lv_transaction_quantity
        CHANGING ls_transact
                 lv_cost
                 lv_price.

  PERFORM fill_product_acceptance
  USING lt_prepared_data
        lv_transaction_quantity
        lv_nomenclature_id
        CHANGING ls_transact
                 lv_cost
                 lv_price.
  PERFORM set_locks
    USING 1
          0
          zarv4_s_transact.

  COMMIT WORK.

ENDFORM.

FORM fill_write_off_materials
  USING lt_prepared_data        LIKE gt_prepared_data
        lv_transaction_quantity LIKE gv_quantity
        CHANGING ls_transact    LIKE zarv4_s_transact
                 lv_cost
                 lv_price.

  DATA: lv_text(50).

  LOOP AT lt_prepared_data ASSIGNING FIELD-SYMBOL(<ls_prepared_data>).
    IF <ls_prepared_data>-iu <> '4' AND <ls_prepared_data>-tq < <ls_prepared_data>-sq.

      CONCATENATE : 'Not enough material with ID ' <ls_prepared_data>-nid INTO lv_text.
      MESSAGE lv_text  TYPE 'S'.
      STOP.
    ELSEIF <ls_prepared_data>-iu = '4' AND <ls_prepared_data>-ta < <ls_prepared_data>-sa.

      CONCATENATE : 'Not enough accrued expenses amount. Check ID  ' <ls_prepared_data>-nid INTO lv_text.
      MESSAGE lv_text  TYPE 'S'.
      STOP.
    ENDIF.

    ls_transact-nomenclature_id      = <ls_prepared_data>-nid.

    IF <ls_prepared_data>-iu <> '4' AND <ls_prepared_data>-sq <> 0.
      ls_transact-transaction_quantity = - <ls_prepared_data>-sq * lv_transaction_quantity.
      ls_transact-transaction_price    = - <ls_prepared_data>-ta / <ls_prepared_data>-tq.
      ls_transact-transaction_amount   = ls_transact-transaction_price * <ls_prepared_data>-sq * lv_transaction_quantity.
    ELSEIF <ls_prepared_data>-iu = '4' AND <ls_prepared_data>-sa <> 0.
      ls_transact-transaction_quantity         = 0.
      ls_transact-transaction_price            = 0.
      ls_transact-transaction_amount           = - <ls_prepared_data>-sa * lv_transaction_quantity.
    ENDIF.

    lv_cost = lv_cost + ls_transact-transaction_amount.

    PERFORM set_update
    USING 1 0.

  ENDLOOP.

ENDFORM.

FORM fill_product_acceptance
  USING lt_prepared_data        LIKE gt_prepared_data
        lv_transaction_quantity LIKE gv_quantity
        lv_nomenclature_id       LIKE gv_nom_id
        CHANGING ls_transact LIKE zarv4_s_transact
                 lv_cost
                 lv_price.

  lv_cost  = - lv_cost.
  lv_price =  lv_cost / lv_transaction_quantity.

  ls_transact-nomenclature_id = lv_nomenclature_id.
  ls_transact-transaction_quantity = lv_transaction_quantity.
  ls_transact-transaction_price  = lv_price.
  ls_transact-transaction_amount = lv_cost.

  PERFORM set_update
  USING 1 0.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Set updates
*&---------------------------------------------------------------------*

FORM set_update
  USING lv_sign        LIKE gv_sign
        lv_transact_id LIKE gv_transact_id.

  gs_transact = CORRESPONDING  #( zarv4_s_transact ).
  SET UPDATE TASK LOCAL.

  IF lv_sign = 1.

    CALL FUNCTION 'ZARV4_UPDATES' IN UPDATE TASK
      EXPORTING
        is_transact     = gs_transact
        add_transact    = abap_true
        change_transact = abap_false
        delete_transact = abap_false.

  ELSEIF lv_sign = 2.

    CALL FUNCTION 'ZARV4_UPDATES' IN UPDATE TASK
      EXPORTING
        is_transact     = gs_transact
        add_transact    = abap_false
        change_transact = abap_true
        delete_transact = abap_false.

  ELSEIF lv_sign = 3.

    CALL FUNCTION 'ZARV4_UPDATES' IN UPDATE TASK
      EXPORTING
        is_transact     = gs_transact
        add_transact    = abap_false
        change_transact = abap_false
        delete_transact = abap_true
        id_number       = lv_transact_id.
  ENDIF.

  CLEAR gs_transact.

ENDFORM.

*&---------------------------------------------------------------------*
*& Locks
*&---------------------------------------------------------------------*
FORM set_locks
  USING lv_sign        LIKE gv_sign
        lv_transact_id LIKE gv_transact_id
        ls_transact    TYPE zarv4_s_transact.

  CASE lv_sign.

    WHEN 1.
      CALL FUNCTION 'ENQUEUE_EZARV4_TRANSACT'
        EXPORTING
          mode_zarv4_d_transact = 'X'
          mandt                 = sy-mandt
          _scope                = '2'
        EXCEPTIONS
          foreign_lock          = 1
          system_failure        = 2
          OTHERS                = 3.

    WHEN 2.
      CALL FUNCTION 'ENQUEUE_EZARV4_TRANSACT'
        EXPORTING
          mode_zarv4_d_transact = 'X'
          mandt                 = sy-mandt
          record_id             = ls_transact-record_id
          _scope                = '2'
        EXCEPTIONS
          foreign_lock          = 1
          system_failure        = 2
          OTHERS                = 3.

    WHEN 3.
      CALL FUNCTION 'ENQUEUE_EZARV4_TRANSACT'
        EXPORTING
          mode_zarv4_d_transact = 'X'
          mandt                 = sy-mandt
          record_id             = lv_transact_id
          _scope                = '2'
        EXCEPTIONS
          foreign_lock          = 1
          system_failure        = 2
          OTHERS                = 3.

  ENDCASE.

  PERFORM messages_lock.


ENDFORM.

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

FORM remove_locks
  USING ls_transact TYPE zarv4_s_transact.

  CALL FUNCTION 'DEQUEUE_EZARV4_TRANSACT'
    EXPORTING
      mode_zarv4_d_transact = 'X'
      mandt                 = sy-mandt
      record_id             = ls_transact-record_id
      _scope                = '3'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Check the fields are filled in
*&---------------------------------------------------------------------*

FORM check_transaction
    USING lv_ch_responsible_person LIKE gv_resp_p
          lv_ch_transaction_date   LIKE gv_date
          lv_ch_transaction_time   LIKE gv_time.

  IF lv_ch_responsible_person IS INITIAL.
    MESSAGE 'Responsible person is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_ch_transaction_date IS INITIAL.
    MESSAGE 'Transaction date is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_ch_transaction_time IS INITIAL.
    MESSAGE 'Transaction time is not specified' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM check_purchase
    USING lv_ch_nomenclature_id      LIKE gv_nom_id
          lv_ch_transaction_quantity LIKE gv_quantity
          lv_ch_transaction_amount   LIKE gv_amount.

  IF lv_ch_nomenclature_id IS INITIAL.
    MESSAGE 'Item ID is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_ch_transaction_quantity IS INITIAL.
    MESSAGE 'Transaction quantity is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_ch_transaction_amount IS INITIAL.
    MESSAGE 'Transaction amount is not specified' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM check_expense
    USING lv_ch_nomenclature_id    LIKE gv_nom_id
          lv_ch_transaction_amount LIKE gv_amount.

  IF lv_ch_nomenclature_id IS INITIAL.
    MESSAGE 'Item ID is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_ch_transaction_amount IS INITIAL.
    MESSAGE 'Transaction amount is not specified' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM check_release
    USING lv_ch_nomenclature_id      LIKE gv_nom_id
          lv_ch_transaction_quantity LIKE gv_quantity.

  IF lv_ch_nomenclature_id IS INITIAL.
    MESSAGE 'Item ID is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_ch_transaction_quantity IS INITIAL.
    MESSAGE 'Transaction quantity is not specified' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM check_deletion
  USING lv_ch_record_ID LIKE gv_transact_id.

  IF lv_ch_record_ID IS INITIAL.
    MESSAGE 'Item ID is not specified' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM check_type_0200
     USING lv_transact        TYPE zarv4_s_transact
           CHANGING  lv_leave TYPE abap_boolean.

  SELECT SINGLE zarv4_d_nom~indicator_of_use AS us
    FROM zarv4_d_nom
    WHERE zarv4_d_nom~nomenclature_id = @lv_transact-nomenclature_id
    INTO @DATA(lv_indicator).

  IF lv_indicator = '4' AND lv_transact-transaction_quantity <> 0.

    MESSAGE 'For items with the type Expenses, accounting by quantity and price is not provided.' TYPE 'S'.
    lv_leave = 'X'.
  ELSEIF lv_indicator <> '4' AND lv_transact-transaction_salary_recipient <> ''.
    MESSAGE 'For items with the types Raw-material, Inventory and Finished goods the payment recipient is not indicated.' TYPE 'S'.
    lv_leave = 'X'.
  ELSEIF lv_indicator <> '4' AND lv_transact-transaction_quantity = 0.
    MESSAGE 'For items with the types Raw-material, Inventory and Finished goods accounting by quantity is mandatory.' TYPE 'S'.
    lv_leave = 'X'.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Selection
*&---------------------------------------------------------------------*

FORM select_entry_data
  USING lv_record_ID LIKE gv_transact_id.

  SELECT *
    FROM zarv4_d_transact
    INTO CORRESPONDING FIELDS OF zarv4_s_transact
    WHERE zarv4_d_transact~record_id = lv_record_ID.
  ENDSELECT.

  IF sy-subrc <> 0.
    zarv4_s_transact-record_id = lv_record_ID.
    MESSAGE 'Record not found' TYPE 'S'.
    STOP.
  ENDIF.

  IF zarv4_s_transact IS INITIAL.
    MESSAGE 'Record not found' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM  select_information_release
  USING lv_nomenclature_id LIKE gv_nom_id
        CHANGING lt_specification     LIKE gt_specific
                 lv_nomenclature_name LIKE gv_nom_name
                 lt_prepared_data     LIKE gt_prepared_data.

  CALL FUNCTION 'ZARV4_SELECT_SPECIFIC'
    EXPORTING
      lv_nomenclature_id = lv_nomenclature_id
    IMPORTING
      lt_specification   = lt_specification
    EXCEPTIONS
      no_data            = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE 'There is no specification for the product.' TYPE 'S'.
    STOP.
  ENDIF.

  SELECT SINGLE zarv4_d_nom_t~nomenclature_name
  FROM zarv4_d_nom_t
  WHERE zarv4_d_nom_t~nomenclature_id = @lv_nomenclature_id
    AND zarv4_d_nom_t~langu = @sy-langu
  INTO @lv_nomenclature_name.

  SELECT s~raw_material_id AS nid, SUM( t~transaction_quantity ) AS tq, SUM( t~transaction_amount ) AS ta,
    n~indicator_of_use AS iu, nt~nomenclature_name AS n_name, ut~unit_type_name AS u_name,
    s~raw_material_quantity AS sq, s~raw_material_amount AS sa
  FROM zarv4_d_transact AS t
  INNER JOIN zarv4_d_nom AS n
  ON n~nomenclature_id = t~nomenclature_id
  INNER JOIN zarv4_d_nom_t AS nt
  ON n~nomenclature_id = nt~nomenclature_id
  INNER JOIN zarv4_d_u_types AS ut
  ON n~unit_type_id = ut~unit_type_id
  INNER JOIN @lt_specification AS s
  ON s~raw_material_id = n~nomenclature_id
  WHERE nt~langu = @sy-langu
  GROUP BY s~raw_material_id, indicator_of_use, nt~nomenclature_name, ut~unit_type_name, s~raw_material_amount, s~raw_material_quantity
  ORDER BY s~raw_material_id
  INTO TABLE @lt_prepared_data.

  IF sy-subrc <> 0.
    MESSAGE 'There are not all the necessary materials for release.' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.
