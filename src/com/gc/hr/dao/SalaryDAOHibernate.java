package com.gc.hr.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.gc.Constants;
import com.gc.common.po.Department;
import com.gc.common.po.Person;
import com.gc.hr.po.SalDeptPsn;
import com.gc.hr.po.SalFact;
import com.gc.hr.po.SalFactD;
import com.gc.hr.po.SalFixOnline;
import com.gc.hr.po.SalItem;
import com.gc.hr.po.SalTemplate;
import com.gc.hr.po.SalTemplateD;
import com.gc.util.CommonUtil;
import com.gc.util.ObjectUtil;

/**
 * HR Salary DAO类
 * @author hsun
 *
 */
public class SalaryDAOHibernate extends HibernateDaoSupport {

//==================================== SalItem ====================================

	public List<SalItem> getSalItems(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select si from SalItem si")
			.append(" left outer join fetch si.branch b");
		String fetch = (String) qo.get(Constants.PARAM_FETCH);
		if (fetch != null) {
			String[] fetchs = fetch.split(",");
			for (int i = 0; i < fetchs.length; i++) sb.append(" left outer join fetch cfd.").append(fetchs[i].trim());
		}
		sb.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and si.branch.id = :branchId");
			if (qo.containsKey("flag")) sb.append(" and si.flagValue = :flag");
			if (qo.containsKey("type")) sb.append(" and si.typeValue = :type");
			if (qo.containsKey("print")) sb.append(" and si.print = :print");
			if (qo.containsKey("onDate_from")) sb.append(" and si.onDate >= :onDate_from");
			if (qo.containsKey("onDate_to")) sb.append(" and si.onDate <= :onDate_to");
			if (qo.containsKey("downDate_from")) sb.append(" and si.downDate >= :downDate_from");
			if (qo.containsKey("downDate_to")) sb.append(" and si.downDate <= :downDate_to");
		}
		String order = (String) qo.get(Constants.PARAM_ORDER);
		if (order == null) order = "no";
		String[] orders = order.split(",");
		if (orders.length > 0) {
			sb.append(" order by");
			for (int i = 0; i < orders.length; i++) sb.append(" si.").append(orders[i].trim()).append(", ");
			sb.delete(sb.length() - 2, sb.length());
		}
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("flag")) q.setParameter("flag", qo.get("flag"));
			if (qo.containsKey("type")) q.setParameter("type", qo.get("type"));
			if (qo.containsKey("print")) q.setParameter("print", qo.get("print"));
			if (qo.containsKey("onDate_from")) q.setParameter("onDate_from", ObjectUtil.toCalendar(qo.get("onDate_from")));
			if (qo.containsKey("onDate_to")) q.setParameter("onDate_to", ObjectUtil.toCalendar(qo.get("onDate_to")));
			if (qo.containsKey("downDate_from")) q.setParameter("downDate_from", ObjectUtil.toCalendar(qo.get("downDate_from")));
			if (qo.containsKey("downDate_to")) q.setParameter("downDate_to", ObjectUtil.toCalendar(qo.get("downDate_to")));
		}
		return (List<SalItem>) q.list();
	}

