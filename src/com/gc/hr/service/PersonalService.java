package com.gc.hr.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import sun.misc.BASE64Encoder;

import com.gc.Constants;
import com.gc.common.po.Person;
import com.gc.common.po.Position;
import com.gc.common.po.PsnOnline;
import com.gc.common.po.PsnPhoto;
import com.gc.common.po.SecurityLimit;
import com.gc.common.po.SecurityUser;
import com.gc.common.service.BaseServiceUtil;
import com.gc.exception.CommonRuntimeException;
import com.gc.hr.dao.PersonalDAOHibernate;
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
import com.gc.util.CommonUtil;
import com.gc.util.FlexUtil;
import com.gc.util.JxlUtil;
import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfWriter;

/**
 * HR Personal Service类
 * @author hsun
 *
 */
class PersonalService {

	private PersonalDAOHibernate personalDAO;

	public void setPersonalDAO(PersonalDAOHibernate personalDAO) {
		this.personalDAO = personalDAO;
	}

//==================================== Person ====================================

	public int addPersons(Person[] persons) {
		if (persons == null) return 0;
		for (int i = 0; i < persons.length; i++) {
			persons[i].setId(i);
			BaseServiceUtil.addObject(persons[i]);
		}
		return persons.length;
	}

	public int allotPersonsDepart(Person[] persons) {
		if (persons == null) return 0;
		for (int i = 0; i < persons.length; i++) {
			personalDAO.allotPersonDepart(persons[i]);
		}
		return persons.length;
	}

	public int allotPersonsLine(Person[] persons) {
		if (persons == null) return 0;
		for (int i = 0; i < persons.length; i++) {
			personalDAO.allotPersonLine(persons[i]);
		}
		return persons.length;
	}

	public int downPersons(Integer[] ids, Person person, Boolean down) {
		return personalDAO.downPersons(ids, person, down);
	}

