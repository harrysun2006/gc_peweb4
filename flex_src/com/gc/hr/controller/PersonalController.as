package com.gc.hr.controller
{
  import com.gc.Beans;
  import com.gc.CommonEvent;
  import com.gc.common.model.Person;
  import com.gc.common.model.SecurityLimit;
  import com.gc.hr.model.*;
  import com.gc.util.CommonUtil;
  import com.gc.util.FaultUtil;

  import flash.utils.getQualifiedClassName;

  import mx.collections.ArrayCollection;
  import mx.controls.Alert;
  import mx.rpc.AsyncToken;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.remoting.RemoteObject;

  import org.swizframework.Swiz;

  public class PersonalController
  {
    private static var _service:RemoteObject;

    [Bindable]
    public static var personList:ArrayCollection;

    [Bindable]
    public static var hireTypeList:ArrayCollection;
    [Bindable]
    public static var jobGradeList:ArrayCollection;
    [Bindable]
    public static var jobSpecList:ArrayCollection;
    [Bindable]
    public static var marryStatusList:ArrayCollection;
    [Bindable]
    public static var nativePlaceList:ArrayCollection;
    [Bindable]
    public static var peopleList:ArrayCollection;
    [Bindable]
    public static var polPartyList:ArrayCollection;
    [Bindable]
    public static var regBranchList:ArrayCollection;
    [Bindable]
    public static var schDegreeList:ArrayCollection;
    [Bindable]
    public static var schGraduateList:ArrayCollection;
    [Bindable]
    public static var schoolingList:ArrayCollection;
    [Bindable]
    public static var positionList:ArrayCollection;
    [Bindable]
    public static var workTypeList:ArrayCollection;

    [Bindable]
    public static var driverList:ArrayCollection;
    [Bindable]
    public static var driverOnlineList:ArrayCollection;
    [Bindable]
    public static var psnOnlineList:ArrayCollection;

    public static const ALL_PERSON_ORDER_COLUMNS:Array=["type", "depart.id", "office", "party", "position",
      "schooling", "grade", "regBelong", "birthday", "workLength", "serviceLength", "contr1End", "workDate",
      "inDate", "sex"];
    public static const DEFAULT_PERSON_ORDER_COLUMNS:Array=["depart.id"];

    public static const ALL_LISTNAMES:Array=["hireTypeList", "jobGradeList", "jobSpecList", "marryStatusList", "nativePlaceList",
      "peopleList", "polPartyList", "regBranchList", "schDegreeList", "schGraduateList", "workTypeList",
      "schoolingList", "positionList", "driverList", "driverOnlineList"];
    public static const PERSONAL_LISTNAMES:Array=["hireTypeList", "jobGradeList", "jobSpecList", "marryStatusList", "nativePlaceList",
      "peopleList", "polPartyList", "regBranchList", "schDegreeList", "schGraduateList", "workTypeList",
      "schoolingList", "positionList"];

    public function PersonalController()
    {
    }

    protected static function get service():RemoteObject
    {
      if (_service == null)
      {
        _service=Swiz.getBean(Beans.SERVICE_HR_PERSONAL) as RemoteObject;
      }
      return _service;
    }

    protected static function exec(call:AsyncToken, resultHandler:Function, faultHandler:Function=null, eventArgs:Array=null):void
    {
      Swiz.executeServiceCall(call, resultHandler, faultHandler, eventArgs);
    }

    public static function getFaultHandler(handler:Function):Function
    {
      return FaultUtil.getGenericFaultHandler(service, handler);
    }

    public static function preloadLists(branchId:int, names:Array=null, force:Boolean=false):void
    {
      if (names == null)
        names = ALL_LISTNAMES;
      if ((hireTypeList == null || force) && names.indexOf("hireTypeList") >= 0)
        getHireTypes(branchId);
      if ((jobGradeList == null || force) && names.indexOf("jobGradeList") >= 0)
        getJobGrades(branchId);
      if ((jobSpecList == null || force) && names.indexOf("jobSpecList") >= 0)
        getJobSpecs(branchId);
      if ((marryStatusList == null || force) && names.indexOf("marryStatusList") >= 0)
        getMarryStatusList(branchId);
      if ((nativePlaceList == null || force) && names.indexOf("nativePlaceList") >= 0)
        getNativePlaces(branchId);
      if ((peopleList == null || force) && names.indexOf("peopleList") >= 0)
        getPeoples(branchId);
      if ((polPartyList == null || force) && names.indexOf("polPartyList") >= 0)
        getPolParties(branchId);
      if ((regBranchList == null || force) && names.indexOf("regBranchList") >= 0)
        getRegBranches(branchId);
      if ((schDegreeList == null || force) && names.indexOf("schDegreeList") >= 0)
        getSchDegrees(branchId);
      if ((schGraduateList == null || force) && names.indexOf("schGraduateList") >= 0)
        getSchGraduates(branchId);
      if ((schoolingList == null || force) && names.indexOf("schoolingList") >= 0)
        getSchoolings(branchId);
      if ((workTypeList == null || force) && names.indexOf("workTypeList") >= 0)
        getWorkTypes(branchId);
      if ((positionList == null || force) && names.indexOf("positionList") >= 0)
        getPositions(branchId);
      if ((driverList == null || force) && names.indexOf("driverList") >= 0)
        getDrivers(branchId,null);
      if ((driverOnlineList == null || force) && names.indexOf("driverOnlineList") >= 0)
        getDriverOnlines(branchId,0);
    }

//==================================== Person ====================================

    public static function getAllPersons(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getAllPersons(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          personList = e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        },  FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPerson(id:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPerson(id), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function addPersons(persons:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.addPersons(persons), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function allotPersonsDepart(persons:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.allotPersonsDepart(persons), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function allotPersonsLine(persons:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.allotPersonsLine(persons), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function downPersons(persons:Array, po:Person, successHandler:Function=null, faultHandler:Function=null):void
    {
      var ids:Array=CommonUtil.getSubArray(persons, ["id"]);
      exec(service.downPersons(ids, po, true), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPersonByCert2(cert2No:String, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPersonByCert2(cert2No), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPersons(limit:SecurityLimit, qo:Object, orderColumns:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPersons(limit, qo, orderColumns), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPersonStats(limit:SecurityLimit, qo:Person, orderColumns:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPersonStats(limit, qo, orderColumns), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function updatePersonsCert2(persons:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.updatePersonsCert2(persons), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function updatePersonsInfo(persons:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.updatePersonsInfo(persons), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function updatePersonsStatus(persons:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.updatePersonsStatus(persons), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function undownPersons(persons:Array, po:Person, successHandler:Function=null, faultHandler:Function=null):void
    {
      var ids:Array=CommonUtil.getSubArray(persons, ["id"]);
      exec(service.downPersons(ids, po, false), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPersonsByIds(ids:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPersons(ids), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPersonsByBranchId(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPersonsByBranchId(branchId), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPersonsCard(ids:Array, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPersonsCard(ids), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getDriverOnlines(branchId:int, departId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getDriverOnlines(branchId, departId), function(e:ResultEvent, arg:Object=null):void
        {
          driverOnlineList = e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    //违章取当前机构的驾驶员调动历史,其中车可以为空
    public static function getDriverOnlines2(branchId:int, departId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getDriverOnlines2(branchId,departId), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getDrivers(branchId:int, date:Date, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getDrivers(branchId, date), function(e:ResultEvent, arg:Object=null):void
        {
          driverList = e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPsnStatusList(obj:Object, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPsnStatusList(obj), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPsnOnlineList(obj:Object, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPsnOnlineList(obj), CommonEvent.DEFAULT_RESULT_EVENT_HANDLER, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    public static function getPsnOnlines(branchId:int, accDate:Date, departId:int,successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPsnOnlines(branchId, accDate, departId), function(e:ResultEvent, arg:Object=null):void
        {
          psnOnlineList = e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

//==================================== T_PSN_XXX ====================================

    /**
     * People
     */
    public static function getPeoples(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPeoples(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          peopleList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * HireType
     */
    public static function getHireTypes(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getHireTypes(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          hireTypeList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * JobGrade
     **/
    public static function getJobGrades(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getJobGrades(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          jobGradeList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * JobSpec
     **/
    public static function getJobSpecs(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getJobSpecs(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          jobSpecList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * MarryStatus
     **/
    public static function getMarryStatusList(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getMarryStatusList(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          marryStatusList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * NativePlace
     **/
    public static function getNativePlaces(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getNativePlaces(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          nativePlaceList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * PolParty
     **/
    public static function getPolParties(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPolParties(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          polPartyList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }
        , FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * RegBranch
     **/
    public static function getRegBranches(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getRegBranches(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          regBranchList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * SchDegree
     **/
    public static function getSchDegrees(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getSchDegrees(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          schDegreeList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * SchGraduate
     **/
    public static function getSchGraduates(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getSchGraduates(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          schGraduateList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * Schooling
     **/
    public static function getSchoolings(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getSchoolings(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          schoolingList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

    /**
     * WorkType
     */
    public static function getWorkTypes(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getWorkTypes(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          workTypeList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

//==================================== Position ====================================

    public static function getPositions(branchId:int, successHandler:Function=null, faultHandler:Function=null):void
    {
      exec(service.getPositions(branchId), function(e:ResultEvent, arg:Object=null):void
        {
          positionList=e.result as ArrayCollection;
          if (arg is Function)
            arg(e);
        }, FaultUtil.getGenericFaultHandler(service, faultHandler), [successHandler]);
    }

  }
}