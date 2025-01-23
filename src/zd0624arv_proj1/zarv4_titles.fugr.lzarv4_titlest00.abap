*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_TITLES..................................*
DATA:  BEGIN OF STATUS_ZARV4_D_TITLES                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_TITLES                .
CONTROLS: TCTRL_ZARV4_D_TITLES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZARV4_D_TITLES                .
TABLES: *ZARV4_D_TITLES_T              .
TABLES: ZARV4_D_TITLES                 .
TABLES: ZARV4_D_TITLES_T               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