//==================================== SalDeptPsn ====================================

	/**
	 * 返回的列表元素为对象数组: [depart, count]
	 * depart: Department
	 * count: Long
	 * @param qo
	 * @return
	 */
	public List<Object[]> getDeptPsnStat(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select d, (select count(*) from SalDeptPsn sdp where sdp.id.depart.id = d.id");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sdp.id.branch.id = :branchId");
		}
		sb.append(" group by sdp.id.depart.id")
			.append(") from Department d where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and d.branch.id = :branchId");
		}
		String order = (String) qo.get(Constants.PARAM_ORDER);
		if (order == null) order = "id";
		String[] orders = order.split(",");
		if (orders.length > 0) {
			sb.append(" order by");
			for (int i = 0; i < orders.length; i++) sb.append(" d.").append(orders[i].trim()).append(", ");
			sb.delete(sb.length() - 2, sb.length());
		}
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
		}
		return (List<Object[]>) q.list();
	}

	public List<SalDeptPsn> getDeptPsns1(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select sdp from SalDeptPsn sdp")
			.append(" left outer join fetch sdp.id.depart d")
			.append(" left outer join fetch sdp.id.person p")
			.append(" left outer join fetch p.fkPosition pp")
			.append(" left outer join fetch p.depart pd")
			.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sdp.id.branch.id = :branchId");
			if (qo.containsKey("depart.id")) sb.append(" and sdp.id.depart.id = :departId");
			if (qo.containsKey("person.id")) sb.append(" and sdp.id.person.id = :personId");
		}
		sb.append(" order by sdp.id.person.workerId, sdp.id.depart.id");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
			if (qo.containsKey("person.id")) q.setParameter("personId", qo.get("person.id"));
		}
		return (List<SalDeptPsn>) q.list();
	}

	public List<Person> getDeptPsns0(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.fkPosition");
		String fetch = (String) qo.get(Constants.PARAM_FETCH);
		if (fetch != null) {
			String[] fetchs = fetch.split(",");
			for (int i = 0; i < fetchs.length; i++) sb.append(" left outer join fetch p.").append(fetchs[i].trim());
		}
		sb.append(" where p.id not in (select sdp.id.person.id from SalDeptPsn sdp where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sdp.id.branch.id = :branchId");
		}
		sb.append(")");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and p.branch.id = :branchId");
		}
		String order = (String) qo.get(Constants.PARAM_ORDER);
		if (order == null) order = "workerId";
		String[] orders = order.split(",");
		if (orders.length > 0) {
			sb.append(" order by");
			for (int i = 0; i < orders.length; i++) sb.append(" p.").append(orders[i].trim()).append(", ");
			sb.delete(sb.length() - 2, sb.length());
		}
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
		}
		return (List<Person>) q.list();
	}
	
	/**
	 * 返回发薪人员在多个发薪部门的发薪部门人员
	 * @param qo
	 * @return
	 */
	public List<SalDeptPsn> getDeptPsns2(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select sdp from SalDeptPsn sdp")
			.append(" left outer join fetch sdp.id.depart d")
			.append(" left outer join fetch sdp.id.person p")
			.append(" left outer join fetch p.fkPosition pp")
			.append(" left outer join fetch p.depart pd")
			.append(" where exists (")
			.append(" select sdp1.id.branch, sdp1.id.person, count(sdp1.id.depart) from SalDeptPsn sdp1")
			.append(" where sdp.id.branch.id = sdp1.id.branch.id")
			.append(" and sdp.id.person.id = sdp1.id.person.id")
			.append(" group by sdp1.id.branch.id, sdp1.id.person.id")
			.append(" having count(sdp1.id.depart) > 1")
			.append(")");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sdp.id.branch.id = :bid");
		}
		sb.append(" order by sdp.id.person.workerId, sdp.id.depart.id");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("bid", qo.get("branch.id"));
		}
		return q.list();
	}

	public List<SalFixOnline> getFixOnlines(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select sfo from SalFixOnline sfo")
			.append(" left outer join fetch sfo.id.item si");
		String fetch = (String) qo.get(Constants.PARAM_FETCH);
		if (fetch != null) {
			String[] fetchs = fetch.split(",");
			for (int i = 0; i < fetchs.length; i++) sb.append(" left outer join fetch sfo.").append(fetchs[i].trim());
		}
		sb.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sfo.id.branch.id = :branchId");
			if (qo.containsKey("depart.id")) sb.append(" and sfo.id.depart.id = :departId");
			if (qo.containsKey("person.id")) sb.append(" and sfo.id.person.id = :personId");
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) sb.append(" and sfo.id.person.id in (:persons)");
			if (qo.containsKey("items") && qo.get("items") != null && ((List) qo.get("items")).size() > 0) sb.append(" and sfo.id.item.id in (:items)");
			if (qo.containsKey("onDate_from")) sb.append(" and sfo.id.onDate >= :onDate_from");
			if (qo.containsKey("onDate_to")) sb.append(" and sfo.id.onDate <= :onDate_to");
			if (qo.containsKey("downDate_from")) sb.append(" and sfo.downDate >= :downDate_from");
			if (qo.containsKey("downDate_to")) sb.append(" and sfo.downDate <= :downDate_to");
		}
		sb.append(" order by sfo.id.person.workerId, sfo.id.depart.id, si.no");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
			if (qo.containsKey("person.id")) q.setParameter("personId", qo.get("person.id"));
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) q.setParameterList("persons", (List) qo.get("persons"));
			if (qo.containsKey("items") && qo.get("items") != null && ((List) qo.get("items")).size() > 0) q.setParameterList("items", (List) qo.get("items"));
			if (qo.containsKey("onDate_from")) q.setParameter("onDate_from", ObjectUtil.toCalendar(qo.get("onDate_from")));
			if (qo.containsKey("onDate_to")) q.setParameter("onDate_to", ObjectUtil.toCalendar(qo.get("onDate_to")));
			if (qo.containsKey("downDate_from")) q.setParameter("downDate_from", ObjectUtil.toCalendar(qo.get("downDate_from")));
			if (qo.containsKey("downDate_to")) q.setParameter("downDate_to", ObjectUtil.toCalendar(qo.get("downDate_to")));
		}
		return (List<SalFixOnline>) q.list();
	}

	public int changeDeptPsn(SalDeptPsn osdp, SalDeptPsn nsdp) {
		// if (nsdp.getId().equals(osdp.getId())) getHibernateTemplate().update(nsdp);
		StringBuilder sb = new StringBuilder();
		sb.append("update SalDeptPsn sdp")
			.append(" set sdp.id.depart.id = :newDepartId")
			.append(", sdp.bank = :bank")
			.append(", sdp.bankCard = :bankCard")
			.append(", sdp.comment = :comment")
			.append(" where sdp.id.branch.id = :branchId")
			.append(" and sdp.id.depart.id = :departId")
			.append(" and sdp.id.person.id = :personId");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("newDepartId", nsdp.getDepartId());
		q.setParameter("bank", nsdp.getBank());
		q.setParameter("bankCard", nsdp.getBankCard());
		q.setParameter("comment", nsdp.getComment());
		q.setParameter("branchId", osdp.getBranchId());
		q.setParameter("departId", osdp.getDepartId());
		q.setParameter("personId", osdp.getPersonId());
		return q.executeUpdate();
	}

	public int deleteDeptPsn(SalDeptPsn sdp) {
		StringBuilder sb = new StringBuilder();
		sb.append("delete SalDeptPsn sdp where sdp.id = :id");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("id", sdp.getId());
		return q.executeUpdate();
	}

	@SuppressWarnings("deprecation")
	protected void spFixOnline(Map params) {
		try {
			int branchId = ((Integer) params.get("branch.id")).intValue();
			String departNo = (String) params.get("depart.no");
			String type = (String) params.get("type");
			String personNo = (String) params.get("person.no");
			String itemNo = (String) params.get("item.no");
			String date = CommonUtil.formatCalendar("yyyy/MM/dd", ObjectUtil.toCalendar(params.get("date")));
			double value = ((Double) params.get("value")).doubleValue();
			String doPerson = (String) params.get("doPerson");
			String doDate = CommonUtil.formatCalendar("yyyy/MM/dd", ObjectUtil.toCalendar(params.get("doDate")));
			Connection conn = getSession().connection();
			CallableStatement cs = conn.prepareCall("{call SP_HRSAL_FIXONLINE(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			int index = 1;
			cs.setInt(index++, branchId);
			cs.setString(index++, departNo);
			cs.setString(index++, type);
			cs.setString(index++, personNo);
			cs.setString(index++, itemNo);
			cs.setString(index++, date);
			cs.setDouble(index++, value);
			cs.setString(index++, doPerson);
			cs.setString(index++, doDate);
			cs.execute();
		} catch (Exception e) {
			throw new HibernateException(e);
		}
		/*
		Query q = getSession().getNamedQuery("HRSAL_FIXONLINE")
			.setParameter("branchId", params.get("branch.id"))
			.setParameter("departNo", params.get("depart.no"))
			.setParameter("type", params.get("type"))
			.setParameter("personNo", params.get("person.no"))
			.setParameter("itemNo", params.get("item.no"))
			.setParameter("date", CommonUtil.formatCalendar("yyyy/MM/dd", ObjectUtil.toCalendar(params.get("date"))))
			.setParameter("value", params.get("value"))
			.setParameter("doPerson", params.get("doPerson"))
			.setParameter("doDate", CommonUtil.formatCalendar("yyyy/MM/dd", ObjectUtil.toCalendar(params.get("doDate"))));
		q.uniqueResult();
		*/
	}

	public void addFixOnline(Map params) {
		params.put("type", "1");
		spFixOnline(params);
	}

	public void terminateFixOnline(Map params) {
		params.put("type", "2");
		spFixOnline(params);
	}

	public void changeFixOnline(Map params) {
		addFixOnline(params);
		terminateFixOnline(params);
	}

//==================================== SalTemplate ====================================

	public List<SalTemplate> getTemplates(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select st from SalTemplate st")
			.append(" left outer join fetch st.depart")
			.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and st.branch.id = :branchId");
			if (qo.containsKey("depart.id")) sb.append(" and st.depart.id = :departId");
		}
		sb.append(" order by st.id");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
		}
		return (List<SalTemplate>) q.list();
	}

	public List<SalTemplateD> getTemplateDetails(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select std from SalTemplateD std")
			.append(" left outer join fetch std.id.template st")
			.append(" left outer join fetch std.id.item si")
			.append(" left outer join fetch std.person p")
			.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and std.id.branch.id = :branchId");
			if (qo.containsKey("template.id")) sb.append(" and st.id = :templateId");
			if (qo.containsKey("depart.id")) sb.append(" and st.depart.id = :departId");
			if (qo.containsKey("person.id")) sb.append(" and std.person.id = :personId");
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) sb.append(" and std.person.id in (:persons)");
		}
		sb.append(" order by std.id.branch.id, st.depart.id, st.id, std.id.no, si.no");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("template.id")) q.setParameter("templateId", qo.get("template.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
			if (qo.containsKey("person.id")) q.setParameter("personId", qo.get("person.id"));
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) q.setParameterList("persons", (List) qo.get("persons"));
		}
		return (List<SalTemplateD>) q.list();
	}

	public void deleteTemplate(SalTemplate st) {
		StringBuilder sb = new StringBuilder();
		sb.append("delete SalTemplateD std where std.id.branch.id = :branchId and std.id.template.id = :templateId");
		Query q = getSession().createQuery(sb.toString())
							.setParameter("branchId", st.getBranchId())
							.setParameter("templateId", st.getId());
		q.executeUpdate();
		getHibernateTemplate().delete(st);
	}
	
