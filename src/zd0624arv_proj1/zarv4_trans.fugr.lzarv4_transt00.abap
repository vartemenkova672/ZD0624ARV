*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_TRANSACT................................*
DATA:  BEGIN OF STATUS_ZARV4_D_TRANSACT              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_TRANSACT              .
CONTROLS: TCTRL_ZARV4_D_TRANSACT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZARV4_D_TRANSACT              .
TABLES: ZARV4_D_TRANSACT               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
