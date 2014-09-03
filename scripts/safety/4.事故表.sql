--175
--v3:���׸� 2009/11/17   �¹��⳥��Ľ�
--v2:���׸� 2009/09/26   ����ʱ�᰸���ڲ��趨ȱʡֵ '-'
--v1:���׸� 2009/09/18   ȫ������
------------------------------------------------------------
--�¹ʹ��� ����
--������Ϣ��
--		t_weather�������硢�����ꡢѩ�����硢˪��������������
--		t_saf_acclevel�¹ʵȼ����ش��ش�һ�㡢��΢��������
--		t_saf_acctype�¹����������ײ��������ײ��β����ײ��������ߡ�ͬ����ߡ���ѹ��������׹����ʧ��ײ�̶�������˺���������
--		t_saf_accduty�¹����Σ�ȫ�����Ρ���Ҫ���Ρ�ͬ�����Ρ���Ҫ���Ρ����𡢴�����
--		t_saf_accobjectײ������С�ͳ������������ͳ����������Ħ�г������г��������������ˡ�������
--		t_saf_accprocessor�������
--		t_saf_accextent����̶ȣ���
--		δ���ö��	����ԭ��
--�¹ʱ�	
--		t_saf_accident 	   �¹ʹ�������
--		t_saf_accoutpsn       ���ˣ�ײ����Ա�����嵥��173��
--		t_saf_accoutpsnpay    �����⳥��ײ����Ա�����⳥��173��
--		t_saf_accoutobj	      ����ײ����������嵥
--		t_saf_accinpsn        ���ˣ�������Ա�����嵥
--		t_saf_accinpsnpay     �����⳥��������Ա�����⳥��173��
--		t_saf_accguareport    ���ձ�����
--		t_saf_accoutgua(pay)    �������������ײ����Ա������ײ��������٣�����������ٵ����������
--		t_saf_accinpsngua(pay)  �������������������Ա�����嵥��
---------------------------------------------------------------------------------------------------------
--�°洴���ű�
----------------------------------------------------
--������
create table t_weather(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,  /*����*/
  c_desc   varchar2(100),	   /*����*/
  constraint pk_weather primary key (c_belong, c_id),
  constraint fk_weather_branch foreign key (c_belong) references t_branch(c_branchid)
); 
CREATE SEQUENCE seq_weather
NOCACHE;
create or replace trigger trg_weather
before insert on t_weather
for each row
 declare nxt_id number;
begin
 select seq_weather.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
--����Ψһ��
create unique index idx_weather_name on t_weather(c_belong, c_name);
-----------------------------------
--�¹ʵȼ���
create table t_saf_acclevel(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_acclevel primary key (c_belong, c_id),
  constraint fk_saf_acclevel_branch foreign key (c_belong) references t_branch(c_branchid)
);
create SEQUENCE seq_saf_acclevel
NOCACHE;
create or replace trigger trg_saf_acclevel
before insert on t_saf_acclevel
for each row
 declare nxt_id number;
begin
 select seq_saf_acclevel.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
create unique index idx_saf_acclevel on t_saf_acclevel(c_belong, c_name);
--�¹����
create table t_saf_acctype(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_acctype primary key (c_belong, c_id),
  constraint fk_saf_acctype_branch foreign key (c_belong) references t_branch(c_branchid)
); 
create SEQUENCE seq_saf_acctype
NOCACHE;
create or replace trigger trg_saf_acctype
before insert on t_saf_acctype
for each row
 declare nxt_id number;
begin
 select seq_saf_acctype.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
create unique index idx_saf_saf_acctype on t_saf_acctype(c_belong, c_name);
--�¹�����
create table t_saf_accduty(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_accduty primary key (c_belong, c_id),
  constraint fk_saf_accduty_branch foreign key (c_belong) references t_branch(c_branchid)
); 
create SEQUENCE seq_saf_accduty
NOCACHE;
create or replace trigger trg_saf_accduty
before insert on t_saf_accduty
for each row
 declare nxt_id number;
