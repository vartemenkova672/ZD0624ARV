*&---------------------------------------------------------------------*
*& Report ZD0624ARV_R_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZD0624ARV_R_TEST.

TYPE-POOLS: vrm.
DATA: name TYPE vrm_id, list TYPE vrm_values, value LIKE LINE OF list.
PARAMETERS: ps_parm(10) AS LISTBOX VISIBLE LENGTH 10.
AT SELECTION-SCREEN OUTPUT.
name = 'PS_PARM'.
value-key = '1'. value-text = 'Line 1'. APPEND value TO list.
value-key = '2'. value-text = 'Line 2'. APPEND value TO list.
CALL FUNCTION 'VRM_SET_VALUES' EXPORTING id = name values = list.
START-OF-SELECTION.
WRITE: / 'Parameter:', ps_parm.
