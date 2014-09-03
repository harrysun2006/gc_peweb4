----------------------------------
--保单类型表 t_saf_guatype
--投保公司表 t_saf_guainsurer
--投保凭证头表 t_saf_guarantee
--投保凭证头表 t_saf_guaranteedt
---------------------------------
--老版本
table t_saf_guarInfo
drop table t_saf_guarantee_type;
drop SEQUENCE seq_saf_guarantee_type;
t_saf_insurer
seq_saf_insurer 
--重建时执行脚本
--投保凭证明细表
drop table t_saf_guaranteedt;
--投保凭证头表
drop table t_saf_guarantee;
--投保公司表
drop table t_saf_guainsurer;
drop sequence seq_saf_guainsurer;
--保单类型表
drop table t_saf_guatype;
drop SEQUENCE seq_saf_guatype;
------------------------------------
--保单类型表
create table t_saf_guatype(
  c_belong number(18) not null,					
  c_id     number(18) not null,					--保单类型ID
  c_name   varchar2(20) not null,				--保单类型名(保留字：客伤险、商业险、交强险)
  c_desc   varchar2(100),					--保单类型描述
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
--投保公司表
create table t_saf_guainsurer(
  c_belong     number(18) not null,				
  c_id         number(18) not null,				--投保公司ID
  c_name       varchar2(60) not null,				--投保公司名称
  c_comment    varchar2(100),					--备注
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
--投保凭证头表
create table t_saf_guarantee(
  c_belong       number(18) not null,		 --机构ID
  c_accno    	 varchar2(16) not null,          --凭证号(B)	
  c_date     	 date   not null,		 --投保日期（结帐后不能改）
  c_type 	 number(18) not null,            --保单类型ID
  c_insurer   	 number(18) not null,            --保险公司ID
  c_ondate       date not null,       		 --保险期限起（00:00:00）			
  c_downdate     date not null,       		 --保险期限止（23:59:59）
  c_dopsn         number(18) not null,            --经办人ID，员工表		
  c_insurerpsn   varchar2(20) not null,          --保险公司经办			
  c_comment      varchar2(40),                    --备注			
  constraint pk_saf_guarantee primary key (c_belong, c_accno),
  constraint fk_saf_guarantee_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_guarantee_type foreign key (c_belong, c_type) references t_saf_guatype (c_belong, c_id),
  constraint fk_saf_guarantee_insurer foreign key (c_belong, c_insurer) references t_saf_guainsurer (c_belong, c_id),
  constraint fk_saf_guarantee_psn foreign key (c_belong, c_dopsn) references t_personal (c_belong, c_personalid)
);
--投保凭证明细表
create table t_saf_guaranteedt ( 
  c_belong                  number(18) not null,		--机构
  c_accno                   VARCHAR2(16) not null,		--投保信息ID
  c_no                      number(3) not null,	   	 	--序号
  c_busid                   number(18) not null,           	--车辆ID，设备表
								--车辆投保时信息仅用于和保单一致之用
  c_busline 		    varchar(30) not null, 		--投保时线路
  c_busauthNo                  varchar2(30) not null,		--投保时号牌
  c_bustype                varchar2(30) not null,		--投保时车型(对应t_equipment.c_prodData)
  c_bussits               number(3) not null,		 	--投保时座位(对应t_equipment.c_outPower1)
  c_busarchNo                  varchar(30) not null,		--投保时车架
  c_buspowerNo                 varchar(30) not null,		--投保时发动机
  c_guano                   varchar2(30) not null,         	--保单编号
  c_guadesp		    varchar(20),			--险别描述
  c_guacost			number(8) not null,		--保额
  c_fee                     number(8,2) not null,           	--保费
  constraint pk_saf_guaranteedt primary key (c_belong, c_accno, c_no),
  constraint fk_saf_guadt_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_guadt_bus foreign key (c_belong, c_busid) references t_equipment (c_belong, c_equid),
  constraint fk_saf_guadt_hd foreign key (c_belong,c_accno) references t_saf_guarantee (c_belong,c_accno)
);