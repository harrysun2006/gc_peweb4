SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF

CREATE OR REPLACE PROCEDURE SP_DROPTABLE(NAME IN VARCHAR2) 
IS
cnt NUMBER := 0;
BEGIN
SELECT COUNT(*) INTO cnt FROM USER_TABLES WHERE TABLE_NAME = NAME;
IF cnt = 1 THEN
  EXECUTE IMMEDIATE 'ALTER TABLE ' || NAME || ' DROP PRIMARY KEY CASCADE';
  EXECUTE IMMEDIATE 'DROP TABLE ' || NAME || ' CASCADE CONSTRAINTS';
END IF;
EXCEPTION
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20001, 'AN ERROR WAS ENCOUNTERED - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
END SP_DROPTABLE;
/

CREATE OR REPLACE PROCEDURE SP_DROPSEQ(NAME IN VARCHAR2) 
IS
cnt NUMBER := 0;
BEGIN
SELECT COUNT(*) INTO cnt FROM USER_SEQUENCES WHERE SEQUENCE_NAME = NAME;
IF cnt = 1 THEN
  EXECUTE IMMEDIATE 'DROP SEQUENCE ' || NAME;
END IF;
EXCEPTION
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20001, 'AN ERROR WAS ENCOUNTERED - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
END SP_DROPSEQ;
/

CREATE OR REPLACE PROCEDURE SP_DROPTRG(NAME IN VARCHAR2) 
IS
cnt NUMBER := 0;
BEGIN
SELECT COUNT(*) INTO cnt FROM USER_OBJECTS WHERE OBJECT_NAME = NAME AND OBJECT_TYPE = 'TRIGGER';
IF cnt = 1 THEN
  EXECUTE IMMEDIATE 'DROP TRIGGER ' || NAME;
END IF;
EXCEPTION
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20001, 'AN ERROR WAS ENCOUNTERED - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
END SP_DROPTRG;
/