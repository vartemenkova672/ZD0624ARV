*&---------------------------------------------------------------------*
*& Include          ZARV4_MAKE_TRANSACTION_TOP
*&---------------------------------------------------------------------*


TABLES: zarv4_d_transact,
        zarv4_d_nom,
        zarv4_d_nom_t,
        zarv4_d_worker,
        zarv4_s_transact,
        sscrfields.

TYPES:
  BEGIN OF gt_s_prepared_data,
    nid    TYPE zarv4_d_specific-raw_material_id,
    tq     TYPE p LENGTH 16 DECIMALS 2,
    ta     TYPE p LENGTH 16 DECIMALS 2,
    iu     TYPE zarv4_d_nom-indicator_of_use,
    n_name TYPE zarv4_d_nom_t-nomenclature_name,
    u_name TYPE zarv4_d_u_types-unit_type_name,
    sq     TYPE p LENGTH 16 DECIMALS 2,
    sa     TYPE p LENGTH 16 DECIMALS 2,
  END OF gt_s_prepared_data.

TYPES:
  BEGIN OF gt_s_spec,
    mandt                 TYPE zarv4_d_specific-mandt,
    record_id             TYPE zarv4_d_specific-record_id,
    finished_goods_id     TYPE zarv4_d_specific-finished_goods_id,
    raw_material_id       TYPE zarv4_d_specific-raw_material_id,
    raw_material_quantity TYPE zarv4_d_specific-raw_material_quantity,
    raw_material_amount   TYPE zarv4_d_specific-raw_material_amount,
  END OF gt_s_spec.

DATA: gs_transact      TYPE zarv4_d_transact,
      gv_sign          TYPE i,
      gv_resp_p        TYPE zarv4_d_transact-responsible_person,
      gv_time          TYPE zarv4_d_transact-transaction_time,
      gv_date          TYPE zarv4_d_transact-transaction_date,
      gv_nom_id        TYPE zarv4_d_transact-nomenclature_id,
      gv_quantity      TYPE zarv4_d_transact-transaction_quantity,
      gv_amount        TYPE zarv4_d_transact-transaction_amount,
      gv_salary_res    TYPE zarv4_d_transact-transaction_salary_recipient,
      gv_transact_id   TYPE zarv4_d_transact-record_id,
      gv_nom_name      TYPE zarv4_d_nom_t-nomenclature_name,
      gt_prepared_data TYPE TABLE OF gt_s_prepared_data,
      gt_specific      TYPE TABLE OF gt_s_spec.
