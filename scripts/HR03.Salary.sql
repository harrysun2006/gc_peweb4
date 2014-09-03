--20100201 许岳丰 
-- SP_HRSAL_FIXONLINE 发放日期和验证增加项目验证
--v176:20091123 程雷干
--工资系统数据库脚本
--==============================================================================
--工资项目表：T_HRSAL_ITEM
--工资部门人员状态表：T_HRSAL_DEPTPSN 工资以部门为单位发放，不一定所有部门都可以发工资，一个人可以在别的部门领工资，或多个部门领工资
--固定项目变动表：T_HRSAL_FIXONLINE
--工资发放模板：T_HRSAL_TEMPLATE & T_HRSAL_TEMPLATEDT
--工资发放表：T_HRSAL_FACT & T_HRSAL_FACTDT
--==============================================================================
SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF
--------------------------------------------------------------------------------
--工资项目表
EXEC SP_DROPTABLE('T_HRSAL_ITEM');
CREATE TABLE T_HRSAL_ITEM
(
  C_BELONG          NUMBER(18)                  NOT NULL,
  C_ID              NUMBER(18)                  NOT NULL,
  C_NO              VARCHAR2(16 BYTE)           NOT NULL, /*项目编号*/
  C_NAME            VARCHAR2(30 BYTE)           NOT NULL, /*项目名称*/
  C_ONDATE          DATE                        NOT NULL, /*本日起生效*/
  C_DOWNDATE        DATE                        NOT NULL, /*次日起失效*/
  C_ACCOUNT_DEBIT   VARCHAR2(30 BYTE)               NULL, /*来源科目*/
  C_ACCOUNT_CREDIT  VARCHAR2(30 BYTE)               NULL, /*去向科目*/
  C_FLAG            NUMBER(1)                   NOT NULL, /*方向：+1发放-1扣回0不记入总额*/
  C_TYPE            VARCHAR2(4 BYTE)            NOT NULL, /*类别：工资项目(WG)、社保项目(SG)、福利项目(WF)、代扣项目(DK)、对消项目(平帐项目PZ)*/
  C_PRINT           CHAR                        NOT NULL, /*打印：'1'显示打印'0'只显示*/
  C_FORMULA         VARCHAR2(128 BYTE)                    /*公式：有效期包含本项目的项目I(不能递归调用)、常数、+ - * /；总额加权分摊项目AVG（权重项目）；接口项目INPUT（A-Z）*/  
) LOGGING NOCACHE NOPARALLEL MONITORING;
COMMENT ON COLUMN T_HRSAL_ITEM.C_TYPE IS '固定类别：工资项目(WG)、社保项目(SG)、福利项目(WF)、代扣项目(DK)、对消项目(平帐项目PZ)';
--关键字内部id
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT PK_HRSAL_ITEM PRIMARY KEY (C_BELONG, C_ID));
--类别枚举
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT CHK_HRSAL_ITEM_TYPE CHECK (C_TYPE IN ('WG','SG','WF','DK','PZ')));
--活动状态
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT CHK_HRSAL_ITEM_DATE CHECK (C_ONDATE <= C_DOWNDATE));
--机构外键
ALTER TABLE T_HRSAL_ITEM ADD (CONSTRAINT FK_HRSAL_ITEM_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--序列号定义
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
--活动工资项目编号不能重复
CREATE INDEX IDX_HRSAL_ITEM ON T_HRSAL_ITEM (C_BELONG, C_NO, C_DOWNDATE) LOGGING NOPARALLEL;
--验证：修改项目后全部公式有效、固定项目有效、模版有效、实际发放表有效
--------------------------------------------------------------------------------
--工资部门人员状态表
EXEC SP_DROPTABLE('T_HRSAL_DEPTPSN');
CREATE TABLE T_HRSAL_DEPTPSN
(
  C_BELONG    NUMBER(18)                        NOT NULL,
  C_DEPART    NUMBER(18)                        NOT NULL,   /*工资部门*/
  C_PERSON    NUMBER(18)                        NOT NULL,   /*工资人员*/
  C_BANK      VARCHAR2(30 BYTE)                     NULL,   /*发放银行*/
  C_BANKCARD  VARCHAR2(30 BYTE)                     NULL,   /*发放卡号*/
  C_COMMENT   VARCHAR2(255 BYTE)                    NULL    /*备注*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
COMMENT ON TABLE T_HRSAL_DEPTPSN IS '一个人可以在多个部门(0,1,n)领取工资';
--部门人员关键字
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT PK_HRSAL_DEPTPSN PRIMARY KEY (C_BELONG, C_DEPART, C_PERSON));
--部门外键
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT FK_HRSAL_DEPTPSN_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
--人员外键
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT FK_HRSAL_DEPTPSN_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));
--------------------------------------------------------------------------------
--老表废弃固定系数合并到固定项目变动表中
EXEC SP_DROPTABLE('T_HRSAL_VARONLINE');
--固定项目变动表
EXEC SP_DROPTABLE('T_HRSAL_FIXONLINE');
CREATE TABLE T_HRSAL_FIXONLINE
(
  C_BELONG    NUMBER(18)                        NOT NULL,
  C_DEPART    NUMBER(18)                        NOT NULL,   /*发薪部门*/
  C_PERSON    NUMBER(18)                        NOT NULL,   /*人员*/
  C_ITEM      NUMBER(18)                        NOT NULL,   /*项目*/
  C_ONDATE    DATE                              NOT NULL,   /*本日起生效*/
  C_DOWNDATE  DATE                              NOT NULL,   /*次日起失效*/
  C_AMOUNT    NUMBER(18,4)                      NOT NULL,   /*项目值*/
  C_COMMENT   VARCHAR2(255 BYTE)                    NULL    /*备注*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
--关键字(发薪部门、人员、项目、本日起生效)
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT PK_HRSAL_FIXONLINE PRIMARY KEY (C_BELONG, C_DEPART, C_PERSON, C_ITEM, C_ONDATE));
--外键(部门、项目、人员)
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG,C_ID));
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));
--验证：固定项目/系数的生效期和项目生效期的包含关系。
--      固定项目/系数的生效期和实际发放及发放模板的一致性关系。
--------------------------------------------------------------------------------
--工资发放模板
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE');
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATEDT');
--
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE_HD');
EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE_DT');
CREATE TABLE T_HRSAL_TEMPLATE
(
  C_BELONG   NUMBER(18)                             NOT NULL,
  C_ID       NUMBER(18)                             NOT NULL,   /*内部id*/
  C_NAME     VARCHAR2(30 BYTE)                      NOT NULL,   /*名称*/
  C_DEPART   NUMBER(18)                             NOT NULL,   /*部门*/
  C_COMMENT  VARCHAR2(255 BYTE)                         NULL    /*摘要*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
CREATE TABLE T_HRSAL_TEMPLATEDT
(
  C_BELONG   NUMBER(18)                             NOT NULL,
  C_HD       NUMBER(18)                             NOT NULL,   /*模板id*/
  C_NO       NUMBER(4)                              NOT NULL,   /*序号1-9999*/
  C_ITEM     NUMBER(18)                             NOT NULL,   /*项目*/
  C_PERSON   NUMBER(18)                             NOT NULL,   /*人员*/
  C_AMOUNT   NUMBER(18,4)                           NOT NULL,   /*缺省值(非公式和固定项目)*/
  C_COMMENT  VARCHAR2(255 BYTE)                         NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;
--关键字
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT PK_HRSAL_TEMPLATE PRIMARY KEY (C_BELONG, C_ID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT PK_HRSAL_TEMPLATEDT PRIMARY KEY (C_BELONG, C_HD, C_NO, C_ITEM));
--唯一性，每个模板中每人的序号唯一(C_PERSON, C_NO)
--外键(部门，HD，人员，项目)
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT FK_HRSAL_TEMPLATE_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG, C_DEPARTMENTID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT FK_HRSAL_TEMPLATEDT_HD FOREIGN KEY (C_BELONG, C_HD) REFERENCES T_HRSAL_TEMPLATE (C_BELONG, C_ID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT FK_HRSAL_TEMPLATEDT_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_TEMPLATEDT ADD (CONSTRAINT FK_HRSAL_TEMPLATEDT_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG, C_ID));
--模板序列号
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
--验证：公式项目中引用的项目必须同时全部包含在模板内。
--      定义数值的项目必须是无公式、有固定项目的必须和当前有效的项目值相等。
--      部门人员不在当前T_HRSAL_DEPTPSN中提示警告信息。
--------------------------------------------------------------------------------
--工资发放表：T_HRSAL_FACT & T_HRSAL_FACTDT
EXEC SP_DROPTABLE('T_HRSAL_FACT');
EXEC SP_DROPTABLE('T_HRSAL_FACTHD');
EXEC SP_DROPTABLE('T_HRSAL_FACTDT');
--
EXEC SP_DROPTABLE('T_HRSAL_FACT_HD');
EXEC SP_DROPTABLE('T_HRSAL_FACT_DT');
CREATE TABLE T_HRSAL_FACT
(
  C_BELONG     NUMBER(18)                       NOT NULL,
  C_NO         VARCHAR2(30 BYTE)                NOT NULL,    /*凭证号*/
  C_DEPART     NUMBER(18)                       NOT NULL,    /*发薪部门*/
  C_DATE       DATE                          	NOT NULL,    /*所属日期*/ 
  C_ISSUEDATE  DATE                             NOT NULL,    /*发放日期*/
  C_ISSUETYPE  VARCHAR2(1 BYTE)                 NOT NULL,    /*发放方式(转、现、物)*/
  C_SUMMARY    VARCHAR2(255 BYTE)                   NULL,    /*摘要*/
  C_ISSUEBY    NUMBER(18)                       NOT NULL,    /*经办*/
  C_COMMENT    VARCHAR2(255 BYTE)                   NULL     /*备注*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
COMMENT ON COLUMN T_HRSAL_FACT.C_ISSUETYPE IS '现(C)，转(T)，物(G)';
CREATE TABLE T_HRSAL_FACTDT
(
  C_BELONG   NUMBER(18)                         NOT NULL,
  C_HDNO     VARCHAR2(30 BYTE)                  NOT NULL,   /*凭证号*/
  C_NO       NUMBER(4)                          NOT NULL,   /*序号1-9999*/
  C_ITEM     NUMBER(18)                         NOT NULL,   /*项目*/
  C_PERSON   NUMBER(18)                         NOT NULL,   /*人员*/
  C_AMOUNT   NUMBER(18,2)                       NOT NULL    /*数值*/
) LOGGING NOCACHE NOPARALLEL MONITORING;
--关键字
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT PK_HRSAL_FACT PRIMARY KEY (C_BELONG, C_NO));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT PK_HRSAL_FACTDT PRIMARY KEY (C_BELONG, C_HDNO, C_NO, C_ITEM));
--唯一性，每个发放中每人的序号唯一(C_PERSON, C_NO)
--外键(部门，经办，HDNO，人员，项目)
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT FK_HRSAL_FACT_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG, C_DEPARTMENTID));
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT FK_HRSAL_FACT_DOPSN FOREIGN KEY (C_BELONG, C_ISSUEBY) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_HD FOREIGN KEY (C_BELONG, C_HDNO) REFERENCES T_HRSAL_FACT (C_BELONG, C_NO));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG, C_ID));
--发放方式限制
ALTER TABLE T_HRSAL_FACT ADD (CONSTRAINT CHK_HRSAL_FACT_TYPE CHECK (C_ISSUETYPE IN ('C','T','G')));


