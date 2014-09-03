CREATE OR REPLACE FUNCTION Fun_Safety_Close(branch_id IN NUMBER, acc_date IN DATE, close_comment IN VARCHAR2, close_type IN VARCHAR2, close_user IN VARCHAR2)
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
  --171
  IF acc_date IS NOT NULL THEN
    v_accdate := TO_DATE(TO_CHAR(acc_date, 'YYYY/MM/DD'), 'YYYY/MM/DD');
  ELSE
    v_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  SELECT MAX(C_DATE) INTO v_max_accdate FROM T_SAF_CLOSECONTROL WHERE C_BELONG = branch_id;
  IF v_max_accdate IS NULL THEN
    v_max_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  IF close_type = '9' THEN
    IF v_accdate <> v_max_accdate THEN
      RAISE_APPLICATION_ERROR(-20101, '指定日期不是最后的安全系统结帐日期!');
    END IF;
    DELETE FROM T_SAF_CLOSECONTROL WHERE C_BELONG = branch_id AND C_DATE = v_max_accdate;
    SELECT MAX(C_DATE) INTO v_accdate FROM T_SAF_CLOSECONTROL WHERE C_BELONG = branch_id;
  ELSIF close_type = '1' THEN
    IF v_accdate <= v_max_accdate THEN
      RAISE_APPLICATION_ERROR(-20101, '指定日期在上一结帐日期之前!');
    END IF;
    INSERT INTO T_SAF_CLOSECONTROL (C_BELONG, C_DATE, C_COMMENT) VALUES (branch_id, v_accdate, close_comment);
  ELSIF close_type = '0' THEN
    v_accdate := v_max_accdate;
  ELSE
    RAISE_APPLICATION_ERROR(-20101, '请指定合法的安全系统帐务操作: 1--close, 9--unclose!');
  END IF;
  IF v_accdate IS NULL THEN
    v_accdate := TO_DATE('1901/01/01','YYYY/MM/DD');
  END IF;
  OPEN v_cursor FOR SELECT v_accdate FROM DUAL;
  RETURN v_cursor;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
  -- WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20101, '人事系统结帐过程中发生未知错误, 请联系管理员!');
END Fun_Safety_Close;