	public void exportPersonList(SecurityLimit limit, Map qo, HttpServletResponse response) {
		List<Person> persons = personalDAO.getPersons(limit, qo, null);
		try {
			WritableWorkbook wwb = Workbook.createWorkbook(response.getOutputStream());
			WritableSheet ws = wwb.createSheet("Sheet1", 0);
			Person person;
			String[] headers = {"workerId", "name", "pid", "sex", "people", "nativePlace", "regAddress", "birthday", 
					"marryStatus", "annuities", "accumulation", "chkGroup.name", "onDate", "downDate", "downReason", "upgradeDate", 
					"upgradeReason", "type", "regBelong", "party", "grade", "schooling", "allotDate", "allotReason", 
					"depart.name", "office", "line.name", "bus.authNo", "fkPosition.name", "fillTableDate", "commend", 
					"workDate", "retireDate", "serviceLength", "inDate", "outDate", "workLength", "groupNo", "contractNo", 
					"contr1From", "contr1End", "contractReason", "contr2From", "contr2End", "workType", "level", 
					"techLevel", "responsibility", "cert1No", "cert1NoDate", "cert2No", "cert2NoHex", "serviceNo", 
					"serviceNoDate", "frontWorkResume", "frontTrainingResume", "specification", "degree", "graduate", 
					"skill", "lanCom", "national", "state", "city", "address", "zip", "telephone", "email", "officeTel", 
					"officeExt", "officeFax", "comment",};
			for (int i = 0; i < headers.length; i++) {
				ws.addCell(new Label(i, 0, CommonUtil.getString("person." + headers[i])));
			}
			int c, r = 1;
			for (Iterator<Person> it = persons.iterator(); it.hasNext(); ) {
				person = it.next();
				c = 0;
				JxlUtil.writeCell(ws, c++, r, person.getWorkerId());
				JxlUtil.writeCell(ws, c++, r, person.getName());
				JxlUtil.writeCell(ws, c++, r, person.getPid());
				JxlUtil.writeCell(ws, c++, r, person.getSex());
				JxlUtil.writeCell(ws, c++, r, person.getPeople());
				JxlUtil.writeCell(ws, c++, r, person.getNativePlace());
				JxlUtil.writeCell(ws, c++, r, person.getRegAddress());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getBirthday()));
				JxlUtil.writeCell(ws, c++, r, person.getMarryStatus());
				JxlUtil.writeCell(ws, c++, r, person.getAnnuities());
				JxlUtil.writeCell(ws, c++, r, person.getAccumulation());
				JxlUtil.writeCell(ws, c++, r, (person.getChkGroup() == null) ? "" : person.getChkGroup().getName());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getOnDate()));
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getDownDate()));
				JxlUtil.writeCell(ws, c++, r, person.getDownReason());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getUpgradeDate()));
				JxlUtil.writeCell(ws, c++, r, person.getUpgradeReason());
				JxlUtil.writeCell(ws, c++, r, person.getType());
				JxlUtil.writeCell(ws, c++, r, person.getRegBelong());
				JxlUtil.writeCell(ws, c++, r, person.getParty());
				JxlUtil.writeCell(ws, c++, r, person.getGrade());
				JxlUtil.writeCell(ws, c++, r, person.getSchooling());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getAllotDate()));
				JxlUtil.writeCell(ws, c++, r, person.getAllotReason());
				JxlUtil.writeCell(ws, c++, r, (person.getDepart() == null) ? "" : person.getDepart().getName());
				JxlUtil.writeCell(ws, c++, r, person.getOffice());
				JxlUtil.writeCell(ws, c++, r, (person.getLine() == null) ? "" : person.getLine().getName());
				JxlUtil.writeCell(ws, c++, r, (person.getBus() == null) ? "" : person.getBus().getAuthNo());
				JxlUtil.writeCell(ws, c++, r, (person.getFkPosition() == null) ? "" : person.getFkPosition().getName());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getFillTableDate()));
				JxlUtil.writeCell(ws, c++, r, person.getCommend());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getWorkDate()));
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getRetireDate()));
				JxlUtil.writeCell(ws, c++, r, person.getServiceLength());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getInDate()));
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getOutDate()));
				JxlUtil.writeCell(ws, c++, r, person.getWorkLength());
				JxlUtil.writeCell(ws, c++, r, person.getGroupNo());
				JxlUtil.writeCell(ws, c++, r, person.getContractNo());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getContr1From()));
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getContr1End()));
				JxlUtil.writeCell(ws, c++, r, person.getContractReason());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getContr2From()));
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getContr2End()));
				JxlUtil.writeCell(ws, c++, r, person.getWorkType());
				JxlUtil.writeCell(ws, c++, r, (person.getLevel() == null) ? "" : person.getLevel().toString());
				JxlUtil.writeCell(ws, c++, r, person.getTechLevel());
				JxlUtil.writeCell(ws, c++, r, person.getResponsibility());
				JxlUtil.writeCell(ws, c++, r, person.getCert1No());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getCert1NoDate()));
				JxlUtil.writeCell(ws, c++, r, person.getCert2No());
				JxlUtil.writeCell(ws, c++, r, person.getCert2NoHex());
				JxlUtil.writeCell(ws, c++, r, person.getServiceNo());
				JxlUtil.writeCell(ws, c++, r, CommonUtil.formatCalendar(Constants.DEFAULT_DATE_FORMAT, person.getServiceNoDate()));
				JxlUtil.writeCell(ws, c++, r, person.getFrontWorkResume());
				JxlUtil.writeCell(ws, c++, r, person.getFrontTrainingResume());
				JxlUtil.writeCell(ws, c++, r, person.getSpecification());
				JxlUtil.writeCell(ws, c++, r, person.getDegree());
				JxlUtil.writeCell(ws, c++, r, person.getGraduate());
				JxlUtil.writeCell(ws, c++, r, person.getSkill());
				JxlUtil.writeCell(ws, c++, r, person.getLanCom());
				JxlUtil.writeCell(ws, c++, r, person.getNational());
				JxlUtil.writeCell(ws, c++, r, person.getState());
				JxlUtil.writeCell(ws, c++, r, person.getCity());
				JxlUtil.writeCell(ws, c++, r, person.getAddress());
				JxlUtil.writeCell(ws, c++, r, person.getZip());
				JxlUtil.writeCell(ws, c++, r, person.getTelephone());
				JxlUtil.writeCell(ws, c++, r, person.getEmail());
				JxlUtil.writeCell(ws, c++, r, person.getOfficeTel());
				JxlUtil.writeCell(ws, c++, r, person.getOfficeExt());
				JxlUtil.writeCell(ws, c++, r, person.getOfficeFax());
				JxlUtil.writeCell(ws, c++, r, person.getComment());
				r++;
			}
			wwb.write();
			wwb.close();
			response.setContentType("application/vnd.ms-excel");
			response.flushBuffer();
		} catch (Exception e) {
			throw new CommonRuntimeException(CommonUtil.getString("error.export.person.list"), e);
		}
	}

	public void exportPersonsCard(Integer[] ids, HttpServletResponse response) {
		List<Person> persons = personalDAO.getPersons(ids);
		try {
			BaseFont bfChinese = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
			Font bodyFont = new Font(bfChinese, 12, Font.NORMAL);
			Document document = new Document(PageSize.A4, 36, 36, 36, 36);
			PdfWriter.getInstance(document, response.getOutputStream());
			document.addTitle("PersonCard");
			document.addAuthor("GreateCreate");
			document.addSubject("This pdf is automatically created by system.");
			document.addKeywords("Person card, Greate Create");
			document.addCreator("iText");
			document.open();
			Person person;
			for (Iterator<Person> it = persons.iterator(); it.hasNext(); ) {
				person = it.next();
				document.add(new Paragraph(person.getName(), bodyFont));
				document.add(new Paragraph(person.getWorkerId(), bodyFont));
				document.newPage();
			}
			document.close();
			response.setContentType("application/pdf");
			response.flushBuffer();
		} catch (Exception e) {
			throw new CommonRuntimeException(CommonUtil.getString("error.export.person.cards"), e);
		}
	}

	public Person getPerson(Integer id) {
		return personalDAO.getPerson(id);
	}

	public Person getPersonByCert2(String cert2No) {
		return personalDAO.getPersonByCert2(cert2No);
	}

	public Person getPersonByWorkerId(Integer bid, String workerId) {
		return personalDAO.getPersonByWorkerId(bid, workerId);
	}

	public List<Person> getPersons(Integer[] ids) {
		return personalDAO.getPersons(ids);
	}

	public List<Person> getAllPersons(Integer branchId) {
		return personalDAO.getAllPersons(branchId);
	}

	public List<Person> getPersonsByBranchId(Integer branchId) {
		return personalDAO.getPersonsByBranchId(branchId);
	}

	/**
	 * 根据limit中的权限查询列表(按orderColumns排序)
	 */
	public List<Person> getPersons(SecurityLimit limit, Map qo, String[] orderColumns) {
		return personalDAO.getPersons(limit, qo, orderColumns);
	}

	public List<Person> getPersonsCard(Integer[] ids) {
		return personalDAO.getPersonsCard(ids);
	}

	public int updatePersonsCert2(Person[] persons) {
		if (persons == null) return 0;
		for (int i = 0; i < persons.length; i++) {
			if (persons[i] != null) personalDAO.updatePersonCert2(persons[i]);
		}
		return persons.length;
	}

	public int updatePersonsInfo(Person[] persons) {
		if (persons == null) return 0;
		for (int i = 0; i < persons.length; i++) {
			personalDAO.updatePersonInfo(persons[i]);
		}
		return persons.length;
	}

	public int updatePersonsStatus(Person[] persons) {
		if (persons == null) return 0;
		for (int i = 0; i < persons.length; i++) {
			personalDAO.updatePersonStatus(persons[i]);
		}
		return persons.length;
	}

	public void uploadPersonsPhoto(SecurityUser user, File[] files, HttpServletResponse response) {
		BASE64Encoder encoder = new BASE64Encoder();
		response.setContentType("text/plain");
		try {
			/*
				response.setContentType("text/plain");
				byte[] b = FlexUtil.writeObject(new Object[]{new Person(8888, "T001", "Harry Sun"), new Integer(10), Calendar.getInstance(),});
				BASE64Encoder encoder = new BASE64Encoder();
				response.getWriter().print(encoder.encode(b));
				response.getWriter().flush();
			*/
			if (files == null || files.length <= 0) {
				response.getWriter().print(encoder.encode(FlexUtil.writeObject("UNKNOWN_ERROR")));
				response.getWriter().flush();
				return;
			}
			File f = files[0];
			String name = f.getName();
			String workerId = name.substring(0, name.lastIndexOf('.'));
			Person p = getPersonByWorkerId(user.getBranchId(), workerId);
			if (p == null) {
				response.getWriter().print(encoder.encode(FlexUtil.writeObject("NONEXISTENT_ERROR")));
				response.getWriter().flush();
				return;
			}
			if (!checkSecurity(user, p)) {
				response.getWriter().print(encoder.encode(FlexUtil.writeObject("SECURITY_ERROR")));
				response.getWriter().flush();
				return;
			}
			BufferedImage image = ImageIO.read(f);
			if (!checkSize(image)) {
				response.getWriter().print(encoder.encode(FlexUtil.writeObject("SIZE_ERROR")));
				response.getWriter().flush();
				return;
			}
			PsnPhoto pp = p.getPsnPhoto();
			byte[] b = CommonUtil.readFile(f);
			if (pp == null || pp.getBranch() == null) {
				pp = new PsnPhoto();
				pp.setBranch(p.getBranch());
				pp.setId(p.getId());
				pp.setPhoto(b);
				pp.setPhotoDate(Calendar.getInstance());
				pp.setUploader(user.getPerson());
				BaseServiceUtil.addObject(pp);
			} else {
				pp.setPhoto(b);
				pp.setPhotoDate(Calendar.getInstance());
				pp.setUploader(user.getPerson());
				BaseServiceUtil.addObject(pp);
			}
			response.getWriter().print(encoder.encode(FlexUtil.writeObject("SUCCESS")));
			response.getWriter().flush();
		} catch (Throwable t) {
			try {
				response.getWriter().print(encoder.encode(FlexUtil.writeObject("UNKNOWN_ERROR")));
				response.getWriter().flush();
			} catch (Throwable t1) {}
			throw new CommonRuntimeException("Error", t);
		}
	}

	private boolean checkSecurity(SecurityUser user, Person p) {
		SecurityLimit limit = user.getLimit();
		boolean b = (user.getBranchId().equals(user.getPerson().getBranchId()) && user.getBranchId().equals(p.getBranchId()));
		int l = limit.getHrLimit();
		if (l == 1 || l == 3 || l == 4) return b;
		else if (l == 7 || l == 8) return b && (user.getPerson().getDepartId().equals(p.getDepartId()));
		else return false;
	}

	/**
	 * 1寸 					2.5*3.5cm 295*413
	 * 身份证大头照 	3.3*2.2cm 260*390
	 * 2寸 					3.5*5.3cm 413*626
	 * 小2寸(护照)		3.3*4.8cm 390*567
	*/
	private boolean checkSize(BufferedImage image) {
		if (image == null) return false;
		int w = image.getWidth();
		int h = image.getHeight();
		return (w >= 240 && w <= 480 && h >= 360 && h <= 720);
	}

	public List<Person> findPersons(Map qo) {
		return personalDAO.findPersons(qo);
	}

