*&---------------------------------------------------------------------*
*& Report ZARV4_R_LIBRARY_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zarv4_r_library_info_top                .    " Global Data
INCLUDE zarv4_r_library_info_sel                .    " Selection screen

* INCLUDE ZARV4_R_LIBRARY_INFO_O01                .  " PBO-Modules
* INCLUDE ZARV4_R_LIBRARY_INFO_I01                .  " PAI-Modules
INCLUDE zarv4_r_library_info_f01                .  " FORM-Routines

START-OF-SELECTION.

  PERFORM get_data
  USING s_a_id[] s_b_id[] s_at_fn[] s_at_ln[] s_a_bd[] s_a_co[] s_t_cn[] s_b_bn[]
  CHANGING gt_book[].


END-OF-SELECTION.

  PERFORM show_data
   USING gt_book[].
