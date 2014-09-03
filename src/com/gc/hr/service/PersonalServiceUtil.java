package com.gc.hr.service;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import org.springframework.context.ApplicationContext;

import com.gc.Constants;
import com.gc.common.po.Person;
import com.gc.common.po.Position;
import com.gc.common.po.PsnOnline;
import com.gc.common.po.SecurityLimit;
import com.gc.common.po.SecurityUser;
import com.gc.hr.po.ChkLongPlan;
import com.gc.hr.po.HireType;
import com.gc.hr.po.HireTypePK;
import com.gc.hr.po.JobGrade;
import com.gc.hr.po.JobGradePK;
import com.gc.hr.po.JobSpec;
import com.gc.hr.po.JobSpecPK;
import com.gc.hr.po.MarryStatus;
import com.gc.hr.po.MarryStatusPK;
import com.gc.hr.po.NativePlace;
import com.gc.hr.po.NativePlacePK;
import com.gc.hr.po.People;
import com.gc.hr.po.PeoplePK;
import com.gc.hr.po.PolParty;
import com.gc.hr.po.PolPartyPK;
import com.gc.hr.po.RegBranch;
import com.gc.hr.po.RegBranchPK;
import com.gc.hr.po.SchDegree;
import com.gc.hr.po.SchDegreePK;
import com.gc.hr.po.SchGraduate;
import com.gc.hr.po.SchGraduatePK;
import com.gc.hr.po.Schooling;
import com.gc.hr.po.SchoolingPK;
import com.gc.hr.po.WorkType;
import com.gc.hr.po.WorkTypePK;
import com.gc.safety.po.AccInPsn;
import com.gc.safety.po.Accident;
import com.gc.util.SpringUtil;

/**
 * HR Personal ServiceUtil类
 * @author hsun
 *
 */
public class PersonalServiceUtil {

	public static final String BEAN_NAME = "hrPersonalServiceUtil";

	private PersonalService personalService;

	public static PersonalService getPersonalService() {
		ApplicationContext ctx = SpringUtil.getContext();
		PersonalServiceUtil util = (PersonalServiceUtil) ctx.getBean(BEAN_NAME);
		PersonalService service = util.personalService;
		return service;
	}

	public void setPersonalService(PersonalService personalService) {
		this.personalService = personalService;
	}

//==================================== Person ====================================

	public static int addPersons(Person[] persons) {
		return getPersonalService().addPersons(persons);
	}

	public static int allotPersonsDepart(Person[] persons) {
		return getPersonalService().allotPersonsDepart(persons);
	}

	public static int allotPersonsLine(Person[] persons) {
		return getPersonalService().allotPersonsLine(persons);
	}

	public static int downPersons(Integer[] ids, Person person, Boolean down) {
		return getPersonalService().downPersons(ids, person, down);
	}

	public static void exportPersonList(SecurityLimit limit, Map qo, HttpServletResponse response) {
		getPersonalService().exportPersonList(limit, qo, response);
	}

	public static void exportPersonsCard(Integer[] ids, HttpServletResponse response) {
		getPersonalService().exportPersonsCard(ids, response);
	}

	public static Person getPerson(Integer id) {
		return getPersonalService().getPerson(id);
	}

	public static Person getPersonByCert2(String cert2No) {
		return getPersonalService().getPersonByCert2(cert2No);
	}

	public static List<Person> getPersons(Integer[] ids) {
		return getPersonalService().getPersons(ids);
	}

	public static List<Person> getAllPersons(Integer branchId) {
		return getPersonalService().getAllPersons(branchId);
	}

	public static List<Person> getPersonsByBranchId(Integer branchId) {
		return getPersonalService().getPersonsByBranchId(branchId);
	}

	public static List<Person> getPersons(SecurityLimit limit, Map qo, String[] orderColumns) {
		return getPersonalService().getPersons(limit, qo, orderColumns);
	}

	public static List<Person> getPersonsCard(Integer[] ids) {
		return getPersonalService().getPersonsCard(ids);
	}

