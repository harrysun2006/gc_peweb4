--»ñµÃÆ¾Ö¤ºÅÂë
create or replace function fun_get_next_safno(p_branch     in number,
                                              p_type       in char,
                                              p_accno_head in varchar2)
  return varchar2 is
  Pragma Autonomous_Transaction;
  next_num Number(7);
begin
  update t_saf_no
     set c_curno = c_curno + 1
   where c_belong = p_branch
     and c_type = p_type
     and c_acc_head = p_accno_head;

  if sql%rowcount = 0 then
    insert into t_saf_no
      (c_belong, c_type, c_acc_head, c_curno)
    values
      (p_branch, p_type, p_accno_head, 1);
    next_num := 1;
  else
    select c_curno
      into next_num
      from t_saf_no
     where c_belong = p_branch
       and c_type = p_type
       and c_acc_head = p_accno_head;
  end if;

  commit;
  next_num := 1000000 + next_num;

  return p_accno_head || substr(to_char(next_num), 2, 6);
end fun_get_next_safno;
/