------------------------------------------------
-- 项目有效性验证
create or replace trigger trg_HRSAL_ITEM_validate
  before update of c_ondate, c_downdate on t_HRSAL_ITEM
  for each row

when (new.c_ondate <> old.c_ondate or new.c_downdate <> old.c_downdate)
declare
  v_tmp             number(18);
begin
  --新的启用日期前不能存在固定项目表和工资发放表的项目使用(提示出错信息的用户关键字)
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
                              '工资项目: ' || :Old.c_no ||
                              '，新的启用日期前存在业务，不能修改启用日期！');
    end if;
  end if;
  --失效日之后不能存在固定项目表和工资发放表的项目使用(提示出错信息的用户关键字)
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
                                '工资项目: ' || :Old.c_no ||
                                '，新的注销日期后存在业务，不能修改注销日期！');
      end if;
    end if;
  end if;
end;
/

----------------------------------------------------------------------
-- 固定项目的验证
CREATE OR REPLACE PROCEDURE SP_HRSAL_FIXONLINE(BRANCHID   NUMBER,
                                               DEPTNO     VARCHAR,
                                               OP_TYPE    VARCHAR,
                                               OP_PSNNO   VARCHAR,
                                               OP_ITEMNO  VARCHAR,
                                               OP_DATE    VARCHAR,
                                               OP_VAL     NUMBER,
                                               OP_LOGPSN  VARCHAR,
                                               OP_LOGDATE VARCHAR)
