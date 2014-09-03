--Υ������
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

--Υ����Ϣ��
create table t_saf_transgress(
  c_belong   number(18) not null,
  c_accno    varchar2(16) not null,         --ƾ֤��
  c_dept     number(18) not null,           --ƾ֤���ţ���Ϊ�ܹ�˾��ʵ�ʰ��ֹ�˾¼�룩h
  c_date     date   not null,               --¼�����ڣ����ʺ��ܸģ�h
  c_inputer  number(18) not null,           --¼��h
-----
  c_no       number(3) not null,            --���(ͬ�������˳��)
  c_fact_date     date not null,            --Υ������d
  c_busid    number(18) not null,           --����ID
  c_driverid number(18),           	    --��ʻԱID
  c_typeid   number(18),                    --Υ�����ID
  c_code     varchar2(6),                   --Υ������
  c_point    varchar2(2),                   --�Ƿ�
  c_penalty  number(7,2),                   --����
  c_do_date  date,                          --��������
  constraint pk_saf_transgress primary key (c_belong,c_accno,c_no),
  constraint fk_saf_transgress_branch foreign key (c_belong) references t_branch(c_branchid),
  constraint fk_saf_transgress_dept foreign key (c_belong, c_dept) references t_department (c_belong, c_departmentid),
  constraint fk_saf_transgress_bus foreign key (c_belong, c_busid) references t_equipment (c_belong, c_equid),
  constraint fk_saf_transgress_driver foreign key (c_belong, c_driverid) references t_personal (c_belong, c_personalid),
  constraint fk_saf_transgress_type foreign key (c_belong, c_typeid) references t_saf_transgresstype (c_belong, c_id)
);
