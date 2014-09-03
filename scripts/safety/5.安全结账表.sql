create table t_saf_closecontrol
(
  c_belong  number(18) not null,
  c_date    date not null,
  c_comment varchar2(32),
  constraint pk_safety_close primary key (c_belong, c_date),
  constraint fk_safety_close_branch foreign key (c_belong) references t_branch (c_branchid)
);