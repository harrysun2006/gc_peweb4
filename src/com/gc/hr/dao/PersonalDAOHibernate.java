package com.gc.hr.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.gc.Constants;
import com.gc.common.po.Person;
import com.gc.common.po.Position;
import com.gc.common.po.PositionPK;
import com.gc.common.po.PsnOnline;
import com.gc.common.po.SecurityLimit;
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
import com.gc.util.ObjectUtil;

public class PersonalDAOHibernate extends HibernateDaoSupport {

//==================================== Person ====================================

	public int allotPersonDepart(Person po) {
		Person lpo = (Person) getSession().get(Person.class, po.getId());
		lpo.setAllotDate(po.getAllotDate());
		lpo.setAllotReason(po.getAllotReason());
		lpo.setDepart(po.getDepart());
		lpo.setOffice(po.getOffice());
		lpo.setLine(null);
		lpo.setBus(null);
		getSession().update(lpo);
		return 1;
	}

	public int allotPersonLine(Person po) {
		Person lpo = (Person) getSession().get(Person.class, po.getId());
		lpo.setAllotDate(po.getAllotDate());
		lpo.setAllotReason(po.getAllotReason());
		lpo.setDepart(po.getDepart());
		lpo.setOffice(po.getOffice());
		lpo.setLine(po.getLine());
		lpo.setBus(po.getBus());
		getSession().update(lpo);
		return 1;
	}

	public int downPersons(Integer[] ids, Person person, Boolean down) {
		if (ids == null || ids.length <= 0) return 0;
		StringBuilder sb = new StringBuilder();
		sb.append("update Person p set p.downDate = ?, p.downReason = ? where p.id in (");
		for (int i = 0; i < ids.length; i++) {
			sb.append("?, ");
		}
		sb.delete(sb.length() - 2, sb.length());
		sb.append(")");
		Query q = getSession().createQuery(sb.toString());
		Calendar cal = down ? person.getDownDate() : Constants.MAX_DATE;
		String reason = down ? person.getDownReason() : "";
		int index=0;
		q.setParameter(index++, cal);
		q.setParameter(index++, reason);
		for (int i = 0; i < ids.length; i++) {
			q.setParameter(index++, ids[i]);
		}
		return q.executeUpdate();
	}

	public Person getPerson(Person po) {
		return getPerson(po.getId());
	}

	public Person getPerson(Integer id) {
		return getPerson2(id);
	}

	protected Person getPerson1(Integer id) {
		return (Person) getHibernateTemplate().get(Person.class, id);
	}

