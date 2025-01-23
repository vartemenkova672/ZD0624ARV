*&---------------------------------------------------------------------*
*& Include          ZARV4_R_GET_INFORMATION_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Selection
*&---------------------------------------------------------------------*

FORM select_additional_information
  USING lt_specific LIKE gt_specific
        lv_nom_id   LIKE gv_nom_id
        lv_lang     LIKE sy-langu
        CHANGING lt_spec_with_inf LIKE gt_spec_with_inf
                 lv_nom_name      LIKE gv_nom_name.

  SELECT s~raw_material_id AS nid, SUM( s~raw_material_quantity ) AS sq, SUM( s~raw_material_amount ) AS sa,
         nt~nomenclature_name AS n_name, ut~unit_type_name AS u_name
    FROM zarv4_d_nom AS n
    INNER JOIN zarv4_d_nom_t AS nt
    ON n~nomenclature_id = nt~nomenclature_id
    INNER JOIN zarv4_d_u_types AS ut
    ON n~unit_type_id = ut~unit_type_id
    INNER JOIN @lt_specific AS s
    ON s~raw_material_id = n~nomenclature_id
    WHERE nt~langu = @lv_lang
    GROUP BY s~raw_material_id, nt~nomenclature_name, ut~unit_type_name
    ORDER BY s~raw_material_id
    INTO TABLE @lt_spec_with_inf.

  SELECT n~nomenclature_name AS rmn
  FROM zarv4_d_nom_t AS n
  WHERE n~nomenclature_id = @lv_nom_id
  AND n~langu = @lv_lang
  INTO @lv_nom_name.
  ENDSELECT.

ENDFORM.

FORM select_stock_information
  USING  lt_id_range       TYPE ANY TABLE
         lt_list_types     LIKE gt_list_types
         lv_date           LIKE gv_date
         lv_lang           LIKE sy-langu
         CHANGING lt_stock LIKE gt_stock.

  SELECT t~nomenclature_id AS nom_id, n~article AS nom_art, nt~nomenclature_name AS nom_name,
    SUM( t~transaction_quantity ) AS nom_q, ut~unit_type_name AS ut_name,
    SUM( t~transaction_amount ) AS nom_a, n~indicator_of_use AS u_type
  FROM zarv4_d_transact AS t
  INNER JOIN zarv4_d_nom AS n
  ON n~nomenclature_id = t~nomenclature_id
  INNER JOIN ZARV4_D_NOM_t AS nt
  ON nt~nomenclature_id = t~nomenclature_id
  INNER JOIN zarv4_d_u_types AS ut
  ON ut~unit_type_id = n~unit_type_id
  INNER JOIN @lt_list_types AS lt
  ON lt~type = n~indicator_of_use
  WHERE t~nomenclature_id IN @lt_id_range
    AND nt~langu = @lv_lang
    AND t~transaction_date <= @lv_date
  GROUP BY t~nomenclature_id, n~article, nt~nomenclature_name, ut~unit_type_name, n~indicator_of_use
  ORDER BY n~indicator_of_use
  INTO TABLE @lt_stock.

  IF sy-subrc <> 0.
    MESSAGE 'There is no data on stock for the item with the specified selection.' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM select_employes
    USING  lt_employe_id_range   TYPE ANY TABLE
           lt_employe_m_id_range TYPE ANY TABLE
           lv_act                TYPE abap_boolean
           lv_lang               LIKE sy-langu
           CHANGING lt_employes  LIKE gt_employes.

  SELECT e~active AS emp_act, e~employee_id AS emp_id, ti~title_name AS emp_tit,
    et~first_name AS emp_fn, et~last_name AS emp_ln, e~phone_number AS emp_pn,
    e~address AS emp_ad
  FROM zarv4_d_worker AS e
  INNER JOIN zarv4_d_titles_t AS ti
  ON ti~title_id = e~title_id
  INNER JOIN zarv4_d_worker_t AS et
  ON e~employee_id = et~employee_id

  WHERE e~employee_id IN @lt_employe_id_range
    AND e~manager IN @lt_employe_m_id_range
    AND e~active = @lv_act
    AND et~langu = @lv_lang
    AND ti~langu = @lv_lang
  INTO TABLE @lt_employes.

  IF sy-subrc <> 0.
    MESSAGE 'There no employees data, which meets the selection criteria.' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Check the fields are filled in