begin
 select seq_saf_accduty.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
create unique index idx_saf_accduty on t_saf_accduty(c_belong, c_name);
--ײ������
create table t_saf_accobject(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_accobject primary key (c_belong, c_id),
  constraint fk_saf_accobject_branch foreign key (c_belong) references t_branch(c_branchid)
); 
create SEQUENCE seq_saf_accobject
NOCACHE;
create or replace trigger trg_saf_accobject
before insert on t_saf_accobject
for each row
 declare nxt_id number;
begin
 select seq_saf_accobject.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
create unique index idx_saf_accobj on t_saf_accobject(c_belong, c_name);
--�������
create table t_saf_accprocessor(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_accprocessor primary key (c_belong, c_id),
  constraint fk_saf_accprocessor_branch foreign key (c_belong) references t_branch(c_branchid)
);
create SEQUENCE seq_saf_accprocessor
NOCACHE;
create or replace trigger trg_saf_accprocessor
before insert on t_saf_accprocessor
for each row
 declare nxt_id number;
begin
 select seq_saf_accprocessor.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
create unique index idx_saf_accprocessor on t_saf_accprocessor(c_belong, c_name);
--����̶�
create table t_saf_accextent(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_accextent primary key (c_belong, c_id),
  constraint fk_saf_accextent_branch foreign key (c_belong) references t_branch(c_branchid)
); 
create SEQUENCE seq_saf_accextent
NOCACHE;
create or replace trigger trg_saf_accextent
before insert on t_saf_accextent
for each row
 declare nxt_id number;
begin
 select seq_saf_accextent.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