	private Person getPerson2(Integer id) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.fkPosition po")
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.chkGroup cg")
			.append(" where p.id = :id");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("id", id);
		return (Person) q.list().get(0);
	}

	public Person getPersonByCert2(String cert2No) {
		if (cert2No == null) return null;
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.fkPosition pos")
			.append(" left outer join fetch p.line l")
			.append(" left outer join fetch p.bus e")
			.append(" where p.cert2No = :cert2No");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("cert2No", cert2No);
		List<Person> l = q.list();
		return (l.size() > 0) ? l.get(0) : null;
	}

	public Person getPersonByWorkerId(Integer branchId, String workerId) {
		if (workerId == null) return null;
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.psnPhoto pp")
			.append(" where p.branch.id = :branchId and p.workerId = :workerId");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("branchId", branchId);
		q.setParameter("workerId", workerId);
		List<Person> l = q.list();
		return (l.size() > 0) ? l.get(0) : null;
	}

	public List<Person> getPersons(Integer[] ids) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.chkGroup g")
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.fkPosition pos")
			.append(" left outer join fetch p.line l")
			.append(" left outer join fetch p.bus e")
			.append(" where p.id in (");
		for (int i = 0; i < ids.length; i++) {
			sb.append("? ,");
		}
		if (ids.length > 0) sb.delete(sb.length() - 2, sb.length());
		sb.append(") order by p.id");
		Query q = getSession().createQuery(sb.toString());
		int index = 0;
		for (int i = 0; i < ids.length; i++) {
			q.setParameter(index++, ids[i]);
		}
		return (List<Person>) q.list();
	}

	public List<Person> getPersons(SecurityLimit limit, Map qo, String[] orderColumns) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.chkGroup g")
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.fkPosition pos")
			.append(" left outer join fetch p.line l")
			.append(" left outer join fetch p.bus e")
			.append(" where p.branch.id = :branchId");
		if (limit.getHrLimit() >= 6 && limit.getHrLimit() <= 9) sb.append(" and p.depart.id = :did");
		String key, k1, k2, k3;
		Object value;
		int m1, m2;
		Map<String, String> tables = new Hashtable<String, String>();
		tables.put("chkGroup", "g");
		tables.put("depart", "d");
		tables.put("fkPosition", "pos");
		tables.put("line", "l");
		tables.put("bus", "e");
		if (qo != null) {
			/**
			 * birthday_from ==> p.birthday >= :birthday_from
			 * workerId ==> p.workerId like :workerId
			 * chkGroup.id ==> g.id = :chkGroup_id
			 */
			for (Iterator it = qo.keySet().iterator(); it.hasNext(); ) {
				key = (String) it.next();
				value = qo.get(key);
				m1 = key.indexOf('.');
				m2 = key.indexOf('_');
				if (m1 > 0) { // Process foriegn key object alias
					k1 = key.substring(0, m1);
					k1 = tables.get(k1) + "." + key.substring(m1+1);
				} else {
					k1 = (m2 > 0) ? "p." + key.substring(0, m2) : "p." + key;
				}
				if (m2 > 0 && value instanceof Date) {
					k2 = key.substring(m2+1);
					k2 = "from".equals(k2) ? " >= " : " <= ";
				} else if (value instanceof String) {
					k2 = " like ";
				} else if (value instanceof Number) {
					k2 = " = ";
				} else {
					k2 = " = ";
				}
				k3 = key.replace('.', '_');
				sb.append(" and ").append(k1).append(k2).append(":").append(k3);
			}
		}
		/*
		if (qo != null) {
			if (qo.getWorkerId() != null) sb.append(" and p.workerId like :workerId");
			if (qo.getName() != null) sb.append(" and p.name like :name");
			if (qo.getPid() != null) sb.append(" and p.pid like :pid");
			if (qo.getSex() != null) {
				if (qo.getSex() == "") sb.append(" and (p.sex = '' or p.sex is null)");
				else sb.append(" and p.sex = :sex");
			}
			if (qo.getPeople() != null) sb.append(" and p.people like :people");
			if (qo.getNativePlace() != null) sb.append(" and p.nativePlace like :nativePlace");
			if (qo.getRegAddress() != null) sb.append(" and p.regAddress like :regAddress");
			if (qo.getBirthday() != null && qo.getBirthday().getTimeInMillis() == 0) sb.append(" and (p.birthday is null)");
			if (qo.getBirthdayFrom() != null) sb.append(" and p.birthday >= :birthdayFrom");
			if (qo.getBirthdayTo() != null) sb.append(" and p.birthday <= :birthdayTo");
			if (qo.getMarryStatus() != null) sb.append(" and p.marryStatus = :marryStatus");
			if (qo.getAnnuities() != null) sb.append(" and p.annuities like :annuities");
			if (qo.getAccumulation() != null) sb.append(" and p.accumulation like :accumulation");
			if (qo.getChkGroupId() != null && qo.getChkGroupId() != 0) sb.append(" and g.id = :chkGroupId");
			if (qo.getOnDateFrom() != null) sb.append(" and p.onDate >= :onDateFrom");
			if (qo.getOnDateTo() != null) sb.append(" and p.onDate <= :onDateTo");
			if (qo.getDownDateFrom() != null) sb.append(" and p.downDate >= :downDateFrom");
			if (qo.getDownDateTo() != null) sb.append(" and p.downDate <= :downDateTo");
			if (qo.getDownReason() != null) sb.append(" and p.downReason like :downReason");
			if (qo.getUpgradeDateFrom() != null) sb.append(" and p.upgradeDate >= :upgradeDateFrom");
			if (qo.getUpgradeDateTo() != null) sb.append(" and p.upgradeDate <= :upgradeDateTo");
			if (qo.getUpgradeReason() != null) sb.append(" and p.upgradeReason like :upgradeReason");
			if (qo.getType() != null) {
				if (qo.getType() == "") sb.append(" and (p.type = '' or p.type is null)");
				else sb.append(" and p.type = :type");
			}
			if (qo.getRegBelong() != null) {
				if (qo.getRegBelong() == "") sb.append(" and (p.regBelong = '' or p.regBelong is null)");
				else sb.append(" and p.regBelong = :regBelong");
			}
			if (qo.getParty() != null) {
				if (qo.getParty() == "") sb.append(" and (p.party = '' or p.party is null)");
				else sb.append(" and p.party = :party");
			}
			if (qo.getGrade() != null) {
				if (qo.getGrade() == "") sb.append(" and (p.grade = '' or p.grade is null)");
				else sb.append(" and p.grade = :grade");
			}
			if (qo.getSchooling() != null) {
				if (qo.getSchooling() == "") sb.append(" and (p.schooling = '' or p.schooling is null)");
				else sb.append(" and p.schooling = :schooling");
			}
			if (qo.getAllotDateFrom() != null) sb.append(" and p.allotDate >= :allotDateFrom");
			if (qo.getAllotDateTo() != null) sb.append(" and p.allotDate <= :allotDateTo");
			if (qo.getAllotReason() != null) sb.append(" and p.allotReson like :allotReason");
			if (qo.getDepartId() != null && qo.getDepartId() != 0) sb.append(" and d.id = :departId");
			if (qo.getDepart() != null && qo.getDepart().getName() != null) sb.append(" and d.name like :departName");
			if (qo.getOffice() != null) {
				if (qo.getOffice() == "") sb.append(" and (p.office = '' or p.office is null)");
				else sb.append(" and p.office like :office");
			}
			if (qo.getLine() != null && qo.getLine().getName() != null) sb.append(" and p.line.name like :lineName");
			if (qo.getBus() != null && qo.getBus().getAuthNo() != null) sb.append(" and p.bus.authNo like :busAuthNo");
			if (qo.getPosition() != null) {
				if (qo.getPosition() == "") sb.append(" and (p.position = '' or p.position is null)");
				else sb.append(" and p.position = :position");
			}
			if (qo.getFillTableDateFrom() != null) sb.append(" and p.fillTableDate >= :fillTableDateFrom");
			if (qo.getFillTableDateTo() != null) sb.append(" and p.fillTableDate <= :fillTableDateTo");
			if (qo.getCommend() != null) sb.append(" and p.commend like :commend");
			if (qo.getWorkDate() != null && qo.getWorkDate().getTimeInMillis() == 0) sb.append(" and (p.workDate is null)");
			if (qo.getWorkDateFrom() != null) sb.append(" and p.workDate >= :workDateFrom");
			if (qo.getWorkDateTo() != null) sb.append(" and p.workDate <= :workDateTo");
			if (qo.getRetireDateFrom() != null) sb.append(" and p.retireDate >= :retireDateFrom");
			if (qo.getRetireDateTo() != null) sb.append(" and p.retireDate <= :retireDateTo");
			if (qo.getServiceLength() != null) {
				if (qo.getServiceLength() == "") sb.append(" and (p.serviceLength = '' or p.serviceLength is null)");
				else sb.append(" and p.serviceLength like :serviceLength");
			}
			if (qo.getInDate() != null && qo.getInDate().getTimeInMillis() == 0) sb.append(" and (p.inDate is null)");
			if (qo.getInDateFrom() != null) sb.append(" and p.inDate >= :inDateFrom");
			if (qo.getInDateTo() != null) sb.append(" and p.inDate <= :inDateTo");
			if (qo.getOutDateFrom() != null) sb.append(" and p.outDate >= :outDateFrom");
			if (qo.getOutDateTo() != null) sb.append(" and p.outDate <= :outDateTo");
			if (qo.getWorkLength() != null) {
				if (qo.getWorkLength() == "") sb.append(" and (p.workLength = '' or p.workLength is null)");
				else sb.append(" and p.workLength like :workLength");
			}
			if (qo.getGroupNo() != null) sb.append(" and p.groupNo like :groupNo");
			if (qo.getContractNo() != null) sb.append(" and p.contractNo like :contractNo");
			if (qo.getContr1FromFrom() != null) sb.append(" and p.contr1From >= :contr1FromFrom");
			if (qo.getContr1FromTo() != null) sb.append(" and p.contr1From <= :contr1FromTo");
			if (qo.getContr1End() != null && qo.getContr1End().getTimeInMillis() == 0) sb.append(" and (p.contr1End is null)");
			if (qo.getContr1EndFrom() != null) sb.append(" and p.contr1End >= :contr1EndFrom");
			if (qo.getContr1EndTo() != null) sb.append(" and p.contr1End <= :contr1EndTo");
			if (qo.getContractReason() != null) sb.append(" and p.contractReason like :contractReason");
			if (qo.getContr2FromFrom() != null) sb.append(" and p.contr2From >= :contr2FromFrom");
			if (qo.getContr2FromTo() != null) sb.append(" and p.contr2From <= :contr2FromTo");
			if (qo.getContr2EndFrom() != null) sb.append(" and p.contr2End >= :contr2EndFrom");
			if (qo.getContr2EndTo() != null) sb.append(" and p.contr2End <= :contr2EndTo");
			if (qo.getWorkType() != null) sb.append(" and p.workType like :workType");
			if (qo.getLevel() != null && qo.getLevel() > 0) sb.append(" and p.level = :level");
			if (qo.getTechLevel() != null) sb.append(" and p.techLevel like :techLevel");
			if (qo.getResponsibility() != null) sb.append(" and p.responsibility like :responsibility");
			if (qo.getCert1No() != null) sb.append(" and p.cert1No like :cert1No");
			if (qo.getCert1NoDateFrom() != null) sb.append(" and p.cert1NoDate >= :cert1NoDateFrom");
			if (qo.getCert1NoDateTo() != null) sb.append(" and p.cert1NoDate <= :cert1NoDateTo");
			if (qo.getCert2No() != null) sb.append(" and p.cert2No like :cert2No");
			if (qo.getCert2NoHex() != null) sb.append(" and p.cert2NoHex like :cert2NoHex");
			if (qo.getServiceNo() != null) sb.append(" and p.serviceNo like :serviceNo");
			if (qo.getServiceNoDateFrom() != null) sb.append(" and p.serviceNoDate >= :serviceNoDateFrom");
			if (qo.getServiceNoDateTo() != null) sb.append(" and p.serviceNoDate <= :serviceNoDateTo");
			if (qo.getFrontWorkResume() != null) sb.append(" and p.frontWorkResume like :frontWorkResume");
			if (qo.getFrontTrainingResume() != null) sb.append(" and p.frontTrainingResume like :frontTrainingResume");
			if (qo.getSpecification() != null) sb.append(" and p.specification like :specification");
			if (qo.getDegree() != null) sb.append(" and p.degree like :degree");
			if (qo.getGraduate() != null) sb.append(" and p.graduate like :graduate");
			if (qo.getSkill() != null) sb.append(" and p.skill like :skill");
			if (qo.getLanCom() != null) sb.append(" and p.lanCom like :lanCom");
			if (qo.getNational() != null) sb.append(" and p.national like :national");
			if (qo.getState() != null) sb.append(" and p.state like :state");
			if (qo.getCity() != null) sb.append(" and p.city like :city");
			if (qo.getAddress() != null) sb.append(" and p.address like :address");
			if (qo.getZip() != null) sb.append(" and p.zip like :zip");
			if (qo.getTelephone() != null) sb.append(" and p.telephone like :telephone");
			if (qo.getEmail() != null) sb.append(" and p.email like :email");
			if (qo.getOfficeTel() != null) sb.append(" and p.officeTel like :officeTel");
			if (qo.getOfficeExt() != null) sb.append(" and p.officeExt like :officeExt");
			if (qo.getOfficeFax() != null) sb.append(" and p.officeFax like :officeFax");
			if (qo.getComment() != null) sb.append(" and p.comment like :comment");
		}
		*/
		sb.append(" order by");
		if (orderColumns != null && orderColumns.length > 0) {
			for (int i = 0; i < orderColumns.length; i++) {
				sb.append(" p.").append(orderColumns[i]).append(",");
			}
		}
		sb.append(" p.workerId");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("branchId", limit.getBranchId());
		if (limit.getHrLimit() >= 6 && limit.getHrLimit() <= 9) q.setParameter("did", limit.getHrLimitDepartId());
		if (qo != null) {
			for (Iterator it = qo.keySet().iterator(); it.hasNext(); ) {
				key = (String) it.next();
				value = qo.get(key);
				key = key.replace('.', '_');
				if (value instanceof Date) {
					value = ObjectUtil.toCalendar(value);
				}
				else if (value instanceof String) {
					value = "%" + value + "%";
				}
				q.setParameter(key, value);
			}
		}
		/*
		if (qo != null) {
			if (qo.getWorkerId() != null) q.setParameter("workerId", "%" + qo.getWorkerId() + "%");
			if (qo.getName() != null) q.setParameter("name", "%" + qo.getName() + "%");
			if (qo.getPid() != null) q.setParameter("pid", "%" + qo.getPid() + "%");
			if (qo.getSex() != null && qo.getSex() != "") q.setParameter("sex", qo.getSex());
			if (qo.getPeople() != null) q.setParameter("people", "%" + qo.getPeople() + "%");
			if (qo.getNativePlace() != null) q.setParameter("nativePlace", "%" + qo.getNativePlace() + "%");
			if (qo.getRegAddress() != null) q.setParameter("regAddress", "%" + qo.getRegAddress() + "%");
			if (qo.getBirthdayFrom() != null) q.setParameter("birthdayFrom", qo.getBirthdayFrom());
			if (qo.getBirthdayTo() != null) q.setParameter("birthdayTo", qo.getBirthdayTo());
			if (qo.getMarryStatus() != null) q.setParameter("marryStatus", qo.getMarryStatus());
			if (qo.getAnnuities() != null) q.setParameter("annuities", "%" + qo.getAnnuities() + "%");
			if (qo.getAccumulation() != null) q.setParameter("accumulation", "%" + qo.getAccumulation() + "%");
			if (qo.getChkGroupId() != null && qo.getChkGroupId() != 0) q.setParameter("chkGroupId", qo.getChkGroupId());
			if (qo.getOnDateFrom() != null) q.setParameter("onDateFrom", qo.getOnDateFrom());
			if (qo.getOnDateTo() != null) q.setParameter("onDateTo", qo.getOnDateTo());
			if (qo.getDownDateFrom() != null) q.setParameter("downDateFrom", qo.getDownDateFrom());
			if (qo.getDownDateTo() != null) q.setParameter("downDateTo", qo.getDownDateTo());
			if (qo.getDownReason() != null) q.setParameter("downReason", "%" + qo.getDownReason() + "%");
			if (qo.getUpgradeDateFrom() != null) q.setParameter("upgradeDateFrom", qo.getUpgradeDateFrom());
			if (qo.getUpgradeDateTo() != null) q.setParameter("upgradeDateTo", qo.getUpgradeDateTo());
			if (qo.getUpgradeReason() != null) q.setParameter("upgradeReason", "%" + qo.getUpgradeReason() + "%");
			if (qo.getType() != null && qo.getType() != "") q.setParameter("type", qo.getType());
			if (qo.getRegBelong() != null && qo.getRegBelong() != "") q.setParameter("regBelong", qo.getRegBelong());
			if (qo.getParty() != null && qo.getParty() != "") q.setParameter("party", qo.getParty());
			if (qo.getGrade() != null && qo.getGrade() != "") q.setParameter("grade", qo.getGrade());
			if (qo.getSchooling() != null && qo.getSchooling() != "") q.setParameter("schooling", qo.getSchooling());
			if (qo.getAllotDateFrom() != null) q.setParameter("allotDateFrom", qo.getAllotDateFrom());
			if (qo.getAllotDateTo() != null) q.setParameter("allotDateTo", qo.getAllotDateTo());
			if (qo.getAllotReason() != null) q.setParameter("allotReason", "%" + qo.getAllotReason() + "%");
			if (qo.getDepartId() != null && qo.getDepartId() != 0) q.setParameter("departId", qo.getDepartId());
			if (qo.getDepart() != null && qo.getDepart().getName() != null) q.setParameter("departName", "%" + qo.getDepart().getName() + "%");
			if (qo.getOffice() != null && qo.getOffice() != "") q.setParameter("office", "%" + qo.getOffice() + "%");
			if (qo.getLine() != null && qo.getLine().getName() != null) q.setParameter("lineName", "%" + qo.getLine().getName() + "%");
			if (qo.getBus() != null && qo.getBus().getAuthNo() != null) q.setParameter("busAuthNo", "%" + qo.getBus().getAuthNo() + "%");
			if (qo.getPosition() != null && qo.getPosition() != "") q.setParameter("position", qo.getPosition());
			if (qo.getFillTableDateFrom() != null) q.setParameter("fillTableDateFrom", qo.getFillTableDateFrom());
			if (qo.getFillTableDateTo() != null) q.setParameter("fillTableDateTo", qo.getFillTableDateTo());
			if (qo.getCommend() != null) q.setParameter("commend", "%" + qo.getCommend() + "%");
			if (qo.getWorkDateFrom() != null) q.setParameter("workDateFrom", qo.getWorkDateFrom());
			if (qo.getWorkDateTo() != null) q.setParameter("workDateTo", qo.getWorkDateTo());
			if (qo.getRetireDateFrom() != null) q.setParameter("retireDateFrom", qo.getRetireDateFrom());
			if (qo.getRetireDateTo() != null) q.setParameter("retireDateTo", qo.getRetireDateTo());
			if (qo.getServiceLength() != null && qo.getServiceLength() != "") q.setParameter("serviceLength", "%" + qo.getServiceLength() + "%");
			if (qo.getInDateFrom() != null) q.setParameter("inDateFrom", qo.getInDateFrom());
			if (qo.getInDateTo() != null) q.setParameter("inDateTo", qo.getInDateTo());
			if (qo.getOutDateFrom() != null) q.setParameter("outDateFrom", qo.getOutDateFrom());
			if (qo.getOutDateTo() != null) q.setParameter("outDateTo", qo.getOutDateTo());
			if (qo.getWorkLength() != null && qo.getWorkLength() != "") q.setParameter("workLength", "%" + qo.getWorkLength() + "%");
			if (qo.getGroupNo() != null) q.setParameter("groupNo", "%" + qo.getGroupNo() + "%");
			if (qo.getContractNo() != null) q.setParameter("contractNo", "%" + qo.getContractNo() + "%");
			if (qo.getContr1FromFrom() != null) q.setParameter("contr1FromFrom", qo.getContr1FromFrom());
			if (qo.getContr1FromTo() != null) q.setParameter("contr1FromTo", qo.getContr1FromTo());
			if (qo.getContr1EndFrom() != null) q.setParameter("contr1EndFrom", qo.getContr1EndFrom());
			if (qo.getContr1EndTo() != null) q.setParameter("contr1EndTo", qo.getContr1EndTo());
			if (qo.getContractReason() != null) q.setParameter("contractReason", "%" + qo.getContractReason() + "%");
			if (qo.getContr2FromFrom() != null) q.setParameter("contr2FromFrom", qo.getContr2FromFrom());
			if (qo.getContr2FromTo() != null) q.setParameter("contr2FromTo", qo.getContr2FromTo());
			if (qo.getContr2EndFrom() != null) q.setParameter("contr2EndFrom", qo.getContr2EndFrom());
			if (qo.getContr2EndTo() != null) q.setParameter("contr2EndTo", qo.getContr2EndTo());
			if (qo.getWorkType() != null) q.setParameter("workType", "%" + qo.getWorkType() + "%");
			if (qo.getLevel() != null && qo.getLevel() > 0) q.setParameter("level", qo.getLevel());
			if (qo.getTechLevel() != null) q.setParameter("techLevel", "%" + qo.getTechLevel() + "%");
			if (qo.getResponsibility() != null) q.setParameter("responsibility", "%" + qo.getResponsibility() + "%");
			if (qo.getCert1No() != null) q.setParameter("cert1No", "%" + qo.getCert1No() + "%");
			if (qo.getCert1NoDateFrom() != null) q.setParameter("cert1NoDateFrom", qo.getCert1NoDateFrom());
			if (qo.getCert1NoDateTo() != null) q.setParameter("cert1NoDateTo", qo.getCert1NoDateTo());
			if (qo.getCert2No() != null) q.setParameter("cert2No", "%" + qo.getCert2No() + "%");
			if (qo.getCert2NoHex() != null) q.setParameter("cert2NoHex", "%" + qo.getCert2NoHex() + "%");
			if (qo.getServiceNo() != null) q.setParameter("serviceNo", "%" + qo.getServiceNo() + "%");
			if (qo.getServiceNoDateFrom() != null) q.setParameter("serviceNoDateFrom", qo.getServiceNoDateFrom());
			if (qo.getServiceNoDateTo() != null) q.setParameter("serviceNoDateTo", qo.getServiceNoDateTo());
			if (qo.getFrontWorkResume() != null) q.setParameter("frontWorkResume", "%" + qo.getFrontWorkResume() + "%");
			if (qo.getFrontTrainingResume() != null) q.setParameter("frontTrainingResume", "%" + qo.getFrontTrainingResume() + "%");
			if (qo.getSpecification() != null) q.setParameter("specification", "%" + qo.getSpecification() + "%");
			if (qo.getDegree() != null) q.setParameter("degree", "%" + qo.getDegree() + "%");
			if (qo.getGraduate() != null) q.setParameter("graduate", "%" + qo.getGraduate() + "%");
			if (qo.getSkill() != null) q.setParameter("skill", "%" + qo.getSkill() + "%");
			if (qo.getLanCom() != null) q.setParameter("lanCom", "%" + qo.getLanCom() + "%");
			if (qo.getNational() != null) q.setParameter("national", "%" + qo.getNational() + "%");
			if (qo.getState() != null) q.setParameter("state", "%" + qo.getState() + "%");
			if (qo.getCity() != null) q.setParameter("city", "%" + qo.getCity() + "%");
			if (qo.getAddress() != null) q.setParameter("address", "%" + qo.getAddress() + "%");
			if (qo.getZip() != null) q.setParameter("zip", "%" + qo.getZip() + "%");
			if (qo.getTelephone() != null) q.setParameter("telephone", "%" + qo.getTelephone() + "%");
			if (qo.getEmail() != null) q.setParameter("email", "%" + qo.getEmail() + "%");
			if (qo.getOfficeTel() != null) q.setParameter("officeTel", "%" + qo.getOfficeTel() + "%");
			if (qo.getOfficeExt() != null) q.setParameter("officeExt", "%" + qo.getOfficeExt() + "%");
			if (qo.getOfficeFax() != null) q.setParameter("officeFax", "%" + qo.getOfficeFax() + "%");
			if (qo.getComment() != null) q.setParameter("comment", "%" + qo.getComment() + "%");
		}
		*/
		return (List<Person>) q.list();
	}

	public List<Person> getAllPersons(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.branch b")
			.append(" where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and p.branch.id = :branchId");
		sb.append(" order by p.workerId");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("branchId", branchId);
		return (List<Person>) q.list();
	}

	@SuppressWarnings("unchecked")
	public List<Person> getPersonsByBranchId(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" where p.branch.id = :id");
		Query q = getSession().createQuery(sb.toString());
		q.setParameter("id", branchId);
		return (List<Person>) q.list();
	}

	public List<Person> getPersonsCard(Integer[] ids) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p")
			.append(", (select min(ps.onDate) from PsnStatus ps where ps.person.id = p.id and ps.schooling = p.schooling) as graudateDate")
			.append(", (select min(ps.onDate) from PsnStatus ps where ps.person.id = p.id and ps.party = p.party) as partyOnDate")
			.append(" from Person p left outer join fetch p.psnPhoto pp")
			.append(" left outer join fetch p.branch b")
			.append(" left outer join fetch p.fkPosition pos")
			/*
			.append(" left outer join fetch p.depart d")
			.append(" left outer join fetch p.line l")
			.append(" left outer join fetch p.bus e")
			*/
			.append(" where p.id in (");
		for (int i = 0; i < ids.length; i++) {
			sb.append("? ,");
		}
		if (ids.length > 0) sb.delete(sb.length() - 2, sb.length());
		sb.append(") order by p.id");
		Query q = getSession().createQuery(sb.toString());
		int index = 0;
		for (int i = 0; i < ids.length; i++) {
			q.setParameter(index++, ids[i]);
		}
		Object[] v;
		Person p;
		List<Object[]> list = (List<Object[]>) q.list();
		List<Person> persons = new ArrayList<Person>();
		for (Iterator<Object[]> it = list.iterator(); it.hasNext(); ) {
			v = it.next();
			p = (Person) v[0];
			p.setGraduateDate((Calendar) v[1]);
			p.setPartyOnDate((Calendar) v[2]);
			persons.add(p);
		}
		return persons;
	}

	public int updatePersonCert2(Person po) {
		Person lpo = (Person) getSession().get(Person.class, po.getId());
		lpo.setCert2No(po.getCert2No());
		lpo.setCert2NoHex(po.getCert2NoHex());
		getSession().update(lpo);
		return 1;
	}

	public int updatePersonInfo(Person po) {
		getSession().update(po);
		return 1;
	}

	public int updatePersonStatus(Person po) {
		Person lpo = (Person) getSession().get(Person.class, po.getId());
		lpo.setUpgradeDate(po.getUpgradeDate());
		lpo.setUpgradeReason(po.getUpgradeReason());
		lpo.setType(po.getType());
		lpo.setPosition(po.getPosition());
		// lpo.setFkPosition(po.getFkPosition());
		lpo.setRegBelong(po.getRegBelong());
		lpo.setParty(po.getParty());
		lpo.setGrade(po.getGrade());
		lpo.setSchooling(po.getSchooling());
		getSession().update(lpo);
		return 1;
	}

	public List<Person> findPersons(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from Person p")
			.append(" left outer join fetch p.depart d")
			.append(" where 1=1");
		if (qo != null) {
			if (qo.containsKey("workerId")) sb.append(" and p.workerId = :workerId");
		}
		sb.append(") order by p.id");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("workerId")) q.setParameter("workerId", qo.get("workerId"));
		}
		return (List<Person>) q.list();
	}

