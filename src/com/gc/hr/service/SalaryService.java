package com.gc.hr.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.gc.common.po.Department;
import com.gc.common.po.Person;
import com.gc.common.service.BaseServiceUtil;
import com.gc.hr.dao.SalaryDAOHibernate;
import com.gc.hr.po.SalDeptPsn;
import com.gc.hr.po.SalFact;
import com.gc.hr.po.SalFactD;
import com.gc.hr.po.SalFixOnline;
import com.gc.hr.po.SalItem;
import com.gc.hr.po.SalTemplate;
import com.gc.hr.po.SalTemplateD;
import com.gc.util.DateUtil;

/**
 * HR Salary Service类
 * @author hsun
 *
 */
class SalaryService {

	private SalaryDAOHibernate salaryDAO;

	public void setSalaryDAO(SalaryDAOHibernate salaryDAO) {
		this.salaryDAO = salaryDAO;
	}

//==================================== SalItem ====================================

	public List<SalItem> getSalItems(Map qo) {
		return salaryDAO.getSalItems(qo);
	}

//==================================== SalDeptPsn ====================================

	public Map<Department, Long> getDeptPsnStat(Map qo) {
		List<Object[]> list = salaryDAO.getDeptPsnStat(qo);
		Map<Department, Long> data = new LinkedHashMap<Department, Long>();
		Department depart;
		Long count;
		Object[] objs;
		for (Iterator<Object[]> it = list.iterator(); it.hasNext(); ) {
			objs = it.next();
			depart = (Department) objs[0];
			count = objs[1] == null ? 0 : (Long) objs[1];
			data.put(depart, count);
		}
		return data;
	}

	public List<SalDeptPsn> getDeptPsns(Map qo) {
		return salaryDAO.getDeptPsns1(qo);
	}

	/**
	 * 返回没有指定发薪部门的人员列表person-->depart(0)
	 * @param qo
	 * @return
	 */
	public List<Person> getDeptPsns0(Map qo) {
		return salaryDAO.getDeptPsns0(qo);
	}

	/**
	 * 返回指定>=1个发薪部门的人员列表person-->depart(>=1)
	 * @param qo
	 * @return
	 */
	public Map<SalDeptPsn, List<SalFixOnline>> getDeptPsn1(Map qo) {
		Calendar now = DateUtil.getBeginCal(Calendar.getInstance(), Calendar.DATE);
		qo.put("onDate_to", now);
		qo.put("downDate_from", now);
		List<SalDeptPsn> list1 = salaryDAO.getDeptPsns1(qo);
		List<SalFixOnline> list2 = salaryDAO.getFixOnlines(qo);
		Map<SalDeptPsn, List<SalFixOnline>> data = new LinkedHashMap<SalDeptPsn, List<SalFixOnline>>();
		SalDeptPsn sdp;
		SalFixOnline sfo;
		SalItem si;
		List<SalFixOnline> sfos = null;
		// 注意拼数据需要根据DAO的排序字段来比较id(person:workerId, deprt:id)!
		String pid0 = null, pid1 = null, pid2 = null;
		Integer did0 = null, did1 = null, did2 = null;
		int i = 0, j = 0;
		List<SalItem> items = new ArrayList<SalItem>();
		while (i < list1.size() && j < list2.size()) {
			sdp = list1.get(i);
			sfo = list2.get(j);
			si = sfo.getItem();
			if (!items.contains(si)) items.add(si);
			pid1 = sdp.getPersonWorkerId();
			did1 = sdp.getDepartId();
			if (!pid1.equals(pid0) || did1 != did0) {
				sfos = new ArrayList<SalFixOnline>();
				data.put(sdp, sfos);
				pid0 = pid1;
				did0 = did1;
			}
			pid2 = sfo.getPersonWorkerId();
			did2 = sfo.getDepartId();
			if (pid2 == null) {
				j++;
				continue;
			}
			if (pid2.equals(pid1)) {
				if (did2 == did1) sfos.add(sfo);
				if (did2 <= did1) j++;
				else i++;
			} else if (pid2.compareTo(pid1) > 0) {
				i++;
			} else {
				j++;
			}
		}
		while (i < list1.size()) {
			sdp = list1.get(i);
			if (!data.containsKey(sdp)) {
				sfos = new ArrayList<SalFixOnline>();
				data.put(sdp, sfos);
			}
			i++;
		}
		qo.put("#items", items);
		qo.put("#time", now);
		return data;
	}

