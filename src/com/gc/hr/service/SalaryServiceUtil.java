package com.gc.hr.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.HibernateException;
import org.springframework.context.ApplicationContext;

import com.gc.Constants;
import com.gc.common.po.Department;
import com.gc.common.po.Person;
import com.gc.exception.CommonRuntimeException;
import com.gc.hr.po.SalDeptPsn;
import com.gc.hr.po.SalFact;
import com.gc.hr.po.SalFactD;
import com.gc.hr.po.SalFactDPK;
import com.gc.hr.po.SalFixOnline;
import com.gc.hr.po.SalItem;
import com.gc.hr.po.SalTemplate;
import com.gc.hr.po.SalTemplateD;
import com.gc.util.SpringUtil;

/**
 * HR Salary ServiceUtil类
 * @author hsun
 *
 */
public class SalaryServiceUtil {

	public static final String BEAN_NAME = "hrSalaryServiceUtil";

	private SalaryService salaryService;

	public static SalaryService getSalaryService() {
		ApplicationContext ctx = SpringUtil.getContext();
		SalaryServiceUtil util = (SalaryServiceUtil) ctx.getBean(BEAN_NAME);
		SalaryService service = util.salaryService;
		return service;
	}

	public void setSalaryService(SalaryService salaryService) {
		this.salaryService = salaryService;
	}

//==================================== SalItem ====================================

	public static List<SalItem> getAllSalItems(Integer branchId) {
		Map qo = new Hashtable();
		if (branchId != null) qo.put("branch.id", branchId);
		return getSalItems(qo);
	}

	public static List<SalItem> getSalItems(Map qo) {
		return getSalaryService().getSalItems(qo);
	}

//==================================== SalDeptPsn & SalFixOnline ====================================

	public static List<SalDeptPsn> getDeptPsns(Integer branchId, Integer departId) {
		Map qo = new Hashtable();
		if (branchId != null && departId != 0) qo.put("branch.id", branchId);
		if (departId != null && departId != 0) qo.put("depart.id", departId);
		return getDeptPsns(qo);
	}

	public static List<SalDeptPsn> getDeptPsns(Map qo) {
		return getSalaryService().getDeptPsns(qo);
	}

	public static List getDeptPsnListA(Integer branchId) {
		Map qo = new Hashtable();
		if (branchId != null) qo.put("branch.id", branchId);
		return getDeptPsnListA(qo);
	}

	/**
	 * 返回部门发薪人员总表, 对象格式为: [{depart:d1, count:c1}, ..., {depart:dn, count:cn}]
	 * @param qo: 参数, branch.id
	 * @return
	 */
	public static List<Map> getDeptPsnListA(Map qo) {
		Map<Department, Long> data = getSalaryService().getDeptPsnStat(qo);
		List<Map> r = new ArrayList<Map>();
		Map entry;
		Department depart;
		Long count;
		for (Iterator<Department> it = data.keySet().iterator(); it.hasNext(); ) {
			depart = it.next();
			count = data.get(depart);
			entry = new Hashtable();
			entry.put("depart", depart);
			entry.put("count", count);
			r.add(entry);
		}
		return r;
	}

	public static Map getDeptPsnListB(Integer branchId, Integer departId) {
		Map qo = new Hashtable();
		if (branchId != null && branchId != 0) qo.put("branch.id", branchId);
		if (departId != null && departId != 0) qo.put("depart.id", departId);
		return getDeptPsnListB(qo);
	}

	/**
	 * 返回部门发薪人员清单, 对象格式为: {items:items, data:[{sdp:sdp, sfos:[sfo1, ..., sfon]}], time:time}
	 * items: 所有固定项目中的工资项目(SalFixOnline.item)合集
	 * sdp: SalDeptPsn(fetched: depart, person, person.fkPosition, person.depart)
	 * sfos: SalFixOnline(fetched: item)
	 * time: 当前查询时的系统日期
	 * @param qo: 参数, branch.id, depart.id (=0全部)
	 * @return
	 */
	public static Map getDeptPsnListB(Map qo) {
		Map<SalDeptPsn, List<SalFixOnline>> data = getSalaryService().getDeptPsn1(qo);
		List<SalItem> items = (List<SalItem>) qo.get("#items");
		List d = new ArrayList();
		Map r = new Hashtable();
		r.put("items", items);
		r.put("data", d);
		r.put("time", qo.get("#time"));
		Map entry;
		SalDeptPsn sdp;
		List<SalFixOnline> sfos;
		for (Iterator<SalDeptPsn> it = data.keySet().iterator(); it.hasNext(); ) {
			sdp = it.next();
			sfos = data.get(sdp);
			entry = new Hashtable();
			entry.put("sdp", sdp);
			entry.put("sfos", sfos);
			d.add(entry);
		}
		return r;
	}

