*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_U_TYPES.................................*
DATA:  BEGIN OF STATUS_ZARV4_D_U_TYPES               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_U_TYPES               .
CONTROLS: TCTRL_ZARV4_D_U_TYPES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZARV4_D_U_TYPES               .
TABLES: ZARV4_D_U_TYPES                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
