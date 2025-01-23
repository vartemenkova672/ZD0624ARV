*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_BOOK....................................*
DATA:  BEGIN OF STATUS_ZARV4_D_BOOK                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_BOOK                  .
CONTROLS: TCTRL_ZARV4_D_BOOK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZARV4_D_BOOK                  .
TABLES: ZARV4_D_BOOK                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