	/**
	 * 返回未指定发薪部门人员清单
	 * @param qo: 参数, branch.id
	 * @return
	 */
	public static List<Person> getDeptPsnListC(Integer branchId) {
		Map qo = new Hashtable();
		if (branchId != null) qo.put("branch.id", branchId);
		return getDeptPsnListC(qo);
	}

	public static List<Person> getDeptPsnListC(Map qo) {
		return getSalaryService().getDeptPsns0(qo);
	}

	/**
	 * 返回外加发薪部门人数清单, 对象格式为: {items:items, data:[{sdp:sdp, sfos:[sfo1, ..., sfon]}], time:time}
	 * items: 所有固定项目中的工资项目(SalFixOnline.item)合集
	 * sdp: SalDeptPsn(fetched: depart, person, person.fkPosition, person.depart)
	 * sfos: SalFixOnline(fetched: item)
	 * time: 当前查询时的系统日期
	 * @param qo: 参数, branch.id
	 * @return
	 */
	public static Map getDeptPsnListD(Integer branchId) {
		Map qo = new Hashtable();
		if (branchId != null) qo.put("branch.id", branchId);
		return getDeptPsnListD(qo);
	}

	public static Map getDeptPsnListD(Map qo) {
		Map<SalDeptPsn, List<SalFixOnline>> data = getSalaryService().getDeptPsn2(qo);
		List<SalItem> items = (List<SalItem>) qo.get("#items");
		List d = new ArrayList();
		Map r = new Hashtable();
		r.put("items", items);
		r.put("data", d);
		r.put("time", qo.get("#time"));
		Map entry;
		SalDeptPsn sdp;
		List<SalFixOnline> sfos;
		for (Iterator<SalDeptPsn> it = data.keySet().iterator(); it.hasNext(); ) {
			sdp = it.next();
			sfos = data.get(sdp);
			entry = new Hashtable();
			entry.put("sdp", sdp);
			entry.put("sfos", sfos);
			d.add(entry);
		}
		return r;
	}

	/**
	 * 变更发薪部门, 注意此处需要更新主键: SalDeptPsn.id.depart
	 * @param osdps
	 * @param nsdps
	 */
	public static int changeDeptPsns(SalDeptPsn[] osdps, SalDeptPsn[] nsdps) {
		return getSalaryService().changeDeptPsns(osdps, nsdps);
	}

	public static int deleteDeptPsns(SalDeptPsn[] sdps) {
		return getSalaryService().deleteDeptPsns(sdps);
	}

	public static List<SalFixOnline> getFixOnlines(Map qo) {
		return getSalaryService().getFixOnlines(qo);
	}

	public static void addFixOnlines(SalFixOnline sfos[], String user) {
		getSalaryService().addFixOnlines(sfos, user);
	}

	public static void terminateFixOnlines(SalFixOnline sfos[], String user) {
		getSalaryService().terminateFixOnlines(sfos, user);
	}

	public static void changeFixOnlines(SalFixOnline sfos[], String user) {
		getSalaryService().changeFixOnlines(sfos, user);
	}

//==================================== SalTemplate ====================================

	public static List<SalTemplate> getTemplates(Integer branchId, Integer departId) {
		Map qo = new Hashtable();
		if (branchId != null && departId != 0) qo.put("branch.id", branchId);
		if (departId != null && departId != 0) qo.put("depart.id", departId);
		return getTemplates(qo);
	}

	public static List<SalTemplate> getTemplates(Map qo) {
		return getSalaryService().getTemplates(qo);
	}

