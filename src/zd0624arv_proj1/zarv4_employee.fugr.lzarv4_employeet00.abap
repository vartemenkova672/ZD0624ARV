*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZARV4_D_WORKER..................................*
DATA:  BEGIN OF STATUS_ZARV4_D_WORKER                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZARV4_D_WORKER                .
CONTROLS: TCTRL_ZARV4_D_WORKER
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZARV4_D_WORKER                .
TABLES: *ZARV4_D_WORKER_T              .
TABLES: ZARV4_D_WORKER                 .
TABLES: ZARV4_D_WORKER_T               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
