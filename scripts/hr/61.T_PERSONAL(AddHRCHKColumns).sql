SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

--考勤组成员定义
ALTER TABLE T_PERSONAL DROP CONSTRAINT FK_PERSONAL_HRCHKGROUP;
ALTER TABLE T_PERSONAL DROP (C_HRCHKGROUPID);
ALTER TABLE T_PERSONAL ADD (C_HRCHKGROUPID NUMBER(18));
--考勤组外键
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_HRCHKGROUP FOREIGN KEY (C_BELONG, C_HRCHKGROUPID) REFERENCES T_HRCHK_GROUP (C_BELONG,C_ID));
