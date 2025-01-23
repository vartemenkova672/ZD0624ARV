*&---------------------------------------------------------------------*
*& Report ZSAPLAB_PATTERN_SQL
*&---------------------------------------------------------------------*
*& This is a pattern program
*& Please use needed parts of the program for your tasks
*&---------------------------------------------------------------------*
report zarv4_r_sql_example.
*&---------------------------------------------------------------------*
*& Global Data Declaration
*&---------------------------------------------------------------------*
data: gv_name type name_text.

*&---------------------------------------------------------------------*
*& Select Statements
*&---------------------------------------------------------------------*

* Select into internal table statement
select sprsl,
       msgnr
  from t100
  into table @data(gt_t100)
  up to 3 rows.

* Select into structure statement
select single bukrs,
              butxt
  from t001
  into @data(gs_t001)
    where bukrs = '0001'.

* Select into declared variable statement
select single name_text
  from v_usr_name
  into @gv_name
    where bname = @sy-uname.

*Join
select single person_first_name, person_last_name, birth_date
  from zfer_d_reader inner join zfer_d_reader_t
  on zfer_d_reader~person_id = zfer_d_reader_t~person_id
  into @data(gs_reader)
  where zfer_d_reader~person_id = 10
  and langu = @sy-langu.

*&---------------------------------------------------------------------*
*& Display output
*& Please note! After program execution you will see selectad table gt_t100 results.
*& To see WRITE results, please press 'Back' (green row) button
*&---------------------------------------------------------------------*

* Display table result using ALV
cl_salv_table=>factory( importing r_salv_table = data(go_salv)
                        changing  t_table      = gt_t100 ).
go_salv->display( ).

* Display result using WRITE statetment
write:/  'Company Code Name:',  gs_t001-bukrs,
      /  'Company Code Description:',  gs_t001-butxt.
skip.
write:/ |Your USER ID is: { gv_name }|.

skip.

loop at gt_t100 assigning field-symbol(<gs_t100>).
  write:/  'Language:',  <gs_t100>-sprsl,
         'Message number:',  <gs_t100>-msgnr.
endloop.
