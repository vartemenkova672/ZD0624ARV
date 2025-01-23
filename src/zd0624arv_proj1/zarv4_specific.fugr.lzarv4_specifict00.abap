*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_SPECIFIC................................*
DATA:  BEGIN OF STATUS_ZARV4_D_SPECIFIC              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_SPECIFIC              .
CONTROLS: TCTRL_ZARV4_D_SPECIFIC
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZARV4_D_SPECIFIC              .
TABLES: ZARV4_D_SPECIFIC               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
