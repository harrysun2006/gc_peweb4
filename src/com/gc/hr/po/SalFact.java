package com.gc.hr.po;

import java.util.Calendar;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;

import com.gc.common.po.Branch;
import com.gc.common.po.Department;
import com.gc.common.po.Person;
import com.gc.util.CommonUtil;

public class SalFact {

	private SalFactPK id;

	private Department depart;

	private Calendar date;

	private Calendar issueDate;

	private Type issueType;

	private String summary;

	private Person issuer;

	private String comment;

	public SalFact() {
	}

	public SalFact(Integer branchId, String no) {
		this(new SalFactPK(branchId, no));
	}

	public SalFact(Branch branch, String no) {
		this(new SalFactPK(branch, no));
	}

	public SalFact(SalFactPK id) {
		setId(id);
	}

	public SalFactPK getId() {
		return id;
	}

	public void setId(SalFactPK id) {
		this.id = id;
	}

	public Branch getBranch() {
		return (id == null) ? null : id.getBranch();
	}

	public Integer getBranchId() {
		return (id == null) ? null : id.getBranchId();
	}

	public String getNo() {
		return (id == null) ? null : id.getNo();
	}

	public Integer getDepartId() {
		return (depart == null) ? null : depart.getId();
	}

	public Department getDepart() {
		return Department.getSafeObject(depart);
	}

	public void setDepart(Department depart) {
		this.depart = depart;
	}

	public Calendar getDate() {
		return date;
	}

	public void setDate(Calendar date) {
		this.date = date;
	}

	public Calendar getIssueDate() {
		return issueDate;
	}

	public void setIssueDate(Calendar issueDate) {
		this.issueDate = issueDate;
	}

	public String getIssueTypeValue() {
		return (issueType == null) ? null : issueType.getValue();
	}

	public void setIssueTypeValue(String value) {
		this.issueType = Type.item(value);
	}

	public Type getIssueType() {
		return issueType;
	}

	public void setIssueType(Type issueType) {
		this.issueType = issueType;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public Integer getIssuerId() {
		return (issuer == null) ? null : issuer.getId();
	}

	public Person getIssuer() {
		return Person.getSafeObject(issuer);
	}

	public void setIssuer(Person issuer) {
		this.issuer = issuer;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public boolean equals(Object obj) {
		SalFact po = (obj instanceof SalFact) ? (SalFact) obj : null;
		return CommonUtil.equals(this, po)
			&& CommonUtil.equals(getDepartId(), po.getDepartId())
			&& CommonUtil.equals(getIssuerId(), po.getIssuerId());
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("HrSalFact{id=").append(id)
			.append(", no=").append(getNo())
			.append(", depart=").append(getDepartId())
			.append(", issueType=").append(getIssueTypeValue()).append("}");
		return sb.toString();
	}

	public static SalFact getSafeObject(SalFact po) {
		if (Hibernate.isInitialized(po)) {
			if (po instanceof HibernateProxy) return (SalFact) ((HibernateProxy) po).getHibernateLazyInitializer().getImplementation();
			else return po;
		} else {
			if (po == null) return null;
			else return new SalFact(po.getId());
		}
	}

	/**
	 * 现[C]，转[T]，物[G]
	 * @author hsun
	 *
	 */
	public final static class Type {

		public final static Type CASH = new Type("C");
		public final static Type TRANS = new Type("T");
		public final static Type GOODS = new Type("G");

		public final static Type[] items = new Type[] {CASH, TRANS, GOODS};

		private String value;

		public Type() {
		}

		public Type(String value) {
			this.value = value;
		}

		public String getValue() {
			return this.value;
		}

		public void setValue(String value) {
			this.value=value;
		}

		public static int size() {
			return items.length;
		}

		protected static Type item(String v) {
			for (int i = 0; i < items.length; i++) {
				if (items[i].getValue().equals(v)) return items[i];
			}
			return null;
		}

		public int hashCode() {
			return value.hashCode();
		}

		public String toString() {
			return (value == null) ? null : value.toString();
		}

		public boolean equals(Object obj) {
			return (value == null) ? ((obj == null) ? true : false) : value.equals(obj);
		}
	}
}
