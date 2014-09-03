--20100201 ������ 
-- SP_HRSAL_FIXONLINE �������ں���֤������Ŀ��֤
--v176:20091123 ���׸�
--����ϵͳ���ݿ�ű�
--==============================================================================
--������Ŀ��T_HRSAL_ITEM
--���ʲ�����Ա״̬��T_HRSAL_DEPTPSN �����Բ���Ϊ��λ���ţ���һ�����в��Ŷ����Է����ʣ�һ���˿����ڱ�Ĳ����칤�ʣ����������칤��
--�̶���Ŀ�䶯��T_HRSAL_FIXONLINE
--���ʷ���ģ�壺T_HRSAL_TEMPLATE & T_HRSAL_TEMPLATEDT
--���ʷ��ű�T_HRSAL_FACT & T_HRSAL_FACTDT
--==============================================================================
SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF
--------------------------------------------------------------------------------
--������Ŀ��
EXEC SP_DROPTABLE('T_HRSAL_ITEM');
CREATE TABLE T_HRSAL_ITEM
(
  C_BELONG          NUMBER(18)                  NOT NULL,
  C_ID              NUMBER(18)                  NOT NULL,
  C_NO              VARCHAR2(16 BYTE)           NOT NULL, /*��Ŀ���*/
  C_NAME            VARCHAR2(30 BYTE)           NOT NULL, /*��Ŀ����*/
  C_ONDATE          DATE                        NOT NULL, /*��������Ч*/
  C_DOWNDATE        DATE                        NOT NULL, /*������ʧЧ*/
  C_ACCOUNT_DEBIT   VARCHAR2(30 BYTE)               NULL, /*��Դ��Ŀ*/
  C_ACCOUNT_CREDIT  VARCHAR2(30 BYTE)               NULL, /*ȥ���Ŀ*/
  C_FLAG            NUMBER(1)                   NOT NULL, /*����+1����-1�ۻ�0�������ܶ�*/
  C_TYPE            VARCHAR2(4 BYTE)            NOT NULL, /*��𣺹�����Ŀ(WG)���籣��Ŀ(SG)��������Ŀ(WF)��������Ŀ(DK)��������Ŀ(ƽ����ĿPZ)*/
  C_PRINT           CHAR                        NOT NULL, /*��ӡ��'1'��ʾ��ӡ'0'ֻ��ʾ*/
  C_FORMULA         VARCHAR2(128 BYTE)                    /*��ʽ����Ч�ڰ�������Ŀ����ĿI(���ܵݹ����)��������+ - * /���ܶ��Ȩ��̯��ĿAVG��Ȩ����Ŀ�����ӿ���ĿINPUT��A-Z��*/  
) LOGGING NOCACHE NOPARALLEL MONITORING;
COMMENT ON COLUMN T_HRSAL_ITEM.C_TYPE IS '�̶���𣺹�����Ŀ(WG)���籣��Ŀ(SG)��������Ŀ(WF)��������Ŀ(DK)��������Ŀ(ƽ����ĿPZ)';
--�ؼ����ڲ�id
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT PK_HRSAL_ITEM PRIMARY KEY (C_BELONG, C_ID));
--���ö��
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT CHK_HRSAL_ITEM_TYPE CHECK (C_TYPE IN ('WG','SG','WF','DK','PZ')));
--�״̬
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT CHK_HRSAL_ITEM_DATE CHECK (C_ONDATE <= C_DOWNDATE));
--�������
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT FK_HRSAL_ITEM_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--���кŶ���
EXEC SP_DROPSEQ('SEQ_HRSAL_ITEM');
CREATE SEQUENCE SEQ_HRSAL_ITEM START WITH 1 MAXVALUE 999999999999999999999999999 MINVALUE 1 NOCYCLE NOCACHE NOORDER;
CREATE OR REPLACE TRIGGER TRG_HRSAL_ITEMID
BEFORE INSERT ON T_HRSAL_ITEM
FOR EACH ROW
DECLARE NEXT_ID NUMBER;
BEGIN
  SELECT SEQ_HRSAL_ITEM.NEXTVAL INTO NEXT_ID FROM T_SEQFRO;
  :NEW.C_ID := NEXT_ID;
