*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZARV4_UNIT_TYPES
*   generation date: 16.08.2024 at 16:10:57
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZARV4_UNIT_TYPES   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
