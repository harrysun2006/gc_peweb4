SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

EXEC SP_DROPTABLE('T_HRSAL_VARONLINE');

CREATE TABLE T_HRSAL_VARONLINE
(
  C_ID        NUMBER(18)                            NOT NULL,
  C_BELONG    NUMBER(18)                            NOT NULL,
  C_DEPART    NUMBER(18)                            NOT NULL,
  C_PERSON    NUMBER(18)                            NOT NULL,
  C_ITEM      NUMBER(18)                            NOT NULL,
  C_ONDATE    DATE                                  NOT NULL,
  C_DOWNDATE  DATE                                  NOT NULL,
  C_RATE      NUMBER(18,2)                          NOT NULL,
  C_COMMENT   VARCHAR2(255 BYTE)                    NULL
) LOGGING NOCACHE NOPARALLEL MONITORING;

CREATE UNIQUE INDEX IDX_HRSAL_VARONLINE ON T_HRSAL_VARONLINE (C_BELONG, C_DEPART, C_PERSON, C_ITEM, C_DOWNDATE) LOGGING NOPARALLEL;
CREATE UNIQUE INDEX IDX_HRSAL_VARONLINEID ON T_HRSAL_VARONLINE (C_ID) LOGGING NOPARALLEL;
CREATE INDEX IDX_HRSAL_VARONLINE_PSN ON T_HRSAL_VARONLINE (C_BELONG, C_DEPART, C_PERSON) LOGGING NOPARALLEL;
CREATE INDEX IDX_HRSAL_VARONLINE_ITEM ON T_HRSAL_VARONLINE (C_BELONG, C_ITEM) LOGGING NOPARALLEL;
ALTER TABLE T_HRSAL_VARONLINE ADD (CONSTRAINT PK_HRSAL_VARONLINE PRIMARY KEY (C_BELONG, C_DEPART, C_PERSON, C_ITEM, C_ONDATE));
ALTER TABLE T_HRSAL_VARONLINE ADD (CONSTRAINT FK_HRSAL_VARONLINE_DEPTPSN FOREIGN KEY (C_BELONG, C_DEPART, C_PERSON) REFERENCES T_HRSAL_DEPTPSN (C_BELONG,C_DEPART,C_PERSON));
ALTER TABLE T_HRSAL_VARONLINE ADD (CONSTRAINT FK_HRSAL_VARONLINE_ITEM FOREIGN KEY (C_BELONG, C_ITEM) REFERENCES T_HRSAL_ITEM (C_BELONG,C_ID));
ALTER TABLE T_HRSAL_VARONLINE ADD (CONSTRAINT FK_HRSAL_VARONLINE_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG,C_PERSONALID));

EXEC SP_DROPSEQ('SEQ_HRSAL_VARONLINE');
CREATE SEQUENCE SEQ_HRSAL_VARONLINE START WITH 1 MAXVALUE 999999999999999999999999999 MINVALUE 1 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE TRIGGER TRG_HRSAL_VARONLINEID
BEFORE INSERT ON T_HRSAL_VARONLINE
FOR EACH ROW
DECLARE NEXT_ID NUMBER;
BEGIN
  SELECT SEQ_HRSAL_VARONLINE.NEXTVAL INTO NEXT_ID FROM T_SEQFRO;
  :NEW.C_ID := NEXT_ID;
END;
/