--违法类别表
create table t_saf_transgresstype(
  c_belong number(18) not null,
  c_id     number(18) not null,
  c_name   varchar2(20) not null,
  c_desc   varchar2(100),
  constraint pk_saf_transgresstype primary key (c_belong, c_id),
  constraint fk_saf_transgresstype_branch foreign key (c_belong) references t_branch(c_branchid)
);

CREATE SEQUENCE seq_saf_transgresstype
NOCACHE;
create or replace trigger trg_saf_transgresstype
before insert on t_saf_transgresstype
for each row
 declare nxt_id number;
begin
 select seq_saf_transgresstype.nextval into nxt_id
 from t_seqfro;
 :new.c_Id := nxt_id;
end;
/

create unique index idx_saf_transgresstype_name on t_saf_transgresstype(c_belong, c_name);

--违法信息表
create table t_saf_transgress(
  c_belong   number(18) not null,
  c_accno    varchar2(16) not null,         --凭证号
  c_dept     number(18) not null,           --凭证部门（空为总公司，实际按分公司录入）h
  c_date     date   not null,               --录入日期（结帐后不能改）h
  c_inputer  number(18) not null,           --录入h
-----
  c_no       number(3) not null,            --序号(同批导入的顺序)
  c_fact_date     date not null,            --违法日期d
  c_busid    number(18) not null,           --车辆ID
  c_driverid number(18),           	    --驾驶员ID
  c_typeid   number(18),                    --违法类别ID
  c_code     varchar2(6),                   --违法代码
  c_point    varchar2(2),                   --记分
  c_penalty  number(7,2),                   --罚款
  c_do_date  date,                          --受理日期
  constraint pk_saf_transgress primary key (c_belong,c_accno,c_no),
  constraint fk_saf_transgress_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_transgress_dept foreign key (c_belong, c_dept) references t_department (c_belong, c_departmentid),
  constraint fk_saf_transgress_bus foreign key (c_belong, c_busid) references t_equipment (c_belong, c_equid),
  constraint fk_saf_transgress_driver foreign key (c_belong, c_driverid) references t_personal (c_belong, c_personalid),
  constraint fk_saf_transgress_type foreign key (c_belong, c_typeid) references t_saf_transgresstype (c_belong, c_id)
);
