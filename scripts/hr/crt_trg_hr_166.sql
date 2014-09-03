--162增加T_PERSONAL的删除触发器
--162分离T_PERSONAL的插入和修改触发器
--162从crt0050203_psnonline_162.sql中拆分
---------------------------------------------------
--含：
--T_PERSONAL的插入前触发器trg_Personalid
--T_PERSONAL的插入后触发器trg_af_Personal_ins
--T_PERSONAL的删除前触发器trg_bf_Personal_del
--T_PERSONAL的修改前触发器trg_bf_Personal_upd
--T_PERSONAL的修改后触发器trg_af_Personal_upd
----------------------------------------------------
--162版同步
drop TRIGGER trg_Personalonline;
drop TRIGGER trg_Personalstatus;
drop TRIGGER trg_Personal_change;
----------------------------------------------------
--触发器产生人员表内部ID
--SYS修改前过渡版本，自动产生变动时间
create or replace trigger trg_Personalid
before insert on t_Personal
for each row
declare 
nxt_id number;
chgdate date;
begin
 select seq_Personal.nextval into nxt_id
 from t_seqfro;
 :new.c_Personalid := nxt_id;
 --SYS修改前过渡版本，自动产生变动时间
 --166:自动产生变动时间缺省等于ondate
 :new.C_UPGRADE_DATE := :new.c_personalondate;
 :new.C_ALLOTDATE := :new.c_personalondate;
 if :new.c_PersonalDownDate <= :new.c_PersonalOnDate then
   raise_application_error(-20003, '工号 '||:new.C_WORKERID||'：注销日期必须大于注册日期！');
 end if;  
end;
/
--插入后触发器自动产生调动记录
CREATE OR REPLACE TRIGGER trg_af_Personal_ins
  AFTER INSERT ON T_PERSONAL FOR EACH ROW
BEGIN
--1.插入初始业务调动记录
  INSERT INTO T_PSN_ONLINE (
  c_belong,
  c_onlinepsn ,
  c_OnDate ,
  C_ALLOTREASON,
  c_Depart ,
  c_Office ,
  c_lineid,
  c_busid,
  c_cert2_no,
  c_cert2_no_hex,
  c_DownDate,
  c_dopsn
  )
  VALUES
    (:NEW.C_BELONG,
     :NEW.C_PERSONALID,
     :NEW.c_personalondate,
     :NEW.C_ALLOTREASON,
     :NEW.C_DEPART, 
     :NEW.C_OFFICE, 
     :NEW.C_LINEID, 
     :NEW.C_BUSID,
     :NEW.c_cert2_no,
     :NEW.c_cert2_no_hex,
		 decode(:new.c_PersonalDownDate, to_date('9999/12/31','yyyy/mm/dd'), to_date('9999/12/31','yyyy/mm/dd'), :new.c_PersonalDownDate -1),
		 :NEW.C_LASTMODIFIER);
--2.插入初始状态变动记录
  INSERT INTO T_PSN_STATUS (
  c_belong,
  c_statuspsn,
  c_OnDate,
  C_UPGRADE_REASON,
  c_type,
  c_position,
  c_regbelong,
  c_party,
  c_grade,
  c_schoolhistory,
  c_DownDate,
  c_dopsn
  )
  VALUES
    (:NEW.C_BELONG,
    :NEW.C_PERSONALID,
    :NEW.c_personalondate,
    :NEW.C_UPGRADE_REASON, 
    :NEW.C_TYPE, 
    :NEW.C_POSITION, 
    :NEW.C_REGBELONG, 
    :NEW.C_PARTY, 
    :NEW.C_GRADE, 
    :NEW.C_SCHOOLHISTORY,
		 decode(:new.c_PersonalDownDate, to_date('9999/12/31','yyyy/mm/dd'), to_date('9999/12/31','yyyy/mm/dd'), :new.c_PersonalDownDate -1),
		:NEW.C_LASTMODIFIER);     
END;
/
--增加删除前触发器自动删除初次调动记录
CREATE OR REPLACE TRIGGER trg_bf_Personal_del
  BEFORE DELETE ON T_PERSONAL FOR EACH ROW
BEGIN
 if :old.C_UPGRADE_DATE <> :old.c_personalondate or :old.C_ALLOTDATE <> :old.c_personalondate then
   raise_application_error(-20003, '工号 '||:old.C_WORKERID||'：最后调动日期或状态变动日期和人员的注册日期不一致，人员不能删除。（处理异常数据或修改调动日期后删除）');
 end if;