	public static int updatePersonsCert2(Person[] persons) {
		return getPersonalService().updatePersonsCert2(persons);
	}

	public static int updatePersonsInfo(Person[] persons) {
		return getPersonalService().updatePersonsInfo(persons);
	}

	public static int updatePersonsStatus(Person[] persons) {
		return getPersonalService().updatePersonsStatus(persons);
	}

	public static void uploadPersonsPhoto(SecurityUser user, File[] files, HttpServletResponse response) {
		getPersonalService().uploadPersonsPhoto(user, files, response);
	}

	public static List<Person> findPersons(Map qo) {
		return getPersonalService().findPersons(qo);
	}

//==================================== PsnOnline ====================================

	@SuppressWarnings("unchecked")
	public static List<PsnOnline> getPsnOnlines(Integer branchId, Calendar accDate, Integer departId) {
		List<PsnOnline> list = new ArrayList<PsnOnline>();
		List<PsnOnline> psnOnlineList =  getPersonalService().getPsnOnlines(branchId, accDate, departId);
		List<Person> personList = getPersonalService().getDrivers(branchId, accDate);
		for (Iterator iterator = psnOnlineList.iterator(); iterator.hasNext();) {
			PsnOnline psnOnline = (PsnOnline) iterator.next();
			for (Iterator iterator1 = personList.iterator(); iterator1.hasNext();) {
				Person person = (Person) iterator1.next();
				if (psnOnline.getPersonId().intValue() == person.getId().intValue()) {
					psnOnline.setPerson(person);
					list.add(psnOnline);
				}
			}
		}
		return list;
	}

	public static List<PsnOnline> getPsnOnlinesByDepart(Integer branchId, Integer departId) {
		return getPersonalService().getPsnOnlinesByDepart(branchId, departId);
	}

	public static List<PsnOnline> getDriverOnlines(Integer branchId, Integer departId) {
		return getPersonalService().getDriverOnlines(branchId, departId);
	}
	
	public static List<PsnOnline> getDriverOnlines2(Integer branchId, Integer departId) {
		return getPersonalService().getDriverOnlines2(branchId, departId);
	}

	public static List<PsnOnline> getPsnOnlineList(Person person) {
		Map qo = new Hashtable();
		qo.put("person", person);
		return getPsnOnlineList(qo);
	}

	public static List<PsnOnline> getPsnOnlineList(Map qo) {
		qo.put(Constants.PARAM_FETCH, "depart, line, bus, alloter");
		return getPersonalService().getPsnOnlineList(qo);
	}

//==================================== PsnStatus ====================================

	public static List<Person> getDrivers(Integer branchId, Calendar date) {
		return getPersonalService().getDrivers(branchId, date);
	}

	public static List<PsnOnline> getPsnStatusList(Person person) {
		Map qo = new Hashtable();
		qo.put("person", person);
		return getPsnStatusList(qo);
	}

	public static List<PsnOnline> getPsnStatusList(Map qo) {
		qo.put(Constants.PARAM_FETCH, "fkPosition, upgrader");
		return getPersonalService().getPsnStatusList(qo);
	}

//==================================== Position =====================================

	public static Position getPosition(Integer branchId, String no) {
		return getPersonalService().getPosition(branchId, no);
	}

	public static List<Position> getPositions(Integer branchId) {
		return getPersonalService().getPositions(branchId);
	}

//==================================== T_PSN_XXX ====================================

