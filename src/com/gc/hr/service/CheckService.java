package com.gc.hr.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import com.gc.Constants;
import com.gc.common.po.Department;
import com.gc.common.po.Person;
import com.gc.common.po.PsnOnline;
import com.gc.common.service.BaseServiceUtil;
import com.gc.exception.CommonRuntimeException;
import com.gc.hr.dao.CheckDAOHibernate;
import com.gc.hr.po.ChkDisp;
import com.gc.hr.po.ChkExtra;
import com.gc.hr.po.ChkFact;
import com.gc.hr.po.ChkFactD;
import com.gc.hr.po.ChkGroup;
import com.gc.hr.po.ChkHoliday;
import com.gc.hr.po.ChkLongPlan;
import com.gc.hr.po.ChkPlan;
import com.gc.hr.po.ChkPlanD;
import com.gc.hr.po.ChkWork;
import com.gc.util.CommonUtil;
import com.gc.util.JxlUtil;

/**
 * HR Check Service类
 * @author hsun
 *
 */
class CheckService {

	private CheckDAOHibernate checkDAO;

	public void setCheckDAO(CheckDAOHibernate checkDAO) {
		this.checkDAO = checkDAO;
	}

//==================================== ChkHoliday ====================================

	public List<ChkHoliday> getHolidays(Integer branchId) {
		return checkDAO.getHolidays(branchId);
	}

//==================================== ChkWork ====================================

	public List<ChkWork> getWorks(Integer branchId) {
		return checkDAO.getWorks(branchId);
	}

//==================================== ChkExtr ====================================

	public List<ChkExtra> getExtras(Integer branchId) {
		return checkDAO.getExtras(branchId);
	}

//==================================== ChkDisp ====================================

	public List<ChkDisp> getDisps(Integer branchId) {
		return checkDAO.getDisps(branchId);
	}

//==================================== ChkGroup ====================================

	public List<ChkGroup> getGroups(Integer branchId) {
		return checkDAO.getGroups(branchId);
	}

	public List<Department> getDepartmentsAndGroups(Integer departId) {
		return checkDAO.getDepartmentsAndGroups(departId);
	}

	public List<ChkGroup> getGroupsByDepart(Integer departId) {
		return checkDAO.getGroupsByDepart(departId);
	}

	public List<Person> getCheckPersonsByDepart(Integer departId) {
		return checkDAO.getCheckPersonsByDepart(departId);
	}

	public List<Person> getCheckPersonsByGroup(ChkGroup group) {
		return checkDAO.getCheckPersonsByGroup(group);
	}

//==================================== ChkLongPlan ====================================

	public List<ChkLongPlan> getLongPlans(Map qo) {
		return checkDAO.getLongPlans(qo);
	}

	public String saveLongPlan(ChkLongPlan po) {
		return saveLongPlan2(po);
	}

	protected String saveLongPlan1(ChkLongPlan po) {
		String no = CommonServiceUtil.getChkLongPlanNo(po.getBranchId(), po.getCheckDate());
		System.out.println("Get LongPlan NO: " + no);
		if (true) throw new RuntimeException("Hello!");
		return no;
	}

	protected String saveLongPlan2(ChkLongPlan po) {
		String no = po.getNo();
		Date lastCloseDate = CommonServiceUtil.getLastCloseDate(po.getBranchId());
		if (po.getCheckDate() != null 
				&& po.getCheckDate().getTime().compareTo(lastCloseDate) < 0)
				throw new CommonRuntimeException(CommonUtil.getString("error.beyond.closeDate", new Object[]{CommonUtil.formatDate(Constants.DEFAULT_DATETIME_FORMAT, lastCloseDate)}));
		if (no == null || no == "") {// add new ChkLongPlan
			no = CommonServiceUtil.getChkLongPlanNo(po.getBranchId(), po.getCheckDate());
			po.getId().setNo(no);
			BaseServiceUtil.addObject(po);
		} else {
			BaseServiceUtil.updateObject(po);
		}
		return no;
	}

	public List<Person> getCheckPersonsAndCLPs(Map qo) {
		ChkGroup group = new ChkGroup();
		group.setName((String) qo.get("group.name"));
		List<Person> list1 = checkDAO.getCheckPersonsByGroup(group);
		List<ChkLongPlan> list2 = checkDAO.getLongPlans(qo);
		ChkLongPlan clp;
		for(Iterator<ChkLongPlan> it = list2.iterator(); it.hasNext(); ) {
			clp = it.next();
			clp.getPerson().addChkLongPlan(clp);
		}
		return list1;
	}

//==================================== ChkPlan ====================================
	