--1.删除初始业务调动记录
 delete  from T_PSN_ONLINE
 where c_belong = :old.c_belong
 and   c_onlinepsn = :old.C_PERSONALID;
--2.删除初始状态变动记录
 delete  from T_PSN_STATUS
 where c_belong = :old.c_belong
 and   c_STATUSpsn = :old.C_PERSONALID;
END;
/
--修改前触发器验证日期合法
CREATE OR REPLACE TRIGGER trg_bf_Personal_upd
  before UPDATE OF c_personalondate,c_personaldowndate,C_UPGRADE_DATE,C_ALLOTDATE
  ON T_PERSONAL  FOR EACH ROW    
BEGIN
  --修改注册日期
  if :old.c_personalondate <> :new.c_personalondate then
     --人员已有业务调动或状态变动不能修改注册日期
     if :old.C_UPGRADE_DATE <> :old.c_personalondate or :old.C_ALLOTDATE <> :old.c_personalondate then
        raise_application_error(-20003, '工号 '||:old.C_WORKERID||'：原调动日期或状态变动日期和人员的原注册日期不一致，人员已有业务调动或状态变动不能修改注册日期。');
     end if;
     --修改后初次调动日期和变动日期必须等于注册日期
     :new.C_UPGRADE_DATE := :new.c_personalondate;
     :new.C_ALLOTDATE := :new.c_personalondate;
  end if;
  if :new.c_PersonalDownDate <= :new.c_PersonalOnDate then
     raise_application_error(-20003, '工号 '||:old.C_WORKERID||'：注销日期必须大于注册日期！');
  end if;
  if :new.C_ALLOTDATE < :new.c_PersonalonDate or :new.C_ALLOTDATE >= :new.c_PersonaldownDate then
     raise_application_error(-20003, '工号 '||:old.C_WORKERID||'：最后的调动日期必须大于等于注册日期、小于注销日期！');
  end if;
  if :new.C_UPGRADE_DATE < :new.c_PersonalonDate or :new.C_UPGRADE_DATE >= :new.c_PersonaldownDate then
     raise_application_error(-20003, '工号 '||:old.C_WORKERID||'：最后的变动日期必须大于等于注册日期、小于注销日期！');
  end if;
end;
/    
--修改后触发器自动产生调动记录
CREATE OR REPLACE TRIGGER trg_af_Personal_upd
  AFTER UPDATE OF c_personalondate,c_personaldowndate,
                  C_UPGRADE_DATE, C_UPGRADE_REASON, C_TYPE, C_POSITION, C_REGBELONG, C_PARTY, C_GRADE, C_SCHOOLHISTORY,
                  C_ALLOTDATE, C_ALLOTREASON, C_DEPART, C_OFFICE, C_LINEID, C_BUSID,c_cert2_no,c_cert2_no_hex
  ON T_PERSONAL  FOR EACH ROW  
when (
        old.c_personalondate <> new.c_personalondate or
        old.c_personaldowndate <> new.c_personaldowndate or
        old.C_UPGRADE_DATE <> new.C_UPGRADE_DATE or
        nvl(old.C_UPGRADE_REASON,'-') <> nvl(new.C_UPGRADE_REASON,'-') or
        old.C_TYPE <> new.C_TYPE or
        nvl(old.C_REGBELONG,'-') <> nvl(new.C_REGBELONG,'-') or
        nvl(old.C_PARTY,'-') <> nvl(new.C_PARTY,'-') or
        nvl(old.C_GRADE,'-') <> nvl(new.C_GRADE,'-') or
        nvl(old.C_SCHOOLHISTORY,'-') <> nvl(new.C_SCHOOLHISTORY,'-') or
        old.C_ALLOTDATE <> new.C_ALLOTDATE or
        nvl(old.C_ALLOTREASON,'-') <> nvl(new.C_ALLOTREASON,'-') or
        old.C_DEPART <> new.C_DEPART or
        nvl(old.C_OFFICE,'-') <> nvl(new.C_OFFICE,'-') or
        nvl(old.C_LINEID,0) <> nvl(new.C_LINEID,0) or
        nvl(old.C_BUSID,0) <> nvl(new.C_BUSID,0) or
        nvl(old.c_cert2_no,'-') <> nvl(new.c_cert2_no,'-') or
        nvl(old.c_cert2_no_hex,'-') <> nvl(new.c_cert2_no_hex,'-')
       )
