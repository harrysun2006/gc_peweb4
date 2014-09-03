package com.gc.hr.model
{

  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;

  [RemoteClass(alias="com.gc.hr.po.SalItem$Type")]
  [Bindable]
  public dynamic class SalItem$Type
  {
    public static const WG:SalItem$Type=new SalItem$Type("WG", "wg");
    public static const SG:SalItem$Type=new SalItem$Type("SG", "sg");
    public static const WF:SalItem$Type=new SalItem$Type("WF", "wf");
    public static const DK:SalItem$Type=new SalItem$Type("DK", "dk");
    public static const PZ:SalItem$Type=new SalItem$Type("PZ", "pz");
    public static const types:Array=[WG, SG, WF, DK, PZ];

    public var value:String;
    public var name:String;

    public function SalItem$Type(value:String=null, name:String=null)
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
      return getString("gcc_hr", "salItem.type." + name);
    }

    public function toString():String
    {
      return "SalItem$Type{value=" + value + ", name=" + name + "}";
    }

    public function valueOf():Object
    {
      return value;
    }

    public static function size():int
    {
      return types.length;
    }

    public static function item(v:String):SalItem$Type
    {
      for each (var type:SalItem$Type in types)
      {
        if (type.value == v)
          return type;
      }
      return null;
    }

  }

}