	/**
	 * 生成发薪模板, 对象格式为: {persons:persons, items:items, head:head, data:[{person:p1, stds:[std11, ..., std1n]}, ..., {person:pn, stds:[stdn1, ..., stdnn]}]}
	 * persons: 部门发薪人员列表
	 * items: 所有模板明细中的项目(SalTemplateD.item)合集
	 * head: SalTemplate(fetched: depart)
	 * data:
	 * - person: Person
	 * - stds: SalTemplateD(fetched: id.template, person, item)
	 * @param qo: 参数, branch.id, depart.id, person.id, template.id
	 * @return
	 */
	public static Map createTemplatePersonsAndItems(Map qo) {
		SalTemplate st = (SalTemplate) qo.get("head");
		List<SalItem> items = (List<SalItem>) qo.get("items");

		// 1. 取部门发薪人员列表
		Map qo1 = new Hashtable();
		SalDeptPsn sdp;
		qo1.put("branch.id", st.getBranchId());
		qo1.put("depart.id", st.getDepartId());
		List<SalDeptPsn> list1 = getDeptPsns(qo1);
		List<Person> persons = new ArrayList<Person>();
		for (Iterator<SalDeptPsn> it1 = list1.iterator(); it1.hasNext(); ) {
			sdp = it1.next();
			if (!persons.contains(sdp.getPerson())) persons.add(sdp.getPerson());
		}

		// 2. 拼装返回的数据对象
		List<Map> data = new ArrayList<Map>();
		Person p;
		SalItem si;
		SalTemplateD std;
		List<SalTemplateD> stds;
		Map entry;
		for (Iterator<Person> it2 = persons.iterator(); it2.hasNext(); )
		{
			p=it2.next();
			stds=new ArrayList<SalTemplateD>();
			for (Iterator<SalItem> it3 = items.iterator(); it3.hasNext(); )
			{
				si=it3.next();
				std=new SalTemplateD(st.getBranch(), st, null, si);
				std.setPerson(p);
				std.setAmount(0.0);
				stds.add(std);
			}
			entry=new Hashtable();
			entry.put("person", p);
			entry.put("stds", stds);
			data.add(entry);
		}
		Map r = new Hashtable();
		r.put("persons", persons);
		r.put("items", items);
		r.put("head", st);
		r.put("data", data);
		return r;
	}

	public static Map getTemplatePersonsAndItems(SalTemplate st) {
		Map qo = new Hashtable();
		if (st.getBranchId() != null && st.getBranchId() != 0) qo.put("branch.id", st.getBranchId());
		if (st.getDepartId() != null && st.getDepartId() != 0) qo.put("depart.id", st.getDepartId());
		if (st.getId() != null && st.getId() != 0) qo.put("template.id", st.getId());
		qo.put("head", st);
		return getTemplatePersonsAndItems(qo);
	}

	/**
	 * 返回发薪模板明细, 对象格式为: {persons:persons, items:items, head:head, data:[{person:p1, stds:[std11, ..., std1n]}, ..., {person:pn, stds:[stdn1, ..., stdnn]}]}
	 * persons: 部门发薪人员列表
	 * items: 所有模板明细中的项目(SalTemplateD.item)合集
	 * head: SalTemplate(fetched: depart)
	 * data:
	 * - person: Person
	 * - stds: SalTemplateD(fetched: id.template, person, item)
	 * @param qo: 参数, branch.id, depart.id, person.id, template.id
	 * @return
	 */
	public static Map getTemplatePersonsAndItems(Map qo) {
		SalTemplate head = (SalTemplate) qo.get("head");
		SalTemplateD std;
		SalItem si;
		Person p;
		List<SalTemplateD> stds;

		// 1. 取模板明细列表
		List<SalTemplateD> list1 = getSalaryService().getTemplateDetails(qo);

		// 2. 生成items, data.stds
		List<SalItem> items = new ArrayList<SalItem>();
		Map<Person, List<SalTemplateD>> data1 = new LinkedHashMap<Person, List<SalTemplateD>>();
		for (Iterator<SalTemplateD> it1 = list1.iterator(); it1.hasNext(); ) {
			std = it1.next();
			si = std.getItem();
			p = std.getPerson();
			if (!items.contains(si)) items.add(si);
			if (head == null && std.getTemplate() != null) head = std.getTemplate();
			if (data1.containsKey(p)) {
				stds = data1.get(p);
			} else {
				stds = new ArrayList<SalTemplateD>();
				data1.put(p, stds);
			}
			stds.add(std);
		}

		// 3. 取部门发薪人员列表
		Map qo2 = new Hashtable();
		SalDeptPsn sdp;
		if (qo.containsKey("branch.id")) qo2.put("branch.id", qo.get("branch.id"));
		if (qo.containsKey("depart.id")) qo2.put("depart.id", qo.get("depart.id"));
		List<SalDeptPsn> list2 = getDeptPsns(qo2);
		List<Person> persons = new ArrayList<Person>();
		for (Iterator<SalDeptPsn> it2 = list2.iterator(); it2.hasNext(); ) {
			sdp = it2.next();
			if (!persons.contains(sdp.getPerson())) persons.add(sdp.getPerson());
		}

		// 4. 拼装返回的数据对象
		List<Map> data = new ArrayList<Map>();
		Map entry;
		for (Iterator<Person> it = data1.keySet().iterator(); it.hasNext(); )
		{
			p=it.next();
			stds=data1.get(p);
			entry=new Hashtable();
			entry.put("person", p);
			entry.put("stds", stds);
			data.add(entry);
		}
		Map r = new Hashtable();
		r.put("persons", persons);
		r.put("items", items);
		r.put("head", head);
		r.put("data", data);
		return r;
	}