//==================================== SalFact ====================================

	public List<SalFact> getFacts(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select sf from SalFact sf")
			.append(" left outer join fetch sf.depart")
			.append(" left outer join fetch sf.issuer")
			.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sf.id.branch.id = :branchId");
			if (qo.containsKey("depart.id")) sb.append(" and sf.depart.id = :departId");
		}
		sb.append(" order by sf.id");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
		}
		return (List<SalFact>) q.list();
	}

	public List<SalFactD> getFactDetails(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select sfd from SalFactD sfd")
			.append(" left outer join fetch sfd.id.fact sf")
			.append(" left outer join fetch sfd.id.item si")
			.append(" left outer join fetch sfd.person p")
			.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and sf.id.branch.id = :branchId");
			if (qo.containsKey("fact.no")) sb.append(" and sf.id.no = :factNo");
			if (qo.containsKey("depart.id")) sb.append(" and sf.depart.id = :departId");
			if (qo.containsKey("person.id")) sb.append(" and sfd.person.id = :personId");
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) sb.append(" and sfd.person.id in (:persons)");
		}
		sb.append(" order by sf.id.branch.id, sf.depart.id, sf.id.no, sfd.id.no, si.no");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("fact.no")) q.setParameter("factNo", qo.get("fact.no"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
			if (qo.containsKey("person.id")) q.setParameter("personId", qo.get("person.id"));
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) q.setParameterList("persons", (List) qo.get("persons"));
		}
		return (List<SalFactD>) q.list();
	}

	public void deleteFact(SalFact sf) {
		StringBuilder sb = new StringBuilder();
		sb.append("delete SalFactD sfd where sfd.id.branch.id = :branchId and sfd.id.fact.no = :factNo");
		Query q = getSession().createQuery(sb.toString())
							.setParameter("branchId", sf.getBranchId())
							.setParameter("factNo", sf.getNo());
		q.executeUpdate();
		getHibernateTemplate().delete(sf);
	}

	public void addSalFactD(SalFactD sfd) {
		Map params = new Hashtable();
		params.put("branch.id", sfd.getBranchId());
		params.put("fact.no", sfd.getHdNo());
		params.put("no", sfd.getNo());
		params.put("item.id", sfd.getItemId());
		params.put("depart.id", sfd.getFact().getDepartId());
		params.put("person.id", sfd.getPersonId());
		params.put("amount", sfd.getAmount());
		params.put("date", sfd.getFact().getDate());
		params.put("person.workerId", sfd.getPerson().getWorkerId());
		addSalFactD(params);
	}

	public void addSalFactD(Map params) {
		params.put("type", "1");
		spSalFactD(params);
	}

	@SuppressWarnings("deprecation")
	protected void spSalFactD(Map params) {
		try {
			Connection conn = getSession().connection();
			CallableStatement cs = conn.prepareCall("{call SP_HRSAL_FACTDT(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			int branchId = ((Integer) params.get("branch.id")).intValue();
			String hdNo = (String) params.get("fact.no");
			int no = ((Integer) params.get("no")).intValue();
			int itemId = ((Integer) params.get("item.id")).intValue();
			int departId = ((Integer) params.get("depart.id")).intValue();
			int personId = ((Integer) params.get("person.id")).intValue();
			double amount = ((Double) params.get("amount")).doubleValue();
			Date date = new Date(ObjectUtil.toCalendar(params.get("date")).getTimeInMillis());
			String workerId = (String) params.get("person.workerId");
			String type = (String) params.get("type");
			int index = 1;
			cs.setInt(index++, branchId);
			cs.setString(index++, hdNo);
			cs.setInt(index++, no);
			cs.setInt(index++, itemId);
			cs.setInt(index++, departId);
			cs.setInt(index++, personId);
			cs.setDouble(index++, amount);
			cs.setDate(index++, date);
			cs.setString(index++, workerId);
			cs.setString(index++, type);
			cs.execute();
		} catch (Exception e) {
			throw new HibernateException(e);
		}
	}

	public List<SalFactD> getSalFactDList(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select s from SalFactD s")
			.append(" left outer join fetch s.id.fact")
			.append(" left outer join fetch s.id.fact.depart")
			.append(" left outer join fetch s.id.fact.issuer")
			.append(" left outer join fetch s.id.item")
			.append(" left outer join fetch s.person")
			.append(" where 1=1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and s.id.fact.id.branch.id = :bid");
			if (qo.containsKey("fact.no")) sb.append(" and s.id.fact.id.no = :no");
			if (qo.containsKey("depart.id")) sb.append(" and s.id.fact.depart.id = :did");
			if (qo.containsKey("date_from")) sb.append(" and s.id.fact.date >= :date_from");
			if (qo.containsKey("date_to")) sb.append(" and s.id.fact.date <= :date_to");
			if (qo.containsKey("issueDate_from")) sb.append(" and s.id.fact.issueDate = :issueDate_from");
			if (qo.containsKey("issueDate_to")) sb.append(" and s.id.fact.issueDate = :issueDate_to");
			if (qo.containsKey("issueType")) sb.append(" and s.id.fact.issueTypeValue = :type");
			if (qo.containsKey("issuer.workerId")) sb.append(" and s.id.fact.issuer.workerId = :uid");
			if (qo.containsKey("summary")) sb.append(" and s.id.fact.summary = :summary");
			if (qo.containsKey("comment")) sb.append(" and s.id.fact.comment = :comment");
		}
		sb.append(" order by s.id.fact.id.no, s.id.no, s.id.item.no");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("bid", qo.get("branch.id"));
			if (qo.containsKey("fact.no")) q.setParameter("no", qo.get("fact.no"));
			if (qo.containsKey("depart.id")) q.setParameter("did", qo.get("depart.id"));
			if (qo.containsKey("date_from")) q.setParameter("date_from", ObjectUtil.toCalendar(qo.get("date_from")));
			if (qo.containsKey("date_to")) q.setParameter("date_to", ObjectUtil.toCalendar(qo.get("date_to")));
			if (qo.containsKey("issueDate_from")) q.setParameter("issueDate_from", ObjectUtil.toCalendar(qo.get("issueDate_from")));
			if (qo.containsKey("issueDate_to")) q.setParameter("issueDate_to", ObjectUtil.toCalendar(qo.get("issueDate_to")));
			if (qo.containsKey("issueType")) q.setParameter("type", qo.get("issueType"));
			if (qo.containsKey("issuer.workerId")) q.setParameter("uid", qo.get("issuer.workerId"));
			if (qo.containsKey("summary")) q.setParameter("summary", qo.get("summary"));
			if (qo.containsKey("comment")) q.setParameter("comment", qo.get("comment"));
		}
		return (List<SalFactD>) q.list();
	}
	
	public List<SalFactD> getSelectedSalFactDs(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select s, p.depart from SalFactD s")
		.append(" left outer join fetch s.id.fact")
		.append(" left outer join fetch s.id.fact.depart")
		.append(" left outer join fetch s.id.fact.issuer")
		.append(" left outer join fetch s.id.item")
		.append(" left outer join fetch s.person")
		.append(", PsnOnline p")
		.append(" where 1=1")
		.append(" and s.id.fact.id.branch.id = p.branch.id")
		.append(" and s.person.id = p.person.id")
		.append(" and p.onDate <= s.id.fact.issueDate")
		.append(" and p.downDate >= s.id.fact.issueDate");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and s.id.fact.id.branch.id = :bid");
			if (qo.containsKey("date_from") && qo.get("date_from") != null) sb.append(" and s.id.fact.issueDate >= :from");
			if (qo.containsKey("date_to") && qo.get("date_to") != null) sb.append(" and s.id.fact.issueDate <= :end");
			if (qo.containsKey("items.id")) sb.append(" and s.id.item.id in (:items)");
		}
		sb.append(" order by s.id.fact.depart.id, p.depart.id, s.person.workerId, s.id.fact.id.no, s.id.item.id");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("bid", qo.get("branch.id"));
			if (qo.containsKey("date_from") && qo.get("date_from") != null) q.setParameter("from", ObjectUtil.toCalendar(qo.get("date_from")));
			if (qo.containsKey("date_to") && qo.get("date_to") != null) q.setParameter("end", ObjectUtil.toCalendar(qo.get("date_to")));
			if (qo.containsKey("items.id")) {
				List<SalItem> list = (List<SalItem>) qo.get("items.id");
				List<Integer> items = new ArrayList<Integer>();
				for (SalItem item : list) {
					if (items.indexOf(item.getId()) == -1) items.add(item.getId());
				}
				q.setParameterList("items", items);
			}
		}
		
		List l = q.list();
		List<SalFactD> ret = new ArrayList<SalFactD>();
		for (int i = 0; i < l.size(); i ++) {
			Object[] obj = (Object[]) l.get(i);
			SalFactD sal = (SalFactD) obj[0];
			sal.getPerson().setDepart((Department) obj[1]);
			ret.add(sal);
		}
		return ret;
	}

}
