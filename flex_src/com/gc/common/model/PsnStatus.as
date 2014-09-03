package com.gc.common.model
{
  import com.gc.common.model.Branch;
  import com.gc.common.model.Person;
  import com.gc.common.model.Position;

  [RemoteClass(alias="com.gc.common.po.PsnStatus")]
  [Bindable]
  public dynamic class PsnStatus
  {
    public var id:int;
    public var branch:Branch;
    public var person:Person;
    public var onDate:Date;
    public var upgradeReason:String;
    public var type:String;
    public var position:String;
    public var fkPosition:Position;
    public var workType:String;
    public var regBelong:String;
    public var party:String;
    public var grade:String;
    public var schooling:String;
    public var downDate:Date;
    public var upgrader:Person;

    public function PsnStatus()
    {
    }

    public function get personId():int
    {
      return person ? person.id : 0;
    }
  }
}