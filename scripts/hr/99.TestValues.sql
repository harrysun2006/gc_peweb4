SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

/*
INSERT INTO T_PSN_STATUS
   (C_BELONG, C_PERSON, C_UPGRADE_REASON, C_TYPE, C_POSITION, 
    C_REGBELONG, C_PARTY, C_GRADE, C_SCHOOLHISTORY, C_ONDATE, 
    C_DOWNDATE, C_UPGRADER)
 Values
   (2, 8238, NULL, '��ͬ', '1', 
    NULL, '��Ա', NULL, '����', TO_DATE('05/20/2009 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 11);
COMMIT;
*/

INSERT INTO T_DEPARTTERM
   (C_BELONG, C_DEPART, C_NAME, C_MANDUTY, C_LEADER, 
    C_COMMENT)
 Values
   (2, 4, '����', NULL, NULL, 
    NULL);
COMMIT;

INSERT INTO T_PSN_PEOPLE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_PEOPLE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_PEOPLE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_PEOPLE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, 'ά�����', 0, 1);
INSERT INTO T_PSN_PEOPLE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
COMMIT;

INSERT INTO T_PSN_NPLACE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����ʡ������', 0, 1);
INSERT INTO T_PSN_NPLACE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '�Ϻ��������', 0, 1);
COMMIT;

INSERT INTO T_PSN_MSTATE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, 'δ��', 0, 1);
INSERT INTO T_PSN_MSTATE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '�ѻ�', 0, 1);
INSERT INTO T_PSN_MSTATE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_MSTATE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
COMMIT;

INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ͬ', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��Ƹ', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, 'ʵϰ', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ʱ��', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '������ʱ��', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ְ', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, 'N/A', 0, 1);
INSERT INTO T_PSN_TYPE
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, 'N/A', 0, 1);
COMMIT;

INSERT INTO T_PSN_REGBELONG
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ǿ', 0, 1);
INSERT INTO T_PSN_REGBELONG
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_REGBELONG
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
COMMIT;

INSERT INTO T_PSN_PARTY
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��Ա', 0, 1);
INSERT INTO T_PSN_PARTY
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��Ա', 0, 1);
INSERT INTO T_PSN_PARTY
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, 'Ⱥ��', 0, 1);
COMMIT;

INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, 'Сѧ', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ר', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ר', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '˶ʿ', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '��ʿ', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, '��ר', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, '����', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, '�о���', 0, 1);
INSERT INTO T_PSN_SCHOOLING
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, '��ʿ', 0, 1);
COMMIT;

INSERT INTO T_PSN_SPEC
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '�繤', 0, 1);
INSERT INTO T_PSN_SPEC
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (2, '����', 0, 1);
INSERT INTO T_PSN_SPEC
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, '���Ա', 0, 1);
INSERT INTO T_PSN_SPEC
   (C_BELONG, C_NAME, C_NO, C_ACTIVE)
 Values
   (4, '�������ù���', 0, 1);
COMMIT;

INSERT INTO T_HRSAL_ITEM
   (C_BELONG, C_ID, C_NO, C_NAME, C_ONDATE, 
    C_DOWNDATE, C_ACCOUNT_DEBIT, C_ACCOUNT_CREDIT, C_FLAG, C_TYPE)
 Values
   (2, 1, 'JB', '�Ӱ��', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 1, 'WG');
INSERT INTO T_HRSAL_ITEM
   (C_BELONG, C_ID, C_NO, C_NAME, C_ONDATE, 
    C_DOWNDATE, C_ACCOUNT_DEBIT, C_ACCOUNT_CREDIT, C_FLAG, C_TYPE)
 Values
   (2, 2, 'GZ', '����', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 1, 'WG');
INSERT INTO T_HRSAL_ITEM
   (C_BELONG, C_ID, C_NO, C_NAME, C_ONDATE, 
    C_DOWNDATE, C_ACCOUNT_DEBIT, C_ACCOUNT_CREDIT, C_FLAG, C_TYPE)
 Values
   (2, 3, 'CB', '�а�
', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 1, 'WG');
INSERT INTO T_HRSAL_ITEM
   (C_BELONG, C_ID, C_NO, C_NAME, C_ONDATE, 
    C_DOWNDATE, C_ACCOUNT_DEBIT, C_ACCOUNT_CREDIT, C_FLAG, C_TYPE)
 Values
   (2, 4, 'FT', '����', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 1, 'WG');
INSERT INTO T_HRSAL_ITEM
   (C_BELONG, C_ID, C_NO, C_NAME, C_ONDATE, 
    C_DOWNDATE, C_ACCOUNT_DEBIT, C_ACCOUNT_CREDIT, C_FLAG, C_TYPE)
 Values
   (2, 5, 'GJJ', '������
', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, -1, 'SG');
INSERT INTO T_HRSAL_ITEM
   (C_BELONG, C_ID, C_NO, C_NAME, C_ONDATE, 
    C_DOWNDATE, C_ACCOUNT_DEBIT, C_ACCOUNT_CREDIT, C_FLAG, C_TYPE)
 Values
   (2, 6, 'DK', '����', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('12/31/9999 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, -1, 'DK');
COMMIT;

INSERT INTO T_HRSAL_DEPTPSN
   (C_BELONG, C_DEPART, C_PERSON, C_BANK, C_BANKCARD, 
    C_COMMENT)
 Values
   (2, 2, 8, '�Ϻ��ֶ���չ����½���������', '123456789000', 
    'TEST');
COMMIT;

INSERT INTO T_HRSAL_FIXONLINE
   (C_ID, C_BELONG, C_DEPART, C_PERSON, C_ITEM, 
    C_ONDATE, C_DOWNDATE, C_AMOUNT, C_COMMENT)
 Values
   (1, 2, 2, 8, 1, 
    TO_DATE('05/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('05/31/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 80, NULL);
COMMIT;

INSERT INTO T_HRSAL_TEMPLATE
   (C_ID, C_BELONG, C_DEPART, C_ITEM, C_AMOUNT, 
    C_COMMENT)
 Values
   (1, 2, 5, 1, 80, 
    NULL);
COMMIT;

INSERT INTO T_HRCHK_FACTHD
   (C_BELONG, C_NO, C_DEPART, C_OFFICE, C_CHECKBY, 
    C_COMMENT)
 Values
   (2, '1', 2, NULL, 1, 
    NULL);
COMMIT;