*&---------------------------------------------------------------------*

FORM check_transaction
    USING:lv_ch_transaction_date   LIKE gv_date
          lv_lang                  LIKE sy-langu.

  IF lv_ch_transaction_date IS INITIAL.
    MESSAGE 'Transaction date is not specified' TYPE 'S'.
    STOP.
  ELSEIF lv_lang IS INITIAL.
    MESSAGE 'The report language is not defined' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

FORM check_fg_ID
    USING lv_ch_nomenclature_id      LIKE gv_nom_id.

  IF lv_ch_nomenclature_id IS INITIAL.
    MESSAGE 'Item ID is not specified' TYPE 'S'.
    STOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Show results
*&---------------------------------------------------------------------*

FORM show_result_spec
  USING  lt_spec_with_inf LIKE gt_spec_with_inf
         lv_nom_name      LIKE gv_nom_name
         lv_nom_id        LIKE gv_nom_id.

  WRITE:/ 'Specification for product assembly. '.
  ULINE.

  WRITE:/ '|', 'Finished good ID:   ', lv_nom_id,
        / '|', 'Finished good name: ', lv_nom_name.
  ULINE.

  LOOP AT lt_spec_with_inf ASSIGNING FIELD-SYMBOL(<ls_spec_with_inf>).
    WRITE: /'|', 'Component ID: ',       <ls_spec_with_inf>-nid,
            '|', 'Component name: ',     <ls_spec_with_inf>-n_name,
            '|', 'Component quantity: ', <ls_spec_with_inf>-sq,
            '|', 'Unit type: ',          <ls_spec_with_inf>-u_name,
            '|', 'Cost per unit: ',      <ls_spec_with_inf>-sa.

  ENDLOOP.
  ULINE.
ENDFORM.

FORM show_result_stock
    USING  lt_stock LIKE gt_stock
           lv_date  LIKE gv_date.

  DATA: lv_type  TYPE string,
        lv_price TYPE p LENGTH 16 DECIMALS 2.

  WRITE:/ 'Remains of the nomenclature as of: ', lv_date.
  ULINE.

  LOOP AT lt_stock ASSIGNING FIELD-SYMBOL(<ls_stock>).

    IF <ls_stock>-u_type = '1' AND lv_type <> '1'.
      lv_type = '1'.
      ULINE.
      WRITE:/ '|', 'Raw-materials: '.
      ULINE.
    ELSEIF <ls_stock>-u_type = '2' AND lv_type <> '2'.
      lv_type = '2'.
      ULINE.
      WRITE:/ '|', 'Inventory: '.
      ULINE.
    ELSEIF <ls_stock>-u_type = '3' AND lv_type <> '3'.
      lv_type = '3'.
      ULINE.
      WRITE:/ '|', 'Finished goods: '.
      ULINE.
    ELSEIF <ls_stock>-u_type = '4' AND lv_type <> '4'.
      lv_type = '4'.
      ULINE.
      WRITE:/ '|', 'Accrued expenses: '.
      ULINE.
    ENDIF.

    IF  <ls_stock>-nom_q <> 0.
      lv_price = <ls_stock>-nom_a / <ls_stock>-nom_q.
    ELSE.
      lv_price = 0.
    ENDIF.

    WRITE: /'|', 'ID: ',           <ls_stock>-nom_id,
            '|', 'Article: ',      <ls_stock>-nom_art,
            '|', 'Name: ',         <ls_stock>-nom_name,
            '|', 'Quantity: ',     <ls_stock>-nom_q,
            '|', 'Unit type: ',    <ls_stock>-ut_name,
            '|', 'Average price: ',        lv_price,
            '|', 'Total amount: ', <ls_stock>-nom_a.
  ENDLOOP.
  ULINE.

  CLEAR lv_type.

ENDFORM.

FORM show_result_employes
    USING  lt_employes LIKE gt_employes.

  TRY.
      cl_salv_table=>factory(
      IMPORTING r_salv_table = DATA(lo_salv)
        CHANGING  t_table = lt_employes ).
      lo_salv->display( ).
    CATCH cx_salv_msg.
  ENDTRY.

ENDFORM.
