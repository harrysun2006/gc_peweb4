--162����T_PERSONAL��ɾ��������
--162����T_PERSONAL�Ĳ�����޸Ĵ�����
--162��crt0050203_psnonline_162.sql�в��
---------------------------------------------------
--����
--T_PERSONAL�Ĳ���ǰ������trg_Personalid
--T_PERSONAL�Ĳ���󴥷���trg_af_Personal_ins
--T_PERSONAL��ɾ��ǰ������trg_bf_Personal_del
--T_PERSONAL���޸�ǰ������trg_bf_Personal_upd
--T_PERSONAL���޸ĺ󴥷���trg_af_Personal_upd
----------------------------------------------------
--162��ͬ��
drop TRIGGER trg_Personalonline;
drop TRIGGER trg_Personalstatus;
drop TRIGGER trg_Personal_change;
----------------------------------------------------
--������������Ա���ڲ�ID
--SYS�޸�ǰ���ɰ汾���Զ������䶯ʱ��
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
 --SYS�޸�ǰ���ɰ汾���Զ������䶯ʱ��
 --166:�Զ������䶯ʱ��ȱʡ����ondate
 :new.C_UPGRADE_DATE := :new.c_personalondate;
 :new.C_ALLOTDATE := :new.c_personalondate;
 if :new.c_PersonalDownDate <= :new.c_PersonalOnDate then
   raise_application_error(-20003, '���� '||:new.C_WORKERID||'��ע�����ڱ������ע�����ڣ�');
 end if;  
end;
/
--����󴥷����Զ�����������¼
CREATE OR REPLACE TRIGGER trg_af_Personal_ins
  AFTER INSERT ON T_PERSONAL FOR EACH ROW
BEGIN
--1.�����ʼҵ�������¼
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
--2.�����ʼ״̬�䶯��¼
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
--����ɾ��ǰ�������Զ�ɾ�����ε�����¼
CREATE OR REPLACE TRIGGER trg_bf_Personal_del
  BEFORE DELETE ON T_PERSONAL FOR EACH ROW
BEGIN
 if :old.C_UPGRADE_DATE <> :old.c_personalondate or :old.C_ALLOTDATE <> :old.c_personalondate then
   raise_application_error(-20003, '���� '||:old.C_WORKERID||'�����������ڻ�״̬�䶯���ں���Ա��ע�����ڲ�һ�£���Ա����ɾ�����������쳣���ݻ��޸ĵ������ں�ɾ����');
 end if;
--1.ɾ����ʼҵ�������¼
 delete  from T_PSN_ONLINE
 where c_belong = :old.c_belong
 and   c_onlinepsn = :old.C_PERSONALID;
--2.ɾ����ʼ״̬�䶯��¼
 delete  from T_PSN_STATUS
 where c_belong = :old.c_belong
 and   c_STATUSpsn = :old.C_PERSONALID;
END;
/
--�޸�ǰ��������֤���ںϷ�
CREATE OR REPLACE TRIGGER trg_bf_Personal_upd
  before UPDATE OF c_personalondate,c_personaldowndate,C_UPGRADE_DATE,C_ALLOTDATE
  ON T_PERSONAL  FOR EACH ROW    
BEGIN
  --�޸�ע������
  if :old.c_personalondate <> :new.c_personalondate then
     --��Ա����ҵ�������״̬�䶯�����޸�ע������
     if :old.C_UPGRADE_DATE <> :old.c_personalondate or :old.C_ALLOTDATE <> :old.c_personalondate then
        raise_application_error(-20003, '���� '||:old.C_WORKERID||'��ԭ�������ڻ�״̬�䶯���ں���Ա��ԭע�����ڲ�һ�£���Ա����ҵ�������״̬�䶯�����޸�ע�����ڡ�');
     end if;
     --�޸ĺ���ε������ںͱ䶯���ڱ������ע������
     :new.C_UPGRADE_DATE := :new.c_personalondate;
     :new.C_ALLOTDATE := :new.c_personalondate;
  end if;
  if :new.c_PersonalDownDate <= :new.c_PersonalOnDate then
     raise_application_error(-20003, '���� '||:old.C_WORKERID||'��ע�����ڱ������ע�����ڣ�');
  end if;
  if :new.C_ALLOTDATE < :new.c_PersonalonDate or :new.C_ALLOTDATE >= :new.c_PersonaldownDate then
     raise_application_error(-20003, '���� '||:old.C_WORKERID||'�����ĵ������ڱ�����ڵ���ע�����ڡ�С��ע�����ڣ�');
  end if;
  if :new.C_UPGRADE_DATE < :new.c_PersonalonDate or :new.C_UPGRADE_DATE >= :new.c_PersonaldownDate then
     raise_application_error(-20003, '���� '||:old.C_WORKERID||'�����ı䶯���ڱ�����ڵ���ע�����ڡ�С��ע�����ڣ�');
  end if;
