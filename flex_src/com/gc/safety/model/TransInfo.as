package com.gc.safety.model
{
  import com.gc.common.model.Branch;
  import com.gc.common.model.Equipment;
  import com.gc.common.model.Person;
  import com.gc.util.CommonUtil;

  import mx.utils.ObjectProxy;

  [RemoteClass(alias="com.gc.safety.po.TransInfo")]
  [Bindable]
  public dynamic class TransInfo
  {
    public var id:TransInfoPK;
    public var inputDate:Date;
    public var inputer:Person;
    public var transDate:Date;
    public var bus:Equipment;
    public var driver:Person;
    public var transType:TransType;
    public var upFee:Number;
    public var code:String;
    public var point:String;
    public var penalty:Number=0;
    public var doDate:Date;

    public static const qo:Object=new ObjectProxy();

    public function TransInfo(branch:Branch=null, accno:String=null, no:int=0)
    {
      this.id = new TransInfoPK(branch, accno, no);
    }

    public static function init():void
    {
      CommonUtil.empty(qo);
    }

  }
}