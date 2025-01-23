*&---------------------------------------------------------------------*
*& Report ZARV4_R_DEBUGGER_PT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZARV4_R_DEBUGGER_PT.

DATA: gv_var_a  TYPE i,
      gv_var_b  TYPE i,
      gv_var_c  TYPE i,
      gv_var_d  TYPE i,
      gv_result TYPE i.

PERFORM run_report. "Report execution

*----------------------*
FORM run_report.
* Prepare internal data
  PERFORM prepare_data.

* Process output
  PERFORM print_result.
ENDFORM.

FORM prepare_data.
* Processing of internal data
  PERFORM init_values.
  PERFORM calc_result.
ENDFORM.


FORM init_values.
* Set variable values
  gv_var_a = 7.
  gv_var_b = 3.
  gv_var_c = 2.
  gv_var_d = 5.
ENDFORM.

FORM calc_result.
* Formula to calculate
  gv_result = ( gv_var_a + gv_var_b ) / gv_var_c * gv_var_d.
ENDFORM.

FORM print_result.
* Display report information
  WRITE:/ |Expected:|.
  WRITE:/ |A = 7|.
  WRITE:/ |B = 3|.
  WRITE:/ |C = 2|.
  WRITE:/ |D = 5|.
  WRITE:/ |(A + B) / C * D = 25|.
  WRITE /.
  WRITE:/ |Actual:|.
  WRITE:/ |A = { gv_var_a }|.
  WRITE:/ |B = { gv_var_b }|.
  WRITE:/ |C = { gv_var_c }|.
  WRITE:/ |D = { gv_var_d }|.
  WRITE:/ |(A + B) / C * D = { gv_result }|.
ENDFORM.
