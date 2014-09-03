--安全系统凭证号表(用于违章、投保、等业务凭证，每年编号A09-000001)
create table t_saf_no (
  c_belong   number(18) not null,
  c_type     varchar2(1) not null,  --A违章B投保C理赔D赔付
  c_acc_head varchar2(4) not null,
  c_curno    number(6) not null,
  constraint pk_saf_no primary key (c_belong, c_type, c_acc_head),
  constraint fk_saf_no_branch foreign key (c_belong) references t_branch (c_branchid)
);