	/**
	 * 返回指定>1个发薪部门的人员列表person-->depart(>1)
	 * @param qo
	 * @return
	 */
	public Map<SalDeptPsn, List<SalFixOnline>> getDeptPsn2(Map qo) {
		Calendar now = DateUtil.getBeginCal(Calendar.getInstance(), Calendar.DATE);
		qo.put("onDate_to", now);
		qo.put("downDate_from", now);
		List<SalDeptPsn> list1 = salaryDAO.getDeptPsns2(qo);
		List<Integer> persons = new ArrayList<Integer>();
		Integer personId = null;
		for (SalDeptPsn deptPsn : list1) {
			if (personId != deptPsn.getPersonId()) {
				personId = deptPsn.getPersonId();
				persons.add(personId);
			}
		}
		qo.put("persons", persons);
		List<SalFixOnline> list2 = salaryDAO.getFixOnlines(qo);
		Map<SalDeptPsn, List<SalFixOnline>> data = new LinkedHashMap<SalDeptPsn, List<SalFixOnline>>();
		SalDeptPsn sdp;
		SalFixOnline sfo;
		SalItem si;
		List<SalFixOnline> sfos = null;
		String pid0 = null, pid1 = null, pid2 = null;
		Integer did0 = null, did1 = null, did2 = null;
		int i = 0, j = 0;
		List<SalItem> items = new ArrayList<SalItem>();
		while (i < list1.size() && j < list2.size()) {
			sdp = list1.get(i);
			sfo = list2.get(j);
			si = sfo.getItem();
			if (!items.contains(si)) items.add(si);
			pid1 = sdp.getPersonWorkerId();
			did1 = sdp.getDepartId();
			if (!pid1.equals(pid0) || did1 != did0) {
				sfos = new ArrayList<SalFixOnline>();
				data.put(sdp, sfos);
				pid0 = pid1;
				did0 = did1;
			}
			pid2 = sfo.getPersonWorkerId();
			did2 = sfo.getDepartId();
			if (pid2.equals(pid1)) {
				if (did2 == did1) sfos.add(sfo);
				if (did2 <= did1) j++;
				else i++;
			} else if (pid2.compareTo(pid1) > 0) {
				i++;
			} else {
				j++;
			}
		}
		while (i < list1.size()) {
			sdp = list1.get(i);
			if (!data.containsKey(sdp)) {
				sfos = new ArrayList<SalFixOnline>();
				data.put(sdp, sfos);
			}
			i++;
		}
		qo.put("#items", items);
		qo.put("#time", now);
		return data;
	}

	public List<SalFixOnline> getFixOnlines(Map qo) {
		return salaryDAO.getFixOnlines(qo);
	}

	public int changeDeptPsn(SalDeptPsn osdp, SalDeptPsn nsdp) {
		return salaryDAO.changeDeptPsn(osdp, nsdp);
	}

	public int changeDeptPsns(SalDeptPsn[] osdps, SalDeptPsn[] nsdps) {
		if (osdps == null || nsdps == null || osdps.length != nsdps.length) return 0;
		for (int i = 0; i < nsdps.length; i++) {
			changeDeptPsn(osdps[i], nsdps[i]);
		}
		return nsdps.length;
	}

	public int deleteDeptPsns(SalDeptPsn[] sdps) {
		if (sdps == null) return 0;
		for (int i = 0; i < sdps.length; i++) {
			salaryDAO.deleteDeptPsn(sdps[i]);
		}
		return sdps.length;
	}