//==================================== PsnPhoto ====================================

//==================================== PsnOnline ====================================

	public List<PsnOnline> getPsnOnlines(Integer branchId, Calendar accDate, Integer departId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select pol from PsnOnline pol")
			.append(" left outer join fetch pol.depart d")
			.append(" where 1=1");
		if (branchId != null && branchId != 0) sb.append(" and pol.branch.id = :bid");
		if (departId != null && departId != 0) sb.append(" and pol.depart.id = :departId");
		if(accDate != null){
			sb.append(" and pol.onDate <= :accDate")
				.append(" and (pol.downDate >= :accDate or pol.downDate is null)");
		}
		sb.append(" order by pol.person.id");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		if (departId != null && departId != 0) q.setParameter("departId", departId);
		if(accDate != null) q.setParameter("accDate", accDate);
		return (List<PsnOnline>) q.list();
	}

	/**
	 * 根据机构和部门取出调动历史
	 * @param branchId
	 * @param departId
	 * @return 
	 */
	@SuppressWarnings("unchecked")
	public List<PsnOnline> getPsnOnlinesByDepart(Integer branchId, Integer departId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from PsnOnline po")
			.append(" where 1=1");
		if (branchId != null) sb.append(" and po.branch.id = :bid");
		if (departId != null) sb.append(" and po.depart.id = :did");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null) q.setParameter("bid", branchId);
		if (departId != null) q.setParameter("did", departId);
		return (List<PsnOnline>) q.list();
	}

	/**
	 * 取出当前机构的驾驶员调动历史
	 * @param branchId
	 */
	public List<PsnOnline> getDriverOnlines(Integer branchId, Integer departId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from PsnOnline po")
			.append(" left outer join fetch po.bus")
			.append(" where po.bus.id > 0");
		if (branchId != null) sb.append(" and po.branch.id = :bid");
		if (departId != null && departId != 0) sb.append(" and po.depart.id = :did");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null) q.setParameter("bid", branchId);
		if (departId != null && departId != 0) q.setParameter("did", departId);
		return (List<PsnOnline>) q.list();
	}
	
	/**
	 * 违章取当前机构的驾驶员调动历史,其中车可以为空
	 * @param qo
	 * @return
	 */
	public List<PsnOnline> getDriverOnlines2(Integer branchId, Integer departId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from PsnOnline po")
//			.append(" left outer join fetch po.bus")
			.append(" left outer join fetch po.person p")
			.append(" left outer join fetch po.line")
//			.append(" left outer join fetch po.depart")
			.append(" where 1=1");
		if (branchId != null) sb.append(" and po.branch.id = :bid");
		if (departId != null && departId != 0) sb.append(" and po.depart.id = :did");
		sb.append(" order by p.workerId");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null) q.setParameter("bid", branchId);
		if (departId != null && departId != 0) q.setParameter("did", departId);
		return (List<PsnOnline>) q.list();
	}
	
	public List<PsnOnline> getPsnOnlineList(Map qo) {
		StringBuilder sb = new StringBuilder("select po from PsnOnline po");
		String order = (String) qo.get(Constants.PARAM_ORDER);
		Person person = null;
		if (qo != null) {
			if (qo.containsKey("person")) person = (Person) qo.get("person");
		}
		if (person != null) sb.append(" left outer join fetch po.person p");
		String fetch = (String) qo.get(Constants.PARAM_FETCH);
		if (fetch != null) {
			String[] fetchs = fetch.split(",");
			for (int i = 0; i < fetchs.length; i++) sb.append(" left outer join fetch po.").append(fetchs[i].trim());
		}
		sb.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and po.branch.id = :branchId");
			if (qo.containsKey("depart.id")) sb.append(" and po.depart.id = :departId");
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) sb.append(" and po.person.id in (:persons)");
			if (qo.containsKey("onDate_from")) sb.append(" and po.onDate >= :onDate_from");
			if (qo.containsKey("onDate_to")) sb.append(" and po.onDate <= :onDate_to");
			if (qo.containsKey("downDate_from")) sb.append(" and po.downDate >= :downDate_from");
			if (qo.containsKey("downDate_to")) sb.append(" and po.downDate <= :downDate_to");
		}
		if (person != null) {
			if (person.getId() != null && person.getId() != 0) sb.append(" and p.id = :personId");
		}
		if (order == null) order = "person.id asc, onDate desc";
		String[] orders = order.split(",");
		if (orders.length > 0) {
			sb.append(" order by");
			for (int i = 0; i < orders.length; i++) sb.append(" po.").append(orders[i].trim()).append(", ");
			sb.delete(sb.length() - 2, sb.length());
		}
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) q.setParameterList("persons", (List) qo.get("persons"));
			if (qo.containsKey("onDate_from")) q.setParameter("onDate_from", ObjectUtil.toCalendar(qo.get("onDate_from")));
			if (qo.containsKey("onDate_to")) q.setParameter("onDate_to", ObjectUtil.toCalendar(qo.get("onDate_to")));
			if (qo.containsKey("downDate_from")) q.setParameter("downDate_from", ObjectUtil.toCalendar(qo.get("downDate_from")));
			if (qo.containsKey("downDate_to")) q.setParameter("downDate_to", ObjectUtil.toCalendar(qo.get("downDate_to")));
		}
		if (person != null) {
			if (person.getId() != null && person.getId() != 0) q.setParameter("personId", person.getId());
		}
		return (List<PsnOnline>) q.list();
	}