BEGIN
  --修改注册日期
  if :old.c_personalondate <> :new.c_personalondate then
     --1.同步初始业务调动记录
     update T_PSN_ONLINE
     set c_ondate = :new.c_personalondate
     where c_belong = :old.c_belong
     and   c_onlinepsn = :old.C_PERSONALID
     and   c_ondate = :old.c_personalondate;
     --2.同步初始状态变动记录
     update T_PSN_STATUS
     set c_ondate = :new.c_personalondate
     where c_belong = :old.c_belong
     and   c_STATUSpsn = :old.C_PERSONALID
     and   c_ondate = :old.c_personalondate;
  end if;
  --修改注销日期
  if :new.c_PersonalDownDate <> :old.c_PersonalDownDate then
    if :old.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') then
       --注销人员
       --注销验证
       sp_check_psnchange(:old.c_belong,:old.c_PersonalId,:old.c_workerid||'-'||:old.c_PersonalName,to_char(:new.c_PersonalDownDate,'yyyy/mm/dd'));
       --变更调动日期
       --1.同步初始业务调动记录
       update T_PSN_ONLINE
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_onlinepsn = :old.C_PERSONALID
       and   c_downdate = to_date('9999/12/31','yyyy/mm/dd');
       --2.同步初始状态变动记录
       update T_PSN_STATUS
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_STATUSpsn = :old.C_PERSONALID
       and   c_downdate = to_date('9999/12/31','yyyy/mm/dd');
    elsif :new.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') then
       --取消注销
       update T_PSN_ONLINE
       set c_ondate = to_date('9999/12/31','yyyy/mm/dd')
       where c_belong = :old.c_belong
       and   c_onlinepsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
       --2.同步初始状态变动记录
       update T_PSN_STATUS
       set c_ondate = to_date('9999/12/31','yyyy/mm/dd')
       where c_belong = :old.c_belong
       and   c_STATUSpsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
    else
       --变更注销
       update T_PSN_ONLINE
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_onlinepsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
       --2.同步初始状态变动记录
       update T_PSN_STATUS
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_STATUSpsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
    end if;
  end if;
  if    :old.C_ALLOTDATE <> :new.C_ALLOTDATE or
        nvl(:old.C_ALLOTREASON,'-') <> nvl(:new.C_ALLOTREASON,'-') or
        :old.C_DEPART <> :new.C_DEPART or
        nvl(:old.C_OFFICE,'-') <> nvl(:new.C_OFFICE,'-') or
        nvl(:old.C_LINEID,0) <> nvl(:new.C_LINEID,0) or
        nvl(:old.C_BUSID,0) <> nvl(:new.C_BUSID,0) or
        nvl(:old.c_cert2_no,'-') <> nvl(:new.c_cert2_no,'-') or
        nvl(:old.c_cert2_no_hex,'-') <> nvl(:new.c_cert2_no_hex,'-') then
     --修改调动信息
     --同步调动记录
      --1.删除新C_ALLOTDATE后有效的记录
     DELETE FROM T_PSN_ONLINE
     WHERE c_Belong = :NEW.C_BELONG
       AND c_onlinepsn = :NEW.C_PERSONALID
       AND C_ONDATE >= :NEW.C_ALLOTDATE;
      --2.修改当前有效时间内的downdate为C_ALLOTDATE - 1
     UPDATE T_PSN_ONLINE SET C_DOWNDATE = (:NEW.C_ALLOTDATE - 1)
     WHERE c_Belong = :NEW.C_BELONG
       AND c_onlinepsn = :NEW.C_PERSONALID
       AND C_ONDATE = (
                        SELECT MAX(C_ONDATE)
                        FROM T_PSN_ONLINE
                        WHERE C_BELONG = :NEW.C_BELONG
                        AND c_onlinepsn = :NEW.C_PERSONALID
                        AND C_ONDATE < :NEW.C_ALLOTDATE);
      --3.插入新的状态变动记录
     INSERT INTO T_PSN_ONLINE (
        c_belong,
        c_onlinepsn ,
        c_OnDate ,
        C_ALLOTREASON,
        c_Depart ,
        c_Office ,
        c_lineid,
        c_busid,
        c_cert2_no,
        c_cert2_no_hex,
        c_DownDate,
        c_dopsn
        )
        VALUES
          (:NEW.C_BELONG,
           :NEW.C_PERSONALID,
           :NEW.C_ALLOTDATE,
           :NEW.C_ALLOTREASON,
           :NEW.C_DEPART,
           :NEW.C_OFFICE,
           :NEW.C_LINEID,
           :NEW.C_BUSID,
           :NEW.c_cert2_no,
           :NEW.c_cert2_no_hex,
           decode(:new.c_PersonalDownDate, to_date('9999/12/31','yyyy/mm/dd'), to_date('9999/12/31','yyyy/mm/dd'), :new.c_PersonalDownDate -1),
           :NEW.C_LASTMODIFIER);
  end if;
  if    :old.C_UPGRADE_DATE <> :new.C_UPGRADE_DATE or
        nvl(:old.C_UPGRADE_REASON,'-') <> nvl(:new.C_UPGRADE_REASON,'-') or
        :old.C_TYPE <> :new.C_TYPE or
        nvl(:old.C_REGBELONG,'-') <> nvl(:new.C_REGBELONG,'-') or
        nvl(:old.C_PARTY,'-') <> nvl(:new.C_PARTY,'-') or
        nvl(:old.C_GRADE,'-') <> nvl(:new.C_GRADE,'-') or
        nvl(:old.C_SCHOOLHISTORY,'-') <> nvl(:new.C_SCHOOLHISTORY,'-') then
     --修改状态信息
     --同步状态记录
      --1.删除新C_UPGRADE_DATE后有效的记录
     DELETE FROM T_PSN_STATUS
     WHERE c_Belong = :NEW.C_BELONG
       AND c_STATUSPSN = :NEW.C_PERSONALID
       AND C_ONDATE >= :NEW.C_UPGRADE_DATE;
      --2.修改当前有效时间内的downdate为C_UPGRADE_DATE - 1
     UPDATE T_PSN_STATUS SET C_DOWNDATE = (:NEW.C_UPGRADE_DATE - 1)
     WHERE c_Belong = :NEW.C_BELONG
       AND c_STATUSPSN = :NEW.C_PERSONALID
       AND C_ONDATE = (
                      SELECT MAX(C_ONDATE)
                      FROM T_PSN_STATUS
                      WHERE C_BELONG = :NEW.C_BELONG
                      AND c_STATUSpsn = :NEW.C_PERSONALID
                      AND C_ONDATE < :NEW.C_UPGRADE_DATE);
      --3.插入新的状态变动记录
      INSERT INTO T_PSN_STATUS (
                c_belong,
                c_statuspsn,
                c_OnDate,
                C_UPGRADE_REASON,
                c_type,
                c_position,
                c_regbelong,
                c_party,
                c_grade,
                c_schoolhistory,
                c_DownDate,
                c_dopsn
      )
      VALUES
        (:NEW.C_BELONG,
        :NEW.C_PERSONALID,
        :NEW.C_UPGRADE_DATE,
        :NEW.C_UPGRADE_REASON,
        :NEW.C_TYPE,
        :NEW.C_POSITION,
        :NEW.C_REGBELONG,
        :NEW.C_PARTY,
        :NEW.C_GRADE,
        :NEW.C_SCHOOLHISTORY,
        decode(:new.c_PersonalDownDate, to_date('9999/12/31','yyyy/mm/dd'), to_date('9999/12/31','yyyy/mm/dd'), :new.c_PersonalDownDate -1),
        :NEW.C_LASTMODIFIER);
  end if;
  --未注销人员的当前部门、线路、岗位、车队等发生变动，检查票务合法和系统帐户
  if :old.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') and
     :NEW.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') AND
              (
                :new.c_depart <> :old.c_depart or
                nvl(:new.c_lineid,0) <> nvl(:old.c_lineid,0) or
                nvl(:new.c_position,'-') <> nvl(:old.c_position,'-') or
                nvl(:new.c_Office,'-') <> nvl(:old.c_Office,'-')
              ) then
      --变动验证
       sp_check_psnchange(:old.c_belong,:old.c_PersonalId,:old.c_workerid||'-'||:old.c_PersonalName,'-');
  end if;
END;
/
