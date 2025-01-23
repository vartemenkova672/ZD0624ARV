*&---------------------------------------------------------------------*
*& Report ZARV4_MAKE_TRANSACTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_make_transaction.

INCLUDE ZARV4_R_MAKE_TRANSACTION_TOP.  " Global Data
INCLUDE ZARV4_R_MAKE_TRANSACTION_SEL.  " Selection screen

INCLUDE ZARV4_R_MAKE_TRANSACTION_O01.  " PBO-Modules
INCLUDE ZARV4_R_MAKE_TRANSACTION_I01.  " PAI-Modules
INCLUDE ZARV4_R_MAKE_TRANSACTION_F01.  " FORM-Routines

INCLUDE ZARV4_R_MAKE_TRANSACTION_0100.

INCLUDE ZARV4_R_MAKE_TRANSACTION_0200.
