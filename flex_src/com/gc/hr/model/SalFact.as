package com.gc.hr.model
{
  import com.gc.common.model.Branch;
  import com.gc.common.model.Department;
  import com.gc.common.model.Person;

  [RemoteClass(alias="com.gc.hr.po.SalFact")]
  [Bindable]
  public dynamic class SalFact
  {
    public var id:SalFactPK
    public var depart:Department;
    public var date:Date;
    public var issueDate:Date;
    private var _issueType:SalFact$Type;
    public var summary:String;
    public var issuer:Person;
    public var comment:String;

    public function SalFact(branch:Branch=null, no:String=null)
    {
      this.id=new SalFactPK(branch, no);
    }

    public function get uid():String
    {
      return "sf#" + no;
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

    public function get departName():String
    {
      return depart ? depart.name : null;
    }

    public function get issuerId():int
    {
      return issuer ? issuer.id : 0;
    }

    public function get issuerName():String
    {
      return issuer ? issuer.name : null;
    }

    public function get issueTypeValue():String
    {
      return _issueType ? _issueType.value : null;
    }

    public function set issueTypeValue(value:String):void
    {
    }

    public function get issueType():SalFact$Type
    {
      return _issueType;
    }

    public function set issueType(value:SalFact$Type):void
    {
      _issueType=value ? SalFact$Type.item(value.value) : null;
    }

    public function toString():String
    {
      return "SalFact{belong=" + branchId + ", no=" + no + ", depart=" + departId + "}";
    }

  }

}