//==================================== PsnStatus ====================================

	public List<Person> getDrivers(Integer branchId, Calendar date) {
		StringBuilder sb = new StringBuilder();
		sb.append("select ps.person from PsnStatus ps")
			.append(" where 1=1")
			.append(" and ps.position ='1'");
		if (branchId != null && branchId != 0) sb.append(" and ps.branch.id = :bid");
		if(date != null) sb.append(" and ps.onDate <= :date and ps.downDate >= :date");
		sb.append(" order by ps.person.workerId");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		if(date != null) q.setParameter("date", date);
		return (List<Person>) q.list();
	}

	public List<PsnOnline> getPsnStatusList(Map qo) {
		StringBuilder sb = new StringBuilder();
		sb.append("select ps from PsnStatus ps");
		Person person = null;
		if (qo != null) {
			if (qo.containsKey("person")) person = (Person) qo.get("person");
		}
		if (person != null) sb.append(" left outer join fetch ps.person p");
		String fetch = (String) qo.get(Constants.PARAM_FETCH);
		if (fetch != null) {
			String[] fetchs = fetch.split(",");
			for (int i = 0; i < fetchs.length; i++) sb.append(" left outer join fetch ps.").append(fetchs[i].trim());
		}
		sb.append(" where 1 = 1");
		if (qo != null) {
			if (qo.containsKey("branch.id")) sb.append(" and ps.branch.id = :branchId");
			if (qo.containsKey("depart.id")) sb.append(" and ps.depart.id = :departId");
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) sb.append(" and ps.person.id in (:persons)");
			if (qo.containsKey("onDate_from")) sb.append(" and ps.onDate >= :onDate_from");
			if (qo.containsKey("onDate_to")) sb.append(" and ps.onDate <= :onDate_to");
			if (qo.containsKey("downDate_from")) sb.append(" and ps.downDate >= :downDate_from");
			if (qo.containsKey("downDate_to")) sb.append(" and ps.downDate <= :downDate_to");
		}
		if (person != null) {
			if (person.getId() != null && person.getId() != 0) sb.append(" and p.id = :personId");
		}
		sb.append(" order by ps.person.id asc, ps.onDate desc");
		Query q = getSession().createQuery(sb.toString());
		if (qo != null) {
			if (qo.containsKey("branch.id")) q.setParameter("branchId", qo.get("branch.id"));
			if (qo.containsKey("depart.id")) q.setParameter("departId", qo.get("depart.id"));
			if (qo.containsKey("persons") && qo.get("persons") != null && ((List) qo.get("persons")).size() > 0) q.setParameterList("persons", (List) qo.get("persons"));
			if (qo.containsKey("onDate_from")) q.setParameter("onDate_from", ObjectUtil.toCalendar(qo.get("onDate_from")));
			if (qo.containsKey("onDate_to")) q.setParameter("onDate_to", ObjectUtil.toCalendar(qo.get("onDate_to")));
			if (qo.containsKey("downDate_from")) q.setParameter("downDate_from", ObjectUtil.toCalendar(qo.get("downDate_from")));
			if (qo.containsKey("downDate_to")) q.setParameter("downDate_to", ObjectUtil.toCalendar(qo.get("downDate_to")));
		}
		if (person != null) {
			if (person.getId() != null && person.getId() != 0) q.setParameter("personId", person.getId());
		}
		return (List<PsnOnline>) q.list();
	}