//==================================== PsnPhoto ====================================

//==================================== PsnOnline ====================================

	public List<PsnOnline> getPsnOnlines(Integer branchId, Calendar accDate, Integer departId) {
		return personalDAO.getPsnOnlines(branchId, accDate, departId);
	}

	public List<PsnOnline> getPsnOnlinesByDepart(Integer branchId, Integer departId) {
		return personalDAO.getPsnOnlinesByDepart(branchId, departId);
	}

	public List<PsnOnline> getDriverOnlines(Integer branchId, Integer departId) {
		return personalDAO.getDriverOnlines(branchId,departId);
	}
	
	public List<PsnOnline> getDriverOnlines2(Integer branchId, Integer departId) {
		return personalDAO.getDriverOnlines2(branchId,departId);
	}

	public List<PsnOnline> getPsnOnlineList(Map qo) {
		return personalDAO.getPsnOnlineList(qo);
	}

//==================================== PsnStatus ====================================

	public List<Person> getDrivers(Integer branchId, Calendar date) {
		return personalDAO.getDrivers(branchId, date);
	}

	public List<PsnOnline> getPsnStatusList(Map qo) {
		return personalDAO.getPsnStatusList(qo);
	}

//==================================== Position ====================================

	public Position getPosition(Integer branchId, String no) {
		return personalDAO.getPosition(branchId, no);
	}

	public List<Position> getPositions(Integer branchId) {
		return personalDAO.getPositions(branchId);
	}

