-- ADD FK of table references (Parent tables)
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_DEGREE FOREIGN KEY (C_BELONG,C_DEGREE) REFERENCES T_PSN_DEGREE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_DEPT FOREIGN KEY (C_BELONG,C_DEPART) REFERENCES T_DEPARTMENT (C_BELONG,C_DEPARTMENTID));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_GRADE FOREIGN KEY (C_BELONG,C_GRADE) REFERENCES T_PSN_GRADE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_GRADUATE FOREIGN KEY (C_BELONG,C_GRADUATE) REFERENCES T_PSN_GRADUATE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_MSTATE FOREIGN KEY (C_BELONG,C_MARRYSTATE) REFERENCES T_PSN_MSTATE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_NPLACE FOREIGN KEY (C_BELONG,C_NATIVEPLACE) REFERENCES T_PSN_NPLACE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_PARTY FOREIGN KEY (C_BELONG,C_PARTY) REFERENCES T_PSN_PARTY (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_PEOPLE FOREIGN KEY (C_BELONG,C_PEOPLE) REFERENCES T_PSN_PEOPLE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_REGBELONG FOREIGN KEY (C_BELONG,C_REGBELONG) REFERENCES T_PSN_REGBELONG (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_SCHOOLING FOREIGN KEY (C_BELONG,C_SCHOOLHISTORY) REFERENCES T_PSN_SCHOOLING (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_SPEC FOREIGN KEY (C_BELONG,C_SPECIFICATION) REFERENCES T_PSN_SPEC (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PERSONAL_TYPE FOREIGN KEY (C_BELONG,C_TYPE) REFERENCES T_PSN_TYPE (C_BELONG,C_NAME));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PSNBUS FOREIGN KEY (C_BELONG,C_BUSID) REFERENCES T_EQUIPMENT (C_BELONG,C_EQUID));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_PSNLINE FOREIGN KEY (C_BELONG,C_LINEID) REFERENCES T_RUNNING_LINE (C_BELONG,C_ID));
ALTER TABLE T_PERSONAL ADD (CONSTRAINT FK_TPERSONALBRANCH FOREIGN KEY (C_BELONG) REFERENCES T_BRANCH (C_BRANCHID));
 
-- ADD FK of table is referenced by (Child tables)
ALTER TABLE T_RUNNING_BUSPARK ADD (CONSTRAINT FK_BUSPARK_ATTEMPER FOREIGN KEY (C_BELONG, C_ATTEMPER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_ELE_TMP ADD (CONSTRAINT FK_ELETMP_CHCKPSN FOREIGN KEY (C_BELONG, C_CHCKPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_ELE_TMP ADD (CONSTRAINT FK_ELETMP_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_ELE_TMP ADD (CONSTRAINT FK_ELE_INPUTPSN FOREIGN KEY (C_BELONG, C_INPUTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_EVENT_LOG ADD (CONSTRAINT FK_EVENT_LOG FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRCHK_DEPTTERM_PSN ADD (CONSTRAINT FK_HRCHK_DEPTTERM_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRCHK_FACTDT ADD (CONSTRAINT FK_HRCHK_FACTDT_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_DEPTPSN ADD (CONSTRAINT FK_HRSAL_DEPTPSN_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_FACTDT ADD (CONSTRAINT FK_HRSAL_FACTDT_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_FIXONLINE ADD (CONSTRAINT FK_HRSAL_FIXONLINE_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_HRSAL_VARONLINE ADD (CONSTRAINT FK_HRSAL_VARONLINE_PSN FOREIGN KEY (C_BELONG, C_PERSON) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_LINE ADD (CONSTRAINT FK_LINE_ATTEMPER FOREIGN KEY (C_BELONG, C_ATTEMPER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_LINE ADD (CONSTRAINT FK_LINE_RESPONSOR FOREIGN KEY (C_BELONG, C_RESPONSOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_OILCARD ADD (CONSTRAINT FK_OILCARDDRIVER FOREIGN KEY (C_BELONG, C_DRIVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_OILCARD_INPUT ADD (CONSTRAINT FK_OILCARDINPUTPERSONAL FOREIGN KEY (C_BELONG, C_INPUTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_OILCARD_OUTPUT ADD (CONSTRAINT FK_OILCARDOUTPUTDRIVER FOREIGN KEY (C_BELONG, C_DRIVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_OILCARD_OUTPUT ADD (CONSTRAINT FK_OILCARDOUTPUTINPUTER FOREIGN KEY (C_BELONG, C_INPUTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_ONLINE ADD (CONSTRAINT FK_ONLINEDOWNINSTALLOR FOREIGN KEY (C_BELONG, C_DOWNINSTALLOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PHASE ADD (CONSTRAINT FK_PHASEMANAGER FOREIGN KEY (C_BELONG, C_MANAGER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PHASE ADD (CONSTRAINT FK_PHASEPLANER FOREIGN KEY (C_BELONG, C_PLANER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PSN_ONLINE ADD (CONSTRAINT FK_PSNON_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PSN_ONLINE ADD (CONSTRAINT FK_PSNON_PSN FOREIGN KEY (C_BELONG, C_ONLINEPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PSN_STATUS ADD (CONSTRAINT FK_PSNSTA_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PSN_STATUS ADD (CONSTRAINT FK_PSNSTA_PSN FOREIGN KEY (C_BELONG, C_STATUSPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_PSN_ONLINE ADD (CONSTRAINT FK_PSN_ONLINE_PSN FOREIGN KEY (C_BELONG, C_PERSONALID) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_DAILY ADD (CONSTRAINT FK_RUNNINGDAILY_DRIVER FOREIGN KEY (C_BELONG, C_DRIVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_DAILY ADD (CONSTRAINT FK_RUNNINGDAILY_SERVER FOREIGN KEY (C_BELONG, C_SERVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_TURN ADD (CONSTRAINT FK_RUNTDRIVER FOREIGN KEY (C_BELONG, C_DRIVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_TURN ADD (CONSTRAINT FK_RUNTSERVER FOREIGN KEY (C_BELONG, C_SERVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_SHIFTROOM ADD (CONSTRAINT FK_SHIFTROOM_ATTEMPER FOREIGN KEY (C_BELONG, C_ATTEMPER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_STATION ADD (CONSTRAINT FK_STATION_RESPONSOR FOREIGN KEY (C_BELONG, C_RESPONSOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_SUPERVISE ADD (CONSTRAINT FK_SUPERVISESUPPER FOREIGN KEY (C_BELONG, C_SUPERVISOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_EQUFIT ADD (CONSTRAINT FK_TEQUFITCNTER FOREIGN KEY (C_BELONG, C_CONNECTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_EQUIPMENT ADD (CONSTRAINT FK_TEQUIPMENTEQURSP FOREIGN KEY (C_BELONG, C_EQURESPONSOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_FITTINGS ADD (CONSTRAINT FK_TFITRSP FOREIGN KEY (C_BELONG, C_FITRESPONSOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_BASEIN_H ADD (CONSTRAINT FK_TKT_BASEIN_H_ACTOR FOREIGN KEY (C_BELONG, C_CENTERACTOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_BASEIN_H ADD (CONSTRAINT FK_TKT_BASEIN_H_DOPSN FOREIGN KEY (C_BELONG, C_BASEDOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_CENTERIN_H ADD (CONSTRAINT FK_TKT_CENTERIN_H_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_CLOSEDAILY ADD (CONSTRAINT FK_TKT_CLOSEDAILY_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERCHECK ADD (CONSTRAINT FK_TKT_SERVERCHECK_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERCHECK ADD (CONSTRAINT FK_TKT_SERVERCHECK_DRIVER FOREIGN KEY (C_BELONG, C_DRIVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERCHECK ADD (CONSTRAINT FK_TKT_SERVERCHECK_INPUTER FOREIGN KEY (C_BELONG, C_INPUTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERCHECK ADD (CONSTRAINT FK_TKT_SERVERCHECK_REVIEWER FOREIGN KEY (C_BELONG, C_REVIEWER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERCHECK ADD (CONSTRAINT FK_TKT_SERVERCHECK_SERVER FOREIGN KEY (C_BELONG, C_SERVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERDEL_H ADD (CONSTRAINT FK_TKT_SERVERDEL_H_DOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERIN_H ADD (CONSTRAINT FK_TKT_SERVERIN_H_ACTOR FOREIGN KEY (C_BELONG, C_BASEACTOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVERIN_H ADD (CONSTRAINT FK_TKT_SERVERIN_H_SERVER FOREIGN KEY (C_BELONG, C_SERVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVEROUT_H ADD (CONSTRAINT FK_TKT_SERVEROUT_H_ACTOR FOREIGN KEY (C_BELONG, C_BASEACTOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TKT_SERVEROUT_H ADD (CONSTRAINT FK_TKT_SERVEROUT_H_SERVER FOREIGN KEY (C_BELONG, C_SERVER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_ONLINE ADD (CONSTRAINT FK_TONLINEINSTALLER FOREIGN KEY (C_BELONG, C_ONLINEINSTALLER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_ONLINE ADD (CONSTRAINT FK_TONLINERESPONSOR FOREIGN KEY (C_BELONG, C_ONLINERESPONSOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PM_WORKSHEETS ADD (CONSTRAINT FK_TPM_WORKSHEETGETTERS FOREIGN KEY (C_BELONG, C_GETTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PROJECT ADD (CONSTRAINT FK_TPROJECTACPTTER FOREIGN KEY (C_BELONG, C_ACCEPTOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PROJECT ADD (CONSTRAINT FK_TPROJECTINITOR FOREIGN KEY (C_BELONG, C_INITATOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PROJECT ADD (CONSTRAINT FK_TPROJECTMANAGER FOREIGN KEY (C_BELONG, C_MANAGER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PROJECT ADD (CONSTRAINT FK_TPROJECTPLANACPTTER FOREIGN KEY (C_BELONG, C_PLAN_ACCEPTOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_PROJECT ADD (CONSTRAINT FK_TPROJECTPLANSUPPER FOREIGN KEY (C_BELONG, C_PLAN_SUPERVISOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_INCOME ADD (CONSTRAINT FK_TRINCOMEPSN FOREIGN KEY (C_BELONG, C_PSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_RUNNING_ANALYSYS ADD (CONSTRAINT FK_TRUNNINGANALYSYSPSN FOREIGN KEY (C_BELONG, C_PSNID) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_SECURITY_USER ADD (CONSTRAINT FK_TSECURITY_USERPSNID FOREIGN KEY (C_PSNBELONG, C_PSNID) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_SUP_INDIVIDUAL ADD (CONSTRAINT FK_TSUP_INDIVIDUALPSN FOREIGN KEY (C_BELONG, C_PSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_TRAINING ADD (CONSTRAINT FK_TTRAININGPSN FOREIGN KEY (C_BELONG, C_ORGINER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP ADD (CONSTRAINT FK_TUSEUPMANAGER FOREIGN KEY (C_BELONG, C_MANAGER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_WORKSHEET ADD (CONSTRAINT FK_TWORKSHEETGETTER FOREIGN KEY (C_BELONG, C_GETTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_WORKSHEET ADD (CONSTRAINT FK_TWORKSHEETINITOR FOREIGN KEY (C_BELONG, C_INITATOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_WORKSHEET ADD (CONSTRAINT FK_TWORKSHEETSETTLER FOREIGN KEY (C_BELONG, C_SETTLER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_WS_WORK ADD (CONSTRAINT FK_TWS_WORKWORKER FOREIGN KEY (C_BELONG, C_WORKER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_ACCDAILY ADD (CONSTRAINT FK_UADPERSONAL1 FOREIGN KEY (C_BELONG, C_REVIEWER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_ACCDAILY ADD (CONSTRAINT FK_UADPERSONAL2 FOREIGN KEY (C_BELONG, C_ACTOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_BASEDAILY ADD (CONSTRAINT FK_UBDPERSONAL FOREIGN KEY (C_BELONG, C_INPUTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUPBASE ADD (CONSTRAINT FK_UBPERSONAL FOREIGN KEY (C_BELONG, C_MANAGER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_TMPDAILY ADD (CONSTRAINT FK_UTDAILYBASEPSN FOREIGN KEY (C_BELONG, C_BASEPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_TMPDAILY ADD (CONSTRAINT FK_UTDAILYCONPSN FOREIGN KEY (C_BELONG, C_CONPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_TMPDAILY ADD (CONSTRAINT FK_UTDAILYUSECHECK FOREIGN KEY (C_BELONG, C_USECHECK) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_TMPDAILY ADD (CONSTRAINT FK_UTDAILYUSEPSN FOREIGN KEY (C_BELONG, C_USEPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_WATING ADD (CONSTRAINT FK_UWTDOPSN FOREIGN KEY (C_BELONG, C_DOPSN) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_USEUP_WATING ADD (CONSTRAINT FK_UWTINPUTER FOREIGN KEY (C_BELONG, C_INPUTER) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
ALTER TABLE T_WS_WATING ADD (CONSTRAINT FK_WSWTPERSONAL FOREIGN KEY (C_BELONG, C_OPERATOR) REFERENCES T_PERSONAL (C_BELONG, C_PERSONALID));