	public static void deleteTemplate(SalTemplate st) {
		getSalaryService().deleteTemplate(st);
	}

//==================================== SalFact ====================================

	public static List<SalFact> getFacts(Integer branchId, Integer departId) {
		Map qo = new Hashtable();
		if (branchId != null && departId != 0) qo.put("branch.id", branchId);
		if (departId != null && departId != 0) qo.put("depart.id", departId);
		return getFacts(qo);
	}

	public static List<SalFact> getFacts(Map qo) {
		return getSalaryService().getFacts(qo);
	}

	/**
	 * 使用模板生成发薪凭证, 对象格式为: {items:items, head:head, data:[{person:p1, sfds:[sfd11, ..., sfd1n], sfos:[sfo11, ..., sfo1n]}, ..., {person:pn, sfds:[sfdn1, ..., sfdnn], sfos:[sfon1, ..., sfonn]}]}
	 * persons: 部门发薪人员列表
	 * items: 所有发薪凭证明细中的项目(SalFactD.item)合集
	 * head: SalFact(fetched: depart, issuer)
	 * data:
	 * - person: Person
	 * - sfds: SalFactD(fetched: id.fact, person, item)
	 * - sfos: SalFixOnline(fetched: person, item), 使用depart, persons, items, onDate条件过滤
	 * @param qo: 参数, branch.id, depart.id, fact.no, fact.date
	 * @return
	 */
	public static Map createFactPersonsAndItems(Map qo) {
		SalFact head = (SalFact) qo.get("head");
		SalFactD sfd;
		SalFixOnline sfo;
		SalItem si;
		Person p;
		List<SalFactD> sfds;
		List<SalFixOnline> sfos;

		// 1. 使用模板明细生成发薪明细
		SalTemplate st = (SalTemplate) qo.get("template");
		SalTemplateD std;
		Map qo2 = new Hashtable();
		if (st.getBranchId() != null && st.getBranchId() != 0) qo2.put("branch.id", st.getBranchId());
		if (st.getDepartId() != null && st.getDepartId() != 0) qo2.put("depart.id", st.getDepartId());
		if (st.getId() != null && st.getId() != 0) qo2.put("template.id", st.getId());
		List<SalTemplateD> list2 = getSalaryService().getTemplateDetails(qo2);
		List<SalFactD> list1 = new ArrayList<SalFactD>();
		for (Iterator<SalTemplateD> it2 = list2.iterator(); it2.hasNext(); ) {
			std = it2.next();
			sfd = new SalFactD();
			sfd.setId(new SalFactDPK(head, std.getNo(), std.getItem()));
			sfd.setPerson(std.getPerson());
			sfd.setAmount(std.getAmount());
			list1.add(sfd);
		}

		// 2. 生成items, pids, iids及data.sfds
		List<SalItem> items = new ArrayList<SalItem>();
		List<Integer> pids = new ArrayList<Integer>();
		List<Integer> iids = new ArrayList<Integer>();
		Map<Person, List<SalFactD>> data1 = new LinkedHashMap<Person, List<SalFactD>>();
		for (Iterator<SalFactD> it1 = list1.iterator(); it1.hasNext(); ) {
			sfd = it1.next();
			si = sfd.getItem();
			p = sfd.getPerson();
			if (!items.contains(si)) items.add(si);
			if (!pids.contains(p.getId())) pids.add(p.getId());
			if (!iids.contains(si.getId())) iids.add(si.getId());
			if (head == null && sfd.getFact() != null) head = sfd.getFact();
			if (data1.containsKey(p)) {
				sfds = data1.get(p);
			} else {
				sfds = new ArrayList<SalFactD>();
				data1.put(p, sfds);
			}
			sfds.add(sfd);
		}

		// 3. 取固定项目列表
		Map qo3 = new Hashtable();
		if (head.getBranchId() != null && head.getBranchId() != 0) qo3.put("branch.id", head.getBranchId());
		if (head.getDepartId() != null && head.getDepartId() != 0) qo3.put("depart.id", head.getDepartId());
		qo3.put("onDate_to", head.getDate());
		qo3.put("downDate_from", head.getDate());
		qo3.put("persons", pids);
		qo3.put("items", iids);
		qo3.put(Constants.PARAM_FETCH, "id.person");
		List<SalFixOnline> list3 = getSalaryService().getFixOnlines(qo3);

		// 4. 生成data.sfos
		Map<Integer, List<SalFixOnline>> data3 = new LinkedHashMap<Integer, List<SalFixOnline>>();
		for (Iterator<SalFixOnline> it3 = list3.iterator(); it3.hasNext(); ) {
			sfo = it3.next();
			p = sfo.getPerson();
			if (data3.containsKey(p.getId())) {
				sfos = data3.get(p.getId());
			} else {
				sfos = new ArrayList<SalFixOnline>();
				data3.put(p.getId(), sfos);
			}
			sfos.add(sfo);
		}

		// 5. 取部门发薪人员列表
		Map qo4 = new Hashtable();
		SalDeptPsn sdp;
		if (qo.containsKey("branch.id")) qo4.put("branch.id", qo.get("branch.id"));
		if (qo.containsKey("depart.id")) qo4.put("depart.id", qo.get("depart.id"));
		List<SalDeptPsn> list4 = getDeptPsns(qo4);
		List<Person> persons = new ArrayList<Person>();
		for (Iterator<SalDeptPsn> it4 = list4.iterator(); it4.hasNext(); ) {
			sdp = it4.next();
			if (!persons.contains(sdp.getPerson())) persons.add(sdp.getPerson());
		}

		// 6. 拼装返回的数据对象
		List<Map> data = new ArrayList<Map>();
		Map entry;
		for (Iterator<Person> it = data1.keySet().iterator(); it.hasNext(); )
		{
			p=it.next();
			sfds=data1.get(p);
			sfos=data3.get(p.getId());
			if (sfos == null) sfos = new ArrayList<SalFixOnline>();
			entry=new Hashtable();
			entry.put("person", p);
			entry.put("sfds", sfds);
			entry.put("sfos", sfos);
			data.add(entry);
		}
		Map r = new Hashtable();
		r.put("persons", persons);
		r.put("items", items);
		r.put("head", head);
		r.put("data", data);
		return r;
	}