//==================================== T_PSN_XXX ====================================

	/**
	 * People
	 * @param id
	 * @return
	 */
	public People getPeople(PeoplePK id) {
		return personalDAO.getPeople(id);
	}

	public List<People> getPeoples(Integer branchId) {
		return personalDAO.getPeoples(branchId);
	}

	public List<People> getPeoples1(Integer branchId) {
		return personalDAO.getPeoples1(branchId);
	}

	public List<People> getPeoples2(Integer branchId) {
		return personalDAO.getPeoples2(branchId);
	}

	/**
	 * PolParty
	 * @param id
	 * @return
	 */
	public PolParty getPolParty(PolPartyPK id) {
		return personalDAO.getPolParty(id);
	}

	public List<PolParty> getPolParties(Integer branchId) {
		return personalDAO.getPolParties(branchId);
	}

	/**
	 * HireType
	 * @param id
	 * @return
	 */
	public HireType getHireType(HireTypePK id) {
		return personalDAO.getHireType(id);
	}

	public List<HireType> getHireTypes(Integer branchId) {
		return personalDAO.getHireTypes(branchId);
	}

	/**
	 * JobGrade
	 * @param id
	 * @return
	 */
	public JobGrade getJobGrade(JobGradePK id) {
		return personalDAO.getJobGrade(id);
	}

	public List<JobGrade> getJobGrades(Integer branchId) {
		return personalDAO.getJobGrades(branchId);
	}

	/**
	 * JobSpec
	 * @param id
	 * @return
	 */
	public JobSpec getJobSpec(JobSpecPK id) {
		return personalDAO.getJobSpec(id);
	}

	public List<JobSpec> getJobSpecs(Integer branchId) {
		return personalDAO.getJobSpecs(branchId);
	}

	/**
	 * MarryStatus
	 * @param id
	 * @return
	 */
	public MarryStatus getMarryStatus(MarryStatusPK id) {
		return personalDAO.getMarryStatus(id);
	}

	public List<MarryStatus> getMarryStatusList(Integer branchId) {
		return personalDAO.getMarryStatusList(branchId);
	}

	/**
	 * NativePlace
	 * @param id
	 * @return
	 */
	public NativePlace getNativePlace(NativePlacePK id) {
		return personalDAO.getNativePlace(id);
	}

	public List<NativePlace> getNativePlaces(Integer branchId) {
		return personalDAO.getNativePlaces(branchId);
	}

	/**
	 * RegBranch
	 * @param id
	 * @return
	 */
	public RegBranch getRegBranch(RegBranchPK id) {
		return personalDAO.getRegBranch(id);
	}

	public List<RegBranch> getRegBranches(Integer branchId) {
		return personalDAO.getRegBranches(branchId);
	}

	/**
	 * SchDegree
	 * @param id
	 * @return
	 */
	public SchDegree getSchDegree(SchDegreePK id) {
		return personalDAO.getSchDegree(id);
	}

	public List<SchDegree> getSchDegrees(Integer branchId) {
		return personalDAO.getSchDegrees(branchId);
	}

	/**
	 * SchGraduate
	 * @param id
	 * @return
	 */
	public SchGraduate getSchGraduate(SchGraduatePK id) {
		return personalDAO.getSchGraduate(id);
	}

	public List<SchGraduate> getSchGraduates(Integer branchId) {
		return personalDAO.getSchGraduates(branchId);
	}

	/**
	 * Schooling
	 * @param id
	 * @return
	 */
	public Schooling getSchooling(SchoolingPK id) {
		return personalDAO.getSchooling(id);
	}

	public List<Schooling> getSchoolings(Integer branchId) {
		return personalDAO.getSchoolings(branchId);
	}

	/**
	 * WorkType
	 * @param id
	 * @return
	 */
	public WorkType getWorkType(WorkTypePK id) {
		return personalDAO.getWorkType(id);
	}

	public List<WorkType> getWorkTypes(Integer branchId) {
		return personalDAO.getWorkTypes(branchId);
	}

	public void testTx(PolParty party, People people) {
		BaseServiceUtil.addObject(party);
		BaseServiceUtil.addObject(people);
	}

}