	/**
	 * People
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static People getPeople(Integer branchId, String name) {
		return getPeople(new PeoplePK(branchId, name));
	}

	public static People getPeople(PeoplePK id) {
		return getPersonalService().getPeople(id);
	}

	public static List<People> getPeoples() {
		return getPersonalService().getPeoples(null);
	}

	public static List<People> getPeoples(Integer branchId) {
		return getPersonalService().getPeoples(branchId);
	}

	public static List<People> getPeoples1(Integer branchId) {
		return getPersonalService().getPeoples1(branchId);
	}

	public static List<People> getPeoples2(Integer branchId) {
		return getPersonalService().getPeoples2(branchId);
	}

	/**
	 * PolParty
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static PolParty getPolParty(Integer branchId, String name) {
		return getPolParty(new PolPartyPK(branchId, name));
	}

	public static PolParty getPolParty(PolPartyPK id) {
		return getPersonalService().getPolParty(id);
	}

	public static List<PolParty> getPolParties(Integer branchId) {
		return getPersonalService().getPolParties(branchId);
	}

	/**
	 * HireType
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static HireType getHireType(Integer branchId, String name) {
		return getHireType(new HireTypePK(branchId, name));
	}

	public static HireType getHireType(HireTypePK id) {
		return getPersonalService().getHireType(id);
	}

	public static List<HireType> getHireTypes(Integer branchId) {
		return getPersonalService().getHireTypes(branchId);
	}

	/**
	 * JobGrade
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static JobGrade getJobGrade(Integer branchId, String name) {
		return getJobGrade(new JobGradePK(branchId, name));
	}

	public static JobGrade getJobGrade(JobGradePK id) {
		return getPersonalService().getJobGrade(id);
	}

	public static List<JobGrade> getJobGrades(Integer branchId) {
		return getPersonalService().getJobGrades(branchId);
	}

	/**
	 * JobSpec
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static JobSpec getJobSpec(Integer branchId, String name) {
		return getJobSpec(new JobSpecPK(branchId, name));
	}

	public static JobSpec getJobSpec(JobSpecPK id) {
		return getPersonalService().getJobSpec(id);
	}

	public static List<JobSpec> getJobSpecs(Integer branchId) {
		return getPersonalService().getJobSpecs(branchId);
	}

	/**
	 * MarryStatus
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static MarryStatus getMarryStatus(Integer branchId, String name) {
		return getMarryStatus(new MarryStatusPK(branchId, name));
	}

	public static MarryStatus getMarryStatus(MarryStatusPK id) {
		return getPersonalService().getMarryStatus(id);
	}

	public static List<MarryStatus> getMarryStatusList(Integer branchId) {
		return getPersonalService().getMarryStatusList(branchId);
	}

	/**
	 * NativePlace
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static NativePlace getNativePlace(Integer branchId, String name) {
		return getNativePlace(new NativePlacePK(branchId, name));
	}

	public static NativePlace getNativePlace(NativePlacePK id) {
		return getPersonalService().getNativePlace(id);
	}

	public static List<NativePlace> getNativePlaces(Integer branchId) {
		return getPersonalService().getNativePlaces(branchId);
	}

	/**
	 * RegBranch
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static RegBranch getRegBranch(Integer branchId, String name) {
		return getRegBranch(new RegBranchPK(branchId, name));
	}

	public static RegBranch getRegBranch(RegBranchPK id) {
		return getPersonalService().getRegBranch(id);
	}

	public static List<RegBranch> getRegBranches(Integer branchId) {
		return getPersonalService().getRegBranches(branchId);
	}

	/**
	 * SchDegree
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static SchDegree getSchDegree(Integer branchId, String name) {
		return getSchDegree(new SchDegreePK(branchId, name));
	}

	public static SchDegree getSchDegree(SchDegreePK id) {
		return getPersonalService().getSchDegree(id);
	}

	public static List<SchDegree> getSchDegrees(Integer branchId) {
		return getPersonalService().getSchDegrees(branchId);
	}

	/**
	 * SchGraduate
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static SchGraduate getSchGraduate(Integer branchId, String name) {
		return getSchGraduate(new SchGraduatePK(branchId, name));
	}

	public static SchGraduate getSchGraduate(SchGraduatePK id) {
		return getPersonalService().getSchGraduate(id);
	}

	public static List<SchGraduate> getSchGraduates(Integer branchId) {
		return getPersonalService().getSchGraduates(branchId);
	}

	/**
	 * Schooling
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static Schooling getSchooling(Integer branchId, String name) {
		return getSchooling(new SchoolingPK(branchId, name));
	}

	public static Schooling getSchooling(SchoolingPK id) {
		return getPersonalService().getSchooling(id);
	}

	public static List<Schooling> getSchoolings(Integer branchId) {
		return getPersonalService().getSchoolings(branchId);
	}

	/**
	 * WorkType
	 * @param branchId
	 * @param name
	 * @return
	 */
	public static WorkType getWorkType(Integer branchId, String name) {
		return getWorkType(new WorkTypePK(branchId, name));
	}

