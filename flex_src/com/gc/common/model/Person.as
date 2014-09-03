package com.gc.common.model
{
  import com.gc.Constants;
  import com.gc.common.controller.UserController;
  import com.gc.hr.controller.PersonalController;
  import com.gc.hr.model.ChkGroup;
  import com.gc.util.CommonUtil;
  import com.gc.util.DateUtil;

  import flash.utils.ByteArray;

  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;
  import mx.utils.ObjectProxy;

  [RemoteClass(alias="com.gc.common.po.Person")]
  [Bindable]
  public dynamic class Person
  {
    public var id:int;
    public var branch:Branch;
    public var workerId:String;
    public var name:String;
    public var pid:String;
    public var sex:String;
    public var people:String;
    public var nativePlace:String;
    public var regAddress:String;
    public var birthday:Date;
    public var marryStatus:String;
    public var annuities:String;
    public var accumulation:String;
    public var onDate:Date;
    public var status:int;
    public var downDate:Date;
    public var downReason:String;
    public var upgradeDate:Date;
    public var upgradeReason:String;
    public var type:String;
    // 当前岗位或工种类别, 保留编码: 1：驾驶员，2：乘务员，3：调度员，4：管理人员， 5：维修工，6：其他人员
    private var _position:String;
    private var _fkPosition:Position;
    public var regBelong:String;
    public var party:String;
    public var grade:String;
    public var schooling:String;
    public var allotDate:Date;
    public var allotReason:String;
    public var depart:Department;
    public var office:String;
    public var line:Line;
    public var bus:Equipment;
    public var cert2No:String;
    public var cert2NoHex:String;
    public var fillTableDate:Date;
    public var commend:String;
    public var workDate:Date;
    public var retireDate:Date;
    public var serviceLength:String;
    public var inDate:Date;
    public var outDate:Date;
    public var workLength:String;
    public var groupNo:String;
    public var contractNo:String;
    public var contr1From:Date;
    public var contr1End:Date;
    public var contractReason:String;
    public var contr2From:Date;
    public var contr2End:Date;
    public var workType:String;
    public var level:int;
    public var techLevel:String;
    public var responsibility:String;
    public var cert1No:String;
    public var cert1NoDate:Date;
    public var serviceNo:String;
    public var serviceNoDate:Date;
    public var frontWorkResume:String;
    public var frontTrainingResume:String;
    public var specification:String;
    public var degree:String;
    public var graduate:String;
    public var skill:String;
    public var lanCom:String;
    public var national:String;
    public var state:String;
    public var city:String;
    public var address:String;
    public var zip:String;
    public var telephone:String;
    public var email:String;
    public var officeTel:String;
    public var officeExt:String;
    public var officeFax:String;
    public var lastModifier:Person;
    public var comment:String;
    public var psnPhoto:PsnPhoto;
    public var photo:ByteArray;
    public var chkGroup:ChkGroup;
    public var chkLongPlans:ArrayCollection;
    public var chkPlanDs:ArrayCollection;
    public var chkFactDs:ArrayCollection;

    // other non-serialized properties
    public var newCert2No:String;
    public var newCert2NoHex:String;

    // other calculated properties
    public var graduateDate:Date;
    public var partyOnDate:Date;

    // 绑定DataGrid里的CheckBox,缺少该量导致点击全选后不能马上显示
    // 可能可以用其他方法处理 override等
    public var selected:Boolean;

    // 全局公用变量
    public static const DEFAULT_SEARCH:Object=new ObjectProxy();
    public static const qo:Object=new ObjectProxy();
    public static const DOWN_STATUS:String="#downStatus";
    public static const DOWN_STATUS_YES:String="yes";
    public static const DOWN_STATUS_NO:String="no";
    public static const DOWN_STATUS_NULL:String="null";

    public static const POSITION_DRIVER:String="1";
    public static const POSITION_CONDUCTOR:String="2";
    public static const POSITION_DISPATCHER:String="3";

    public function Person(id:int=0, workerId:String=null, name:String=null)
    {
      this.id=id;
      this.workerId=workerId;
      this.name=name;
    }

    public function get uid():String
    {
      return "p#"+id;
    }

    public function get branchId():int
    {
      return branch ? branch.id : 0;
    }

    public function get departId():int
    {
      return depart ? depart.id : 0;
    }

    public function get lineId():int
    {
      return line ? line.id : 0;
    }

    public function get busId():int
    {
      return bus ? bus.id : 0;
    }

    public function get isDown():Boolean
    {
      return downDate < Constants.MAX_DATE;
    }

    public function get isOn():Boolean
    {
      return downDate >= Constants.MAX_DATE;
    }

    /**
     * 定义只读属性label, 对应于一般控件(Tree)的labelField(显示文本)
     **/
    public function get label():String
    {
      return workerId + "[" + name + "]";
    }

    public function get value():Object
    {
      return id;
    }

    [Embed(source="assets/icons/16x16/person.png")]
    public static const ICON:Class;

    public function get icon():Class
    {
      return ICON;
    }

    public function toString():String
    {
      return "Person{id=" + id + ", workerId=" + workerId + ", belong=" + branchId + ", name=" + name + "}";
    }

    public function get position():String
    {
      return _position;
    }

    public function set position(s:String):void
    {
      this._position=s;
      dispatchEvent(new Event("positionChanged"));
    }

    public function get fkPosition():Position
    {
      return _fkPosition;
    }

    public function set fkPosition(p:Position):void
    {
      this._fkPosition=p;
      this.position=p ? p.no : null;
    }

    [Bindable("positionChanged")]
    public function get driverCardNo():String
    {
      return (position == POSITION_DRIVER) ? serviceNo : "";
    }

    [Bindable("positionChanged")]
    public function get conductorCardNo():String
    {
      return (position == POSITION_CONDUCTOR) ? serviceNo : "";
    }

    [Bindable("positionChanged")]
    public function get dispatcherCardNo():String
    {
      return (position == POSITION_DISPATCHER) ? serviceNo : "";
    }

    public static function init():void
    {
      CommonUtil.empty(qo);
      qo[DOWN_STATUS]=DEFAULT_SEARCH[DOWN_STATUS]=DOWN_STATUS_NO;
      // CommonUtil.copyProperties(Person.DEFAULT_SEARCH, Person.qo);
    }

    public static function getSearch(qo:Object=null, orders:Array=null):Object
    {
      var type:String;
      var value:Object;
      var date:Date;
      if (qo == null)
        qo=Person.qo;
      var status:Object=qo[Person.DOWN_STATUS];
      qo=CommonUtil.clear(qo);
      for each (var node:Object in orders)
      {
        if (node is Date)
          date=node as Date;
        else
          value=node[Constants.PROP_NAME_VALUE];
        type=node[Constants.PROP_NAME_TYPE];
        switch (type)
        {
          case Constants.TYPE_ROOT:
          case Constants.TYPE_UNKNOWN:
            continue;
            break;
          case "birthday":
          case "contr1End":
          case "workDate":
          case "inDate":
            if (date.fullYear == 0)
              qo[type]=new Date(0);
            else
            {
              qo[type + "_from"]=DateUtil.getBeginYear(date, Constants.INTERVAL_YEARS);
              qo[type + "_to"]=DateUtil.getEndYear(date, Constants.INTERVAL_YEARS);
            }
            break;
          default:
            // CommonUtil.setValue(qo, type, value);
            qo[type]=value;
            break;
        }
      }
      if (status == null || status == "" || status.toLowerCase() == Person.DOWN_STATUS_NULL)
      {
        qo["downDate_from"]=null;
        qo["downDate_to"]=null;
      }
      else if (status.toLowerCase() == Person.DOWN_STATUS_YES)
      {
        var d:Date=Constants.MAX_DATE;
        d.setMilliseconds(d.getMilliseconds() - 1);
        qo["downDate_from"]=null;
        qo["downDate_to"]=d;
      }
      else if (status.toLowerCase() == Person.DOWN_STATUS_NO)
      {
        qo["downDate_from"]=Constants.MAX_DATE;
        qo["downDate_to"]=null;
      }
      qo.setPropertyIsEnumerable("downDate_from", qo["downDate_from"]!=null);
      qo.setPropertyIsEnumerable("downDate_to", qo["downDate_to"]!=null);
      return qo;
    }

    private static var _ALL:ArrayCollection=null;
    private static var _ALL_MAP:Object=new Object();

    public static function indexOfAll(obj:Object):int
    {
      return obj is Person && _ALL_MAP.hasOwnProperty(obj.id) ? int(_ALL_MAP[obj.id]) : -1;
    }

    public static function get ALL():ArrayCollection
    {
      if (!_ALL)
      {
        _ALL=new ArrayCollection();
        PersonalController.getPersons(UserController.limit, {}, ["workerId"], function(e:ResultEvent):void
          {
            var i:int=0;
            for each(var p:Person in e.result)
            {
              _ALL.addItem(p);
              _ALL_MAP[p.id]=i++;
            }
          });
      }
      return _ALL;
    }
  }
}