create unique index idx_saf_accextent on t_saf_accextent(c_belong, c_name);
----------------------------------------------------------------------------------------
--�¹ʹ��̱�
CREATE TABLE t_saf_accident(
  c_belong     NUMBER(18) NOT NULL,
  c_id         NUMBER(18) NOT NULL,				    --*�ڲ�id
  c_no         VARCHAR2(16) NOT NULL,                               --�¹ʱ��
  c_date       DATE NOT NULL,                                       --�¹�����
  c_deptid     NUMBER(18) NOT NULL,                                 --����ID
  c_lineid     NUMBER(18) NOT NULL,                                 --��·ID
  c_busid      NUMBER(18) NOT NULL,                               --�¹ʳ���ID
  c_driverid   NUMBER(18) NOT NULL,                                 --��ʻԱID
  c_levelid    NUMBER(18) NOT NULL,                                 --�¹ʵȼ�ID
  c_typeid     NUMBER(18) NOT NULL,                                 --�¹�����ID
  c_dutyid     NUMBER(18) NOT NULL,                                 --�������ID
  c_weatherid  NUMBER(18) NOT NULL,                                 --����ID
  c_address    VARCHAR2(20),                                        --���µص�
  c_roadfacility VARCHAR2(60),                                      --��·��ʩ
  c_roaddesc1  VARCHAR2(20),                                        --·������
  c_roaddesc2  VARCHAR2(20),                                        --·��·��
  c_roaddesc3  VARCHAR2(20),                                        --·��·��
  c_reason     VARCHAR2(80),                                --��ʻ��̬����ԭ��
  c_course     VARCHAR2(200),                                       --�¹ʾ���
  c_processinfo VARCHAR2(200),                                      --������
  c_processor  NUMBER(18),                                        --�������ID
  c_policeno   VARCHAR2(20),                                  --���Ա��(�����������)
  c_billnum    NUMBER(3),                                         --����������
  c_report     NUMBER(1),                          --�Ƿ��ϱ�  1,�ϱ�,0,���ϱ�
  c_extentid   NUMBER(18),                                        --����̶�ID
  c_destroy    VARCHAR2(80),                                    --�����������
  c_lost       NUMBER(9,2) default 0 NOT NULL,                      	--��������������
  c_status     number(1) not null,                       	--��ת״̬ 0����,1�����ύ����,2Ӫ�˲����,3Ӫ�˲��浵
  c_init_date  date not null,					    --0��������
  c_init_psn  number(18) not null,   				    --������id
  c_init_desc  varchar2(40),					    --����
  c_dept_date  date not null,					    --1���Ӵ�������
  c_dept_psn   number(18),  					    --���Ӵ�����id
  c_dept_desc  varchar2(40),					    --����
  c_comp_date  date not null,					    --2Ӫ�˲���������
  c_comp_psn   number(18),					    --Ӫ�˲�������id
  c_comp_desc  varchar2(40),					    --����
  c_arch_date  date not null,                                       --3�浵����
  c_arch_psn   number(18),                                          --�浵��id
  CONSTRAINT pk_saf_accident PRIMARY KEY (c_belong, c_id),
  CONSTRAINT fk_saf_accident_dept FOREIGN KEY (c_belong, c_deptid) REFERENCES t_department(c_belong, c_departmentid),
  CONSTRAINT fk_saf_accident_line FOREIGN KEY (c_belong, c_lineid) REFERENCES t_running_line(c_belong, c_id),
  CONSTRAINT fk_saf_accident_bus FOREIGN KEY (c_belong, c_busid) REFERENCES t_equipment(c_belong, c_equid),
  CONSTRAINT fk_saf_accident_driver FOREIGN KEY (c_belong, c_driverid) REFERENCES t_personal(c_belong, c_personalid),
  CONSTRAINT fk_saf_accident_level FOREIGN KEY (c_belong, c_levelid) REFERENCES t_saf_acclevel(c_belong, c_id),
  CONSTRAINT fk_saf_accident_type FOREIGN KEY (c_belong, c_typeid) REFERENCES t_saf_acctype(c_belong, c_id),
  CONSTRAINT fk_saf_accident_duty FOREIGN KEY (c_belong, c_dutyid) REFERENCES t_saf_accduty(c_belong, c_id),
  CONSTRAINT fk_saf_accident_weather FOREIGN KEY (c_belong, c_weatherid) REFERENCES t_weather(c_belong, c_id),
  CONSTRAINT fk_saf_accident_processor FOREIGN KEY (c_belong, c_processor) REFERENCES t_saf_accprocessor(c_belong, c_id),
  CONSTRAINT fk_saf_accident_extent FOREIGN KEY (c_belong, c_extentid) REFERENCES t_saf_accextent(c_belong, c_id),
  CONSTRAINT fk_saf_accident_initpsn foreign key (c_belong, c_init_psn) REFERENCES t_personal(c_belong, c_personalid),
  CONSTRAINT fk_saf_accident_deptpsn foreign key (c_belong, c_dept_psn) REFERENCES t_personal(c_belong, c_personalid),
  CONSTRAINT fk_saf_accident_comppsn foreign key (c_belong, c_comp_psn) REFERENCES t_personal(c_belong, c_personalid),
  CONSTRAINT fk_saf_accident_archpsn foreign key (c_belong, c_arch_psn) REFERENCES t_personal(c_belong, c_personalid)
);
create SEQUENCE seq_saf_accident
NOCACHE;
create or replace trigger trg_saf_accident
before insert on t_saf_accident
for each row
 declare nxt_id number;
begin
 select seq_saf_accident.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/
