SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

EXEC SP_DROPTABLE('T_HRSAL_TEMPLATE');

CREATE TABLE T_HRSAL_TEMPLATE
(
  C_ID       NUMBER(18)                             NOT NULL,
  C_BELONG   NUMBER(18)                             NOT NULL,
  C_DEPART   NUMBER(18)                             NOT NULL,
  C_ITEM     NUMBER(18)                             NOT NULL,
  C_AMOUNT  NUMBER(18,2)                            NOT NULL,
  C_COMMENT  VARCHAR2(255 BYTE)                         NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;

CREATE UNIQUE INDEX IDX_HRSAL_TEMPLATEID ON T_HRSAL_TEMPLATE (C_ID) LOGGING NOPARALLEL;
CREATE INDEX IDX_HRSAL_TEMPLATE_DEPT ON T_HRSAL_TEMPLATE (C_BELONG, C_DEPART) LOGGING NOPARALLEL;
CREATE INDEX IDX_HRSAL_TEMPLATE_ITEM ON T_HRSAL_TEMPLATE (C_BELONG, C_ITEM) LOGGING NOPARALLEL;
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT PK_HRSAL_TEMPLATE PRIMARY KEY (C_BELONG, C_DEPART, C_ITEM));
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT FK_HRSAL_TEMPLATE_DEPT FOREIGN KEY (C_BELONG, C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
ALTER TABLE T_HRSAL_TEMPLATE ADD (CONSTRAINT FK_HRSAL_TEMPLATE_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG,C_ID));

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