--/*参数
  --      branchid   机构id
  --      deptno     部门编号
  --      op_type    操作类别（1增加项目，2终止项目，变更项目=前台2+1，恢复项目=前台1）
  --      op_psnno   人员工号
  --      op_itemno  项目编号
  --      op_date    操作日期
  --      op_val     项目值
  --      op_logpsn  经办人工号
  --      op_logdate 经办日期
  --*/
 AS
  V_DEPTID       NUMBER(18); --deptno部门ID
  V_LOGPSNID     NUMBER(18); --op_logpsn经办人ID
  V_OPPSNID      NUMBER(18); --op_psnno人员ID
  V_LAST_HRCLOSE DATE; --最后人事账日
  V_ITEMID       NUMBER(18); --op_itemno项目id
  V_ONDATE       DATE;
  V_DOWNDATE     DATE;
  V_DATE         DATE;
  V_FACT_AMOUNT  NUMBER(18, 2);
  V_REFNO        VARCHAR2(30);
  V_NO           NUMBER(4);
  V_MONTH        CHAR(2);
BEGIN
  --判断部门deptno是否在操作日期op_date合法，取出合法的deptnoid
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
                              '指定部门编号:' || DEPTNO || '在操作日期无效!');
  END;
  --判断经办人op_logpsn是否在经办日期op_logdate合法，取出合法的op_logpsnid
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
                              '指定经办人工号:' || OP_LOGPSN || '在经办日期无效!');
  END;
  --判断人员工号op_psnno是否在操作日期op_date合法，取出合法的op_psnnoid
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
                              '指定人员工号:' || OP_PSNNO || '在操作日期无效!');
  END;
  --判断op_date是否小于最后开帐日，op_date必须大于等于最后人事开帐日
  BEGIN
    SELECT MAX(NVL(C_DATE, TO_DATE('1901/01/01', 'yyyy/mm/dd')))
      INTO V_LAST_HRCLOSE
      FROM T_HR_CLOSE
     WHERE C_BELONG = BRANCHID;
    IF TO_DATE(OP_DATE, 'yyyy/mm/dd') < V_LAST_HRCLOSE THEN
      RAISE_APPLICATION_ERROR(-20003,
                              '操作日期:' || OP_DATE || '必须大于等于人事最后开账日:' ||
                              TO_CHAR(V_LAST_HRCLOSE, 'yyyy/mm/dd'));
    END IF;
  END;
  --验证项目编号op_itemno是否在操作日期op_date-9999/12/31在项目库T_HRSAL_ITEM中合法，取出合法的op_itemnoid
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
                              '项目编号:' || OP_ITEMNO || '在项目库中无效!');
  END;
  BEGIN
    IF OP_TYPE = '1' THEN
      --1增加项目
      BEGIN
        --判断该部门、该人、该项目，该时段op_date-9999/12/31在本表T_HRSAL_FIXONLINE中是否有同项目交叉重复，提示重复项目的起止日期等信息；
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
                                        '部门:' || DEPTNO || ', 人员:' ||
                                        OP_PSNNO || ', 项目:' || OP_ITEMNO ||
                                        ', 操作日期:' || OP_DATE || '与' ||
                                        to_char(V_ONDATE, 'yyyy/mm/dd') || '生效,' || to_char(V_DOWNDATE, 'yyyy/mm/dd') ||
                                        '失效的固定项目交叉!');
              END IF;
            END LOOP;
            CLOSE CUR_PSN_FIXONLINE;
          END;
        END;
        --判断该部门、该人、该项目，该时段op_date-9999/12/31在工资发放表T_HRSAL_FACT&DT中是否是有非等值项目发放，提示工资日期凭证号、月份、发放日、序号
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
                                        '部门:' || DEPTNO || ', 人员:' ||
                                        OP_PSNNO || ', 项目:' || OP_ITEMNO ||
                                        ', 操作日期:' || OP_DATE ||
                                        '与工资发放记录中的发放凭证号:' || V_REFNO ||
                                        ', 序号:' || V_NO || ', 所属日期:' ||
                                        V_MONTH || ', 发放日期:' ||
                                        TO_CHAR(V_DATE, 'yyyy/mm/dd') ||
                                        '中的实际发放金额不一致!');
              END IF;
            END LOOP;
            CLOSE CUR_FACT;
          END;
        END;
        --判断该部门、该人、该项目，该时段op_date-9999/12/31在本表T_HRSAL_FIXONLINE中是否有同项目接续
        --判断是否存在接续项目down_date = op_date - 1，并且项目值相同
        --接续项目 更新down_date = 9999/12/31
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
            RAISE_APPLICATION_ERROR(-20003, '固定项目表中发生异常!');
          END IF;
        END;
      END;
    ELSIF OP_TYPE = '2' THEN
      --2终止项目
      --终止项目不验证工资发放表
      BEGIN
        --验证该部门、该人、该项目是否在操作日期op_date-9999/12/31合法（被包含），取出该合法项目的on_date和op_itemnoid
        --注意：错误提示必须：注明部门、人员、项目,日期等全面的错误原因，让用户完全理解所发生的错误。
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
                                    '操作日期:' || OP_DATE || '时不存在部门:' ||
                                    DEPTNO || ', 人员:' || OP_PSNNO ||
                                    ', 项目:' || OP_ITEMNO);
        END;
        BEGIN
          --判断是否删除项目
          --on_date=op_date则删除该部门人员项目值，否则更新down_date = op_date - 1
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
      RAISE_APPLICATION_ERROR(-20003, '操作类型参数错误!');
    END IF;
  END;
END;
/

---------------------------------------------------------
-- 验证实发有效性
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
  -- OP_TYPE : '1' 增加, '2' 修改, '3' 删除
  V_COUNT   NUMBER;
  V_FORMULA VARCHAR2(128);
  V_NAME    VARCHAR2(30);
BEGIN
  -- 验证人员没有重复
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
                              '第' || OP_NO || '行发放人员' || WORKERID ||
                              '在本次发放中重复!');
    END IF;
  END;

  -- 验证公式项目的数值等价性
  -- 有固定项目先验证有没有公式,没有公式必须和当前有效的项目值相等
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
                                '第' || OP_NO || '行固定项目' || V_NAME || '的值为' ||
                                V_COUNT || '与实际发放值不一致!');
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

