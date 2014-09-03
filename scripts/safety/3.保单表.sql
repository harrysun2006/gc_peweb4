----------------------------------
--�������ͱ� t_saf_guatype
--Ͷ����˾�� t_saf_guainsurer
--Ͷ��ƾ֤ͷ�� t_saf_guarantee
--Ͷ��ƾ֤ͷ�� t_saf_guaranteedt
---------------------------------
--�ϰ汾
table t_saf_guarInfo
drop table t_saf_guarantee_type;
drop SEQUENCE seq_saf_guarantee_type;
t_saf_insurer
seq_saf_insurer 
--�ؽ�ʱִ�нű�
--Ͷ��ƾ֤��ϸ��
drop table t_saf_guaranteedt;
--Ͷ��ƾ֤ͷ��
drop table t_saf_guarantee;
--Ͷ����˾��
drop table t_saf_guainsurer;
drop sequence seq_saf_guainsurer;
--�������ͱ�
drop table t_saf_guatype;
drop SEQUENCE seq_saf_guatype;
------------------------------------
--�������ͱ�
create table t_saf_guatype(
  c_belong number(18) not null,					
  c_id     number(18) not null,					--��������ID
  c_name   varchar2(20) not null,				--����������(�����֣������ա���ҵ�ա���ǿ��)
  c_desc   varchar2(100),					--������������
  constraint pk_saf_guatype primary key (c_belong, c_id),
  constraint fk_saf_guatype_branch foreign key (c_belong) references t_branch(c_branchid)
);
CREATE SEQUENCE seq_saf_guatype
NOCACHE;
create or replace trigger trg_saf_guatype
before insert on t_saf_guatype
for each row
 declare nxt_id number;
begin
 select seq_saf_guatype.nextval into nxt_id
 from t_seqfro;
 :new.c_id := nxt_id;
end;
/
create unique index idx_saf_guatype on t_saf_guatype(c_belong, c_name);
---------------------------------
--Ͷ����˾��
create table t_saf_guainsurer(
  c_belong     number(18) not null,				
  c_id         number(18) not null,				--Ͷ����˾ID
  c_name       varchar2(60) not null,				--Ͷ����˾����
  c_comment    varchar2(100),					--��ע
  constraint pk_saf_guainsurer primary key (c_belong, c_id),
  constraint fk_saf_guainserer_branch foreign key (c_belong) references t_branch(c_branchid)
);
create sequence seq_saf_guainsurer nocache;
create or replace trigger trg_saf_guainsurer
before insert on t_saf_guainsurer
for each row
  declare nxt_id number;
begin
  select seq_saf_guainsurer.nextval into nxt_id
  from t_seqfro;
  :new.c_id := nxt_id;
end;
/
create unique index idx_saf_guainsurer on t_saf_guainsurer(c_belong, c_name);
----------------------------------------------------------------------------------
--Ͷ��ƾ֤ͷ��
create table t_saf_guarantee(
  c_belong       number(18) not null,		 --����ID
  c_accno    	 varchar2(16) not null,          --ƾ֤��(B)	
  c_date     	 date   not null,		 --Ͷ�����ڣ����ʺ��ܸģ�
  c_type 	 number(18) not null,            --��������ID
  c_insurer   	 number(18) not null,            --���չ�˾ID
  c_ondate       date not null,       		 --����������00:00:00��			
  c_downdate     date not null,       		 --��������ֹ��23:59:59��
  c_dopsn         number(18) not null,            --������ID��Ա����		
  c_insurerpsn   varchar2(20) not null,          --���չ�˾����			
  c_comment      varchar2(40),                    --��ע			
  constraint pk_saf_guarantee primary key (c_belong, c_accno),
  constraint fk_saf_guarantee_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_guarantee_type foreign key (c_belong, c_type) references t_saf_guatype (c_belong, c_id),
  constraint fk_saf_guarantee_insurer foreign key (c_belong, c_insurer) references t_saf_guainsurer (c_belong, c_id),
  constraint fk_saf_guarantee_psn foreign key (c_belong, c_dopsn) references t_personal (c_belong, c_personalid)
);
--Ͷ��ƾ֤��ϸ��
create table t_saf_guaranteedt ( 
  c_belong                  number(18) not null,		--����
  c_accno                   VARCHAR2(16) not null,		--Ͷ����ϢID
  c_no                      number(3) not null,	   	 	--���
  c_busid                   number(18) not null,           	--����ID���豸��
								--����Ͷ��ʱ��Ϣ�����ںͱ���һ��֮��
  c_busline 		    varchar(30) not null, 		--Ͷ��ʱ��·
  c_busauthNo                  varchar2(30) not null,		--Ͷ��ʱ����
  c_bustype                varchar2(30) not null,		--Ͷ��ʱ����(��Ӧt_equipment.c_prodData)
  c_bussits               number(3) not null,		 	--Ͷ��ʱ��λ(��Ӧt_equipment.c_outPower1)
  c_busarchNo                  varchar(30) not null,		--Ͷ��ʱ����
  c_buspowerNo                 varchar(30) not null,		--Ͷ��ʱ������
  c_guano                   varchar2(30) not null,         	--�������
  c_guadesp		    varchar(20),			--�ձ�����
  c_guacost			number(8) not null,		--����
  c_fee                     number(8,2) not null,           	--����
  constraint pk_saf_guaranteedt primary key (c_belong, c_accno, c_no),
  constraint fk_saf_guadt_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_guadt_bus foreign key (c_belong, c_busid) references t_equipment (c_belong, c_equid),
  constraint fk_saf_guadt_hd foreign key (c_belong,c_accno) references t_saf_guarantee (c_belong,c_accno)
);