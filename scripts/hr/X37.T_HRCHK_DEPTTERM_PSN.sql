SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

EXEC SP_DROPTABLE('T_HRCHK_DEPTTERM_PSN');
--考勤组管理
CREATE TABLE T_HRCHK_DEPTTERM_PSN
(
  C_BELONG   NUMBER(18)                         NOT NULL,
  C_PERSON   NUMBER(18)                         NOT NULL, /*人员*/
  C_DEPART   NUMBER(18)                         NOT NULL, /*部门*/
  C_OFFICE   VARCHAR2(40 BYTE)                      NULL, /*科室*/
  C_COMMENT  VARCHAR2(255 BYTE)                     NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;

CREATE INDEX IDX_HRCHK_DTP_DEPT ON T_HRCHK_DEPTTERM_PSN (C_BELONG, C_DEPART) LOGGING NOPARALLEL;
CREATE INDEX IDX_HRCHK_DTP_TERM ON T_HRCHK_DEPTTERM_PSN (C_BELONG, C_DEPART, C_OFFICE) LOGGING NOPARALLEL;
CREATE UNIQUE INDEX IDX_HRCHK_DEPTTERM_PSN ON T_HRCHK_DEPTTERM_PSN (C_BELONG, C_DEPART, C_OFFICE, C_PERSON) LOGGING NOPARALLEL;
ALTER TABLE T_HRCHK_DEPTTERM_PSN ADD (CONSTRAINT PK_HRCHK_DEPTTERM_PSN PRIMARY KEY (C_BELONG, C_PERSON));
ALTER TABLE T_HRCHK_DEPTTERM_PSN ADD (CONSTRAINT FK_HRCHK_DEPTTERM_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
ALTER TABLE T_HRCHK_DEPTTERM_PSN ADD (CONSTRAINT FK_HRCHK_DEPTTERM_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));
ALTER TABLE T_HRCHK_DEPTTERM_PSN ADD (CONSTRAINT FK_HRCHK_DEPTTERM_TERM FOREIGN KEY (C_BELONG, C_DEPART, C_OFFICE) REFERENCES T_DEPARTTERM (C_BELONG,C_DEPART,C_NAME));
