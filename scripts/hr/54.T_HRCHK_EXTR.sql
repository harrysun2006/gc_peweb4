SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

--考勤项目表-2加班项目
EXEC SP_DROPTABLE('T_HRCHK_EXTR');
CREATE TABLE T_HRCHK_EXTR
(
  C_BELONG    NUMBER(18)                        NOT NULL,
  C_ID        NUMBER(18)                        NOT NULL,
  C_NO        VARCHAR2(16 BYTE)                 NOT NULL, /*项目标号*/
  C_NAME      VARCHAR2(30 BYTE)                 NOT NULL, /*项目名称*/
  C_COMMENT   VARCHAR2(255 BYTE)                    NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;
--关键字
ALTER TABLE T_HRCHK_EXTR ADD (CONSTRAINT PK_HRCHK_EXTR PRIMARY KEY (C_BELONG, C_ID));
EXEC SP_DROPSEQ('SEQ_HRCHK_EXTR');
CREATE SEQUENCE SEQ_HRCHK_EXTR START WITH 1 MAXVALUE 999999999999999999999999999 MINVALUE 1 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE TRIGGER TRG_HRCHK_EXTRID
BEFORE INSERT ON T_HRCHK_EXTR
FOR EACH ROW
DECLARE NEXT_ID NUMBER;
BEGIN
  SELECT SEQ_HRCHK_EXTR.NEXTVAL INTO NEXT_ID FROM T_SEQFRO;
  :NEW.C_ID := NEXT_ID;
END;
/
--唯一性关键字
CREATE UNIQUE INDEX IDX_HRCHK_EXTRNAME ON T_HRCHK_EXTR (C_BELONG,C_NAME) LOGGING NOPARALLEL;
CREATE UNIQUE INDEX IDX_HRCHK_EXTRNO ON T_HRCHK_EXTR (C_BELONG,C_NO) LOGGING NOPARALLEL;
--外键
ALTER TABLE T_HRCHK_EXTR ADD (CONSTRAINT FK_HRCHKEXTR_BRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