	public void addFixOnlines(SalFixOnline[] sfos, String user) {
		for (int i = 0; i < sfos.length; i++) {
			Map params = new HashMap();
			params.put("branch.id", sfos[i].getBranchId());
			params.put("depart.no", sfos[i].getDepartNo());
			params.put("person.no", sfos[i].getPersonWorkerId());
			params.put("item.no", sfos[i].getItemNo());
			params.put("date", sfos[i].getOnDate());
			params.put("value", sfos[i].getAmount());
			params.put("doPerson", user);
			params.put("doDate", Calendar.getInstance());
			salaryDAO.addFixOnline(params);
		}
	}

	public void terminateFixOnlines(SalFixOnline[] sfos, String user) {
		for (int i = 0; i < sfos.length; i++) {
			Map params = new HashMap();
			params.put("branch.id", sfos[i].getBranchId());
			params.put("depart.no", sfos[i].getDepartNo());
			params.put("person.no", sfos[i].getPersonWorkerId());
			params.put("item.no", sfos[i].getItemNo());
			params.put("date", sfos[i].getDownDate());
			params.put("value", sfos[i].getAmount());
			params.put("doPerson", user);
			params.put("doDate", Calendar.getInstance());
			salaryDAO.terminateFixOnline(params);
		}
	}

	public void changeFixOnlines(SalFixOnline[] sfos, String user) {
		for (int i = 0; i < sfos.length; i++) {
			Map params = new HashMap();
			params.put("branch.id", sfos[i].getBranchId());
			params.put("depart.no", sfos[i].getDepartNo());
			params.put("person.no", sfos[i].getPersonWorkerId());
			params.put("item.no", sfos[i].getItemNo());
			params.put("date", sfos[i].getOnDate());
			params.put("value", sfos[i].getAmount());
			params.put("doPerson", user);
			params.put("doDate", Calendar.getInstance());
			salaryDAO.terminateFixOnline(params);
			salaryDAO.addFixOnline(params);
		}
	}

//==================================== SalTemplate ====================================

	public List<SalTemplate> getTemplates(Map qo) {
		return salaryDAO.getTemplates(qo);
	}

	public List<SalTemplateD> getTemplateDetails(Map qo) {
		return salaryDAO.getTemplateDetails(qo);
	}

	public void deleteTemplate(SalTemplate st) {
		salaryDAO.deleteTemplate(st);
	}
	
//==================================== SalFact ====================================

	public List<SalFact> getFacts(Map qo) {
		return salaryDAO.getFacts(qo);
	}

	public List<SalFactD> getFactDetails(Map qo) {
		return salaryDAO.getFactDetails(qo);
	}

	public void deleteFact(SalFact sf) {
		salaryDAO.deleteFact(sf);
	}

	public SalFact saveFact(SalFact header, SalFactD[] opos, SalFact nheader, SalFactD[] npos) {
		String ono = nheader.getNo();
		String no;
		if (ono == null) {
			no = CommonServiceUtil.getSalFactNo(nheader.getBranchId(), nheader.getIssueDate());
			nheader.getId().setNo(no);
		}
		if (ono == null) BaseServiceUtil.addObject(nheader);
		else BaseServiceUtil.updateObject(nheader);
		if (header != null) {
			BaseServiceUtil.deleteObjects(SalFactD.class.getName(), header);
		}
		BaseServiceUtil.flush();
		for (int i = 0; i < npos.length; i++) {
			npos[i].getId().setFact(nheader);
			addSalFactD(npos[i]);
		}
		if (npos.length == 0) {
			BaseServiceUtil.deleteObject(nheader);
			return null;
		}
		return nheader;
	}

	public void addSalFactD(SalFactD sfd) {
		salaryDAO.addSalFactD(sfd);
	}

	public List<SalFactD> getSalFactDList(Map qo) {
		return salaryDAO.getSalFactDList(qo);
	}
	
	public List<SalFactD> getSelectedSalFactDs(Map qo) {
		return salaryDAO.getSelectedSalFactDs(qo);
	}
	
}
