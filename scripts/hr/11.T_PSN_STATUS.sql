--人员状态变动表(新)
EXEC SP_DROPTABLE('T_PSN_STATUS');
CREATE TABLE T_PSN_STATUS
(
  C_BELONG          NUMBER(18)                      NULL,
  C_PERSON          NUMBER(18)                      NULL,
  C_UPGRADE_REASON  VARCHAR2(20 BYTE)               NULL,
  C_TYPE            VARCHAR2(10 BYTE)           NOT NULL,
  C_POSITION        VARCHAR2(1 BYTE)                NULL,
  C_REGBELONG       VARCHAR2(20 BYTE)               NULL,
  C_PARTY           VARCHAR2(12 BYTE)               NULL,
  C_GRADE           VARCHAR2(40 BYTE)               NULL,
  C_SCHOOLHISTORY   VARCHAR2(60 BYTE)               NULL,
  C_ONDATE          DATE                            NULL,
  C_DOWNDATE        DATE                        NOT NULL,
  C_UPGRADER        NUMBER(18)                  NOT NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;
--关键字
ALTER TABLE T_PSN_STATUS ADD (CONSTRAINT PK_PSN_STATUS PRIMARY KEY (C_BELONG, C_PERSON, C_ONDATE));
--人员外键
ALTER TABLE T_PSN_STATUS ADD (ONSTRAINT FK_PSN_STATUS FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));
--按人员索引
CREATE INDEX IDX_PSN_STATUS ON T_PSN_STATUS (C_BELONG, C_PERSON) LOGGING NOPARALLEL;