	public static Map getFactPersonsAndItems(SalFact sf) {
		Map qo = new Hashtable();
		if (sf.getBranchId() != null && sf.getBranchId() != 0) qo.put("branch.id", sf.getBranchId());
		if (sf.getDepartId() != null && sf.getDepartId() != 0) qo.put("depart.id", sf.getDepartId());
		if (sf.getNo() != null && sf.getNo() != "") qo.put("fact.no", sf.getNo());
		if (sf.getDate() != null) qo.put("fact.date", sf.getDate());
		qo.put("head", sf);
		return getFactPersonsAndItems(qo);
	}

	/**
	 * 返回发薪凭证明细, 对象格式为: {items:items, head:head, data:[{person:p1, sfds:[sfd11, ..., sfd1n], sfos:[sfo11, ..., sfo1n]}, ..., {person:pn, sfds:[sfdn1, ..., sfdnn], sfos:[sfon1, ..., sfonn]}]}
	 * persons: 部门发薪人员列表
	 * items: 所有发薪凭证明细中的项目(SalFactD.item)合集
	 * head: SalFact(fetched: depart, issuer)
	 * data:
	 * - person: Person
	 * - sfds: SalFactD(fetched: id.fact, person, item)
	 * - sfos: SalFixOnline(fetched: person, item), 注意depart, onDate条件
	 * @param qo: 参数, branch.id, depart.id, fact.no, fact.date
	 * @return
	 */
	public static Map getFactPersonsAndItems(Map qo) {
		SalFact head = (SalFact) qo.get("head");
		SalFactD sfd;
		SalFixOnline sfo;
		SalItem si;
		Person p;
		List<SalFactD> sfds;
		List<SalFixOnline> sfos;

		// 1. 取发薪凭证明细列表
		List<SalFactD> list1 = getSalaryService().getFactDetails(qo);

		// 2. 生成items, pids, iids及data.sfds
		List<SalItem> items = new ArrayList<SalItem>();
		List<Integer> pids = new ArrayList<Integer>();
		List<Integer> iids = new ArrayList<Integer>();
		Map<Person, List<SalFactD>> data1 = new LinkedHashMap<Person, List<SalFactD>>();
		for (Iterator<SalFactD> it1 = list1.iterator(); it1.hasNext(); ) {
			sfd = it1.next();
			si = sfd.getItem();
			p = sfd.getPerson();
			if (!items.contains(si)) items.add(si);
			if (!pids.contains(p.getId())) pids.add(p.getId());
			if (!iids.contains(si.getId())) iids.add(si.getId());
			if (head == null && sfd.getFact() != null) head = sfd.getFact();
			if (data1.containsKey(p)) {
				sfds = data1.get(p);
			} else {
				sfds = new ArrayList<SalFactD>();
				data1.put(p, sfds);
			}
			sfds.add(sfd);
		}

		// 3. 取固定项目列表
		Map qo3 = new Hashtable();
		if (head.getBranchId() != null && head.getBranchId() != 0) qo3.put("branch.id", head.getBranchId());
		if (head.getDepartId() != null && head.getDepartId() != 0) qo3.put("depart.id", head.getDepartId());
		qo3.put("onDate_to", head.getDate());
		qo3.put("downDate_from", head.getDate());
		qo3.put("persons", pids);
		qo3.put("items", iids);
		qo3.put(Constants.PARAM_FETCH, "id.person");
		List<SalFixOnline> list3 = getSalaryService().getFixOnlines(qo3);

		// 4. 生成data.sfos
		Map<Integer, List<SalFixOnline>> data3 = new LinkedHashMap<Integer, List<SalFixOnline>>();
		for (Iterator<SalFixOnline> it3 = list3.iterator(); it3.hasNext(); ) {
			sfo = it3.next();
			p = sfo.getPerson();
			if (data3.containsKey(p.getId())) {
				sfos = data3.get(p.getId());
			} else {
				sfos = new ArrayList<SalFixOnline>();
				data3.put(p.getId(), sfos);
			}
			sfos.add(sfo);
		}

		// 5. 取部门发薪人员列表
		Map qo4 = new Hashtable();
		SalDeptPsn sdp;
		if (qo.containsKey("branch.id")) qo4.put("branch.id", qo.get("branch.id"));
		if (qo.containsKey("depart.id")) qo4.put("depart.id", qo.get("depart.id"));
		List<SalDeptPsn> list4 = getDeptPsns(qo4);
		List<Person> persons = new ArrayList<Person>();
		for (Iterator<SalDeptPsn> it4 = list4.iterator(); it4.hasNext(); ) {
			sdp = it4.next();
			if (!persons.contains(sdp.getPerson())) persons.add(sdp.getPerson());
		}

		// 5. 拼装返回的数据对象
		List<Map> data = new ArrayList<Map>();
		Map entry;
		for (Iterator<Person> it = data1.keySet().iterator(); it.hasNext(); )
		{
			p=it.next();
			sfds=data1.get(p);
			sfos=data3.get(p.getId());
			if (sfos == null) sfos = new ArrayList<SalFixOnline>();
			entry=new Hashtable();
			entry.put("person", p);
			entry.put("sfds", sfds);
			entry.put("sfos", sfos);
			data.add(entry);
		}
		Map r = new Hashtable();
		r.put("persons", persons);
		r.put("items", items);
		r.put("head", head);
		r.put("data", data);
		return r;
	}