//==================================== Position ====================================

	public Position getPosition(Integer branchId, String no) {
		return (Position) getHibernateTemplate().get(Position.class, new PositionPK(branchId, no));
	}

	public List<Position> getPositions(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from Position po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<Position>) q.list();
	}

//==================================== T_PSN_XXX ====================================

	/**
	 * People
	 * @param id
	 * @return
	 */
	public People getPeople(PeoplePK id) {
		return (People) getHibernateTemplate().get(People.class, id);
	}

	public List<People> getPeoples(Integer branchId) {
		return getPeoples2(branchId);
	}

	public List<People> getPeoples1(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from People p where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and p.id.branch.id = :bid");
		sb.append(" order by p.no, p.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<People>) q.list();
	}

	public List<People> getPeoples2(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select p from People p left outer join fetch p.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and p.id.branch.id = :bid");
		sb.append(" order by p.no, p.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<People>) q.list();
	}

	/**
	 * PolParty
	 * @param id
	 * @return
	 */
	public PolParty getPolParty(PolPartyPK id) {
		return (PolParty) getHibernateTemplate().get(PolParty.class, id);
	}

	public List<PolParty> getPolParties(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from PolParty po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<PolParty>) q.list();
	}

	/**
	 * HireType
	 * @param id
	 * @return
	 */
	public HireType getHireType(HireTypePK id) {
		return (HireType) getHibernateTemplate().get(HireType.class, id);
	}

	public List<HireType> getHireTypes(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from HireType po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<HireType>) q.list();
	}

	/**
	 * JobGrade
	 * @param id
	 * @return
	 */
	public JobGrade getJobGrade(JobGradePK id) {
		return (JobGrade) getHibernateTemplate().get(JobGrade.class, id);
	}

	public List<JobGrade> getJobGrades(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from JobGrade po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<JobGrade>) q.list();
	}

	/**
	 * JobSpec
	 * @param id
	 * @return
	 */
	public JobSpec getJobSpec(JobSpecPK id) {
		return (JobSpec) getHibernateTemplate().get(JobSpec.class, id);
	}

	public List<JobSpec> getJobSpecs(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from JobSpec po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<JobSpec>) q.list();
	}

	/**
	 * MarryStatus
	 * @param id
	 * @return
	 */
	public MarryStatus getMarryStatus(MarryStatusPK id) {
		return (MarryStatus) getHibernateTemplate().get(MarryStatus.class, id);
	}

	public List<MarryStatus> getMarryStatusList(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from MarryStatus po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<MarryStatus>) q.list();
	}

	/**
	 * NativePlace
	 * @param id
	 * @return
	 */
	public NativePlace getNativePlace(NativePlacePK id) {
		return (NativePlace) getHibernateTemplate().get(NativePlace.class, id);
	}

	public List<NativePlace> getNativePlaces(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from NativePlace po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<NativePlace>) q.list();
	}

	/**
	 * RegBranch
	 * @param id
	 * @return
	 */
	public RegBranch getRegBranch(RegBranchPK id) {
		return (RegBranch) getHibernateTemplate().get(RegBranch.class, id);
	}

	public List<RegBranch> getRegBranches(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from RegBranch po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<RegBranch>) q.list();
	}

	/**
	 * SchDegree
	 * @param id
	 * @return
	 */
	public SchDegree getSchDegree(SchDegreePK id) {
		return (SchDegree) getHibernateTemplate().get(SchDegree.class, id);
	}

	public List<SchDegree> getSchDegrees(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from SchDegree po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<SchDegree>) q.list();
	}

	/**
	 * SchGraduate
	 * @param id
	 * @return
	 */
	public SchGraduate getSchGraduate(SchGraduatePK id) {
		return (SchGraduate) getHibernateTemplate().get(SchGraduate.class, id);
	}

	public List<SchGraduate> getSchGraduates(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from SchGraduate po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<SchGraduate>) q.list();
	}

	/**
	 * Schooling
	 * @param id
	 * @return
	 */
	public Schooling getSchooling(SchoolingPK id) {
		return (Schooling) getHibernateTemplate().get(Schooling.class, id);
	}

	public List<Schooling> getSchoolings(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from Schooling po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<Schooling>) q.list();
	}

	/**
	 * WorkType
	 * @param id
	 * @return
	 */
	public WorkType getWorkType(WorkTypePK id) {
		return (WorkType) getHibernateTemplate().get(WorkType.class, id);
	}

	public List<WorkType> getWorkTypes(Integer branchId) {
		StringBuilder sb = new StringBuilder();
		sb.append("select po from WorkType po left outer join fetch po.id.branch b where 1 = 1");
		if (branchId != null && branchId != 0) sb.append(" and po.id.branch.id = :bid");
		sb.append(" order by po.no, po.id.name");
		Query q = getSession().createQuery(sb.toString());
		if (branchId != null && branchId != 0) q.setParameter("bid", branchId);
		return (List<WorkType>) q.list();
	}
}
