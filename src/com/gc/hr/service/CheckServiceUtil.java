package com.gc.hr.service;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.context.ApplicationContext;

import com.gc.common.po.Department;
import com.gc.common.po.Person;
import com.gc.common.po.PsnOnline;
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
import com.gc.util.DateUtil;
import com.gc.util.SpringUtil;

/**
 * HR Check ServiceUtil类
 * @author hsun
 *
 */
public class CheckServiceUtil {

	public static final String BEAN_NAME = "hrCheckServiceUtil";

	private CheckService checkService;

	public static CheckService getCheckService() {
		ApplicationContext ctx = SpringUtil.getContext();
		CheckServiceUtil util = (CheckServiceUtil) ctx.getBean(BEAN_NAME);
		CheckService service = util.checkService;
		return service;
	}

	public void setCheckService(CheckService checkService) {
		this.checkService = checkService;
	}

//==================================== ChkHoliday ====================================

	public static List<ChkHoliday> getHolidays(Integer branchId) {
		return getCheckService().getHolidays(branchId);
	}

//==================================== ChkWork ====================================

	public static List<ChkWork> getWorks(Integer branchId) {
		return getCheckService().getWorks(branchId);
	}

//==================================== ChkExtr ====================================

	public static List<ChkExtra> getExtras(Integer branchId) {
		return getCheckService().getExtras(branchId);
	}

//==================================== ChkDisp ====================================

	public static List<ChkDisp> getDisps(Integer branchId) {
		return getCheckService().getDisps(branchId);
	}

//==================================== ChkGroup ====================================

	public static List<ChkGroup> getGroups(Integer branchId) {
		return getCheckService().getGroups(branchId);
	}

	public static List<Department> getDepartmentsAndGroups(Integer departId) {
		return getCheckService().getDepartmentsAndGroups(departId);
	}

	public static List<ChkGroup> getGroupsByDepart(Integer departId) {
		return getCheckService().getGroupsByDepart(departId);
	}

	public static List<Person> getCheckPersonsByDepart(Integer departId) {
		return getCheckService().getCheckPersonsByDepart(departId);
	}

	public static List<Person> getCheckPersonsByGroup(ChkGroup group) {
		return getCheckService().getCheckPersonsByGroup(group);
	}

//==================================== ChkLongPlan ====================================

	public static List<ChkLongPlan> getLongPlans(Map qo) {
		return getCheckService().getLongPlans(qo);
	}

	public static String saveLongPlan(ChkLongPlan po) {
		return getCheckService().saveLongPlan(po);
	}

//==================================== ChkPlan ====================================

	public static List<ChkPlan> getPlans(Integer branchId) {
		return getCheckService().getPlans(branchId);
	}

	public static List<ChkPlan> getPlans(ChkPlan cp) {
		return getCheckService().getPlans(cp);
	}

	public static List<ChkPlanD> getPlanDetails(Integer branchId, String hdNo) {
		return getPlanDetails(new ChkPlan(branchId, hdNo));
	}

	/**
	 * Hashtable的Entry中value不可以是null, HashMap的Entry中value可以是null
	 * @param cp
	 * @return
	 */
	public static List<ChkPlanD> getPlanDetails(ChkPlan cp) {
		Map qo = new Hashtable();
		if(cp.getBranchId() != null) qo.put("plan.branch.id", cp.getBranchId());
		if(cp.getNo() != null) qo.put("plan.no", cp.getNo());
		if(cp.getDepartId() != null) qo.put("plan.depart.id", cp.getDepartId());
		if(cp.getOffice() != null) qo.put("plan.office", cp.getOffice());
		return getPlanDetails(qo);
	}

	public static List<ChkPlanD> getPlanDetails(Map qo) {
		return getCheckService().getPlanDetails(qo);
	}

	public static List<Person> getCheckPersonsAndCLPs(Map qo) {
		return getCheckService().getCheckPersonsAndCLPs(qo);
	}

