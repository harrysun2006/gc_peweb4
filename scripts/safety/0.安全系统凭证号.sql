--��ȫϵͳƾ֤�ű�(����Υ�¡�Ͷ������ҵ��ƾ֤��ÿ����A09-000001)
create table t_saf_no (
  c_belong   number(18) not null,
  c_type     varchar2(1) not null,  --AΥ��BͶ��C����D�⸶
  c_acc_head varchar2(4) not null,
  c_curno    number(6) not null,
  constraint pk_saf_no primary key (c_belong, c_type, c_acc_head),
  constraint fk_saf_no_branch foreign key (c_belong) references t_branch (c_branchid)
);