END;
/
--�������Ŀ��Ų����ظ�
CREATE INDEX IDX_HRSAL_ITEM ON T_HRSAL_ITEM (C_BELONG, C_NO, C_DOWNDATE) LOGGING NOPARALLEL;
--��֤���޸���Ŀ��ȫ����ʽ��Ч���̶���Ŀ��Ч��ģ����Ч��ʵ�ʷ��ű���Ч
--------------------------------------------------------------------------------
--���ʲ�����Ա״̬��
EXEC SP_DROPTABLE('T_HRSAL_DEPTPSN');
CREATE TABLE T_HRSAL_DEPTPSN
(
  C_BELONG    NUMBER(18)                        NOT NULL,
  C_DEPART    NUMBER(18)                        NOT NULL,   /*���ʲ���*/
  C_PERSON    NUMBER(18)                        NOT NULL,   /*������Ա*/
  C_BANK      VARCHAR2(30 BYTE)                     NULL,   /*��������*/
  C_BANKCARD  VARCHAR2(30 BYTE)                     NULL,   /*���ſ���*/
  C_COMMENT   VARCHAR2(255 BYTE)                    NULL    /*��ע*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
COMMENT ON TABLE T_HRSAL_DEPTPSN IS 'һ���˿����ڶ������(0,1,n)��ȡ����';
--������Ա�ؼ���
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT PK_HRSAL_DEPTPSN PRIMARY KEY (C_BELONG, C_DEPART, C_PERSON));
--�������
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT FK_HRSAL_DEPTPSN_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
--��Ա���
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT FK_HRSAL_DEPTPSN_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));
--------------------------------------------------------------------------------
--�ϱ�����̶�ϵ���ϲ����̶���Ŀ�䶯����
EXEC SP_DROPTABLE('T_HRSAL_VARONLINE');
--�̶���Ŀ�䶯��
EXEC SP_DROPTABLE('T_HRSAL_FIXONLINE');
CREATE TABLE T_HRSAL_FIXONLINE
(
  C_BELONG    NUMBER(18)                        NOT NULL,
  C_DEPART    NUMBER(18)                        NOT NULL,   /*��н����*/
  C_PERSON    NUMBER(18)                        NOT NULL,   /*��Ա*/
  C_ITEM      NUMBER(18)                        NOT NULL,   /*��Ŀ*/
  C_ONDATE    DATE                              NOT NULL,   /*��������Ч*/
  C_DOWNDATE  DATE                              NOT NULL,   /*������ʧЧ*/
  C_AMOUNT    NUMBER(18,4)                      NOT NULL,   /*��Ŀֵ*/
  C_COMMENT   VARCHAR2(255 BYTE)                    NULL    /*��ע*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
--�ؼ���(��н���š���Ա����Ŀ����������Ч)
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT PK_HRSAL_FIXONLINE PRIMARY KEY (C_BELONG, C_DEPART, C_PERSON, C_ITEM, C_ONDATE));
--���(���š���Ŀ����Ա)
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG,C_ID));
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));
--��֤���̶���Ŀ/ϵ������Ч�ں���Ŀ��Ч�ڵİ�����ϵ��
--      �̶���Ŀ/ϵ������Ч�ں�ʵ�ʷ��ż�����ģ���һ���Թ�ϵ��
--------------------------------------------------------------------------------
--���ʷ���ģ��
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE');
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATEDT');
--
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE_HD');
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE_DT');
CREATE TABLE T_HRSAL_TEMPLATE
(
  C_BELONG   NUMBER(18)                             NOT NULL,
  C_ID       NUMBER(18)                             NOT NULL,   /*�ڲ�id*/
  C_NAME     VARCHAR2(30 BYTE)                      NOT NULL,   /*����*/
  C_DEPART   NUMBER(18)                             NOT NULL,   /*����*/
  C_COMMENT  VARCHAR2(255 BYTE)                         NULL    /*ժҪ*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
CREATE TABLE T_HRSAL_TEMPLATEDT
(
  C_BELONG   NUMBER(18)                             NOT NULL,
  C_HD       NUMBER(18)                             NOT NULL,   /*ģ��id*/
  C_NO       NUMBER(4)                              NOT NULL,   /*���1-9999*/
  C_ITEM     NUMBER(18)                             NOT NULL,   /*��Ŀ*/
  C_PERSON   NUMBER(18)                             NOT NULL,   /*��Ա*/
  C_AMOUNT   NUMBER(18,4)                           NOT NULL,   /*ȱʡֵ(�ǹ�ʽ�͹̶���Ŀ)*/
  C_COMMENT  VARCHAR2(255 BYTE)                         NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;
--�ؼ���
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT PK_HRSAL_TEMPLATE PRIMARY KEY (C_BELONG, C_ID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT PK_HRSAL_TEMPLATEDT PRIMARY KEY (C_BELONG, C_HD, C_NO, C_ITEM));
--Ψһ�ԣ�ÿ��ģ����ÿ�˵����Ψһ(C_PERSON, C_NO)
--���(���ţ�HD����Ա����Ŀ)
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT FK_HRSAL_TEMPLATE_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG, C_DEPARTMENTID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT FK_HRSAL_TEMPLATEDT_HD FOREIGN KEY (C_BELONG, C_HD) REFERENCES T_HRSAL_TEMPLATE (C_BELONG, C_ID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT FK_HRSAL_TEMPLATEDT_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT FK_HRSAL_TEMPLATEDT_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG, C_ID));
--ģ�����к�
EXEC SP_DROPSEQ('SEQ_HRSAL_TEMPLATE');
CREATE SEQUENCE SEQ_HRSAL_TEMPLATE START WITH 1 MAXVALUE 999999999999999999999999999 MINVALUE 1 NOCYCLE NOCACHE NOORDER;
CREATE OR REPLACE TRIGGER TRG_HRSAL_TEMPLATEID
BEFORE INSERT ON T_HRSAL_TEMPLATE
FOR EACH ROW
DECLARE NEXT_ID NUMBER;
BEGIN
	SELECT SEQ_HRSAL_TEMPLATE.NEXTVAL INTO NEXT_ID FROM T_SEQFRO;
	:NEW.C_ID := NEXT_ID;