	public List<ChkPlan> getPlans(Integer branchId) {
		return checkDAO.getPlans(branchId);
	}

	public List<ChkPlan> getPlans(ChkPlan cp) {
		return checkDAO.getPlans(cp);
	}

	public List<ChkPlanD> getPlanDetails(Map qo) {
		return checkDAO.getPlanDetails(qo);
	}

	public List<Person> getCheckPersonsAndCPDs(Map qo) {
		List<ChkPlanD> list1 = checkDAO.getPlanDetails(qo);
		List<Person> list2 = new ArrayList();
		ChkPlanD cpd;
		Person p;
		for(Iterator<ChkPlanD> it = list1.iterator(); it.hasNext(); ) {
			cpd = it.next();
			p = cpd.getPerson();
			p.addChkPlanD(cpd);
			if (!list2.contains(p)) list2.add(p);
		}
		return list2;
	}

//==================================== ChkFact ====================================
	
	public List<ChkFact> getFacts(Integer branchId) {
		return checkDAO.getFacts(branchId);
	}


	public List<ChkFact> getFacts(ChkFact cf) {
		return checkDAO.getFacts(cf);
	}

	public List<ChkFactD> getFactDetails(Map qo) {
		return checkDAO.getFactDetails(qo);
	}

	public List<Person> getCheckPersonsAndCFDs(Map qo) {
		List<ChkFactD> list1 = checkDAO.getFactDetails(qo);
		List<Person> list2 = new ArrayList();
		ChkFactD cfd;
		Person p;
		for(Iterator<ChkFactD> it = list1.iterator(); it.hasNext(); ) {
			cfd = it.next();
			p = cfd.getPerson();
			p.addChkFactD(cfd);
			if (!list2.contains(p)) list2.add(p);
		}
		return list2;
	}

//==================================== Report ====================================

	public List<Person> getPersonsOnlineByDepart(Map qo) {
		return checkDAO.getPersonsOnlineByDepart(qo);
	}

	public Map<PsnOnline, List<ChkFactD>> getOnlinePersonsAndCFDs(Map qo) {
		Person person = qo.containsKey("person") ? (Person) qo.get("person") : null;
		if (person != null) {
			Map q2 = new Hashtable();
			q2.put("id", person.getId());
			q2.put("workerId", person.getWorkerId());
			List<Person> persons = PersonalServiceUtil.findPersons(q2);
			if (persons.size() <= 0) throw new CommonRuntimeException(CommonUtil.getString("error.person.nonexistence", new Object[]{person.getWorkerId()}));
			person = persons.get(0);
			qo.put("person.id", person.getId());
			if (!qo.containsKey("depart.id")) qo.put("depart.id", person.getDepartId());
		}
		List<Object[]> list = checkDAO.getOnlinePersonsAndCFDs(qo);
		Map<PsnOnline, List<ChkFactD>> data = new Hashtable<PsnOnline, List<ChkFactD>>();
		PsnOnline po;
		ChkFactD cfd;
		List<ChkFactD> cfds;
		Object[] objs;
		for (Iterator<Object[]> it = list.iterator(); it.hasNext(); ) {
			objs = it.next();
			po = (PsnOnline) objs[0];
			cfd = (ChkFactD) objs[1];
			if (data.containsKey(po)) {
				cfds = data.get(po);
			} else {
				cfds = new ArrayList<ChkFactD>();
				data.put(po, cfds);
			}
			cfds.add(cfd);
		}
		return data;
	}

	public Map<Person, Map<Object, Long>> getOnlinePersonsAndCheckStat(Map qo) {
		List<Object[]> list1 = checkDAO.getOnlinePersonsAndCheckStat(qo);
		Map<Person, Map<Object, Long>> data = new LinkedHashMap<Person, Map<Object, Long>>();
		Map<Object, Long> stat = null;
		Object[] objs;
		Integer pid = null, cid;
		Person p;
		Long count;
		// list1: person.id, person.name, person.workerId, person.contractNo, holiday, work, extra, disp, count
		for (Iterator<Object[]> it = list1.iterator(); it.hasNext(); ) {
			objs = it.next();
			cid = (Integer) objs[0];
			if (!cid.equals(pid)) {// another person
				pid = cid;
				p = new Person();
				p.setId(cid);
				p.setName((String) objs[1]);
				p.setWorkerId((String) objs[2]);
				p.setContractNo((String) objs[3]);
				stat = new Hashtable<Object, Long>();
				data.put(p, stat);
			}
			for (int i = 4; i < 8 ; i++) {// holiday, work, extra, disp
				if (objs[i] != null) {
					count = stat.containsKey(objs[i]) ? stat.get(objs[i]) : 0;
					count += (Long) objs[8];
					stat.put(objs[i], count);
				}
			}
		}
		return data;
	}

