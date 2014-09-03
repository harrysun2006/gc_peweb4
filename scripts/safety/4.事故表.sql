--175
--v3:程雷干 2009/11/17   事故赔偿表改进
--v2:程雷干 2009/09/26   报案时结案号内部设定缺省值 '-'
--v1:程雷干 2009/09/18   全面整理
------------------------------------------------------------
--事故管理 部分
--基础信息表
--		t_weather天气表（晴、阴、雨、雪、雾、风、霜、冰、雹、霾）
--		t_saf_acclevel事故等级（特大、重大、一般、轻微、待定）
--		t_saf_acctype事故类别（正面相撞、侧面相撞、尾随相撞、对向刮檫、同向刮檫、碾压、翻车、坠车、失火、撞固定物、运行伤害、其他）
--		t_saf_accduty事故责任（全部责任、主要责任、同等责任、次要责任、无责、待定）
--		t_saf_accobject撞击对象（小型车、面包车、大客车、大货车、摩托车、自行车、助动车、行人、其他）
--		t_saf_accprocessor处理机关
--		t_saf_accextent受损程度（）
--		未设计枚举	肇事原因
--事故表	
--		t_saf_accident 	   事故过程主表
--		t_saf_accoutpsn       伤人：撞击人员伤亡清单（173）
--		t_saf_accoutpsnpay    伤人赔偿：撞击人员伤亡赔偿表（173）
--		t_saf_accoutobj	      物损：撞击物体损毁清单
--		t_saf_accinpsn        客伤：车上人员伤亡清单
--		t_saf_accinpsnpay     客伤赔偿：车上人员伤亡赔偿表（173）
--		t_saf_accguareport    保险报案表
--		t_saf_accoutgua(pay)    三责理赔情况（撞击人员伤亡，撞击物体损毁，车辆自身损毁的理赔情况）
--		t_saf_accinpsngua(pay)  客伤理赔情况（车上人员伤亡清单）
---------------------------------------------------------------------------------------------------------
--新版创建脚本
----------------------------------------------------
--天气表
create table t_weather(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,  /*名称*/
  c_desc   varchar2(100),	   /*描述*/
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
--名字唯一性
create unique index idx_weather_name on t_weather(c_belong, c_name);
-----------------------------------
--事故等级表
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
--事故类别
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
--事故责任
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
--撞击对象
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
--处理机关
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
--受损程度
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
--事故过程表
CREATE TABLE t_saf_accident(
  c_belong     NUMBER(18) NOT NULL,
  c_id         NUMBER(18) NOT NULL,				    --*内部id
  c_no         VARCHAR2(16) NOT NULL,                               --事故编号
  c_date       DATE NOT NULL,                                       --事故日期
  c_deptid     NUMBER(18) NOT NULL,                                 --部门ID
  c_lineid     NUMBER(18) NOT NULL,                                 --线路ID
  c_busid      NUMBER(18) NOT NULL,                               --事故车辆ID
  c_driverid   NUMBER(18) NOT NULL,                                 --驾驶员ID
  c_levelid    NUMBER(18) NOT NULL,                                 --事故等级ID
  c_typeid     NUMBER(18) NOT NULL,                                 --事故类型ID
  c_dutyid     NUMBER(18) NOT NULL,                                 --责任类别ID
  c_weatherid  NUMBER(18) NOT NULL,                                 --天气ID
  c_address    VARCHAR2(20),                                        --肇事地点
  c_roadfacility VARCHAR2(60),                                      --道路设施
  c_roaddesc1  VARCHAR2(20),                                        --路面区域
  c_roaddesc2  VARCHAR2(20),                                        --路幅路形
  c_roaddesc3  VARCHAR2(20),                                        --路基路况
  c_reason     VARCHAR2(80),                                --行驶动态肇事原因
  c_course     VARCHAR2(200),                                       --事故经过
  c_processinfo VARCHAR2(200),                                      --处理经过
  c_processor  NUMBER(18),                                        --处理机关ID
  c_policeno   VARCHAR2(20),                                  --电脑编号(警方或处理机关)
  c_billnum    NUMBER(3),                                         --报销单据数
  c_report     NUMBER(1),                          --是否上报  1,上报,0,不上报
  c_extentid   NUMBER(18),                                        --受损程度ID
  c_destroy    VARCHAR2(80),                                    --受损情况描述
  c_lost       NUMBER(9,2) default 0 NOT NULL,                      	--车辆自损修理金额
  c_status     number(1) not null,                       	--流转状态 0建立,1车队提交审批,2营运部审核,3营运部存档
  c_init_date  date not null,					    --0建立日期
  c_init_psn  number(18) not null,   				    --建立人id
  c_init_desc  varchar2(40),					    --描述
  c_dept_date  date not null,					    --1车队处理日期
  c_dept_psn   number(18),  					    --车队处理人id
  c_dept_desc  varchar2(40),					    --描述
  c_comp_date  date not null,					    --2营运部处理日期
  c_comp_psn   number(18),					    --营运部处理人id
  c_comp_desc  varchar2(40),					    --描述
  c_arch_date  date not null,                                       --3存档日期
  c_arch_psn   number(18),                                          --存档人id
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
--事故编号唯一
create unique index idx_saf_accident on t_saf_accident(c_belong, c_no);
--175--------------------------------
--175伤人：撞击人员表
create table t_saf_accoutpsn(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --事故id
  c_no           number(3) not null,         --序号
  c_name         varchar2(40) not null,        --姓名
  c_sex          varchar2(5),                  --性别
  c_age          number(3),                    --年龄
  c_regaddress   varchar2(50),                 --户口
  c_address      varchar2(60),                 --地址及单位
  c_tel          varchar2(20),                 --电话
  c_duty         number(18) not null,          --主体责任id
  c_desc         varchar2(40),                 --责任描述
  c_status       number(1) not null,           --0死亡,1受伤
  constraint pk_saf_accoutpsn primary key (c_belong, c_accid,c_no),
  constraint fk_saf_accoutpsn_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutpsn_acc foreign key (c_belong, c_accid) references t_saf_accident(c_belong, c_id),
  constraint fk_saf_accoutpsn_duty foreign key (c_belong, c_duty) references t_saf_accduty(c_belong, c_id)
);
--175伤人赔偿：撞击人员赔偿表
create table t_saf_accoutpsnpay(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --事故id
  c_no           number(3) not null,         --事故伤人序号
  c_paydate      date not null,              --支付时间
  c_paypsn       number(18) not null,        --经办人id  
  c_medifee      number(9,2) default 0 not null,           --医药费
  c_other1       number(9,2) default 0 not null,           --补偿费
  c_other2       number(9,2) default 0 not null,           --误工费
  c_paydesc      varchar2(40),               --支付备注
  constraint pk_saf_accoutpsnpay primary key (c_belong,c_accid,c_no,c_paydate),
  constraint fk_saf_accoutpsnpay_outpsn foreign key (c_belong,c_accid,c_no) references t_saf_accoutpsn(c_belong,c_accid,c_no),
  constraint fk_saf_accoutpsnpay_paypsn foreign key (c_belong, c_paypsn) references t_personal(c_belong, c_personalid)
);
--客伤：车上人员伤亡表
create table t_saf_accinpsn(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --事故id
  c_no      number(3) not null,              --序号
  c_name         varchar2(40) not null,        --姓名
  c_sex          varchar2(5),                  --性别
  c_age          number(3),                    --年龄
  c_regaddress   varchar2(50),                 --户口
  c_address      varchar2(60),                 --地址及单位
  c_tel          varchar2(20),                 --电话
  c_duty         number(18) not null,          --主体责任id
  c_desc         varchar2(40),                 --责任描述
  c_status       number(1) not null,           --0死亡,1受伤
  constraint pk_saf_accinpsn primary key (c_belong, c_accid,c_no),
  constraint fk_saf_accinpsn_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accinpsn_acc foreign key (c_belong, c_accid) references t_saf_accident(c_belong, c_id),
  constraint fk_saf_accinpsn_duty foreign key (c_belong, c_duty) references t_saf_accduty(c_belong, c_id)
);
--客伤赔偿：车上人员伤亡赔偿表
create table t_saf_accinpsnpay(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --事故id
  c_no           number(3) not null,         --序号
  c_paydate      date not null,              --支付时间
  c_paypsn       number(18) not null,        --经办人id  
  c_medifee      number(9,2) default 0 not null,           --医药费
  c_other1       number(9,2) default 0 not null,           --补偿费
  c_other2       number(9,2) default 0 not null,           --误工费
  c_paydesc      varchar2(40),               --支付备注
  constraint pk_saf_accinpsnpay primary key (c_belong,c_accid,c_no,c_paydate),
  constraint fk_saf_accinpsnpay_outpsn foreign key (c_belong,c_accid,c_no) references t_saf_accinpsn(c_belong,c_accid,c_no),
  constraint fk_saf_accinpsnpay_paypsn foreign key (c_belong, c_paypsn) references t_personal(c_belong, c_personalid)
);
----------------------------------
--物损：撞击对象表
create table t_saf_accoutobj(
  c_belong       number(18) not null,
  c_accid        number(18) not null,        --事故id
  c_no      number(3) not null,              --序号
  c_objid        number(18) not null,          --撞击对象ID
  c_tel          varchar2(20),                 --联系电话
  c_address      varchar2(60),                 --单位及地址
  c_duty         number(18) not null,          --主体责任id
  c_desc         varchar2(40),                 --责任描述
  c_payfee       number(9,2) default 0 not null,  --赔偿金额
  c_payDate      date,                         --赔偿日期
  c_paydesc      varchar2(40),                 --赔偿描述
  c_paypsn       number(18),                   --赔偿经办id  
  constraint pk_saf_accoutobj primary key (c_belong, c_accid,c_no),
  constraint fk_saf_accoutobj_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutobj_acc foreign key (c_belong, c_accid) references t_saf_accident(c_belong, c_id),
  constraint fk_saf_accoutobj_obj foreign key (c_belong, c_objid) references t_saf_accobject(c_belong, c_id),
  constraint fk_saf_accoutobj_duty foreign key (c_belong, c_duty) references t_saf_accduty(c_belong, c_id),
  constraint fk_saf_accoutobj_paypsn foreign key (c_belong, c_paypsn) references t_personal(c_belong, c_personalid)
); 
--事故理赔表(理赔时间、赔付时间考虑受结账控制)
-- 事故id,保单号,报案号(保险公司报案号),理赔凭证号,支出金额,理赔时间,赔付凭证号,赔付金额,赔付时间
--事故的保险报案、理赔、赔付、结案过程
--根据事故日期有效保单的投保公司建立报案记录
--根据已报案未结案的事故可以建立理赔凭证、没有理赔过的事故自动调出缺省理赔清单（可增加和减少）（客伤险独立处理）
--根据已报案未结案、未赔付的可以建立赔付凭证、自动调出缺省赔付清单（可减少、不能增加）
--保险报案表
create table t_saf_accguareport(
  c_belong	number(18) not null,
  c_accid     	 number(18) not null,        --事故id
  c_insurer   number(18) not null,        --保险公司id
  c_reportno     varchar2(16) not null,	     --报案号
  c_closeno      varchar2(16) default '-' not null,	     --结案号(-表示未结案) v2
  constraint pk_saf_accguareport primary key (c_belong,c_accid,c_insurer),
  constraint fk_saf_accguareport_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accguareport_acc foreign key (c_belong, c_accid) references t_saf_accident (c_belong, c_id),
  constraint fk_saf_accguareport_insurer foreign key (c_belong,c_insurer) references t_saf_guainsurer(c_belong, c_id)
);
--非客伤险种的（三责等）理赔赔付表
create table t_saf_accoutgua(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --理赔凭证号(C09-000001)
  c_no     VARCHAR2(16) not null,       --理赔凭证序号
  c_accid       number(18) not null,        --事故id
  c_insurer     number(18) not null,        --保险公司id
  c_appdate  date  not null,           --提交理赔日期
  c_objsum  number(9,2) default 0 not null,  --理赔物损金额（三责支出包括车辆自损，撞击对象）
  c_medifee      number(9,2) default 0 not null,  	   --医药费（非客伤亡人员支出）
  c_other1       number(9,2) default 0 not null,           --补偿费
  c_other2	 number(9,2) default 0 not null,	   --误工费
  c_appdesc varchar2(40),		--提交理赔备注
  c_APPpsn  number(18)  not null,         --提交理赔经办id
  constraint pk_saf_accoutgua primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accoutgua_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutgua_insurer foreign key (c_belong,c_accid,c_insurer) references t_saf_accguareport(c_belong,c_accid,c_insurer),
  constraint fk_saf_accoutgua_psn foreign key (c_belong, c_APPpsn) references t_personal (c_belong, c_personalid)
);
create table t_saf_accoutguapay(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --赔付凭证号(D09-000001)
  c_no     VARCHAR2(16) not null,       --赔付凭证序号
  c_paydate  date  not null,            --赔付理赔日期
  c_objsum  number(9,2) default 0 not null,  --赔付物损金额（三责支出包括车辆自损，撞击对象）
  c_medifee      number(9,2) default 0 not null,  	   --医药费（非客伤亡人员支出）
  c_other1       number(9,2) default 0 not null,           --补偿费
  c_other2	 number(9,2) default 0 not null,	   --误工费
  c_paydesc varchar2(40),		--赔付备注
  c_paypsn  number(18)  not null,       --赔付经办id
  c_apprefno  VARCHAR2(16) not null,       --理赔凭证号id
  c_appno     VARCHAR2(16) not null,       --理赔凭证序号
  constraint pk_saf_accoutguapay primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accoutguapay_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accoutguapay_app foreign key (c_belong,c_apprefno,c_appno) references t_saf_accoutgua(c_belong,c_refno,c_no),
  constraint fk_saf_accoutguapay_psn foreign key (c_belong, c_paypsn) references t_personal (c_belong, c_personalid)
);
--加理赔凭证唯一索引(理赔凭证不能被重复赔付)
create unique index idx_saf_accoutguapay_app on t_saf_accoutguapay(c_belong, c_apprefno, c_appno);
--客伤险种的理赔赔付表
create table t_saf_accinpsngua(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --理赔凭证号(C09-000001)
  c_no     VARCHAR2(16) not null,       --理赔凭证序号
  c_accid       number(18) not null,        --事故id
  c_insurer     number(18) not null,        --保险公司id
  c_cstmno     number(3) not null,        --客伤序号
  c_appdate  date  not null,           --提交理赔日期
  c_medifee      number(9,2) default 0 not null,  	   --医药费（非客伤亡人员支出）
  c_other1       number(9,2) default 0 not null,           --补偿费
  c_other2	 number(9,2) default 0 not null,	   --误工费
  c_appdesc varchar2(40),    --提交理赔备注
  c_APPpsn  number(18)  not null,         --提交理赔经办id
  constraint pk_saf_accinpsngua primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accinpsngua_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accinpsngua_insurer foreign key (c_belong,c_accid,c_insurer) references t_saf_accguareport(c_belong,c_accid,c_insurer),
  constraint fk_saf_accinpsngua_cstm foreign key (c_belong,c_accid,c_cstmno) references t_saf_accinpsn(c_belong, c_accid,c_no),
  constraint fk_saf_accinpsngua_psn foreign key (c_belong, c_APPpsn) references t_personal (c_belong, c_personalid)
);
create table t_saf_accinpsnguapay(
  c_belong  number(18) not null,
  c_refno  VARCHAR2(16) not null,       --赔付凭证号(D09-000001)
  c_no     VARCHAR2(16) not null,       --赔付凭证序号
  c_paydate  date  not null,            --赔付理赔日期
  c_medifee      number(9,2) default 0 not null,  	   --医药费（非客伤亡人员支出）
  c_other1       number(9,2) default 0 not null,           --补偿费
  c_other2	 number(9,2) default 0 not null,	   --误工费
  c_paydesc varchar2(40),    --赔付备注
  c_paypsn  number(18)  not null,       --赔付经办id
  c_apprefno  VARCHAR2(16) not null,       --理赔凭证号id
  c_appno     VARCHAR2(16) not null,       --理赔凭证序号
  constraint pk_saf_accinpsnguapay primary key (c_belong,c_refno,c_no),
  constraint fk_saf_accinpsnguapay_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_accinpsnguapay_app foreign key (c_belong,c_apprefno,c_appno) references t_saf_accinpsngua(c_belong,c_refno,c_no),
  constraint fk_saf_accinpsnguapay_psn foreign key (c_belong, c_paypsn) references t_personal (c_belong, c_personalid)
);
--加理赔凭证唯一索引(理赔凭证不能被重复赔付)
create unique index idx_saf_accinguapay_app on t_saf_accinpsnguapay(c_belong, c_apprefno, c_appno);