END;
/
--��֤����ʽ��Ŀ�����õ���Ŀ����ͬʱȫ��������ģ���ڡ�
--      ������ֵ����Ŀ�������޹�ʽ���й̶���Ŀ�ı���͵�ǰ��Ч����Ŀֵ��ȡ�
--      ������Ա���ڵ�ǰT_HRSAL_DEPTPSN����ʾ������Ϣ��
--------------------------------------------------------------------------------
--���ʷ��ű�T_HRSAL_FACT & T_HRSAL_FACTDT
EXEC SP_DROPTABLE('T_HRSAL_FACT');
EXEC SP_DROPTABLE('T_HRSAL_FACTHD');
EXEC SP_DROPTABLE('T_HRSAL_FACTDT');
--
EXEC SP_DROPTABLE('T_HRSAL_FACT_HD');
EXEC SP_DROPTABLE('T_HRSAL_FACT_DT');
CREATE TABLE T_HRSAL_FACT
(
  C_BELONG     NUMBER(18)                       NOT NULL,
  C_NO         VARCHAR2(30 BYTE)                NOT NULL,    /*ƾ֤��*/
  C_DEPART     NUMBER(18)                       NOT NULL,    /*��н����*/
  C_DATE       DATE                          	NOT NULL,    /*��������*/ 
  C_ISSUEDATE  DATE                             NOT NULL,    /*��������*/
  C_ISSUETYPE  VARCHAR2(1 BYTE)                 NOT NULL,    /*���ŷ�ʽ(ת���֡���)*/
  C_SUMMARY    VARCHAR2(255 BYTE)                   NULL,    /*ժҪ*/
  C_ISSUEBY    NUMBER(18)                       NOT NULL,    /*����*/
  C_COMMENT    VARCHAR2(255 BYTE)                   NULL     /*��ע*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
COMMENT ON COLUMN T_HRSAL_FACT.C_ISSUETYPE IS '��(C)��ת(T)����(G)';
CREATE TABLE T_HRSAL_FACTDT
(
  C_BELONG   NUMBER(18)                         NOT NULL,
  C_HDNO     VARCHAR2(30 BYTE)                  NOT NULL,   /*ƾ֤��*/
  C_NO       NUMBER(4)                          NOT NULL,   /*���1-9999*/
  C_ITEM     NUMBER(18)                         NOT NULL,   /*��Ŀ*/
  C_PERSON   NUMBER(18)                         NOT NULL,   /*��Ա*/
  C_AMOUNT   NUMBER(18,2)                       NOT NULL    /*��ֵ*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
--�ؼ���
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT PK_HRSAL_FACT PRIMARY KEY (C_BELONG, C_NO));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT PK_HRSAL_FACTDT PRIMARY KEY (C_BELONG, C_HDNO, C_NO, C_ITEM));
--Ψһ�ԣ�ÿ��������ÿ�˵����Ψһ(C_PERSON, C_NO)
--���(���ţ����죬HDNO����Ա����Ŀ)
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT FK_HRSAL_FACT_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG, C_DEPARTMENTID));
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT FK_HRSAL_FACT_DOPSN FOREIGN KEY (C_BELONG, C_ISSUEBY) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_HD FOREIGN KEY (C_BELONG, C_HDNO) REFERENCES T_HRSAL_FACT (C_BELONG, C_NO));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG, C_ID));
--���ŷ�ʽ����
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT CHK_HRSAL_FACT_TYPE CHECK (C_ISSUETYPE IN ('C','T','G')));


------------------------------------------------
-- ��Ŀ��Ч����֤
create or replace trigger trg_HRSAL_ITEM_validate
  before update of c_ondate, c_downdate on t_HRSAL_ITEM
  for each row

when (new.c_ondate <> old.c_ondate or new.c_downdate <> old.c_downdate)
declare
  v_tmp             number(18);
begin
  --�µ���������ǰ���ܴ��ڹ̶���Ŀ��͹��ʷ��ű����Ŀʹ��(��ʾ������Ϣ���û��ؼ���)
  if :new.c_ondate <> :old.c_ondate then
    select count(*)
      into v_tmp
      from (select c_item
              from t_hrsal_fixonline
             where c_belong = :new.c_belong
               and c_item = :new.c_id
               and c_ondate < :new.c_ondate
            union all
            select t_hrsal_factdt.c_item
              from t_hrsal_fact, t_hrsal_factdt
             where t_hrsal_fact.c_belong = t_hrsal_factdt.c_belong
               and t_hrsal_fact.c_no = t_hrsal_factdt.c_hdno
               and t_hrsal_factdt.c_belong = :new.c_belong
               and t_hrsal_factdt.c_item = :new.c_id
               and t_hrsal_fact.c_date < :new.c_ondate);
    if v_tmp > 0 then
      raise_application_error(-20001,
                              '������Ŀ: ' || :Old.c_no ||
                              '���µ���������ǰ����ҵ�񣬲����޸��������ڣ�');
    end if;
  end if;
  --ʧЧ��֮���ܴ��ڹ̶���Ŀ��͹��ʷ��ű����Ŀʹ��(��ʾ������Ϣ���û��ؼ���)
  if :new.c_downdate <> :old.c_downdate then
    if :new.c_downdate <> to_date('9999/12/31', 'yyyy/mm/dd') then
      select count(*)
        into v_tmp
        from (select c_item
                from t_hrsal_fixonline
               where c_belong = :new.c_belong
                 and c_item = :new.c_id
                 and c_downdate > :new.c_downdate
              union all
              select t_hrsal_factdt.c_item
                from t_hrsal_fact, t_hrsal_factdt
               where t_hrsal_fact.c_belong = t_hrsal_factdt.c_belong
                 and t_hrsal_fact.c_no = t_hrsal_factdt.c_hdno
                 and t_hrsal_factdt.c_belong = :new.c_belong
                 and t_hrsal_factdt.c_item = :new.c_id
                 and t_hrsal_fact.c_date > :new.c_downdate);
      if v_tmp > 0 then
        raise_application_error(-20001,
                                '������Ŀ: ' || :Old.c_no ||
                                '���µ�ע�����ں����ҵ�񣬲����޸�ע�����ڣ�');
      end if;
    end if;
  end if;
end;
/

----------------------------------------------------------------------
-- �̶���Ŀ����֤
CREATE OR REPLACE PROCEDURE SP_HRSAL_FIXONLINE(BRANCHID   NUMBER,
                                               DEPTNO     VARCHAR,
                                               OP_TYPE    VARCHAR,
                                               OP_PSNNO   VARCHAR,
                                               OP_ITEMNO  VARCHAR,
                                               OP_DATE    VARCHAR,
                                               OP_VAL     NUMBER,
                                               OP_LOGPSN  VARCHAR,
                                               OP_LOGDATE VARCHAR)
--/*����
  --      branchid   ����id
  --      deptno     ���ű��
  --      op_type    �������1������Ŀ��2��ֹ��Ŀ�������Ŀ=ǰ̨2+1���ָ���Ŀ=ǰ̨1��
  --      op_psnno   ��Ա����
  --      op_itemno  ��Ŀ���
  --      op_date    ��������
  --      op_val     ��Ŀֵ
  --      op_logpsn  �����˹���
  --      op_logdate ��������
  --*/
 AS
  V_DEPTID       NUMBER(18); --deptno����ID
  V_LOGPSNID     NUMBER(18); --op_logpsn������ID
  V_OPPSNID      NUMBER(18); --op_psnno��ԱID
  V_LAST_HRCLOSE DATE; --�����������
  V_ITEMID       NUMBER(18); --op_itemno��Ŀid
  V_ONDATE       DATE;
  V_DOWNDATE     DATE;
  V_DATE         DATE;
  V_FACT_AMOUNT  NUMBER(18, 2);
  V_REFNO        VARCHAR2(30);
  V_NO           NUMBER(4);
  V_MONTH        CHAR(2);
BEGIN
  --�жϲ���deptno�Ƿ��ڲ�������op_date�Ϸ���ȡ���Ϸ���deptnoid
  BEGIN
    SELECT C_DEPARTMENTID
      INTO V_DEPTID
      FROM T_DEPARTMENT
     WHERE C_BELONG = BRANCHID
       AND C_NO = DEPTNO
       AND C_DEPARTMENTONDATE <= TO_DATE(OP_DATE, 'yyyy/mm/dd')
       AND C_DEPARTMENTDOWNDATE > TO_DATE(OP_DATE, 'yyyy/mm/dd');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20003,
                              'ָ�����ű��:' || DEPTNO || '�ڲ���������Ч!');
  END;
  --�жϾ�����op_logpsn�Ƿ��ھ�������op_logdate�Ϸ���ȡ���Ϸ���op_logpsnid
  BEGIN
    SELECT C_PERSONALID
      INTO V_LOGPSNID
      FROM T_PERSONAL
     WHERE C_BELONG = BRANCHID
       AND C_WORKERID = OP_LOGPSN
       AND C_PERSONALONDATE <= TO_DATE(OP_LOGDATE, 'yyyy/mm/dd')
       AND C_PERSONALDOWNDATE > TO_DATE(OP_LOGDATE, 'yyyy/mm/dd');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20003,
                              'ָ�������˹���:' || OP_LOGPSN || '�ھ���������Ч!');
  END;
  --�ж���Ա����op_psnno�Ƿ��ڲ�������op_date�Ϸ���ȡ���Ϸ���op_psnnoid
  BEGIN
    SELECT C_PERSONALID
      INTO V_OPPSNID
      FROM T_PERSONAL
     WHERE C_BELONG = BRANCHID
       AND C_WORKERID = OP_PSNNO
       AND C_PERSONALONDATE <= TO_DATE(OP_DATE, 'yyyy/mm/dd')
       AND C_PERSONALDOWNDATE > TO_DATE(OP_DATE, 'yyyy/mm/dd');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20003,
                              'ָ����Ա����:' || OP_PSNNO || '�ڲ���������Ч!');
  END;
  --�ж�op_date�Ƿ�С��������գ�op_date������ڵ���������¿�����
  BEGIN
    SELECT MAX(NVL(C_DATE, TO_DATE('1901/01/01', 'yyyy/mm/dd')))
      INTO V_LAST_HRCLOSE
      FROM T_HR_CLOSE
     WHERE C_BELONG = BRANCHID;
    IF TO_DATE(OP_DATE, 'yyyy/mm/dd') < V_LAST_HRCLOSE THEN
      RAISE_APPLICATION_ERROR(-20003,
                              '��������:' || OP_DATE || '������ڵ��������������:' ||
                              TO_CHAR(V_LAST_HRCLOSE, 'yyyy/mm/dd'));
    END IF;
  END;
  --��֤��Ŀ���op_itemno�Ƿ��ڲ�������op_date-9999/12/31����Ŀ��T_HRSAL_ITEM�кϷ���ȡ���Ϸ���op_itemnoid
  BEGIN
    SELECT C_ID
      INTO V_ITEMID
      FROM T_HRSAL_ITEM
     WHERE C_BELONG = BRANCHID
       AND C_NO = OP_ITEMNO
       AND C_ONDATE <= TO_DATE(OP_DATE, 'yyyy/mm/dd')
       AND C_DOWNDATE = TO_DATE('9999/12/31', 'yyyy/mm/dd');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20003,
                              '��Ŀ���:' || OP_ITEMNO || '����Ŀ������Ч!');
  END;
  BEGIN
    IF OP_TYPE = '1' THEN
      --1������Ŀ
      BEGIN
        --�жϸò��š����ˡ�����Ŀ����ʱ��op_date-9999/12/31�ڱ���T_HRSAL_FIXONLINE���Ƿ���ͬ��Ŀ�����ظ�����ʾ�ظ���Ŀ����ֹ���ڵ���Ϣ��
        BEGIN
          DECLARE
            CURSOR CUR_PSN_FIXONLINE IS
              SELECT C_ONDATE, C_DOWNDATE
                FROM T_HRSAL_FIXONLINE
               WHERE C_BELONG = BRANCHID
                 AND C_DEPART = V_DEPTID
                 AND C_PERSON = V_OPPSNID
                 AND C_ITEM = V_ITEMID
               ORDER BY C_ONDATE, C_DOWNDATE DESC;
          BEGIN
            OPEN CUR_PSN_FIXONLINE;
            LOOP
              FETCH CUR_PSN_FIXONLINE
                INTO V_ONDATE, V_DOWNDATE;
              EXIT WHEN CUR_PSN_FIXONLINE%NOTFOUND;
              IF V_DOWNDATE >= TO_DATE(OP_DATE, 'yyyy/mm/dd') THEN
                 RAISE_APPLICATION_ERROR(-20003,
                                        '����:' || DEPTNO || ', ��Ա:' ||
                                        OP_PSNNO || ', ��Ŀ:' || OP_ITEMNO ||
                                        ', ��������:' || OP_DATE || '��' ||
                                        to_char(V_ONDATE, 'yyyy/mm/dd') || '��Ч,' || to_char(V_DOWNDATE, 'yyyy/mm/dd') ||
                                        'ʧЧ�Ĺ̶���Ŀ����!');
              END IF;
            END LOOP;
            CLOSE CUR_PSN_FIXONLINE;
          END;
        END;
        --�жϸò��š����ˡ�����Ŀ����ʱ��op_date-9999/12/31�ڹ��ʷ��ű�T_HRSAL_FACT&DT���Ƿ����зǵ�ֵ��Ŀ���ţ���ʾ��������ƾ֤�š��·ݡ������ա����
        BEGIN
          DECLARE
            CURSOR CUR_FACT IS
              SELECT T_HRSAL_FACTDT.C_AMOUNT,
                     T_HRSAL_FACT.C_NO,
                     T_HRSAL_FACTDT.C_NO,
                     T_HRSAL_FACT.C_DATE,
                     T_HRSAL_FACT.C_ISSUEDATE
                FROM T_HRSAL_FACT, T_HRSAL_FACTDT
               WHERE T_HRSAL_FACT.C_BELONG = T_HRSAL_FACTDT.C_BELONG
                 AND T_HRSAL_FACT.C_NO = T_HRSAL_FACTDT.C_HDNO
                 AND T_HRSAL_FACT.C_DATE >=
                     TO_DATE(OP_DATE, 'yyyy/mm/dd')
                 AND T_HRSAL_FACT.C_DATE <=
                     TO_DATE('9999/12/31', 'yyyy/mm/dd')
                 AND T_HRSAL_FACTDT.C_BELONG = BRANCHID
                 AND T_HRSAL_FACTDT.C_PERSON = V_OPPSNID
                 AND T_HRSAL_FACTDT.C_ITEM = V_ITEMID
                 AND T_HRSAL_FACT.C_DEPART = V_DEPTID;
          BEGIN
            OPEN CUR_FACT;
            LOOP
              FETCH CUR_FACT
                INTO V_FACT_AMOUNT, V_REFNO, V_NO, V_MONTH, V_DATE;
              EXIT WHEN CUR_FACT%NOTFOUND;
              IF V_FACT_AMOUNT != OP_VAL THEN
                RAISE_APPLICATION_ERROR(-20003,
                                        '����:' || DEPTNO || ', ��Ա:' ||
                                        OP_PSNNO || ', ��Ŀ:' || OP_ITEMNO ||
                                        ', ��������:' || OP_DATE ||
                                        '�빤�ʷ��ż�¼�еķ���ƾ֤��:' || V_REFNO ||
                                        ', ���:' || V_NO || ', ��������:' ||
                                        V_MONTH || ', ��������:' ||
                                        TO_CHAR(V_DATE, 'yyyy/mm/dd') ||
                                        '�е�ʵ�ʷ��Ž�һ��!');
              END IF;
            END LOOP;
            CLOSE CUR_FACT;
          END;
        END;
        --�жϸò��š����ˡ�����Ŀ����ʱ��op_date-9999/12/31�ڱ���T_HRSAL_FIXONLINE���Ƿ���ͬ��Ŀ����
        --�ж��Ƿ���ڽ�����Ŀdown_date = op_date - 1��������Ŀֵ��ͬ
        --������Ŀ ����down_date = 9999/12/31
        BEGIN
          UPDATE T_HRSAL_FIXONLINE
             SET C_DOWNDATE = TO_DATE('9999/12/31', 'yyyy/mm/dd')
           WHERE C_BELONG = BRANCHID
             AND C_DEPART = V_DEPTID
             AND C_PERSON = V_OPPSNID
             AND C_ITEM = V_ITEMID
             AND C_AMOUNT = OP_VAL
             AND C_DOWNDATE = TO_DATE(OP_DATE, 'yyyy/mm/dd') - 1;
          IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO T_HRSAL_FIXONLINE
              (C_BELONG,
               C_DEPART,
               C_PERSON,
               C_ITEM,
               C_ONDATE,
               C_DOWNDATE,
               C_AMOUNT)
            VALUES
              (BRANCHID,
               V_DEPTID,
               V_OPPSNID,
               V_ITEMID,
               TO_DATE(OP_DATE, 'yyyy/mm/dd'),
               TO_DATE('9999/12/31', 'yyyy/mm/dd'),
               OP_VAL);
          ELSIF SQL%ROWCOUNT > 1 THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20003, '�̶���Ŀ���з����쳣!');
          END IF;
        END;
      END;
    ELSIF OP_TYPE = '2' THEN
      --2��ֹ��Ŀ
      --��ֹ��Ŀ����֤���ʷ��ű�
      BEGIN
        --��֤�ò��š����ˡ�����Ŀ�Ƿ��ڲ�������op_date-9999/12/31�Ϸ�������������ȡ���úϷ���Ŀ��on_date��op_itemnoid
        --ע�⣺������ʾ���룺ע�����š���Ա����Ŀ,���ڵ�ȫ��Ĵ���ԭ�����û���ȫ����������Ĵ���
        BEGIN
          SELECT C_ONDATE
            INTO V_DATE
            FROM T_HRSAL_FIXONLINE
           WHERE C_BELONG = BRANCHID
             AND C_PERSON = V_OPPSNID
             AND C_DEPART = V_DEPTID
             AND C_ITEM = V_ITEMID
             AND C_ONDATE <= TO_DATE(OP_DATE, 'yyyy/mm/dd')
             AND C_DOWNDATE = TO_DATE('9999/12/31', 'yyyy/mm/dd');
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003,
                                    '��������:' || OP_DATE || 'ʱ�����ڲ���:' ||
                                    DEPTNO || ', ��Ա:' || OP_PSNNO ||
                                    ', ��Ŀ:' || OP_ITEMNO);
        END;
        BEGIN
          --�ж��Ƿ�ɾ����Ŀ
          --on_date=op_date��ɾ���ò�����Ա��Ŀֵ���������down_date = op_date - 1
          IF V_DATE = TO_DATE(OP_DATE, 'yyyy/mm/dd') THEN
            DELETE FROM T_HRSAL_FIXONLINE
             WHERE C_BELONG = BRANCHID
               AND C_PERSON = V_OPPSNID
               AND C_DEPART = V_DEPTID
               AND C_ITEM = V_ITEMID
               AND C_ONDATE = V_DATE
               AND C_DOWNDATE = TO_DATE('9999/12/31', 'yyyy/mm/dd');
          ELSE
            UPDATE T_HRSAL_FIXONLINE
               SET C_DOWNDATE = TO_DATE(OP_DATE, 'yyyy/mm/dd') - 1
             WHERE C_BELONG = BRANCHID
               AND C_PERSON = V_OPPSNID
               AND C_DEPART = V_DEPTID
               AND C_ITEM = V_ITEMID
               AND C_ONDATE <= TO_DATE(OP_DATE, 'yyyy/mm/dd')
               AND C_DOWNDATE = TO_DATE('9999/12/31', 'yyyy/mm/dd');
          END IF;
        END;
      END;
    ELSE
      RAISE_APPLICATION_ERROR(-20003, '�������Ͳ�������!');
    END IF;
  END;
