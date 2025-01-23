*&---------------------------------------------------------------------*
*& Report ZARV4_R_PRODUCTION_OOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zarv4_r_production_oop.

INCLUDE zarv4_r_oop_top. " Global Data
INCLUDE zarv4_r_oop_sel. " Selection screen

INCLUDE zarv4_r_oop_cld.
INCLUDE zarv4_r_oop_cli.

INCLUDE zarv4_r_oop_o01.  " PBO-Modules
INCLUDE zarv4_r_oop_i01.  " PAI-Modules
INCLUDE zarv4_r_oop_f01.  " FORM-Routines

INCLUDE zarv4_r_oop_0100.
INCLUDE zarv4_r_oop_0200.
INCLUDE zarv4_r_oop_0300.
INCLUDE zarv4_r_oop_0400.
INCLUDE zarv4_r_oop_0500.