	public static WorkType getWorkType(WorkTypePK id) {
		return getPersonalService().getWorkType(id);
	}

	public static List<WorkType> getWorkTypes(Integer branchId) {
		return getPersonalService().getWorkTypes(branchId);
	}

//==================================== TEST ====================================

	public static void testTx(PolParty party, People people) {
		getPersonalService().testTx(party, people);
	}

	public static Object testAmf(Object obj) {
		System.out.println(obj);
		return obj;
	}

	/**
	 * BlazeDS在匹配多态函数时有问题, flex.messaging.util.MethodMatcher.getMethod方法会依次进行函数匹配
	 * 在methods[]数组中:
	 * 1. 如果testPoly(Map)在最前面, 则前端调用testPoly(People)时, 后台抛错:java.lang.ClassCastException
	 * flex.messaging.io.amf.translator.decoder.MapDecoder.decodeObject(91):
	 * --return decodeMap((Map)shell, (Map)encodedObject);
	 * --shell转换前应该判断一下类型
	 * 2. 其它类型没有此问题.
	 * 解决方案: 
	 * 1. testPoly(Map)改为queryPoly(Map)
	 * 2. 研究BlazeDS是否可以注入自定义实现的MapDecoder(似乎不行)
	 * 3. 修改MapDecoder, 重新打包flex-messaging-core.jar(OK)
	 * 参见: flex.messaging.io.amf.translator.decoder.DecoderFactory
	 * @param obj
	 * @return
	 */
	public static List<Person> testPoly(Map obj) {
		System.out.println(obj);
		List<Person> list = new ArrayList<Person>();
		list.add(new Person(6666, "MAP", "MAP"));
		return list;
	}

	public static List<Person> testPoly(People p) {
		System.out.println(p);
		List<Person> list = new ArrayList<Person>();
		list.add(new Person(7777, "PEOPLE", "PEOPLE"));
		return list;
	}

	public static List<Person> testPoly(Schooling s) {
		System.out.println(s);
		List<Person> list = new ArrayList<Person>();
		list.add(new Person(8888, "SCHOOLING", "SCHOOLING"));
		return list;
	}

	public static Person testList(Person p) {
		List<ChkLongPlan> list = p.getChkLongPlans();
		ChkLongPlan clp;
		for (Iterator<ChkLongPlan> it = list.iterator(); it.hasNext(); ) {
			clp = it.next();
			System.out.println(clp);
			clp.setCheckDescription("test");
		}
		clp = new ChkLongPlan(2, "A09-000099");
		clp.setCheckDescription("new");
		p.addChkLongPlan(clp);
		return p;
	}

	public static Accident testSet(Accident acc) {
		Set<AccInPsn> set = acc.getAccInPsns();
		AccInPsn aip;
		for (Iterator<AccInPsn> it = set.iterator(); it.hasNext(); ) {
			aip = it.next();
			System.out.println(aip);
			aip.setName("test");
		}
		aip = new AccInPsn();
		aip.setName("new");
		acc.getAccInPsns().add(aip);
		return acc;
	}

	public static Map testMap(Map obj) {
		Object key, value;
		for (Iterator it = obj.keySet().iterator(); it.hasNext(); ) {
			key = it.next();
			value = obj.get(key);
			System.out.println(key + ": " + value);
		}
		obj.put(new Person(8888, "8888", "flex"), new ChkLongPlan(2, "A09-000099"));
		return obj;
	}
}