END;
/

---------------------------------------------------------
-- ��֤ʵ����Ч��
CREATE OR REPLACE PROCEDURE SP_HRSAL_FACTDT(BRANCHID IN NUMBER,
                                            HDNO     IN VARCHAR2,
                                            OP_NO    IN NUMBER,
                                            ITEMID   IN NUMBER,
                                            DEPARTID IN NUMBER,
                                            PERSONID IN NUMBER,
                                            AMOUNT   IN NUMBER,
                                            HDDATE   IN DATE,
                                            WORKERID IN VARCHAR2,
                                            OP_TYPE  IN VARCHAR2) IS
  -- OP_TYPE : '1' ����, '2' �޸�, '3' ɾ��
  V_COUNT   NUMBER;
  V_FORMULA VARCHAR2(128);
  V_NAME    VARCHAR2(30);
BEGIN
  -- ��֤��Աû���ظ�
  BEGIN
    V_COUNT := 0;
    SELECT COUNT(*)
      INTO V_COUNT
      FROM T_HRSAL_FACTDT
     WHERE C_BELONG = BRANCHID
       AND C_HDNO = HDNO
       AND C_PERSON = PERSONID
       AND C_NO <> OP_NO;
    IF V_COUNT > 0 THEN
      RAISE_APPLICATION_ERROR(-20003,
                              '��' || OP_NO || '�з�����Ա' || WORKERID ||
                              '�ڱ��η������ظ�!');
    END IF;
  END;

  -- ��֤��ʽ��Ŀ����ֵ�ȼ���
  -- �й̶���Ŀ����֤��û�й�ʽ,û�й�ʽ����͵�ǰ��Ч����Ŀֵ���
  BEGIN
    BEGIN
      V_COUNT := NULL;
      SELECT T_HRSAL_FIXONLINE.C_AMOUNT,
             T_HRSAL_ITEM.C_FORMULA,
             T_HRSAL_ITEM.C_NAME
        INTO V_COUNT, V_FORMULA, V_NAME
        FROM T_HRSAL_FIXONLINE, T_HRSAL_ITEM
       WHERE T_HRSAL_FIXONLINE.C_BELONG = T_HRSAL_ITEM.C_BELONG
         AND T_HRSAL_FIXONLINE.C_ITEM = T_HRSAL_ITEM.C_ID
         AND T_HRSAL_FIXONLINE.C_BELONG = BRANCHID
         AND T_HRSAL_FIXONLINE.C_ITEM = ITEMID
         AND T_HRSAL_FIXONLINE.C_DEPART = DEPARTID
         AND T_HRSAL_FIXONLINE.C_PERSON = PERSONID
         AND T_HRSAL_FIXONLINE.C_ONDATE <= HDDATE
         AND T_HRSAL_FIXONLINE.C_DOWNDATE > HDDATE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_COUNT := NULL;
    END;
    IF V_COUNT IS NOT NULL AND V_FORMULA IS NULL THEN
      IF V_COUNT <> AMOUNT THEN
        RAISE_APPLICATION_ERROR(-20003, 
                                '��' || OP_NO || '�й̶���Ŀ' || V_NAME || '��ֵΪ' ||
                                V_COUNT || '��ʵ�ʷ���ֵ��һ��!');
      END IF;
    END IF;
  END;

  IF OP_TYPE = '1' THEN
    INSERT INTO T_HRSAL_FACTDT
    VALUES
      (BRANCHID, HDNO, OP_NO, ITEMID, PERSONID, AMOUNT);
  ELSIF OP_TYPE = '2' THEN
    UPDATE T_HRSAL_FACTDT
       SET C_AMOUNT = AMOUNT
     WHERE C_BELONG = BRANCHID
       AND C_HDNO = HDNO
       AND C_NO = OP_NO
       AND C_PERSON = PERSONID
       AND C_ITEM = ITEMID;
  ELSE
    DELETE FROM T_HRSAL_FACTDT
     WHERE C_BELONG = BRANCHID
       AND C_HDNO = HDNO
       AND C_NO = OP_NO
       AND C_PERSON = PERSONID
       AND C_ITEM = ITEMID;
  END IF;
END SP_HRSAL_FACTDT;
/