	public static void deleteFact(SalFact sf) {
		getSalaryService().deleteFact(sf);
	}

	public static SalFact saveFact(SalFact header, SalFactD[] opos, SalFact nheader, SalFactD[] npos) {
		return getSalaryService().saveFact(header, opos, nheader, npos);
	}

	/**
	 * 返回工资实发明细及凭证头
	 * @param arr [branchId, id.no, depart, month, issueDate, issueTypeValue, issuer.workerId, summary, comment]
	 * @return {facts: facts, factds: [salfact: items, ... salfact: items], list: [SalFactD, ... SalFactD]}<br/>
	 * 		facts: 实际发放凭证列表
	 * 		list : List<{@link SalFactD}><br/>
	 */
	public static Map getSalFactDList(List o) {
		if (o.size() != 9)
			throw new CommonRuntimeException("Parameter Error!");
		Map qo=new HashMap();
		if (o.get(0) != null) qo.put("branch.id", o.get(0));
		if (o.get(1) != "") qo.put("fact.no", o.get(1));
		if (o.get(2) != null) qo.put("depart.id", ((Department) o.get(2)).getId());
		try {
			Map date = (Map) o.get(3);
			if (date.containsKey("date_from") && date.get("date_from") != null) 
				qo.put("date_from", date.get("date_from"));
			if (date.containsKey("date_to") && date.get("date_to") != null) 
				qo.put("date_to", date.get("date_to"));
			Map issueDate = (Map) o.get(4);
			if (issueDate.containsKey("issueDate_from") && issueDate.get("issueDate_from") != null) 
				qo.put("issueDate_from", issueDate.get("issueDate_from"));
			if (issueDate.containsKey("issueDate_to") && issueDate.get("issueDate_to") != null) 
				qo.put("issueDate_to", issueDate.get("issueDate_to"));
		} catch (Exception e) {
			throw new HibernateException(e);
		}
		if (o.get(5) != null) qo.put("issueType", o.get(5));
		if (o.get(6) != "") qo.put("issuer.workerId", o.get(6));
		if (o.get(7) != "") qo.put("summary", o.get(7));
		if (o.get(8) != "") qo.put("comment", o.get(8));
		return getSalFactDList(qo);
	}

