*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZARV4_EMPLOYEE
*   generation date: 16.08.2024 at 14:21:25
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZARV4_EMPLOYEE     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