--�¹ʱ��Ψһ
create unique index idx_saf_accident on t_saf_accident(c_belong, c_no);
--175--------------------------------
--175���ˣ�ײ����Ա��
create table t_saf_accoutpsn(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --�¹�id
  c_no           number(3) not null,         --���
  c_name         varchar2(40) not null,        --����
  c_sex          varchar2(5),                  --�Ա�
  c_age          number(3),                    --����
  c_regaddress   varchar2(50),                 --����
  c_address      varchar2(60),                 --��ַ����λ
  c_tel          varchar2(20),                 --�绰
  c_duty         number(18) not null,          --��������id
  c_desc         varchar2(40),                 --��������
  c_status       number(1) not null,           --0����,1����
  constraint pk_saf_accoutpsn primary key (c_belong, c_accid,c_no),
  constraint fk_saf_accoutpsn_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutpsn_acc foreign key (c_belong, c_accid) references t_saf_accident(c_belong, c_id),
  constraint fk_saf_accoutpsn_duty foreign key (c_belong, c_duty) references t_saf_accduty(c_belong, c_id)
);
--175�����⳥��ײ����Ա�⳥��
create table t_saf_accoutpsnpay(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --�¹�id
  c_no           number(3) not null,         --�¹��������
  c_paydate      date not null,              --֧��ʱ��
  c_paypsn       number(18) not null,        --������id  
  c_medifee      number(9,2) default 0 not null,           --ҽҩ��
  c_other1       number(9,2) default 0 not null,           --������
  c_other2       number(9,2) default 0 not null,           --�󹤷�
  c_paydesc      varchar2(40),               --֧����ע
  constraint pk_saf_accoutpsnpay primary key (c_belong,c_accid,c_no,c_paydate),
  constraint fk_saf_accoutpsnpay_outpsn foreign key (c_belong,c_accid,c_no) references t_saf_accoutpsn(c_belong,c_accid,c_no),
  constraint fk_saf_accoutpsnpay_paypsn foreign key (c_belong, c_paypsn) references t_personal(c_belong, c_personalid)
);
--���ˣ�������Ա������
create table t_saf_accinpsn(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --�¹�id
  c_no      number(3) not null,              --���
  c_name         varchar2(40) not null,        --����
  c_sex          varchar2(5),                  --�Ա�
  c_age          number(3),                    --����
  c_regaddress   varchar2(50),                 --����
  c_address      varchar2(60),                 --��ַ����λ
  c_tel          varchar2(20),                 --�绰
  c_duty         number(18) not null,          --��������id
  c_desc         varchar2(40),                 --��������
  c_status       number(1) not null,           --0����,1����
  constraint pk_saf_accinpsn primary key (c_belong, c_accid,c_no),
  constraint fk_saf_accinpsn_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accinpsn_acc foreign key (c_belong, c_accid) references t_saf_accident(c_belong, c_id),
  constraint fk_saf_accinpsn_duty foreign key (c_belong, c_duty) references t_saf_accduty(c_belong, c_id)
);
--�����⳥��������Ա�����⳥��
create table t_saf_accinpsnpay(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --�¹�id
  c_no           number(3) not null,         --���
  c_paydate      date not null,              --֧��ʱ��
  c_paypsn       number(18) not null,        --������id  
  c_medifee      number(9,2) default 0 not null,           --ҽҩ��
  c_other1       number(9,2) default 0 not null,           --������
  c_other2       number(9,2) default 0 not null,           --�󹤷�
  c_paydesc      varchar2(40),               --֧����ע
  constraint pk_saf_accinpsnpay primary key (c_belong,c_accid,c_no,c_paydate),
  constraint fk_saf_accinpsnpay_outpsn foreign key (c_belong,c_accid,c_no) references t_saf_accinpsn(c_belong,c_accid,c_no),
  constraint fk_saf_accinpsnpay_paypsn foreign key (c_belong, c_paypsn) references t_personal(c_belong, c_personalid)
);
----------------------------------
--����ײ�������
create table t_saf_accoutobj(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --�¹�id
  c_no      number(3) not null,              --���
  c_objid        number(18) not null,          --ײ������ID
  c_tel          varchar2(20),                 --��ϵ�绰
  c_address      varchar2(60),                 --��λ����ַ
  c_duty         number(18) not null,          --��������id
  c_desc         varchar2(40),                 --��������
  c_payfee       number(9,2) default 0 not null,  --�⳥���
  c_payDate      date,                         --�⳥����
  c_paydesc      varchar2(40),                 --�⳥����
  c_paypsn       number(18),                   --�⳥����id  
  constraint pk_saf_accoutobj primary key (c_belong, c_accid,c_no),
  constraint fk_saf_accoutobj_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutobj_acc foreign key (c_belong, c_accid) references t_saf_accident(c_belong, c_id),
  constraint fk_saf_accoutobj_obj foreign key (c_belong, c_objid) references t_saf_accobject(c_belong, c_id),
  constraint fk_saf_accoutobj_duty foreign key (c_belong, c_duty) references t_saf_accduty(c_belong, c_id),
  constraint fk_saf_accoutobj_paypsn foreign key (c_belong, c_paypsn) references t_personal(c_belong, c_personalid)
); 
--�¹������(����ʱ�䡢�⸶ʱ�俼���ܽ��˿���)
-- �¹�id,������,������(���չ�˾������),����ƾ֤��,֧�����,����ʱ��,�⸶ƾ֤��,�⸶���,�⸶ʱ��
--�¹ʵı��ձ��������⡢�⸶���᰸����
--�����¹�������Ч������Ͷ����˾����������¼
--�����ѱ���δ�᰸���¹ʿ��Խ�������ƾ֤��û����������¹��Զ�����ȱʡ�����嵥�������Ӻͼ��٣��������ն�������
--�����ѱ���δ�᰸��δ�⸶�Ŀ��Խ����⸶ƾ֤���Զ�����ȱʡ�⸶�嵥���ɼ��١��������ӣ�
--���ձ�����
create table t_saf_accguareport(
  c_belong	number(18) not null,
  c_accid     	 number(18) not null,        --�¹�id
  c_insurer   number(18) not null,        --���չ�˾id
  c_reportno     varchar2(16) not null,	     --������
  c_closeno      varchar2(16) default '-' not null,	     --�᰸��(-��ʾδ�᰸) v2
  constraint pk_saf_accguareport primary key (c_belong,c_accid,c_insurer),
  constraint fk_saf_accguareport_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accguareport_acc foreign key (c_belong, c_accid) references t_saf_accident (c_belong, c_id),
  constraint fk_saf_accguareport_insurer foreign key (c_belong,c_insurer) references t_saf_guainsurer(c_belong, c_id)
);
--�ǿ������ֵģ�����ȣ������⸶��
create table t_saf_accoutgua(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --����ƾ֤��(C09-000001)
  c_no     VARCHAR2(16) not null,       --����ƾ֤���
  c_accid       number(18) not null,        --�¹�id
  c_insurer     number(18) not null,        --���չ�˾id
  c_appdate  date  not null,           --�ύ��������
  c_objsum  number(9,2) default 0 not null,  --�������������֧��������������ײ������
  c_medifee      number(9,2) default 0 not null,  	   --ҽҩ�ѣ��ǿ�������Ա֧����
  c_other1       number(9,2) default 0 not null,           --������
  c_other2	 number(9,2) default 0 not null,	   --�󹤷�
  c_appdesc varchar2(40),		--�ύ���ⱸע
  c_APPpsn  number(18)  not null,         --�ύ���⾭��id
  constraint pk_saf_accoutgua primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accoutgua_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutgua_insurer foreign key (c_belong,c_accid,c_insurer) references t_saf_accguareport(c_belong,c_accid,c_insurer),
  constraint fk_saf_accoutgua_psn foreign key (c_belong, c_APPpsn) references t_personal (c_belong, c_personalid)
);
create table t_saf_accoutguapay(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --�⸶ƾ֤��(D09-000001)
  c_no     VARCHAR2(16) not null,       --�⸶ƾ֤���
  c_paydate  date  not null,            --�⸶��������
  c_objsum  number(9,2) default 0 not null,  --�⸶���������֧��������������ײ������
  c_medifee      number(9,2) default 0 not null,  	   --ҽҩ�ѣ��ǿ�������Ա֧����
  c_other1       number(9,2) default 0 not null,           --������
  c_other2	 number(9,2) default 0 not null,	   --�󹤷�
  c_paydesc varchar2(40),		--�⸶��ע
  c_paypsn  number(18)  not null,       --�⸶����id
  c_apprefno  VARCHAR2(16) not null,       --����ƾ֤��id
  c_appno     VARCHAR2(16) not null,       --����ƾ֤���
  constraint pk_saf_accoutguapay primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accoutguapay_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutguapay_app foreign key (c_belong,c_apprefno,c_appno) references t_saf_accoutgua(c_belong,c_refno,c_no),
  constraint fk_saf_accoutguapay_psn foreign key (c_belong, c_paypsn) references t_personal (c_belong, c_personalid)
);
--������ƾ֤Ψһ����(����ƾ֤���ܱ��ظ��⸶)
create unique index idx_saf_accoutguapay_app on t_saf_accoutguapay(c_belong, c_apprefno, c_appno);
--�������ֵ������⸶��
create table t_saf_accinpsngua(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --����ƾ֤��(C09-000001)
  c_no     VARCHAR2(16) not null,       --����ƾ֤���
  c_accid       number(18) not null,        --�¹�id
  c_insurer     number(18) not null,        --���չ�˾id
  c_cstmno     number(3) not null,        --�������
  c_appdate  date  not null,           --�ύ��������
  c_medifee      number(9,2) default 0 not null,  	   --ҽҩ�ѣ��ǿ�������Ա֧����
  c_other1       number(9,2) default 0 not null,           --������
  c_other2	 number(9,2) default 0 not null,	   --�󹤷�
  c_appdesc varchar2(40),    --�ύ���ⱸע
  c_APPpsn  number(18)  not null,         --�ύ���⾭��id
  constraint pk_saf_accinpsngua primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accinpsngua_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accinpsngua_insurer foreign key (c_belong,c_accid,c_insurer) references t_saf_accguareport(c_belong,c_accid,c_insurer),
  constraint fk_saf_accinpsngua_cstm foreign key (c_belong,c_accid,c_cstmno) references t_saf_accinpsn(c_belong, c_accid,c_no),
  constraint fk_saf_accinpsngua_psn foreign key (c_belong, c_APPpsn) references t_personal (c_belong, c_personalid)
);
create table t_saf_accinpsnguapay(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --�⸶ƾ֤��(D09-000001)
  c_no     VARCHAR2(16) not null,       --�⸶ƾ֤���
  c_paydate  date  not null,            --�⸶��������
  c_medifee      number(9,2) default 0 not null,  	   --ҽҩ�ѣ��ǿ�������Ա֧����
  c_other1       number(9,2) default 0 not null,           --������
  c_other2	 number(9,2) default 0 not null,	   --�󹤷�
  c_paydesc varchar2(40),    --�⸶��ע
  c_paypsn  number(18)  not null,       --�⸶����id
  c_apprefno  VARCHAR2(16) not null,       --����ƾ֤��id
  c_appno     VARCHAR2(16) not null,       --����ƾ֤���
  constraint pk_saf_accinpsnguapay primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accinpsnguapay_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accinpsnguapay_app foreign key (c_belong,c_apprefno,c_appno) references t_saf_accinpsngua(c_belong,c_refno,c_no),
  constraint fk_saf_accinpsnguapay_psn foreign key (c_belong, c_paypsn) references t_personal (c_belong, c_personalid)
);
--������ƾ֤Ψһ����(����ƾ֤���ܱ��ظ��⸶)
create unique index idx_saf_accinguapay_app on t_saf_accinpsnguapay(c_belong, c_apprefno, c_appno);
