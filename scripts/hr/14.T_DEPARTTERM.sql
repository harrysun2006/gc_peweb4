--部门处室表(新)
EXEC SP_DROPTABLE('T_DEPARTTERM');
CREATE TABLE T_DEPARTTERM
(
  C_BELONG   NUMBER(18)                         NOT NULL,
  C_DEPART   NUMBER(18)                         NOT NULL,
  C_NAME     VARCHAR2(40 BYTE)                  NOT NULL,
  C_MANDUTY  VARCHAR2(400 BYTE)                     NULL,
  C_LEADER   NUMBER(18)                             NULL,
  C_COMMENT  VARCHAR2(255 BYTE)                     NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;
--关键字
ALTER TABLE T_DEPARTTERM ADD (CONSTRAINT PK_DEPARTTERM PRIMARY KEY (C_BELONG, C_DEPART, C_NAME));
--部门外键
ALTER TABLE T_DEPARTTERM ADD (CONSTRAINT FK_DEPARTTERM FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
--按部门索引
CREATE INDEX IDX_DEPARTTERM_DEPT ON T_DEPARTTERM (C_BELONG, C_DEPART) LOGGING NOPARALLEL;