	/**
	 * 返回人员考勤计划表
	 * person: Person(fetched: chkPlanDs(fetched: person, id.plan, holiday, work, extra))
	 * @param qo
	 * @return
	 */
	public static List<Person> getCheckPersonsAndCPDs(Map qo) {
		return getCheckService().getCheckPersonsAndCPDs(qo);
	}

	/**
	 * 按考勤组和月建立计划, 建立时自动调出对应人员的请假单
	 * @param cp: office, date
	 * @return
	 */
	public static List<Person> getCheckPersonsAndCLPs(ChkPlan cp) {
		Map qo = new Hashtable();
		if(cp.getOffice() != null) qo.put("group.name", cp.getOffice());
		if(cp.getDate() != null) {
			qo.put("date_from", DateUtil.getBeginCal(cp.getDate()));
			qo.put("date_to", DateUtil.getEndCal(cp.getDate()));
		}
		return getCheckPersonsAndCLPs(qo);
	}

	/**
	 * 修改考勤计划, 按人员分组调出考勤计划凭证
	 * @param cp: id.branch.id, id.no
	 * @return
	 */
	public static List<Person> getCheckPersonsAndCPDs(ChkPlan cp) {
		Map qo = new Hashtable();
		if(cp.getBranchId() != null) qo.put("plan.branch.id", cp.getBranchId());
		if(cp.getNo() != null) qo.put("plan.no", cp.getNo());
		if(cp.getDate() != null) {
			qo.put("date_from", DateUtil.getBeginCal(cp.getDate()));
			qo.put("date_to", DateUtil.getEndCal(cp.getDate()));
		}
		return getCheckPersonsAndCPDs(qo);
	}

//==================================== ChkFact ====================================

	public static List<ChkFact> getFacts(Integer branchId) {
		return getCheckService().getFacts(branchId);
	}

	public static List<ChkFact> getFacts(ChkFact cf) {
		return getCheckService().getFacts(cf);
	}

	public static List<ChkFactD> getFactDetails(Integer branchId, String hdNo) {
		return getFactDetails(new ChkFact(branchId, hdNo));
	}

	public static List<ChkFactD> getFactDetails(ChkFact cf) {
		Map qo = new Hashtable();
		if(cf.getBranchId() != null) qo.put("fact.branch.id", cf.getBranchId());
		if(cf.getNo() != null) qo.put("fact.no", cf.getNo());
		// if(cf.getDepartId() != null) qo.put("fact.depart.id", cf.getDepartId());
		// if(cf.getOffice() != null) qo.put("plan.office", cf.getOffice());
		return getFactDetails(qo);
	}

	public static List<ChkFactD> getFactDetails(Map qo) {
		return getCheckService().getFactDetails(qo);
	}

	public static List<Person> getCheckPersonsAndCPDs(ChkFact cf) {
		Map qo = new Hashtable();
		if(cf.getBranchId() != null) qo.put("plan.branch.id", cf.getBranchId());
		if(cf.getDepartId() != null) qo.put("plan.depart.id", cf.getDepartId());
		if(cf.getOffice() != null) qo.put("plan.office", cf.getOffice());
		if(cf.getDate() != null) {
			qo.put("date_from", DateUtil.getBeginCal(cf.getDate()));
			qo.put("date_to", DateUtil.getEndCal(cf.getDate()));
		}
		return getCheckPersonsAndCPDs(qo);
	}

	public static List<Person> getCheckPersonsAndCLPs(ChkFact cf) {
		Map qo = new Hashtable();
		if(cf.getOffice() != null) qo.put("group.name", cf.getOffice());
		if(cf.getDate() != null) {
			qo.put("date_from", DateUtil.getBeginCal(cf.getDate()));
			qo.put("date_to", DateUtil.getEndCal(cf.getDate()));
		}
		return getCheckPersonsAndCLPs(qo);
	}

	public static List<Person> getCheckPersonsAndCFDs(Map qo) {
		return getCheckService().getCheckPersonsAndCFDs(qo);
	}

