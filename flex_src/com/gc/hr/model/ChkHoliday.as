package com.gc.hr.model
{
  import com.gc.Constants;
  import com.gc.common.model.Branch;

  [RemoteClass(alias="com.gc.hr.po.ChkHoliday")]
  [Bindable]
  public dynamic class ChkHoliday
  {
    public var id:int;
    public var branch:Branch;
    public var no:String;
    public var name:String;
    public var comment:String;

    public function ChkHoliday(branch:Branch=null, id:int=0, name:String=null)
    {
      this.branch=branch;
      this.id=id;
      this.name=name;
    }

    public function get branchId():int
    {
      return branch ? branch.id : 0;
    }

    public function get label():String
    {
      return name ? name : Constants.NULL_LABEL;
    }

    public function get value():Object
    {
      return no ? no : Constants.NULL_VALUE;
    }

    public static const color:uint=Constants.Black;

    public function get color():uint
    {
      return ChkHoliday.color;
    }

    public static const bgColor:uint=0xCCCCFF;

    public function get bgColor():uint
    {
      return ChkHoliday.bgColor;
    }

    public static function get ICON():Class
    {
      return $Icon;
    }

    [Exclude(name="icon", kind="property")]
    public function get icon():Class
    {
      return $Icon;
    }

    public function toString():String
    {
      return "CheckHoliday{id=" + id + ", belong=" + branchId + ", name=" + name + "}";
    }

  }
}

import com.gc.controls.RectangleIcon;
import com.gc.hr.model.ChkHoliday;

class $Icon extends com.gc.controls.RectangleIcon
{
  public function $Icon():void
  {
    color=ChkHoliday.bgColor;
  }
}