	public void reportPersonCheck(Map qo, HttpServletResponse response) {
		Map<PsnOnline, List<ChkFactD>> data = getOnlinePersonsAndCFDs(qo);
		try {
			String path = (String) Constants.SETTINGS.get(Constants.PROP_TEMPLATE_PATH);
			WritableWorkbook wwb = JxlUtil.copy(response.getOutputStream(), path + "hr_chk_ygkqb.xls");
			WritableSheet ws = wwb.getSheet(0);
			StringBuilder description = new StringBuilder("考勤符号:");
			String format = CommonUtil.getString("date.format.ym");
			PsnOnline po = data.size() > 0 ? (PsnOnline) data.keySet().toArray()[0] : null;
			Person person = po != null ? po.getPerson() : qo.containsKey("person") ? (Person) qo.get("person") : null;
			List<ChkFactD> cfds;
			ChkFactD cfd;
			if (person != null) {
				JxlUtil.writeCell(ws, 1, 1, person.getDepartName());
				// JxlUtil.writeCell(ws, 22, 1, person.getChkGroupName());
				JxlUtil.writeCell(ws, 1, 2, person.getName());
				JxlUtil.writeCell(ws, 6, 2, person.getSex());
				JxlUtil.writeCell(ws, 11, 2, person.getPositionName());
				JxlUtil.writeCell(ws, 17, 2, CommonUtil.formatCalendar(format, person.getBirthday()));
				JxlUtil.writeCell(ws, 23, 2, CommonUtil.formatCalendar(format, person.getWorkDate()));
				JxlUtil.writeCell(ws, 29, 2, person.getServiceLength());
				Integer branchId = person.getBranchId();
				List<ChkWork> works = getWorks(branchId);
				List<ChkHoliday> holidays = getHolidays(branchId);
				List<ChkExtra> extras = getExtras(branchId);
				List<ChkDisp> disps = getDisps(branchId);
				ChkWork work;
				ChkHoliday holiday;
				ChkExtra extra;
				ChkDisp disp;
				for (Iterator<ChkWork> it1 = works.iterator(); it1.hasNext(); ) {
					work = it1.next();
					description.append(work.getName()).append("（").append(work.getNo()).append("）、");
				}
				for (Iterator<ChkHoliday> it2 = holidays.iterator(); it2.hasNext(); ) {
					holiday = it2.next();
					description.append(holiday.getName()).append("（").append(holiday.getNo()).append("）、");
				}
				for (Iterator<ChkExtra> it3 = extras.iterator(); it3.hasNext(); ) {
					extra = it3.next();
					description.append(extra.getName()).append("（").append(extra.getNo()).append("）、");
				}
				for (Iterator<ChkDisp> it4 = disps.iterator(); it4.hasNext(); ) {
					disp = it4.next();
					description.append(disp.getName()).append("（").append(disp.getNo()).append("）、");
				}
				if (works.size() + holidays.size() + extras.size() + disps.size() > 0) {
					description.delete(description.length()-1, description.length());
					description.append("。");
				}
			}
			Calendar cal;
			int row, col;
			for (Iterator<PsnOnline> it1 = data.keySet().iterator(); it1.hasNext(); ) {
				po = it1.next();
				cfds = data.get(po);
				for (Iterator<ChkFactD> it2 = cfds.iterator(); it2.hasNext(); ) {
					cfd = it2.next();
					cal = cfd.getDate();
					row = cal.get(Calendar.MONTH)*4+5;
					col = cal.get(Calendar.DATE);
					JxlUtil.writeCell(ws, col, row, cfd.getWorkNo());
					JxlUtil.writeCell(ws, col, row+1, cfd.getHolidayNo());
					JxlUtil.writeCell(ws, col, row+2, cfd.getExtraNo());
					JxlUtil.writeCell(ws, col, row+3, cfd.getDispNo());
				}
			}
			JxlUtil.writeCell(ws, 0, 53, description.toString());
			wwb.write();
			wwb.close();
			response.setContentType("application/vnd.ms-excel");
			response.flushBuffer();
		} catch (Exception e) {
			throw new CommonRuntimeException(CommonUtil.getString("error.report.person.check"), e);
		}
	}

