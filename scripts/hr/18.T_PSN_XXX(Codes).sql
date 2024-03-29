--人事基本代码表(新):
--T_PSN_DEGREE
EXEC SP_DROPTABLE('T_PSN_DEGREE');
CREATE TABLE T_PSN_DEGREE
(
  C_BELONG  NUMBER(18)					NOT NULL,
  C_NAME    VARCHAR2(60 BYTE)		NOT NULL,
  C_NO      NUMBER(18,2)				DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)						DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_DEGREE ADD (CONSTRAINT PK_PSN_DEGREE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_DEGREE ADD (CONSTRAINT FK_PSN_DEGREE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_DEGREE ON T_PSN_DEGREE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_DEGREE_NO ON T_PSN_DEGREE (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_GRADE
EXEC SP_DROPTABLE('T_PSN_GRADE');
CREATE TABLE T_PSN_GRADE
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(40 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_GRADE ADD (CONSTRAINT PK_PSN_GRADE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_GRADE ADD (CONSTRAINT FK_PSN_GRADE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_GRADE ON T_PSN_GRADE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_GRADE_NO ON T_PSN_GRADE (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_GRADUATE
EXEC SP_DROPTABLE('T_PSN_GRADUATE');
CREATE TABLE T_PSN_GRADUATE
(
  C_BELONG  NUMBER(18)					NOT NULL,
  C_NAME    VARCHAR2(20 BYTE)		NOT NULL,
  C_NO      NUMBER(18,1)				DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)						DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_GRADUATE ADD (CONSTRAINT PK_PSN_GRADUATE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_GRADUATE ADD (CONSTRAINT FK_PSN_GRADUATE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_GRADUATE ON T_PSN_GRADUATE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_GRADUATE_NO ON T_PSN_GRADUATE (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_MSTATE
EXEC SP_DROPTABLE('T_PSN_MSTATE');
CREATE TABLE T_PSN_MSTATE
(
  C_BELONG  NUMBER(18)        NOT NULL,
  C_NAME    VARCHAR2(4 BYTE)  NOT NULL,
  C_NO      NUMBER(18,2)      DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)         DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_MSTATE ADD (CONSTRAINT PK_PSN_MSTATE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_MSTATE ADD (CONSTRAINT FK_PSN_MSTATE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_MSTATE ON T_PSN_MSTATE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_MSTATE_NO ON T_PSN_MSTATE (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_NPLACE
EXEC SP_DROPTABLE('T_PSN_NPLACE');
CREATE TABLE T_PSN_NPLACE
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(20 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_NPLACE ADD (CONSTRAINT PK_PSN_NPLACE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_NPLACE ADD (CONSTRAINT FK_PSN_NPLACE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_NPLACE ON T_PSN_NPLACE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_NPLACE_NO ON T_PSN_NPLACE (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_PARTY
EXEC SP_DROPTABLE('T_PSN_PARTY');
CREATE TABLE T_PSN_PARTY
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(12 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_PARTY ADD (CONSTRAINT PK_PSN_PARTY PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_PARTY ADD (CONSTRAINT FK_PSN_PARTY FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_PARTY ON T_PSN_PARTY (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_PARTY_NO ON T_PSN_PARTY (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_PEOPLE
EXEC SP_DROPTABLE('T_PSN_PEOPLE');
CREATE TABLE T_PSN_PEOPLE
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(20 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_PEOPLE ADD (CONSTRAINT PK_PSN_PEOPLE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_PEOPLE ADD (CONSTRAINT FK_PSN_PEOPLE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_PEOPLE ON T_PSN_PEOPLE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_PEOPLE_NO ON T_PSN_PEOPLE (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_REGBELONG
EXEC SP_DROPTABLE('T_PSN_REGBELONG');
CREATE TABLE T_PSN_REGBELONG
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(20 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_REGBELONG ADD (CONSTRAINT PK_PSN_REGBELONG PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_REGBELONG ADD (CONSTRAINT FK_PSN_REGBELONG FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_REGBELONG ON T_PSN_REGBELONG (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_REGBELONG_NO ON T_PSN_REGBELONG (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_SCHOOLING
EXEC SP_DROPTABLE('T_PSN_SCHOOLING');
CREATE TABLE T_PSN_SCHOOLING
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(60 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_SCHOOLING ADD (CONSTRAINT PK_PSN_SCHOOLING PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_SCHOOLING ADD (CONSTRAINT FK_PSN_SCHOOLING FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_SCHOOLING ON T_PSN_SCHOOLING (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_SCHOOLING_NO ON T_PSN_SCHOOLING (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_SPEC
EXEC SP_DROPTABLE('T_PSN_SPEC');
CREATE TABLE T_PSN_SPEC
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(60 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_SPEC ADD (CONSTRAINT PK_PSN_SPEC PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_SPEC ADD (CONSTRAINT FK_PSN_SPEC FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_SPEC ON T_PSN_SPEC (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_SPEC_NO ON T_PSN_SPEC (C_BELONG, C_NO) LOGGING NOPARALLEL;

--T_PSN_TYPE
EXEC SP_DROPTABLE('T_PSN_TYPE');
CREATE TABLE T_PSN_TYPE
(
  C_BELONG  NUMBER(18)          NOT NULL,
  C_NAME    VARCHAR2(10 BYTE)   NOT NULL,
  C_NO      NUMBER(18,2)        DEFAULT 0 NOT NULL,
  C_ACTIVE  NUMBER(1)           DEFAULT 1 NOT NULL
) LOGGING NOCACHE NOPARALLEL NOMONITORING;
--关键字
ALTER TABLE T_PSN_TYPE ADD (CONSTRAINT PK_PSN_TYPE PRIMARY KEY (C_BELONG, C_NAME));
--BRANCH外键
ALTER TABLE T_PSN_TYPE ADD (CONSTRAINT FK_PSN_TYPE FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
--按BRANCH索引
CREATE INDEX IDX_PSN_TYPE ON T_PSN_TYPE (C_BELONG) LOGGING NOPARALLEL;
--唯一索引
CREATE UNIQUE INDEX IDX_PSN_TYPE_NO ON T_PSN_TYPE (C_BELONG, C_NO) LOGGING NOPARALLEL;