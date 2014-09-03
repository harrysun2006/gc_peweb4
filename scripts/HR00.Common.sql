---------------------------------------------------------------------
--����ƾ֤���ʱ�:T_HR_CLOSE
--����ƾ֤�ű�:T_HR_NO
--------------------------------------------------------
SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF
-----------------------------------------------------------------
--����ƾ֤���ʱ�
EXEC SP_DROPTABLE('T_HR_CLOSE');
CREATE TABLE T_HR_CLOSE
(
  C_BELONG   NUMBER(18)                         NOT NULL, --��������
  C_DATE     DATE                               NOT NULL, --��������
  C_COMMENT  VARCHAR2(100 BYTE)                           --��ע
) LOGGING NOCACHE NOPARALLEL MONITORING;
--����
ALTER TABLE T_HR_CLOSE ADD (CONSTRAINT PK_HR_CLOSE PRIMARY KEY (C_BELONG, C_DATE));
--�����������
ALTER TABLE T_HR_CLOSE ADD (CONSTRAINT FK_HR_CLOSE_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--���ʲ���
CREATE OR REPLACE FUNCTION FUN_HR_CLOSE(branch_id IN NUMBER, acc_date IN DATE, close_comment IN VARCHAR2, close_type IN VARCHAR2, close_user IN VARCHAR2) 
RETURN SYS_REFCURSOR
IS
/*
close_type:
'0'--get latest close date
'1'--close acc, acc_date must greater than current latest close date
'9'--unclose acc, acc_date must be current latest close date
�����Ҫ����������, ���Լ�һ�����ñ�(һ���ֶ�, ÿ����¼��Ӧһ����Ҫ�������ƵĲ���, ִ��ǰSELECT FOR UPDATE
*/
v_cursor SYS_REFCURSOR;
v_accdate DATE;
v_max_accdate DATE;
BEGIN
  IF acc_date IS NOT NULL THEN
    v_accdate := TO_DATE(TO_CHAR(acc_date, 'YYYY/MM/DD'), 'YYYY/MM/DD');
  ELSE
    v_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  SELECT MAX(C_DATE) INTO v_max_accdate FROM T_HR_CLOSE WHERE C_BELONG = branch_id;
  IF v_max_accdate IS NULL THEN
    v_max_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  IF close_type = '9' THEN
    IF v_accdate <> v_max_accdate THEN
      RAISE_APPLICATION_ERROR(-20101, 'ָ�����ڲ�����������ϵͳ��������!');
    END IF;
    DELETE FROM T_HR_CLOSE WHERE C_BELONG = branch_id AND C_DATE = v_max_accdate;
    SELECT MAX(C_DATE) INTO v_accdate FROM T_HR_CLOSE WHERE C_BELONG = branch_id;
  ELSIF close_type = '1' THEN
    IF v_accdate <= v_max_accdate THEN
      RAISE_APPLICATION_ERROR(-20101, 'ָ����������һ��������֮ǰ!');
    END IF;
    INSERT INTO T_HR_CLOSE (C_BELONG, C_DATE, C_COMMENT) VALUES (branch_id, v_accdate, close_comment);
  ELSIF close_type = '0' THEN
    v_accdate := v_max_accdate;
  ELSE
    RAISE_APPLICATION_ERROR(-20101, '��ָ���Ϸ�������ϵͳ�������: 1--close, 9--unclose!');
  END IF;
  IF v_accdate IS NULL THEN
    v_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  OPEN v_cursor FOR SELECT v_accdate FROM DUAL;
  RETURN v_cursor;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
  -- WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20101, '����ϵͳ���ʹ����з���δ֪����, ����ϵ����Ա!');
END FUN_HR_CLOSE;
/

