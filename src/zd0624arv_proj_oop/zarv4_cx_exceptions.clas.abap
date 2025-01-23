class ZARV4_CX_EXCEPTIONS definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

  constants:
    begin of DATE_FIELD_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '000',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DATE_FIELD_EMPTY .
  constants:
    begin of AMOUNT_FIELD_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '004',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of AMOUNT_FIELD_EMPTY .
  constants:
    begin of ID_FIELD_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '002',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ID_FIELD_EMPTY .
  constants:
    begin of QUANTITY_FIELD_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '003',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of QUANTITY_FIELD_EMPTY .
  constants:
    begin of TIME_FIELD_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '001',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of TIME_FIELD_EMPTY .
  constants:
    begin of ARTICLE_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '005',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ARTICLE_EMPTY .
  constants:
    begin of UTID_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '006',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of UTID_EMPTY .
  constants:
    begin of IOFUSE_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '007',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of IOFUSE_EMPTY .
  constants:
    begin of NOMNAME_EMPTY,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '008',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NOMNAME_EMPTY .
  constants:
    begin of UTID_NOT_FOUND,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '010',
      attr1 type scx_attrname value 'IV_FIELD1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of UTID_NOT_FOUND .
  constants:
    begin of IOFUSE_NOT_FOUND,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '009',
      attr1 type scx_attrname value 'IV_FIELD1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of IOFUSE_NOT_FOUND .
  constants:
    begin of NO_SPECIFICATION,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '011',
      attr1 type scx_attrname value 'IV_FIELD1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_SPECIFICATION .
  constants:
    begin of INCLUDED_IN_SPECIFICATION,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '012',
      attr1 type scx_attrname value 'IV_FIELD1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INCLUDED_IN_SPECIFICATION .
  constants:
    begin of NO_NOMENCLATURE_ITEM,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '013',
      attr1 type scx_attrname value 'IV_FIELD1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_NOMENCLATURE_ITEM .
  constants:
    begin of SHORTAGE_OF_REMAINDER,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '014',
      attr1 type scx_attrname value 'IV_FIELD1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SHORTAGE_OF_REMAINDER .
  constants:
    begin of INSUFFICIENT_STOCK,
      msgid type symsgid value 'ZARV4_MESSAGE_CLASS',
      msgno type symsgno value '015',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INSUFFICIENT_STOCK .
  data IV_FIELD1 type CHAR10 read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !IV_FIELD1 type CHAR10 optional .
protected section.
private section.
ENDCLASS.



CLASS ZARV4_CX_EXCEPTIONS IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->IV_FIELD1 = IV_FIELD1 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
