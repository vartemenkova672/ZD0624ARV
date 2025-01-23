*&---------------------------------------------------------------------*
*& Include          ZARV4_R_GET_INFORMATION_TOP
*&---------------------------------------------------------------------*


TABLES: zarv4_d_transact,
        zarv4_d_nom,
        zarv4_d_nom_t,
        zarv4_d_worker,
        zarv4_s_transact,
        sscrfields.
TYPES:
  BEGIN OF gt_s_spec,
    mandt                 TYPE zarv4_d_specific-mandt,
    record_id             TYPE zarv4_d_specific-record_id,
    finished_goods_id     TYPE zarv4_d_specific-finished_goods_id,
    raw_material_id       TYPE zarv4_d_specific-raw_material_id,
    raw_material_quantity TYPE zarv4_d_specific-raw_material_quantity,
    raw_material_amount   TYPE zarv4_d_specific-raw_material_amount,
  END OF gt_s_spec.

TYPES:
  BEGIN OF gt_s_specification,
    nid    TYPE zarv4_d_specific-raw_material_id,
    sq     TYPE p LENGTH 16 DECIMALS 2,
    sa     TYPE p LENGTH 16 DECIMALS 2,
    n_name TYPE zarv4_d_nom_t-nomenclature_name,
    u_name TYPE zarv4_d_u_types-unit_type_name,
  END OF gt_s_specification.

TYPES:
  BEGIN OF gt_s_stock,
    nom_id   TYPE zarv4_d_nom-nomenclature_id,
    nom_art  TYPE zarv4_d_nom-article,
    nom_name TYPE zarv4_d_nom_t-nomenclature_name,
    nom_q    TYPE p LENGTH 16 DECIMALS 2,
    ut_name  TYPE zarv4_d_u_types-unit_type_name,
    nom_a    TYPE p LENGTH 16 DECIMALS 2,
    u_type   TYPE zarv4_d_nom-indicator_of_use,
  END OF gt_s_stock.

TYPES:
  BEGIN OF gt_s_employes,
    emp_act   TYPE zarv4_d_worker-active,
    emp_id    TYPE zarv4_d_worker-employee_id,
    emp_tit   TYPE zarv4_d_titles_t-title_name,
    emp_fn    TYPE zarv4_d_worker_t-first_name,
    emp_ln    TYPE zarv4_d_worker_t-last_name,
    emp_pn    TYPE zarv4_d_worker-phone_number,
    emp_ad    TYPE zarv4_d_worker-address,
    empm_name TYPE string,
  END OF gt_s_employes.

DATA: gv_date          TYPE zarv4_d_transact-transaction_date,
      gv_nom_id        TYPE zarv4_d_transact-nomenclature_id,
      gv_emp           TYPE zarv4_d_transact-responsible_person,
      gv_nom_name      TYPE zarv4_d_nom_t-nomenclature_name,
      gt_specific      TYPE TABLE OF gt_s_spec,
      gt_spec_with_inf TYPE TABLE OF gt_s_specification,
      gt_stock         TYPE TABLE OF gt_s_stock,
      gt_employes      TYPE TABLE OF gt_s_employes,

      BEGIN OF line,
        type TYPE zarv4_d_nom-indicator_of_use,
      END OF line,
      gt_list_types LIKE STANDARD TABLE OF line.
