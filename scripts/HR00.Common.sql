---------------------------------------------------------------------
--人事凭证结帐表:T_HR_CLOSE
--人事凭证号表:T_HR_NO
--------------------------------------------------------
SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF
-----------------------------------------------------------------
--人事凭证结帐表
EXEC SP_DROPTABLE('T_HR_CLOSE');
CREATE TABLE T_HR_CLOSE
(
  C_BELONG   NUMBER(18)                         NOT NULL, --所属机构
  C_DATE     DATE                               NOT NULL, --结账日期
  C_COMMENT  VARCHAR2(100 BYTE)                           --备注
) LOGGING NOCACHE NOPARALLEL MONITORING;
--主键
ALTER TABLE T_HR_CLOSE ADD (CONSTRAINT PK_HR_CLOSE PRIMARY KEY (C_BELONG, C_DATE));
--所属机构外键
ALTER TABLE T_HR_CLOSE ADD (CONSTRAINT FK_HR_CLOSE_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--结帐操作
CREATE OR REPLACE FUNCTION FUN_HR_CLOSE(branch_id IN NUMBER, acc_date IN DATE, close_comment IN VARCHAR2, close_type IN VARCHAR2, close_user IN VARCHAR2) 
RETURN SYS_REFCURSOR
IS
/*
close_type:
'0'--get latest close date
'1'--close acc, acc_date must greater than current latest close date
'9'--unclose acc, acc_date must be current latest close date
如果需要做并发控制, 可以加一个公用表(一个字段, 每个记录对应一个需要并发控制的操作, 执行前SELECT FOR UPDATE
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
      RAISE_APPLICATION_ERROR(-20101, '指定日期不是最后的人事系统结帐日期!');
    END IF;
    DELETE FROM T_HR_CLOSE WHERE C_BELONG = branch_id AND C_DATE = v_max_accdate;
    SELECT MAX(C_DATE) INTO v_accdate FROM T_HR_CLOSE WHERE C_BELONG = branch_id;
  ELSIF close_type = '1' THEN
    IF v_accdate <= v_max_accdate THEN
      RAISE_APPLICATION_ERROR(-20101, '指定日期在上一结帐日期之前!');
    END IF;
    INSERT INTO T_HR_CLOSE (C_BELONG, C_DATE, C_COMMENT) VALUES (branch_id, v_accdate, close_comment);
  ELSIF close_type = '0' THEN
    v_accdate := v_max_accdate;
  ELSE
    RAISE_APPLICATION_ERROR(-20101, '请指定合法的人事系统帐务操作: 1--close, 9--unclose!');
  END IF;
  IF v_accdate IS NULL THEN
    v_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  OPEN v_cursor FOR SELECT v_accdate FROM DUAL;
  RETURN v_cursor;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
  -- WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20101, '人事系统结帐过程中发生未知错误, 请联系管理员!');
END FUN_HR_CLOSE;
/

-----------------------------------------------------------------
--人事凭证号表
EXEC SP_DROPTABLE('T_HR_NO');
CREATE TABLE T_HR_NO
(
  C_BELONG    NUMBER(18)                        NOT NULL, --所属机构
  C_TYPE      VARCHAR2(1 BYTE)                  NOT NULL, --凭证类型, A:请假单
  C_ACC_HEAD  VARCHAR2(4 BYTE)                  NOT NULL, --凭证号前缀, AYY-:请假单
  C_CURNO     NUMBER(6)                         NOT NULL  --当前序号
) LOGGING NOCACHE NOPARALLEL MONITORING;
--主键
ALTER TABLE T_HR_NO ADD (CONSTRAINT PK_HR_NO PRIMARY KEY (C_BELONG, C_TYPE, C_ACC_HEAD));
--所属机构外键
ALTER TABLE T_HR_NO ADD (CONSTRAINT FK_HR_NO_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--取凭证号存储函数
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
使用自治事务PRAGMA AUTONOMOUS_TRANSACTION的方式, 可以使SELECT FUN_GET_NEXT_HRNO(...) FROM DUAL调用中执行UPDATE/INSERT/DELETE被允许;
并且保证了线程间的互斥(锁表记录)!!!由于取凭证号和其他客户端操作不在同一事务, 此种方式会跳号.
使用RETURN SYS_REFCURSOR的方式, 通过存储函数调用可以使取凭证号和其他操作处于同一事务, 减少了跳号情况, 但无法保证并发线程的互斥.
注意: 
1. 使用匿名事务PRAGMA AUTONOMOUS_TRANSACTION的方式, 必须在返回前COMMIT, 否则Oracle抛错"ORA-06519: 检测到活动的自治事务处理，已经回退"
2. 使用RETURN SYS_REFCURSOR的方式, 事务统一由客户端提交或回滚, 所以存储函数中不要使用COMMIT或ROLLBACK(可以抛自定义错误)
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