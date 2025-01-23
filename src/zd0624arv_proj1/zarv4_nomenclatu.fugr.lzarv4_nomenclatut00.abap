*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_NOM.....................................*
DATA:  BEGIN OF STATUS_ZARV4_D_NOM                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_NOM                   .
CONTROLS: TCTRL_ZARV4_D_NOM
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZARV4_D_TOFUSE..................................*
DATA:  BEGIN OF STATUS_ZARV4_D_TOFUSE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_TOFUSE                .
*.........table declarations:.................................*
TABLES: *ZARV4_D_NOM                   .
TABLES: *ZARV4_D_NOM_T                 .
TABLES: *ZARV4_D_TOFUSE                .
TABLES: ZARV4_D_NOM                    .
TABLES: ZARV4_D_NOM_T                  .
TABLES: ZARV4_D_TOFUSE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
