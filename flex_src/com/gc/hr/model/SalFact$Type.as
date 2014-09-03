package com.gc.hr.model
{
  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;

  [RemoteClass(alias="com.gc.hr.po.SalFact$Type")]
  [Bindable]
  public dynamic class SalFact$Type
  {
    public static const CASH:SalFact$Type=new SalFact$Type("C", "cash");
    public static const TRANS:SalFact$Type=new SalFact$Type("T", "trans");
    public static const GOODS:SalFact$Type=new SalFact$Type("G", "goods");
    public static const types:Array=[CASH, TRANS, GOODS];

    public var value:String;
    public var name:String;

    public function SalFact$Type(value:String=null, name:String=null)
    {
      this.value=value;
      this.name=name;
    }

    private static var RESOURCE_MANAGER:IResourceManager=null;

    private static function getString(bundle:String, code:String):String
    {
      if (RESOURCE_MANAGER == null)
      {
        RESOURCE_MANAGER=ResourceManager.getInstance();
        RESOURCE_MANAGER.localeChain=["zh_CN"];
      }
      return RESOURCE_MANAGER.getString(bundle, code);
    }

    public function get label():String
    {
      return getString("gcc_hr", "salFact.type." + name);
    }

    public function toString():String
    {
      return "SalFact$Type{value=" + value + ", name=" + name + "}";
    }

    public function valueOf():Object
    {
      return value;
    }

    public static function size():int
    {
      return types.length;
    }

    public static function item(v:String):SalFact$Type
    {
      for each (var type:SalFact$Type in types)
      {
        if (type.value == v)
          return type;
      }
      return null;
    }
  }

}