end;
/    
--�޸ĺ󴥷����Զ�����������¼
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
  --�޸�ע������
  if :old.c_personalondate <> :new.c_personalondate then
     --1.ͬ����ʼҵ�������¼
     update T_PSN_ONLINE
     set c_ondate = :new.c_personalondate
     where c_belong = :old.c_belong
     and   c_onlinepsn = :old.C_PERSONALID
     and   c_ondate = :old.c_personalondate;
     --2.ͬ����ʼ״̬�䶯��¼
     update T_PSN_STATUS
     set c_ondate = :new.c_personalondate
     where c_belong = :old.c_belong
     and   c_STATUSpsn = :old.C_PERSONALID
     and   c_ondate = :old.c_personalondate;
  end if;
  --�޸�ע������
  if :new.c_PersonalDownDate <> :old.c_PersonalDownDate then
    if :old.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') then
       --ע����Ա
       --ע����֤
       sp_check_psnchange(:old.c_belong,:old.c_PersonalId,:old.c_workerid||'-'||:old.c_PersonalName,to_char(:new.c_PersonalDownDate,'yyyy/mm/dd'));
       --�����������
       --1.ͬ����ʼҵ�������¼
       update T_PSN_ONLINE
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_onlinepsn = :old.C_PERSONALID
       and   c_downdate = to_date('9999/12/31','yyyy/mm/dd');
       --2.ͬ����ʼ״̬�䶯��¼
       update T_PSN_STATUS
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_STATUSpsn = :old.C_PERSONALID
       and   c_downdate = to_date('9999/12/31','yyyy/mm/dd');
    elsif :new.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') then
       --ȡ��ע��
       update T_PSN_ONLINE
       set c_ondate = to_date('9999/12/31','yyyy/mm/dd')
       where c_belong = :old.c_belong
       and   c_onlinepsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
       --2.ͬ����ʼ״̬�䶯��¼
       update T_PSN_STATUS
       set c_ondate = to_date('9999/12/31','yyyy/mm/dd')
       where c_belong = :old.c_belong
       and   c_STATUSpsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
    else
       --���ע��
       update T_PSN_ONLINE
       set c_ondate = :new.c_PersonalDownDate - 1
       where c_belong = :old.c_belong
       and   c_onlinepsn = :old.C_PERSONALID
       and   c_downdate = :old.c_PersonalDownDate - 1;
       --2.ͬ����ʼ״̬�䶯��¼
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
     --�޸ĵ�����Ϣ
     --ͬ��������¼
      --1.ɾ����C_ALLOTDATE����Ч�ļ�¼
     DELETE FROM T_PSN_ONLINE
     WHERE c_Belong = :NEW.C_BELONG
       AND c_onlinepsn = :NEW.C_PERSONALID
       AND C_ONDATE >= :NEW.C_ALLOTDATE;
      --2.�޸ĵ�ǰ��Чʱ���ڵ�downdateΪC_ALLOTDATE - 1
     UPDATE T_PSN_ONLINE SET C_DOWNDATE = (:NEW.C_ALLOTDATE - 1)
     WHERE c_Belong = :NEW.C_BELONG
       AND c_onlinepsn = :NEW.C_PERSONALID
       AND C_ONDATE = (
                        SELECT MAX(C_ONDATE)
                        FROM T_PSN_ONLINE
                        WHERE C_BELONG = :NEW.C_BELONG
                        AND c_onlinepsn = :NEW.C_PERSONALID
                        AND C_ONDATE < :NEW.C_ALLOTDATE);
      --3.�����µ�״̬�䶯��¼
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
     --�޸�״̬��Ϣ
     --ͬ��״̬��¼
      --1.ɾ����C_UPGRADE_DATE����Ч�ļ�¼
     DELETE FROM T_PSN_STATUS
     WHERE c_Belong = :NEW.C_BELONG
       AND c_STATUSPSN = :NEW.C_PERSONALID
       AND C_ONDATE >= :NEW.C_UPGRADE_DATE;
      --2.�޸ĵ�ǰ��Чʱ���ڵ�downdateΪC_UPGRADE_DATE - 1
     UPDATE T_PSN_STATUS SET C_DOWNDATE = (:NEW.C_UPGRADE_DATE - 1)
     WHERE c_Belong = :NEW.C_BELONG
       AND c_STATUSPSN = :NEW.C_PERSONALID
       AND C_ONDATE = (
                      SELECT MAX(C_ONDATE)
                      FROM T_PSN_STATUS
                      WHERE C_BELONG = :NEW.C_BELONG
                      AND c_STATUSpsn = :NEW.C_PERSONALID
                      AND C_ONDATE < :NEW.C_UPGRADE_DATE);
      --3.�����µ�״̬�䶯��¼
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
  --δע����Ա�ĵ�ǰ���š���·����λ�����ӵȷ����䶯�����Ʊ��Ϸ���ϵͳ�ʻ�
  if :old.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') and
     :NEW.c_PersonalDownDate = to_date('9999/12/31','yyyy/mm/dd') AND
              (
                :new.c_depart <> :old.c_depart or
                nvl(:new.c_lineid,0) <> nvl(:old.c_lineid,0) or
                nvl(:new.c_position,'-') <> nvl(:old.c_position,'-') or
                nvl(:new.c_Office,'-') <> nvl(:old.c_Office,'-')
              ) then
      --�䶯��֤
       sp_check_psnchange(:old.c_belong,:old.c_PersonalId,:old.c_workerid||'-'||:old.c_PersonalName,'-');
  end if;
END;
/