-----------------------------------------------------------------
--����ƾ֤�ű�
EXEC SP_DROPTABLE('T_HR_NO');
CREATE TABLE T_HR_NO
(
  C_BELONG    NUMBER(18)                        NOT NULL, --��������
  C_TYPE      VARCHAR2(1 BYTE)                  NOT NULL, --ƾ֤����, A:��ٵ�
  C_ACC_HEAD  VARCHAR2(4 BYTE)                  NOT NULL, --ƾ֤��ǰ׺, AYY-:��ٵ�
  C_CURNO     NUMBER(6)                         NOT NULL  --��ǰ���
) LOGGING NOCACHE NOPARALLEL MONITORING;
--����
ALTER TABLE T_HR_NO ADD (CONSTRAINT PK_HR_NO PRIMARY KEY (C_BELONG, C_TYPE, C_ACC_HEAD));
--�����������
ALTER TABLE T_HR_NO ADD (CONSTRAINT FK_HR_NO_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--ȡƾ֤�Ŵ洢����
CREATE OR REPLACE FUNCTION FUN_GET_NEXT_HRNO(P_BRANCH  IN NUMBER, P_TYPE  IN CHAR, P_ACC_HEAD IN VARCHAR2) 
RETURN VARCHAR2 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  NEXT_NUM NUMBER(7);
BEGIN
  MERGE INTO T_HR_NO T USING
    (SELECT P_BRANCH C_BELONG, P_TYPE C_TYPE, P_ACC_HEAD C_ACC_HEAD FROM DUAL) V
      ON (T.C_BELONG = V.C_BELONG AND T.C_TYPE = V.C_TYPE AND T.C_ACC_HEAD = V.C_ACC_HEAD)
  WHEN MATCHED THEN
    UPDATE SET T.C_CURNO = T.C_CURNO + 1
  WHEN NOT MATCHED THEN
    INSERT (T.C_BELONG, T.C_TYPE, T.C_ACC_HEAD, T.C_CURNO)
      VALUES (P_BRANCH, P_TYPE, P_ACC_HEAD, 1);
  SELECT C_CURNO INTO NEXT_NUM FROM T_HR_NO WHERE C_BELONG = P_BRANCH AND C_TYPE = P_TYPE AND C_ACC_HEAD = P_ACC_HEAD;
  COMMIT;
  NEXT_NUM := 1000000 + NEXT_NUM;
  RETURN P_ACC_HEAD || SUBSTR(TO_CHAR(NEXT_NUM), 2, 6);
END FUN_GET_NEXT_HRNO;
/
/*
ʹ����������PRAGMA AUTONOMOUS_TRANSACTION�ķ�ʽ, ����ʹSELECT FUN_GET_NEXT_HRNO(...) FROM DUAL������ִ��UPDATE/INSERT/DELETE������;
���ұ�֤���̼߳�Ļ���(�����¼)!!!����ȡƾ֤�ź������ͻ��˲�������ͬһ����, ���ַ�ʽ������.
ʹ��RETURN SYS_REFCURSOR�ķ�ʽ, ͨ���洢�������ÿ���ʹȡƾ֤�ź�������������ͬһ����, �������������, ���޷���֤�����̵߳Ļ���.
ע��: 
1. ʹ����������PRAGMA AUTONOMOUS_TRANSACTION�ķ�ʽ, �����ڷ���ǰCOMMIT, ����Oracle�״�"ORA-06519: ��⵽��������������Ѿ�����"
2. ʹ��RETURN SYS_REFCURSOR�ķ�ʽ, ����ͳһ�ɿͻ����ύ��ع�, ���Դ洢�����в�Ҫʹ��COMMIT��ROLLBACK(�������Զ������)
RETURN SYS_REFCURSOR
IS
  V_CURSOR SYS_REFCURSOR;
  NEXT_NUM NUMBER(7);
BEGIN
  MERGE INTO T_HR_NO T USING
    (SELECT P_BRANCH C_BELONG, P_TYPE C_TYPE, P_ACC_HEAD C_ACC_HEAD FROM DUAL) V
      ON (T.C_BELONG = V.C_BELONG AND T.C_TYPE = V.C_TYPE AND T.C_ACC_HEAD = V.C_ACC_HEAD)
  WHEN MATCHED THEN
    UPDATE SET T.C_CURNO = T.C_CURNO + 1
  WHEN NOT MATCHED THEN
    INSERT (T.C_BELONG, T.C_TYPE, T.C_ACC_HEAD, T.C_CURNO)
      VALUES (P_BRANCH, P_TYPE, P_ACC_HEAD, 1);
  SELECT C_CURNO INTO NEXT_NUM FROM T_HR_NO WHERE C_BELONG = P_BRANCH AND C_TYPE = P_TYPE AND C_ACC_HEAD = P_ACC_HEAD;
  -- COMMIT;
  NEXT_NUM := 1000000 + NEXT_NUM;
  OPEN V_CURSOR FOR SELECT P_ACC_HEAD || SUBSTR(TO_CHAR(NEXT_NUM), 2, 6) FROM DUAL;
  RETURN V_CURSOR;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END FUN_GET_NEXT_HRNO;
/
*/