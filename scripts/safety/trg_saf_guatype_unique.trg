--重置sequence 存储过程：(暂不使用)
-- create or replace procedure seq_reset(v_seqname varchar2) as
-- n number(10);
-- tsql varchar2(100);
-- begin
-- execute immediate 'select '||v_seqname||'.nextval from dual' into n;
-- n:=-(n-1);
-- tsql:='alter sequence '||v_seqname||' increment by '|| n;    --让序列一次递增-N，实现归0
-- execute immediate tsql;
-- execute immediate 'select '||v_seqname||'.nextval from dual' into n;
-- tsql:='alter sequence '||v_seqname||' increment by 1';
-- execute immediate tsql;
-- end seq_reset;
-- /
--执行
-- exec seq_reset('seq_saf_guatype');
--------------------------------------------------------------------
--默认插入一条客伤险数据
insert into table t_saf_guatype values(&bid,1,'客伤险','客伤险');

触发器:
create or replace trigger trg_saf_guatype_unique
before update or delete 
     on t_saf_guatype
for each row
begin
     if :old.c_id = 1 then
       raise_application_error(-20600,'该数据不能被修改');
     end if;
end;
/