	public static Map getSalFactDList(Map qo) {
		List<SalFactD> list = getSalaryService().getSalFactDList(qo);
		List<SalItem> ls = null;
		List<SalFact> facts = new ArrayList<SalFact>();
		Map<SalFact, List<SalItem>> factds=new LinkedHashMap<SalFact, List<SalItem>>();
		for (SalFactD salFactD : list) {
			if (!factds.containsKey(salFactD.getFact())) {
				ls = new ArrayList<SalItem>();
				ls.add(salFactD.getItem());
				factds.put(salFactD.getFact(), ls);
				facts.add(salFactD.getFact());
			} else {
				if (ls.indexOf(salFactD.getItem()) == -1) {
					ls.add(salFactD.getItem());
				}
			}
		}
		List<Map> data = new ArrayList<Map>();
		Map entry;
		SalFact s;
		List<SalItem> items;
		for (Iterator<SalFact> it = factds.keySet().iterator(); it.hasNext(); ) {
			s = it.next();
			items = factds.get(s);
			entry=new Hashtable();
			entry.put("salfact", s);
			entry.put("items", items);
			data.add(entry);
		}
		
		Map r = new Hashtable();
		r.put("facts", facts);
		r.put("factds", data);
		r.put("list", list);
		return r;
	}
	
	public static Map getSelectedSalFactDs(Map obj) {
		List<SalFactD> list = getSalaryService().getSelectedSalFactDs(obj);
		List<SalItem> ls = new ArrayList<SalItem>();
		for (SalFactD salFactD : list) {
			if (ls.indexOf(salFactD.getItem()) == -1) {
				ls.add(salFactD.getItem());
			}
		}
		Map r = new Hashtable();
		r.put("factds", list);
		r.put("items", ls);
		return r;
	}
	
}
