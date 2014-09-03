package com.gc.hr.model
{
  import com.gc.Constants;
  import com.gc.common.model.Branch;
  import com.gc.common.model.Department;
  import com.gc.common.model.Person;
  import com.gc.util.DateUtil;

  [RemoteClass(alias="com.gc.hr.po.ChkFact")]
  [Bindable]
  public dynamic class ChkFact
  {
    public var id:ChkFactPK;
    public var date:Date;
    public var depart:Department;
    public var office:String;
    public var checker:Person;
    public var checkDate:Date;
    public var comment:String;

    public function ChkFact(branch:Branch=null, no:String=null)
    {
      this.id=new ChkFactPK(branch, no);
    }

    public function get branch():Branch
    {
      return id ? id.branch : null;
    }

    public function get branchId():int
    {
      return id ? id.branchId : 0;
    }

    public function get no():String
    {
      return id ? id.no : null;
    }

    public function get departId():int
    {
      return depart ? depart.id : 0;
    }

    public function get label():String
    {
      return id ? id.label : Constants.NULL_LABEL;
    }

    public function get value():Object
    {
      return id ? id.value : Constants.NULL_VALUE;
    }

    public function get icon():Class
    {
      return null;
    }

    public function toString():String
    {
      // return "ChkFact{id=" + id + ", date=" + DateUtil.formatDateTime(date) + "}";
      return "ChkFact{belong=" + branchId + ", no=" + no + ", depart=" + departId + ", date=" + DateUtil.formatDateTime(date) + "}";
    }

  }
}