	/**
	 * 按考勤组和月建立考勤表, 建立时自动调出对应的考勤计划
	 * person: Person(fetched: 
	 * @param cf: id.branch.id, depart.id, office, date
	 * @return
	 */
	public static List<Person> getCheckPersonsAndCPDsOrCLPs(ChkFact cf) {
		List<Person> persons = getCheckPersonsAndCPDs(cf);
		if (persons.size() <= 0) persons = getCheckPersonsAndCLPs(cf);
		return persons;
	}

	/**
	 * 修改考勤表, 按人员分组调出考勤表凭证
	 * @param cf：id.branch.id, id.no
	 * @return
	 */
	public static List<Person> getCheckPersonsAndCFDs(ChkFact cf) {
		Map qo = new Hashtable();
		if(cf.getBranchId() != null) qo.put("fact.branch.id", cf.getBranchId());
		if(cf.getNo() != null) qo.put("fact.no", cf.getNo());
		if(cf.getDepartId() != null) qo.put("fact.depart.id", cf.getDepartId());
		if(cf.getOffice() != null) qo.put("fact.office", cf.getOffice());
		if(cf.getDate() != null) {
			qo.put("date_from", DateUtil.getBeginCal(cf.getDate()));
			qo.put("date_to", DateUtil.getEndCal(cf.getDate()));
		}
		return getCheckPersonsAndCFDs(qo);
	}

//==================================== Report ====================================

	protected static List<Person> getPersonsOnlineByDepart1(Map qo) {
		List<PsnOnline> list = PersonalServiceUtil.getPsnOnlineList(qo);
		List<Person> r = new ArrayList<Person>();
		Person p;
		for (Iterator<PsnOnline> it = list.iterator(); it.hasNext(); ) {
			p = it.next().getPerson();
			if (!r.contains(p) && p.getWorkerId() != null) r.add(p);
		}
		return r;
	}

	public static List<Person> getPersonsOnlineByDepart(Map qo) {
		return getCheckService().getPersonsOnlineByDepart(qo);
	}

	/**
	 * 返回考勤人及其考勤明细数组, 数组元素对象格式为: {psnOnline:po, chkFactDs:cfds}
	 * @param qo: 参数, branch.id, person.id/person, depart.id/depart, date_from, date_to
	 * @return
	 */
	public static List getOnlinePersonsAndCFDs(Map qo) {
		Map<PsnOnline, List<ChkFactD>> data = getCheckService().getOnlinePersonsAndCFDs(qo);
		List r = new ArrayList();
		Map entry;
		PsnOnline po;
		List<ChkFactD> cfds;
		for (Iterator<PsnOnline> it = data.keySet().iterator(); it.hasNext(); ) {
			po = it.next();
			cfds = data.get(po);
			entry = new Hashtable();
			entry.put("psnOnline", po);
			entry.put("chkFactDs", cfds);
			r.add(entry);
		}
		return r;
	}

	/**
	 * 返回考勤人及其考勤统计数组, 数组元素对象格式为: {person:p, stat:[{item:chkWork1, count:w1}, ... ..., {item:chkDispn, count:dn}]}
	 * @param qo
	 * @return
	 */
	public static List getOnlinePersonsAndCheckStat(Map qo) {
		Map<Person, Map<Object, Long>> data = getCheckService().getOnlinePersonsAndCheckStat(qo);
		List r = new ArrayList(), s;
		Map re, se;
		Person p;
		Map<Object, Long> stat;
		Object item;
		Long count;
		for (Iterator<Person> it1 = data.keySet().iterator(); it1.hasNext(); ) {
			p = it1.next();
			stat = data.get(p);
			s = new ArrayList();
			for (Iterator<Object> it2 = stat.keySet().iterator(); it2.hasNext(); ) {
				item = it2.next();
				count = stat.get(item);
				se = new Hashtable();
				se.put("item", item);
				se.put("count", count);
				s.add(se);
			}
			re = new Hashtable();
			re.put("person", p);
			re.put("stat", s);
			r.add(re);
		}
		return r;
	}
	
	public static void reportPersonCheck(Map qo, HttpServletResponse response) {
		getCheckService().reportPersonCheck(qo, response);
	}

	public static void reportDepartCheck(Map qo, HttpServletResponse response) {
		getCheckService().reportDepartCheck(qo, response);
	}

}
