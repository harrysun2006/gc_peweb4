package com.gc.hr.model
{
  import bee.eval.Ident;
  import bee.eval.ParseError;
  import bee.eval.Util;
  import bee.eval.ast.CallExpression;

  import com.gc.Constants;
  import com.gc.common.model.Branch;
  import com.gc.hr.controller.SalaryController;
  import com.gc.util.ExprUtil;

  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;

  [RemoteClass(alias="com.gc.hr.po.SalItem")]
  [Bindable]
  public dynamic class SalItem
  {
    public var id:int;
    public var branch:Branch;
    public var no:String;
    public var name:String;
    public var onDate:Date;
    public var downDate:Date;
    public var accountDebit:String;
    public var accountCredit:String;
    private var _flag:SalItem$Flag;
    private var _type:SalItem$Type;
    public var print:String;
    public var formula:String;

    public function SalItem()
    {
      onDate=Constants.MIN_DATE;
      downDate=Constants.MAX_DATE;
      print="0";
      flag=SalItem$Flag.POS;
      // type=SalItem$Type.WG;
    }

    public function get uid1():String
    {
      return "si#" + id;
    }

    public function get branchId():int
    {
      return branch ? branch.id : 0;
    }

    public function get flagValue():int
    {
      return _flag ? _flag.value : 0;
    }

    public function set flagValue(value:int):void
    {
    }

    public function get flag():SalItem$Flag
    {
      return _flag;
    }

    public function set flag(value:SalItem$Flag):void
    {
      _flag=value ? SalItem$Flag.item(value.value) : null;
    }

    public function get typeValue():String
    {
      return _type ? _type.value : null;
    }

    public function set typeValue(value:String):void
    {
    }

    public function get type():SalItem$Type
    {
      return _type;
    }

    public function set type(value:SalItem$Type):void
    {
      _type=value ? SalItem$Type.item(value.value) : null;
    }

    private static var RESOURCE_MANAGER:IResourceManager=null;

    private static function getString(bundle:String, code:String, params:Array=null):String
    {
      if (RESOURCE_MANAGER == null)
      {
        RESOURCE_MANAGER=ResourceManager.getInstance();
        RESOURCE_MANAGER.localeChain=["zh_CN"];
      }
      return RESOURCE_MANAGER.getString(bundle, code, params);
    }

    public static const STATUS_ENABLE:Object={value:true, label:getString("gcc", "enable")};
    public static const STATUS_DISABLE:Object={value:false, label:getString("gcc", "disable")};
    public static const STATUS_LIST:Array=[STATUS_ENABLE, STATUS_DISABLE];

    public function get status():Object
    {
      var value:Boolean=(downDate >= Constants.MAX_DATE);
      return value ? STATUS_ENABLE : STATUS_DISABLE;
    }

    public function set status(value:Object):void
    {
      if (value && value.value)
      {
        downDate=Constants.MAX_DATE;
      }
      else
      {
        var today:Date=new Date();
        downDate=new Date(today.fullYear, today.month, today.date+1);
      }
    }

    public static const PRINT_VIEW:Object={value:"0", label:getString("gcc_hr", "salItem.print.view")};
    public static const PRINT_PRINT:Object={value:"1", label:getString("gcc_hr", "salItem.print.view&print")};
    public static const PRINT_LIST:Array=[PRINT_VIEW, PRINT_PRINT];

    public function get print$():Object
    {
      return print == "1" ? PRINT_PRINT : PRINT_VIEW;
    }

    public function set print$(value:Object):void
    {
      print=value && value.value ? value.value : print;
    }

    public function toString():String
    {
      return "SalItem{id=" + id + ", belong=" + branchId + ", name=" + name + "}";
    }

    private static var _map:Object=null;

    private static function get map():Object
    {
      if (!_map)
      {
        _map=new Object();
        var si:SalItem;
        for each (si in SalaryController.salItemList)
          _map[si.no]=si;
      }
      return _map;
    }

    public static function refresh():void
    {
      _map=null;
    }

    private static function getItemByNo(no:String):SalItem
    {
      return map[no];
    }

    public static function getNameByNo(no:String):String
    {
      return map[no] ? map[no].name : "";
    }

// -------------------------------- Validate & Evaluate --------------------------------

    private static const xx_avg:Function=function(obj:Object, id:Ident):void
      {
        var call:CallExpression;
        var f1:Function=function(id:Ident):Boolean{return id && xxId(id.id);};
        var f2:Function=function(id:Ident):Boolean{return id && id.isV;};
        for each (call in id.calls)
        {
          if (!call.args || call.args.length != 2) obj.error=getString("gcc_hr", "salItem.formula.error.function.args.length", [obj.id, obj.expr, id.id, 2, call.args ? call.args.length : 0]);
          // else if (id.count > 1)
          //  obj.error=getString("gcc_hr", "salItem.formula.error.avg.count.gt1", [obj.id, obj.expr, id.id]);
          else if (!f1(call.args[0].id)) obj.error=getString("gcc_hr", "salItem.formula.error.function.args.type1", [obj.id, obj.expr, id.id, 1]);
          else if (!f2(call.args[1].id)) obj.error=getString("gcc_hr", "salItem.formula.error.function.args.type2", [obj.id, obj.expr, id.id, 2]);
          if (obj.error) return;
        }
      };
    private static const XX_FUNCS:Object={avg:xx_avg};

    public static function xxFunc(f:String):Boolean
    {
      return XX_FUNCS[f];
    }

    public static function xxId(id:String):Boolean
    {
      var reg:RegExp=/xx\d{3}/ig;
      return reg.test(id);
    }

    public static const EVALF_ITEMS:Function=function(obj:Object):Boolean
      {
        if (obj.miss && obj.miss.length > 0)
        {
          var n:String, s:String="", id:Ident;
          for each (n in obj.miss) 
          {
            id=obj.dep[n];
            if (id.isV) s+=n+"("+getNameByNo(n)+"), ";
          }
          if (s.length > 0) obj.error=getString("gcc_hr", "salTemplate.error.missing.items", [getNameByNo(obj.id), obj.expr, s.substr(0, s.length-2)]);
        }
        return false;
      };

    // 判断xx项目及avg之类的函数的合法性
    private static const EVALF_XX:Function=function(obj:Object):Boolean
      {
        var n:String, id1:Ident;
        for (n in obj.dep)
        {
          id1=obj.dep[n];
          if (XX_FUNCS[n])
          {
            XX_FUNCS[n](obj, id1);
          }
          else if (xxId(n))
          {
            if (!obj.sylla.xx) obj.sylla.xx={};
            if (id1.count > 1) obj.error=getString("gcc_hr", "salItem.formula.error.xx1", [obj.id, obj.expr, n]);
            else if (obj.sylla.xx[n]) obj.error=getString("gcc_hr", "salItem.formula.error.xx2", [obj.id, obj.expr, n]);
            else obj.sylla.xx[n]=true;
          }
        }
        return false;
      }

    // 针对工资项目公式的错误提示
    private static const EVALF_GENERAL:Function=function(obj:Object):Boolean
      {
        var n:String, s1:String="", s2:String="", id:Ident;
        if (obj.eobj is ParseError)
        {
          if (obj.eid == ParseError.NOT_FUNCTION) obj.error=getString("gcc_hr", "salItem.formula.error.not.function", [obj.id, obj.expr, obj.edata]);
          else if (obj.eid == ParseError.UNEXPECTED_TOKEN) obj.error=getString("gcc_hr", "salItem.formula.error.unexpected.token", [obj.id, obj.expr, obj.edata]);
          else if (obj.eid == ParseError.MISSING_TOKEN_RIGHTPAR) obj.error=getString("gcc_hr", "salItem.formula.error.missing.token.rightpar", [obj.id, obj.expr]);
          else if (obj.eid == ParseError.MISSING_TOKEN_LEFTPAR) obj.error=getString("gcc_hr", "salItem.formula.error.missing.token.leftpar", [obj.id, obj.expr]);
        }
        else if (obj.eobj is Error)
        {
          obj.error=getString("gcc_hr", "salItem.formula.error.general", [obj.id, obj.expr, obj.edata]);
        }
        else
        {
          if (obj.eid == Util.ERROR_WRONG_IDS)
          {
            for each (id in obj.edata) s1+=id.id+", ";
            if (s1.length > 0) obj.error=getString("gcc_hr", "salItem.formula.error.wrong.ids", [obj.id, obj.expr, s1.substr(0, s1.length-2)]);
          }
          else if (obj.eid == Util.ERROR_RECURSIVE) obj.error=getString("gcc_hr", "salItem.formula.error.recursive", [obj.id, obj.expr]);

          else if (obj.eid == Util.ERROR_INVALID_EXPRS) obj.error=getString("gcc_hr", "salItem.formula.error.invalid");
          else if (obj.eid == Util.ERROR_NOT_DEFINED) obj.error=getString("gcc_hr", "salItem.formula.error.not.defined", [obj.id]);
          else if (obj.eid == Util.ERROR_NOT_NUMBER) obj.error=getString("gcc_hr", "salItem.formula.error.not.number", [obj.id]);
          else if (obj.eid == Util.ERROR_DIVIDE_ZERO) obj.error=getString("gcc_hr", "salItem.formula.error.divide.zero", [obj.id, obj.expr]);
        }
        if (obj.miss && obj.miss.length > 0)
        {
          for each (n in obj.miss) 
          {
            id=obj.dep[n];
            if (id && id.isF) s2+=n+", ";
            else s1+=n+", ";
          }
          if (s1.length > 0) obj.error=getString("gcc_hr", "salItem.formula.error.missing.vars", [obj.id, obj.expr, s1.substr(0, s1.length-2)]);
          else if (s2.length > 0) obj.error=getString("gcc_hr", "salItem.formula.error.missing.funcs", [obj.id, obj.expr, s2.substr(0, s2.length-2)]);
        }
        return false;
      };

    private static const EVAL_EXPRS:Object={
      // constants defined in Math: E=1+1/1!+1/2!+1/3!+1/4!+...+1/n!
        _E:Math.E, _LN10:Math.LN10, _LN2:Math.LN2, _LOG10E:Math.LOG10E, _LOG2E:Math.LOG2E, 
        _PI:Math.PI, _SQRT2R:Math.SQRT1_2, _SQRT2:Math.SQRT2, 
        // functions defined in Math
        _abs:Math.abs, _acos:Math.acos, _asin:Math.asin, _atan:Math.atan, _atan2:Math.atan2, 
        _ceil:Math.ceil, _cos:Math.cos, _exp:Math.exp, _floor:Math.floor, _log:Math.log,
        _max:Math.max, _min:Math.min, _pow:Math.pow, _random:Math.random, _round:Math.round, 
        _sin:Math.sin, _sqrt:Math.sqrt, _tan:Math.tan,
        // user defined functions
        _sig:sig, _sig2:sig2, avg:avg};

    private static function getExprs():Object
    {
      var exprs:Object=new Object();
      for (var n:String in EVAL_EXPRS)
        exprs[n]=EVAL_EXPRS[n];
      return exprs;
    }

    // 返回验证回调函数,额外的错误处理:错误提示, 自定义错误
    private static function getCallback(callbacks:Array=null):Function
    {
      var f6:Function=function(obj:Object):Boolean
        {
          var n:String, mm:Array=[], xx:Array=[];
          if (obj.miss && obj.miss.length > 0)
          {
            for each (n in obj.miss)
            {
              if (xxId(n)) xx.push(n);
              else mm.push(n);
            }
            obj.miss=mm;
            if (xx.length > 0)
            {
              if (!obj.sylla.xxq) obj.sylla.xxq={};
              obj.sylla.xxq[obj.id]=xx;
            }
          }
          return false;
        };
      callbacks=callbacks ? callbacks : [];
      callbacks.unshift(f6);
      callbacks.push(EVALF_GENERAL, EVALF_XX);
      var ff:Function=function(obj:Object):Boolean
        {
          var callback:Function, b:Boolean;
          for each (callback in callbacks)
          {
            b=callback(obj);
            if (obj.error) return b;
          }
          return true;
        };
      return ff;
    }

    // 验证所有项目公式的合法性
    public static function validate(sis:Object, callbacks:Array=null):Object
    {
      var si:SalItem;
      var exprs:Object=getExprs();
      for each (si in sis)
      {
        if (si.formula && si.formula != "")
          exprs[si.no]=si.formula;
        else
          exprs[si.no]=Ident.V;
      }
      var rr:Object=ExprUtil.validate(exprs, getCallback(callbacks));
      if (rr.sylla.xx)
      {
        var n:String, xxq:Object=rr.sylla.xxq, xx:Array=[];
        for each (n in rr.queue)
        {
          if (rr.sylla.xxq[n])
            xx=xx.concat(rr.sylla.xxq[n]);
        }
        rr.sylla.xxq=xx;
      }
      return rr;
    }

    // 公式求值
    public static function evaluate(exprs:Object, context:Object, callbacks:Array=null):Object
    {
      return ExprUtil.evaluate(exprs, context, getCallback(callbacks));
    }

    /**
     * return signal of x.
     * if (x > 50) y = a;
     * else if (x < 50) y = b;
     * else y = c;
     * ==>
     * x1=sig(x-50)
     * y=(x1+1)*x1/2*a+(x1-1)*x1/2*b+(1-x1*x1)*c
     **/
    public static function sig(x:Number):Number
    {
      return x > 0 ? 1 : x < 0 ? -1 : 0;
    }

    public static function sig2(x:Number, a:Number, b:Number, c:Number):Number
    {
      return x > 0 ? a : x < 0 ? b : c;
    }

    public static function avg(obj:Object, x:Number):Number
    {
      var amount:Number=Number(obj["#amount"]), total:Number=NaN;
      if (obj["#params"].length > 0)
      {
        total=obj["#total#"+obj["#params"][0]];
      }
      return (isNaN(amount) || isNaN(total)) ? NaN : amount*x/total;
    }

    public static function avg2(obj:Object, x:Number):Number
    {
      return 100;
    }

  }
}