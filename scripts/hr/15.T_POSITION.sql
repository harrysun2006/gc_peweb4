--岗位表(重建)
EXEC SP_DROPTABLE('T_POSITION');
CREATE TABLE T_POSITION
(
  C_BELONG                NUMBER(18)            NOT NULL,
  C_NO                    VARCHAR2(1 BYTE)      NOT NULL,
  C_NAME                  VARCHAR2(40 BYTE)     NOT NULL,
  C_RESPONSIBILITY        VARCHAR2(400 BYTE)        NULL,
  C_REQ_DESCRIPTION       VARCHAR2(400 BYTE)        NULL,
  C_REQ_CERT              VARCHAR2(400 BYTE)        NULL,
  C_REQ_PSNCOUNT          NUMBER(18)                NULL,
  C_GEN_LEVEL             NUMBER(3)                 NULL,
  C_SALARY_LEVEL          NUMBER(3)                 NULL,
  C_TECH_LEVEL            NUMBER(3)                 NULL,
  C_SECURITY_LEVEL        NUMBER(3)                 NULL,
  C_TECH_DESCRIPTION      VARCHAR2(400 BYTE)        NULL,
  C_SECURITY_DESCRIPTION  VARCHAR2(400 BYTE)        NULL,
  C_COMMENT               VARCHAR2(255 BYTE)        NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_POSITION ADD (CONSTRAINT PK_POSITION PRIMARY KEY (C_BELONG, C_NO));
--BRANCH外键
ALTER TABLE T_POSITION ADD (CONSTRAINT FK_POSITION FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_POSITION_BELONG ON T_POSITION (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_POSITIONID ON T_POSITION (C_NO) LOGGING NOPARALLEL;