package com.gc.hr.po;

import java.util.Calendar;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;

import com.gc.common.po.Branch;
import com.gc.util.CommonUtil;

public class SalItem {

	private Integer id;

	private Branch branch;

	private String no;

	private String name;

	private Calendar onDate;

	private Calendar downDate;

	private String accountDebit;

	private String accountCredit;

	private Flag flag;

	private Type type;

	private String print;

	private String formula;

	public SalItem() {
	}

	public SalItem(Integer id) {
		setId(id);
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getBranchId() {
		return (branch == null) ? null : branch.getId();
	}

	public Branch getBranch() {
		return Branch.getSafeObject(branch);
	}

	public void setBranch(Branch branch) {
		this.branch = branch;
	}

	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Calendar getOnDate() {
		return onDate;
	}

	public void setOnDate(Calendar onDate) {
		this.onDate = onDate;
	}

	public Calendar getDownDate() {
		return downDate;
	}

	public void setDownDate(Calendar downDate) {
		this.downDate = downDate;
	}

	public String getAccountDebit() {
		return accountDebit;
	}

	public void setAccountDebit(String accountDebit) {
		this.accountDebit = accountDebit;
	}

	public String getAccountCredit() {
		return accountCredit;
	}

	public void setAccountCredit(String accountCredit) {
		this.accountCredit = accountCredit;
	}

	/**
	 * 一般使用枚举变量的值
	 * @return
	 */
	public Integer getFlagValue() {
		return (flag == null) ? null : flag.getValue();
	}

	public void setFlagValue(Integer value) {
		this.flag = Flag.item(value);
	}

	public Flag getFlag() {
		return flag;
	}

	/**
	 * 控制对枚举变量的赋值
	 * @param flag
	 */
	public void setFlag(Flag flag) {
		this.flag = flag;
	}

	public String getTypeValue() {
		return (type == null) ? null : type.getValue();
	}

	public void setTypeValue(String value) {
		this.type = Type.item(value);
	}

	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}

	public String getPrint() {
		return print;
	}

	public void setPrint(String print) {
		this.print = print;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}

	public boolean equals(Object obj) {
		SalItem po = (obj instanceof SalItem) ? (SalItem) obj : null;
		return CommonUtil.equals(this, po)
			&& CommonUtil.equals(getBranchId(), po.getBranchId());
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("HrSalItem{id=").append(id)
			.append(", no=").append(no)
			.append(", flag=").append(flag)
			.append(", type=").append(type)
			.append("}");
		return sb.toString();
	}

	public static SalItem getSafeObject(SalItem po) {
		if (Hibernate.isInitialized(po)) {
			if (po instanceof HibernateProxy) return (SalItem) ((HibernateProxy) po).getHibernateLazyInitializer().getImplementation();
			else return po;
		} else {
			if (po == null) return null;
			else return new SalItem(po.getId());
		}
	}

	public final static class Flag {

		public final static Flag POS = new Flag(1);
		public final static Flag NEG = new Flag(-1);
		public final static Flag ZERO = new Flag(0);

		public final static Flag[] items = new Flag[] {POS, NEG, ZERO};

		private Integer value;

		public Flag() {
		}

		public Flag(Integer value) {
			this.value = value;
		}

		public Integer getValue() {
			return this.value;
		}

		public void setValue(Integer value) {
			this.value=value;
		}

		public static int size() {
			return items.length;
		}

		protected static Flag item(Integer v) {
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
			/*
			if (!(obj instanceof Flag)) return false;
			Flag f2 = (Flag) obj;
			Integer v2 = f2.value;
			return (value == null) ? ((v2 == null) ? true : false) : value.equals(v2);
			*/
			return (value == null) ? ((obj == null) ? true : false) : value.equals(obj);
		}
	}

	/**
	 * 固定类别：工资项目[WG]、社保项目[SG]、福利项目[WF]、代扣项目[DK]、对消项目[平帐项目PZ]
	 * @author hsun
	 *
	 */
	public final static class Type {

		public final static Type WG = new Type("WG");
		public final static Type SG = new Type("SG");
		public final static Type WF = new Type("WF");
		public final static Type DK = new Type("DK");
		public final static Type PZ = new Type("PZ");

		public final static Type[] items = new Type[] {WG, SG, WF, DK, PZ};

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
			/*
			if (!(obj instanceof Type)) return false;
			Type t2 = (Type) obj;
			String v2 = t2.value;
			return (value == null) ? ((v2 == null) ? true : false) : value.equals(v2);
			*/
			return (value == null) ? ((obj == null) ? true : false) : value.equals(obj);
		}
	}

}
