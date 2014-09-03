package com.gc.hr.model
{

  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;

  [RemoteClass(alias="com.gc.hr.po.SalItem$Flag")]
  [Bindable]
  public dynamic class SalItem$Flag
  {
    public static const POS:SalItem$Flag=new SalItem$Flag(1, "pos");
    public static const NEG:SalItem$Flag=new SalItem$Flag(-1, "neg");
    public static const ZERO:SalItem$Flag=new SalItem$Flag(0, "zero");
    public static const flags:Array=[POS, NEG, ZERO];

    public var value:int;
    public var name:String;

    public function SalItem$Flag(value:int=0, name:String=null)
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
      return getString("gcc_hr", "salItem.flag." + name);
    }

    public function toString():String
    {
      return "SalItem$Flag{value=" + value + ", name=" + name + "}";
    }

    public function valueOf():Object
    {
      return value;
    }

    public static function size():int
    {
      return flags.length;
    }

    public static function item(v:int):SalItem$Flag
    {
      for each (var flag:SalItem$Flag in flags)
      {
        if (flag.value == v)
          return flag;
      }
      return null;
    }
  }

}