	private String getItemHeader(Object item) {
		String s = "";
		if (item instanceof ChkWork) s = ((ChkWork) item).getName();
		else if (item instanceof ChkHoliday) s = ((ChkHoliday) item).getName();
		else if (item instanceof ChkExtra) s = ((ChkExtra) item).getName();
		else if (item instanceof ChkDisp) s = ((ChkDisp) item).getName();
		StringBuilder r = new StringBuilder();
		if (s.length() > 0 && s.length() <= 3) {
			for (int i = 0; i < s.length(); i++) {
				r.append(s.charAt(i)).append(' ');
			}
			r.delete(r.length() - 1, r.length());
		} else {
			r.append(s);
		}
		return r.toString();
	}

	private String getItemId(Object item) {
		String s = "";
		if (item instanceof ChkWork) s = "w" + ((ChkWork) item).getId();
		else if (item instanceof ChkHoliday) s = "h" + ((ChkHoliday) item).getId();
		else if (item instanceof ChkExtra) s = "e" + ((ChkExtra) item).getId();
		else if (item instanceof ChkDisp) s = "d" + ((ChkDisp) item).getId();
		return s;
	}

	public void reportDepartCheck(Map qo, HttpServletResponse response) {
		Map<Person, Map<Object, Long>> data = getOnlinePersonsAndCheckStat(qo);
		try {
			String path = (String) Constants.SETTINGS.get(Constants.PROP_TEMPLATE_PATH);
			WritableWorkbook wwb = JxlUtil.copy(response.getOutputStream(), path + "hr_chk_ygkqhzb.xls");
			WritableSheet ws = wwb.getSheet(0);
			// write title
			Department depart = qo.containsKey("depart") ? (Department) qo.get("depart") : null;
			if (depart != null) {
				JxlUtil.writeCell(ws, 2, 1, depart.getName());
			}
			Calendar cal = Calendar.getInstance();
			String dfYmd = CommonUtil.getString("date.format.ymd", Constants.DEFAULT_DATE_FORMAT);
			JxlUtil.writeCell(ws, 17, 1, CommonUtil.getString("report.chkFactD.fillDate", 
					new Object[]{CommonUtil.formatCalendar(dfYmd, cal)}));
			// write columns' header
			Person p;
			Map<Object, Long> stat;
			Object item;
			int row = 2, col = 2;
			Map<String, Integer> columns = new Hashtable<String, Integer>();
			Integer branchId = (Integer) qo.get("branch.id");
			List items = new ArrayList();
			items.addAll(getWorks(branchId));
			items.addAll(getHolidays(branchId));
			items.addAll(getExtras(branchId));
			items.addAll(getDisps(branchId));
			for (Iterator it = items.iterator(); it.hasNext(); ) {
				item = it.next();
				col++;
				if (col >= 21) JxlUtil.insertColumn(ws, col);
				columns.put(getItemId(item), new Integer(col));
				JxlUtil.writeCell(ws, col, row, getItemHeader(item));
			}
			// write table cells
			for (Iterator<Person> it1 = data.keySet().iterator(); it1.hasNext(); ) {
				p = it1.next();
				stat = data.get(p);
				row++;
				if (row >= 20) JxlUtil.insertRow(ws, row);
				JxlUtil.writeCell(ws, 0, row, new Integer(row-2));
				JxlUtil.writeCell(ws, 1, row, p.getContractNo());
				JxlUtil.writeCell(ws, 2, row, p.getName());
				for (Iterator<Object> it2 = stat.keySet().iterator(); it2.hasNext(); ) {
					item = it2.next();
					JxlUtil.writeCell(ws, columns.get(getItemId(item)).intValue(), row, stat.get(item));
				}
			}
			wwb.write();
			wwb.close();
			response.setContentType("application/vnd.ms-excel");
			response.flushBuffer();
		} catch (Exception e) {
			throw new CommonRuntimeException(CommonUtil.getString("error.report.depart.check"), e);
		}
	}
}
