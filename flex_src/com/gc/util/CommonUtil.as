package com.gc.util
{
  import com.gc.Beans;
  import com.gc.CommonEvent;
  import com.gc.Constants;
  import com.gc.LoadModuleEvent;
  import com.gc.validators.ComboBoxValidator;

  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.events.ContextMenuEvent;
  import flash.events.DataEvent;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.SecurityErrorEvent;
  import flash.geom.Point;
  import flash.net.FileFilter;
  import flash.net.FileReference;
  import flash.net.FileReferenceList;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.system.Capabilities;
  import flash.text.TextFieldAutoSize;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
  import flash.ui.Keyboard;
  import flash.utils.ByteArray;
  import flash.utils.getDefinitionByName;
  import flash.utils.setTimeout;

  import flexlib.containers.WindowShade;

  import mx.collections.ArrayCollection;
  import mx.collections.IList;
  import mx.containers.Form;
  import mx.containers.TitleWindow;
  import mx.containers.ViewStack;
  import mx.controls.AdvancedDataGrid;
  import mx.controls.Alert;
  import mx.controls.Button;
  import mx.controls.ComboBase;
  import mx.controls.ComboBox;
  import mx.controls.DataGrid;
  import mx.controls.DateField;
  import mx.controls.Image;
  import mx.controls.Label;
  import mx.controls.Menu;
  import mx.controls.MenuBar;
  import mx.controls.TextArea;
  import mx.controls.ToolTip;
  import mx.controls.Tree;
  import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
  import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
  import mx.controls.dataGridClasses.DataGridColumn;
  import mx.controls.listClasses.AdvancedListBase;
  import mx.controls.listClasses.ListBase;
  import mx.controls.richTextEditorClasses.ToolBar;
  import mx.core.Application;
  import mx.core.ClassFactory;
  import mx.core.Container;
  import mx.core.DragSource;
  import mx.core.IFlexDisplayObject;
  import mx.core.IUIComponent;
  import mx.core.UIComponent;
  import mx.core.UITextField;
  import mx.core.mx_internal;
  import mx.events.CollectionEvent;
  import mx.events.DragEvent;
  import mx.events.FocusRequestDirection;
  import mx.events.MenuEvent;
  import mx.events.ValidationResultEvent;
  import mx.managers.DragManager;
  import mx.managers.IFocusManager;
  import mx.managers.IFocusManagerComponent;
  import mx.managers.PopUpManager;
  import mx.managers.ToolTipManager;
  import mx.printing.FlexPrintJob;
  import mx.printing.PrintAdvancedDataGrid;
  import mx.printing.PrintDataGrid;
  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;
  import mx.skins.ProgrammaticSkin;
  import mx.utils.Base64Encoder;
  import mx.utils.DescribeTypeCache;
  import mx.utils.ObjectUtil;
  import mx.utils.StringUtil;
  import mx.validators.DateValidator;
  import mx.validators.Validator;

  use namespace mx_internal;

  public class CommonUtil
  {
    private static function singleton():void
    {
    }

    public function CommonUtil(caller:Function=null)
    {
      if (caller != singleton)
        throw new Error("CommonUtil is a non-instance class!!!");
    }

//==================================== 对象公用方法 ====================================

    /**
     * 返回组件对象(AdvancedListBase/ListBase/ComboBase)的选择项(selectedItem)
     * 如果对象是其它类型则返回对象本身
     **/
    public static function getItem(item:Object):Object
    {
      var r:Object=item;
      if (item is AdvancedListBase)
      {
        r=(item as AdvancedListBase).selectedItem;
      }
      else if (item is ListBase)
      {
        r=(item as ListBase).selectedItem;
      }
      else if (item is ComboBase)
      {
        r=(item as ComboBase).selectedItem;
      }
      return r;
    }

    /**
     * 返回对象的name属性值, 如果是简单对象则返回其字符串值
     **/
    public static function getItemName(item:Object):String
    {
      if (item == null)
        return null;
      else if (item.hasOwnProperty("name") && item.name is String)
        return item.name;
      else if (ObjectUtil.isSimple(item))
        return item.toString();
      else
        return null;
    }

    /**
     * 返回对象的label/text属性值, 如果是简单对象则返回其字符串值
     **/
    public static function getItemLabel(item:Object):String
    {
      if (item == null)
        return null;
      else if (item.hasOwnProperty("label") && item.label is String)
        return item.label;
      else if (item.hasOwnProperty("text") && item.text is String)
        return item.text;
      else if (ObjectUtil.isSimple(item))
        return item.toString();
      else
        return null;
    }

    /**
     * 返回对象的value/text属性值, 如果是简单对象则返回对象本身
     **/
    public static function getItemValue(item:Object):Object
    {
      try
      {
        if (item == null)
          return null;
        else if (item.hasOwnProperty("value") && item.value != null)
          return item.value;
        else if (item.hasOwnProperty("text"))
          return item.text;
        else if (ObjectUtil.isSimple(item))
          return item;
          // else if (item is ComboBase)
          //  return (item as ComboBase).selectedItem;
      }
      catch (error:Error)
      {
      }
      return null;
    }

    /**
     * 返回对象中所有name和value属性值不为null的子对象数组
     * [{name:n1, value:v1}, {name:n2, value:v2}, ...]
     **/
    mx_internal static function getItems(obj:Object):Array
    {
      var items:Array=[];
      visit(obj, function(obj:Object):void
        {
          var name:String;
          var value:Object;
          var item:Object;
          if (obj is Array || obj is Label) {
            return;
          } else if (obj is UIComponent) {
            name=getItemName(obj);
            if (name != null)
            {
              value=getItemValue(obj);
              if (value != null)
              {
                item=new Object();
                item[Constants.PROP_NAME_NAME]=name;
                item[Constants.PROP_NAME_VALUE]=value;
                item[Constants.PROP_NAME_OBJECT]=obj;
                item.enabled=obj.hasOwnProperty("enabled") ? obj.enabled : true;
                item.visible=obj.hasOwnProperty("visible") ? obj.visible : true;
                items.push(item);
                if (obj is DateField) {
                  item[Constants.PROP_NAME_ITEM]=DateUtil.parseDate(value.toString());
                } else if (obj is ComboBase) {
                  item[Constants.PROP_NAME_ITEM]=(obj as ComboBase).selectedItem == null ? value : (obj as ComboBase).selectedItem;
                } else {
                  item[Constants.PROP_NAME_ITEM]=value;
                }
              }
            }
          } else {
            var names:Array=getPropertyNames(obj, ["children"]);
            for each (name in names) {
              item=new Object();
              item[Constants.PROP_NAME_NAME]=name;
              item[Constants.PROP_NAME_VALUE]=obj[name];
              item[Constants.PROP_NAME_OBJECT]=obj[name];
              item[Constants.PROP_NAME_ITEM]=obj[name];
              item.enabled=true;
              item.visible=true;
              items.push(item);
            }
          }
        });
      return items;
    }

    /**
     * 返回对象所有属性name和type的集合: {name1:type1, name2:type2, ...}
     * 所有属性的name将添加到names数组中(如果不为null)
     **/
    mx_internal static function getAccessors(obj:Object, names:Array=null):Object
    {
      var accessors:Object=new Object();
      var desObj:XML=DescribeTypeCache.describeType(obj).typeDescription;
      var attrs:XMLList=desObj..accessor;
      for each (var attr:Object in attrs)
      {
        accessors[attr.@name.toString()]=attr.@type;
        if (names != null)
          names.push(attr.@name.toString());
      }
      return accessors;
    }

    /**
     * 返回对象所有的属性名数组: [name1, name2, ...]
     **/
    mx_internal static function getAccessorNames(obj:Object):Array
    {
      var names:Array=new Array();
      var desObj:XML=DescribeTypeCache.describeType(obj).typeDescription;
      var attrs:XMLList=desObj..accessor;
      for each (var attr:Object in attrs)
      {
        names.push(attr.@name.toString());
      }
      return names;
    }

    /**
     * 返回对象所有的属性值数组:
     * [{name: n1, value: v1, type: t1}, {name: n2, value: v2, type: t2}, ...]
     **/
    mx_internal static function getAccessorValues(obj:Object):Array
    {
      var values:Array=new Array();
      var desObj:XML=DescribeTypeCache.describeType(obj).typeDescription;
      var attrs:XMLList=desObj..accessor;
      var name:String;
      var type:String;
      var item:Object;
      for each (var attr:Object in attrs)
      {
        name=attr.@name.toString();
        type=attr.@type.toString();
        item=new Object();
        item[Constants.PROP_NAME_NAME]=name;
        item[Constants.PROP_NAME_VALUE]=obj[name];
        item[Constants.PROP_NAME_TYPE]=type;
        values.push(item);
      }
      return values;
    }

    /**
     * 返回对象obj属性name的值, 支持多级属性(如id.branch.id)
     **/
    public static function getAccessorValue(obj:Object, name:String):Object
    {
      if (obj == null || name == null)
        return null;
      var names:Array=name.split(".");
      var item:Object=obj;
      for each (var s:String in names)
      {
        if (!item.hasOwnProperty(s) || item[s] == null)
          return obj.hasOwnProperty(name) ? obj[name] : null;
        item=item[s];
      }
      return item;
    }

    /**
     * 返回对象obj属性name的类型名
     **/
    public static function getAccessorType(obj:Object, name:String):String
    {
      var des:XML=DescribeTypeCache.describeType(obj).typeDescription;
      var attrs:XMLList=des.accessor.(@name == name);
      if (attrs.length() <= 0)
        attrs=des.factory.accessor.(@name == name);
      return (attrs == null || attrs.length() <= 0) ? null : attrs[0].@type;
    }

    mx_internal static function setAccessor(obj:Object, names:Array, value:Object, accessors:Object=null):Boolean
    {
      var name:String;
      var r:Boolean=true;
      if (accessors == null)
        accessors=getAccessors(obj);
      while (names.length > 0)
      {
        name=names.shift().toString();
        if (obj.hasOwnProperty(name) && accessors.hasOwnProperty(name))
        {
          if (names.length > 0)
          {
            if (obj[name] == null)
              obj[name]=newInstance(accessors[name]);
            r=setAccessor(obj[name], names, value);
          }
          else
          {
            obj[name]=getValue(value, accessors[name]);
          }
        }
        else
        {
          r=false;
        }
        if (!r)
          return r;
      }
      return r;
    }

    /**
     * 转换value对象为type类型的对象返回
     **/
    mx_internal static function getValue(value:Object, type:String):Object
    {
      if (value == null)
        return null;
      if (type == "int")
        return parseInt(value.toString());
      else if (type == "Number")
        return parseFloat(value.toString());
      else if (type == "String")
        return value.toString();
      else if (type == "Date")
        return (value is Date) ? value : DateUtil.parseDate(value.toString());
      else
        return value;
    }

    /**
     * 设置对象obj属性name的值为value, 支持多级属性(如limit.id.branch.useId)
     **/
    public static function setValue(obj:Object, accessor:String, value:Object, accessors:Object=null):void
    {
      if (accessor != null)
        setAccessor(obj, accessor.split("."), value, accessors);
    }

    /**
     * 返回类型全名为type的新实例对象
     * 解决ReferenceError: Error #1065: Variable is not defined错误:
     * 1. Require Flash Player version >= 10.0.12
     * 2. 之前调用type对应的类
     **/
    mx_internal static function newInstance(type:String):Object
    {
      var clazz:Class=getDefinitionByName(type) as Class;
      return new clazz();
    }

    /**
     * 生成类型为name的实例对象
     * 提取src对象(一般是form)中所有项目(不包含enabled=false的项目)的值设置此实例对象的属性值
     **/
    public static function createInstance(src:Object, name:String):Object
    {
      var crObj:Class=getDefinitionByName(name) as Class;
      var r:Object=new crObj();
      var items:Array=getItems(src);
      var accessors:Object=getAccessors(r);
      for each (var item:Object in items)
      {
        if (item.enabled)
          setAccessor(r, item.name.split("."), item.item, accessors);
      }
      return r;
    }

    /**
     * 提取src对象(一般是form)中所有项目(不包含enabled=false的项目)的值复制为dest对象的属性值
     * all: 是否复制所有项目值.
     * 		- false: 只复制与dest对象属性匹配的项目
     * 		- true: 复制所有项目
     **/
    public static function loadInstance(src:Object, dest:Object, all:Boolean=false):void
    {
      var items:Array=getItems(src);
      var accessors:Object=getAccessors(dest);
      var _dynamic:Boolean=isDynamic(dest);
      var r:Boolean;
      var old:Object;
      for each (var item:Object in items)
      {
        if (item.enabled)
        {
          old=getAccessorValue(dest, item.name);
          if (old == null && item.item == "")
            continue;
          if (old != null && item.item == "")
            item.item = null;
          r=setAccessor(dest, item.name.split("."), item.item, accessors);
          if (!r && all && _dynamic)
            dest[item.name]=item.item;
        }
      }
    }

    /**
     * 通过obj对象生成对象, 支持属性/样式/事件和子对象数组
     * 一般用来快捷方便地生成界面控件, 用法参考com.gc.controls.Voucher的createButtons方法
     * obj定义规范如下:
     * {obj:new HBox(), horizontalAlign:"center", percentWidth:100, children:[], click:onClick}
     * 属性obj为实际的返回对象, children为子对象数组
     **/
    public static function createObject(obj:Object, callback:Function=null):*
    {
      var r:Object=null;
      if (obj.hasOwnProperty("obj") && obj.obj != null)
      {
        r=obj.obj;
        copyProperties(obj, r, ["obj", "children"]);
      }
      else
      {
        r=obj;
      }
      if (callback != null)
        callback(r, obj);
      if (obj.hasOwnProperty("children") && obj.children is Array)
        createObjects(obj.children, r, callback);
      return r;
    }

    /**
     * 生成对象数组
     **/
    public static function createObjects(arr:Array, parent:Object=null, callback:Function=null):Array
    {
      var r:Array=[];
      var item:Object, p:DisplayObjectContainer;
      for each (var obj:Object in arr)
      {
        item=createObject(obj, callback);
        p=(item is DisplayObjectContainer) ? item as DisplayObjectContainer : null;
        if (item != null)
        {
          if (item is DisplayObject && parent is DisplayObjectContainer)
            (parent as DisplayObjectContainer).addChild(item as DisplayObject);
          r.push(item);
        }
      }
      return r;
    }

    /**
     * 生成表格的所有列
     **/
    public static function createColumns(grid:Object, columns:Array):void
    {
      if (!(grid is DataGrid) && !(grid is AdvancedDataGrid))
        return;
      var _columns:Array=[];
      var column:Object;
      for each (var obj:Object in columns)
      {
        if (obj.hasOwnProperty("column"))
        {
          column=obj.column;
          if (column is DataGridColumn || column is AdvancedDataGridColumn)
          {
            copyProperties(obj, column, ["column"]);
            _columns.push(column);
          }
        }
      }
      grid.columns=_columns;
    }

    /**
     * Sprite->DisplayObjectContainer->InteractiveObject->DisplayObject->EventDispatcher->Object
     * TextField->InteractiveObject->DisplayObject->EventDispatcher->Object
     * TextInput->UIComponent->FlexSprite->Sprite->DisplayObjectContainer->InteractiveObject->DisplayObject->EventDispatcher->Object
     * TextArea->ScrollControlBase->UIComponent->FlexSprite->Sprite->DisplayObjectContainer->InteractiveObject->DisplayObject->EventDispatcher->Object
     **/
    private static function getParent(dobj:DisplayObject):DisplayObject
    {
      if (dobj is UIComponent)
        return (dobj as UIComponent).owner;
      else
        return dobj.parent;
    }

    public static function findAncestor(obj:Object, clazz:Class=null):DisplayObject
    {
      var r:Object=obj;
      if (clazz == null && r is UIComponent)
      {
        var document:Object=(r as UIComponent).document;
        if (document is DisplayObject)
          return document as DisplayObject;
      }
      while (!(r is clazz) && r is DisplayObject)
      {
        r=getParent(r as DisplayObject);
      }
      return (r is DisplayObject) ? r as DisplayObject : null;
    }

    private static function getPropertyNames(obj:Object, excludes:Array=null, options:Object=null):Array
    {
      var info:Object=ObjectUtil.getClassInfo(obj, excludes, options);
      var qnames:Array=info.properties;
      var names:Array=[];
      for each (var name:Object in qnames)
      {
        names.push(name.localName);
      }
      return names;
    }

    public static function getAlias(clazz:Class):String
    {
      if (clazz == null)
        return null;
      var info:XML=DescribeTypeCache.describeType(clazz).typeDescription;
      return info.@alias.toString();
    }

    public static function getClass(obj:Object):Class
    {
      if (obj==null)
        return null;
      var info:XML=DescribeTypeCache.describeType(obj).typeDescription;
      var name:String=info.@name.toString();
      return getDefinitionByName(name) as Class;
    }

    public static function isDynamic(obj:Object):Boolean
    {
      var info:XML=DescribeTypeCache.describeType(obj).typeDescription;
      return info.@isDynamic.toString() == "true";
    }

    /**
     * 复制对象src的所有属性到dest对象
     **/
    public static function copyProperties(src:Object, dest:Object, excludes:Array=null, names:Array=null):void
    {
      if (src == null)
        return;
      if (names == null)
        names=getPropertyNames(src, excludes);
      var info:XML=DescribeTypeCache.describeType(dest).typeDescription;
      for each (var name:String in names)
      {
        if (dest is Array || dest is IList)
        {
          for each (var item:Object in dest)
            copyProperties(src, item, excludes, names);
        }
        else
        {
          if (dest.hasOwnProperty(name) && info..accessor.(@name == name).@access == "readonly")
            continue;
          if (!dest.hasOwnProperty(name))
          {
            if (dest is UIComponent)
            {
              var comp:UIComponent=dest as UIComponent;
              comp.setStyle(name, src[name]);
            }
            if (dest is EventDispatcher && src[name] is Function)
            {
              var ed:EventDispatcher=dest as EventDispatcher;
              ed.addEventListener(name, src[name]);
            }
            if (info.@isDynamic.toString() != "true")
              continue;
          }
          dest[name] = src[name];
        }
      }
    }

    private static function addEventListener(obj:Object, l:Object):void
    {
      if (obj is EventDispatcher && l != null)
      {
        var ed:EventDispatcher=obj as EventDispatcher;
        var type:String=(l.hasOwnProperty("type") && l.type is String) ? l.type : null;
        var listener:Function=(l.hasOwnProperty("listener") && l.listener is Function) ? l.listener as Function : null;
        var useCapture:Boolean=(l.hasOwnProperty("useCapture") && l.useCapture is Boolean) ? l.useCapture : false;
        var priority:int=(l.hasOwnProperty("priority") && l.priority is int) ? l.priority : 0;
        var useWeakReference:Boolean=(l.hasOwnProperty("useWeakReference") && l.useWeakReference is Boolean) ? l.useWeakReference : false;
        if (type != null && listener != null)
          ed.addEventListener(type, listener, useCapture, priority, useWeakReference);
      }
    }

    public static function addEventListeners(obj:Object, listeners:Array):void
    {
      if (listeners != null)
      {
        for each (var listener:Object in listeners)
        {
          addEventListener(obj, listener);
        }
      }
    }

    /**
     * 派发事件到所有子控件
     **/
    private static function dispatchEvent(obj:Object, event:Event, recursive:Boolean=false):void
    {
      if (obj is Array)
      {
        var items:Array=obj as Array;
        for each (var item:Object in items)
        {
          dispatchEvent(item, event);
        }
      }
      else if (obj is Form)
      {
        var form:Form=obj as Form;
        form.dispatchEvent(event);
      }
      else if (obj is Container)
      {
        var con:Container=obj as Container;
        con.dispatchEvent(event);
        if (recursive)
          dispatchEvent(con.getChildren(), event);
      }
    }

    public static function show(obj:Object, visible:Boolean=true):void
    {
      if (obj is UIComponent)
      {
        var comp:UIComponent=obj as UIComponent;
        if (!comp.descriptor.properties.hasOwnProperty("includeInLayout"))
          comp.includeInLayout=visible;
        if (!comp.descriptor.properties.hasOwnProperty("visible"))
          comp.visible=visible;
      }
      else if (obj is Array || obj is IList)
      {
        for each (var item:Object in obj)
          show(item, visible);
      }
    }

    public static function enable(obj:Object, enabled:Boolean=true):void
    {
      if (obj is UIComponent)
      {
        var comp:UIComponent=obj as UIComponent;
        if (!comp.descriptor.properties.hasOwnProperty("enabled"))
          comp.enabled=enabled;
      }
      else if (obj is Array || obj is IList)
      {
        for each (var item:Object in obj)
          enable(item, enabled);
      }
    }

    public static function close(obj:Object, closed:Boolean=true):void
    {
      if (obj is WindowShade)
      {
        var ws:WindowShade=obj as WindowShade;
        ws.opened=!closed;
      }
      else if (obj is Array || obj is IList)
      {
        for each (var item:Object in obj)
          close(item, closed);
      }
    }

    /**
     * 访问对象, 递归遍历访问此对象的所有子对象
     * obj: 一般为form, grid等父容器对象或数组
     * visitor: 回调函数, 接口为function(Object, Array=null):void
     **/
    public static function visit(obj:Object, visitor:Function, args:Array=null, flag:Object=null):void
    {
      if (flag != null && flag.hasOwnProperty("cancel") && flag.cancel)
        return;
      if (obj == null)
        return;
      else
      {
        if (args == null)
          visitor(obj);
        else
          visitor(obj, args);
      }
      if (obj is Array || obj is ArrayCollection)
      {
        for each (var item:Object in obj)
        {
          visit(item, visitor, args, flag);
        }
      }
      else if (obj is Container)
      {
        var con:Container=obj as Container;
        visit(con.getChildren(), visitor, args, flag);
      }
      else if (obj.hasOwnProperty("children"))
      {
        visit(obj["children"], visitor, args, flag);
      }
    }

    public static function empty(obj:Object):void
    {
      for (var x:*in obj)
      {
        obj[x]=null;
          // obj.setPropertyIsEnumerable(x, false);
      }
    }

    public static function clear(obj:Object):Object
    {
      var r:Object=ObjectUtil.copy(obj);
      for (var x:*in r)
      {
        if (r[x] == null || x.substr(0, 1) == "#")
          r.setPropertyIsEnumerable(x, false);
      }
      return r;
    }

//==================================== 数组/列表公用方法 ====================================

    public static const EMPTY_ARRAY:Array=[];
    public static const EMPTY_ARRAY_COLLECTION:ArrayCollection=new ArrayCollection();

    /**
     * 返回Array/IList中与item对象值(value属性值)相等的数据项
     **/
    public static function indexOfObject(arr:Object, item:Object):int
    {
      if (arr == null || item == null)
        return -1;
      var a:Array=arr is Array ? arr as Array : 
        arr is IList ? (arr as IList).toArray() : [];
      var obj:Object;
      for (var i:int = 0; i < a.length; i++)
      {
        obj = a[i];
        if (obj == item || 
          (obj.hasOwnProperty(Constants.PROP_NAME_VALUE) 
          && item.hasOwnProperty(Constants.PROP_NAME_VALUE) 
          && obj[Constants.PROP_NAME_VALUE] == item[Constants.PROP_NAME_VALUE]))
          return i;
      }
      return -1;
    }

    /**
     * 返回Array/IList中与key的对象值(value属性值)相等或attr的属性值等于key的数据项
     * attr支持多级属性, 如id.branch.id
     * _include: 回调函数, 接口为function(obj:Object, key:Object, attr:String):Boolean
     *    返回true, 则忽略跳过obj; 否则index+1
     **/
    public static function indexOfKey(arr:Object, key:Object, attr:String=null, _include:Function=null):int
    {
      if (arr == null || key == null)
        return -1;
      var _arr:Array=arr is Array ? arr as Array : 
        arr is IList ? (arr as IList).toArray() : [];
      var count:int=0;
      for each (var obj:Object in _arr)
      {
        if (_include != null && !_include(obj, key, attr))
          continue;
        if (obj == null)
          continue;
        if (obj == key || 
          (obj.hasOwnProperty(Constants.PROP_NAME_VALUE) 
          && key.hasOwnProperty(Constants.PROP_NAME_VALUE) 
          && obj[Constants.PROP_NAME_VALUE] == key[Constants.PROP_NAME_VALUE]))
          return count;
        if (attr != null && getAccessorValue(obj, attr) == key)
          return count;
        count++;
      }
      return -1;
    }

    /**
     * 返回数组中key属性值与obj的key属性值相等的对象
     * key缺省为id
     **/
    public static function getObject(arr:Object, obj:Object, key:String="id"):*
    {
      if (obj == null)
        return null;
      var k:int=indexOfKey(arr, obj[key], key);
      return (k >= 0) ? arr[k] : null;
    }

    public static function getSubArray(arr:Array, names:Array=null):Array
    {
      var r:Array=[];
      var obj:Object;
      if (names == null || names.length <= 0)
        return EMPTY_ARRAY;
      for each (var item:Object in arr)
      {
        obj=new Object();
        for each (var name:String in names)
          obj[name]=getAccessorValue(item, name);
        r.push((names.length == 1) ? obj[names[0]] : obj);
      }
      return r;
    }

//==================================== 其他公用方法 ====================================

    /**
     * 返回程序的查询字符串, 如:username=hr1&password=1234&module=hr&branch=gjgs
     **/
    public static function getQueryString():String
    {
      var s:String="";
      for each (var name:String in Application.application.parameters)
      {
        /**
         * Firefox中有bug:
         * 如果页面链接是http://localhost/index.html, 参数中会包含此链接:
         * 	index.mxml中login方法获取的链接为login.swf?http://localhost/index.html=&
         * 如果页面链接是http://localhost/index.html?debug=true, 函数正常返回:
         *   index.mxml中login方法获取的链接为login.swf?debug=true&
         **/
        if (name.indexOf("http://") >= 0)
          continue;
        s=s + name + "=" + Application.application.parameters[name] + "&";
      }
      return s;
    }

    /**
     * 返回url的Full URL
     **/
    public static function getFullURL(url:String):String
    {
      if (url == null)
        return null;
      if (url.indexOf("://") > 0)
        return url;
      var r:String=Constants.SERVER_PROTOCOL + "://" + Constants.SERVER_NAME 
        + (Constants.SERVER_PORT == 80 ? "" : Constants.SERVER_PORT);
      if (Constants.SERVER_CONTEXT.charAt(0) != "/")
        r += "/";
      r += Constants.SERVER_CONTEXT;
      if (Constants.SERVER_CONTEXT != "" 
        && Constants.SERVER_CONTEXT.charAt(Constants.SERVER_CONTEXT.length - 1) != "/")
        r += "/";
      r += url.substring(url.charAt(0) == "/" ? 1 : 0, url.length);
      return r;
    }

    /**
     * 打印, 参考hr/index.mxml的printCards方法
     * obj: 表格, 对象数组或列表
     * template: 页面渲染模板, 必须是Container的子类
     **/
    public static function print(obj:Object, template:Class=null, f:Function=null):void
    {
      if (obj is DataGrid)
        printDataGrid(obj as DataGrid);
      else if (obj is AdvancedDataGrid)
        printAdvancedDataGrid(obj as AdvancedDataGrid);
      else if (obj is Array)
        printPages(obj as Array, template, f);
      else if (obj is IList)
        printPages((obj as IList).toArray(), template, f);
    }

    private static function printDataGrid(dg:DataGrid):void
    {
      var fpj:FlexPrintJob=new FlexPrintJob();
      if (fpj.start())
      {
        var pdg:PrintDataGrid=new PrintDataGrid();
        pdg.visible=false;
        pdg.width=fpj.pageWidth;
        pdg.height=fpj.pageHeight;
        pdg.columns=dg.columns;
        pdg.dataProvider=dg.dataProvider;
        pdg.labelFunction=dg.labelFunction;
        Application.application.addChild(pdg);
        fpj.addObject(pdg);
        while (pdg.validNextPage)
        {
          pdg.nextPage();
          fpj.addObject(pdg);
        }
        fpj.send();
        Application.application.removeChild(pdg);
      }
    }

    private static function printAdvancedDataGrid(adg:AdvancedDataGrid):void
    {
      var fpj:FlexPrintJob=new FlexPrintJob();
      if (fpj.start())
      {
        var padg:PrintAdvancedDataGrid=new PrintAdvancedDataGrid();
        padg.visible=false;
        padg.width=fpj.pageWidth;
        padg.height=fpj.pageHeight;
        padg.columns=adg.columns;
        padg.dataProvider=adg.dataProvider;
        padg.labelFunction=adg.labelFunction;
        padg.headerRenderer=adg.headerRenderer;
        padg.itemRenderer=adg.itemRenderer;
        padg.setStyle("headerSortSeparatorSkin", adg.getStyle("headerSortSeparatorSkin"));
        Application.application.addChild(padg);
        fpj.addObject(padg);
        while (padg.validNextPage)
        {
          padg.nextPage();
          fpj.addObject(padg);
        }
        fpj.send();
        Application.application.removeChild(padg);
      }
    }

    private static function printPages(objs:Array, template:Class, f:Function=null):void
    {
      printPages2(objs, template, f);
    }

    /**
     * objs: 页面数组
     **/
    private static function printPages1(objs:Array, template:Class):void
    {
      if (objs == null || objs.length <= 0)
        return;
      var fpj:FlexPrintJob=new FlexPrintJob();
      fpj.printAsBitmap=false;
      if (fpj.start())
      {
        for each (var page:UIComponent in objs)
        {
          fpj.addObject(page);
          Application.application.removeChild(page);
        }
        fpj.send();
      }
    }
    /*
       PersonalController.getPersonsCard(ids, function(e1:ResultEvent):void
       {
       var coll:ArrayCollection=e1.result as ArrayCollection;
       var page:Container;
       var pages:Array=[];
       var count:int=0;
       var ed:EventDispatcher=new EventDispatcher();
       var f:Function=function(e2:Event):void
       {
       CommonUtil.print(pages);
       ed.removeEventListener(CommonEvent.READY, f);
       };
       ed.addEventListener(CommonEvent.READY, f);
       for each (var obj:Object in coll)
       {
       page=new PersonCard1();
       page.visible=page.includeInLayout=false;
       Application.application.addChild(page);
       page.addEventListener(Event.COMPLETE, function(e:Event):void
       {
       count++;
       if (count == coll.length) ed.dispatchEvent(CommonEvent.READY_EVENT);
       }, true);
       page.data=obj;
       pages.push(page);
       }
       Application.application.validateNow();
       });
     */

    /**
     * objs: 数据对象数组
     **/
    private static function printPages2(objs:Array, template:Class, f:Function=null):void
    {
      if (objs == null || objs.length <= 0)
        return;
      var pages:Array=[]
      var page:Container;

      var ed:EventDispatcher=new EventDispatcher();
      var f1:Function=function(e:CommonEvent=null):void
        {
          var fpj:FlexPrintJob=new FlexPrintJob();
          fpj.printAsBitmap=false;
          if (fpj.start())
          {
            for each (var page:UIComponent in pages)
            {
              fpj.addObject(page);
              Application.application.removeChild(page);
            }
            fpj.send();
          }
          ed.removeEventListener(CommonEvent.READY, f1);
        };
      ed.addEventListener(CommonEvent.READY, f1);

      for each (var obj:Object in objs)
      {
        page=template is Class ? new template() : obj as Container;
        page.visible=page.includeInLayout=false;
        Application.application.addChild(page);
        page.addEventListener(Event.COMPLETE, function(e:Event):void
          {
            if (f != null && f(page, objs)) ed.dispatchEvent(CommonEvent.READY_EVENT);
          }, true);
        page.data=obj;
        pages.push(page);
      }
      Application.application.validateNow();
      if (f == null)
        setTimeout(f1, 200);
    }

    /**
     * 导出数据, 保存为excel文件, 参考com.gc.controls.Voucher的epxort方法
     * data: 二维数组, 如果是表格数据, 可以调用getGridData方法获取
     * headers: 表头, 如果是表格表头, 可以调用getGridHeaders方法获取
     * formats: 格式及样式, 留待以后扩展
     * name: excel文件名, 缺省为data.xls
     **/
    public static function export(data:Array, headers:Object, formats:Object=null, name:String="data.xls"):void
    {
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      var fr:FileReference=new FileReference();
      fr.addEventListener(Event.COMPLETE, function(e:Event):void
        {
          Alert.show(resourceManager.getString("gcc", "download.complete"), 
            Constants.APP_NAME, Alert.OK, null, null, Constants.ICON32_INFO);
        });
      var ur:URLRequest=getServiceRequest(Beans.SERVICE_COMMON_BASE, "export", [data, headers, formats]);
      fr.download(ur, name);
    }

    /**
     * 导入数据并调用callback函数进行后续处理
     * callback: 回调函数, 接口待定
     * description: 上传文件时可选择文件的描述, 如["所有文件(*.*)", ...]
     * extension: 上传文件时可选择文件的扩展名, 如["*.*", ...]
     * single: 是否选择单个文件上传
     **/
    public static function _import(callback:Function, description:String=null, extension:String=null, single:Boolean=true):void
    {
      importFile(callback, description, extension);
    }

    private static function importFile(callback:Function, description:String=null, extension:String=null):void
    {
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      if (description == null)
        description=resourceManager.getString("gcc", "file.filter.all.tip");
      if (extension == null)
        extension=resourceManager.getString("gcc", "file.filter.all");
      var fr:FileReference=new FileReference();
      var ff:FileFilter=new FileFilter(description, extension);
      fr.browse([ff]);
    }

    private static function importFiles(callback:Function, description:String=null, extension:String=null):void
    {
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      if (description == null)
        description=resourceManager.getString("gcc", "file.filter.all.tip");
      if (extension == null)
        extension=resourceManager.getString("gcc", "file.filter.all");
      try
      {
        var frl:FileReferenceList=new FileReferenceList();
        var ff:FileFilter=new FileFilter(description, extension);
        frl.addEventListener(Event.SELECT, function(event:Event):void
          {
            var frl:FileReferenceList=FileReferenceList(event.target);
            var files:Array=frl.fileList;
            for each (var file:Object in files)
            {
              var fr:FileReference=FileReference(file);
              fr.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
                {
                });
              fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void
                {
                });
              fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, function(e:DataEvent):void
                {
                });
              try
              {
                var ur:URLRequest=getServiceRequest(Beans.SERVICE_COMMON_BASE, "_import");
                fr.upload(ur);
              }
              catch (err:Error)
              {
                Alert.show(resourceManager.getString("gcc", "upload.fail"), 
                  Constants.APP_NAME, Alert.OK, null, null, Constants.ICON32_ERROR);
              }
            }
          });
        frl.browse(new Array(ff));
      }
      catch (err:Error)
      {
        Alert.show(resourceManager.getString("gcc", "browse.fail"), 
          Constants.APP_NAME, Alert.OK, null, null, Constants.ICON32_ERROR);
      }
    }

    /**
     * 返回服务器端方法调用的请求, 参考export方法
     * service: 服务名称, 可以是spring定义的service名
     * method: 方法名
     * params: 参数
     **/
    public static function getServiceRequest(service:String, method: String, params: Array=null):URLRequest
    {
      var ur:URLRequest=new URLRequest(getFullURL(Constants.FLEX_SERVLET_URL));
      var uv:URLVariables=new URLVariables();
      if (params != null && params.length > 0)
      {
        var b:ByteArray = new ByteArray();
        b.writeObject(params);
        var e:Base64Encoder=new Base64Encoder();
        e.encodeBytes(b);
        uv.params=e.drain();
      }
      uv.service=service;
      uv.method=method;
      ur.contentType="application/octet-stream";
      ur.method=URLRequestMethod.POST;
      ur.data=uv;
      return ur;
    }

//==================================== ToolBar/Menu/Context Menu ====================================

    /**
     * 通过items数组构造ToolBar, 参考hr/index.mxml的onPreinitialize方法
     **/
    public static function buildToolBar(items:Array):ToolBar
    {
      var toolBar:ToolBar=new ToolBar();
      var image:Image;
      for each (var item:Object in items)
      {
        image=new Image();
        if (item.icon != null)
          image.source=item.icon;
        if (item.toolTip is String)
          image.toolTip=item.toolTip;
        if (item.click is Function)
          image.addEventListener(MouseEvent.CLICK, item.click);
        toolBar.addChild(image);
      }
      return toolBar;
    }

    /**
     * 此3个函数有问题, 暂时不用, 无法做到click="moveItems(arrAllColumns, arrOrderColumns, arrAllColumns.toArray())"的效果:
     * 如果数组中直接写command: moveItems(arrAllColumns, arrOrderColumns, arrAllColumns.toArray()), 则数组初始化时会执行函数!!!
     * 如果写成command: xxx, args: yyy, 则args的值无法做到动态更新!!!
     **/
    private static function getCallback(callback:Function, args:Array):Function
    {
      return function(evt:*):void
      {
        if (args == null)
          callback.apply(null, [evt]);
        else if (evt == null)
          callback.apply(null, args);
        else
          callback.apply(null, [evt].concat(args));
      }
    }

    private static function buildContextMenu(arr:Array, caption:String="caption", command:String="command", args:String="args", icon:String="icon", hideBuiltIn:Boolean=true):ContextMenu
    {
      var menu:ContextMenu=new ContextMenu();
      var item:ContextMenuItem;
      for each (var obj:Object in arr)
      {
        item=new ContextMenuItem(obj[caption]);
        item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getCallback(obj[command], obj[args]));
        menu.customItems.push(item);
      }
      if (hideBuiltIn)
        menu.hideBuiltInItems();
      return menu;
    }

    private static function accessable(obj:Object, limit:int, inheritAccess:Object=null):Boolean
    {
      var arr:Array=[];
      if (inheritAccess != null)
        arr.push(inheritAccess);
      if (obj.access != null)
        arr.push(obj.access);
      for each (var item:Object in arr)
      {
        if (item is Array && item.indexOf(limit) >= 0)
        {
          return true;
        }
        else if (item is Function)
        {
          return item(obj, limit);
        }
        else
        {
          return false;
        }
      }
      return true;
    }

    /**
     * 构造菜单, 参考hr/index.mxml的loadMenu方法
     * items: 菜单数组, 支持多级, 支持command/url/view/popup执行方式
     * 		- label: 菜单文本
     * 		- type: "separator"显示分隔线; "check"显示打勾符号(需配合toggled来控制是否显示)
     *    - toggled: 是否显示打勾符号
     *    - enabled: 是否激活菜单项
     *    - access: 权限, 数组或回调函数
     *    - icon: 菜单项图标
     *    - accelerator: 快捷方式, 待扩展
     * limit: 当前用户权限
     * inheritAccess: 权限, 数组或回调函数. 回调函数的接口为function(Object, int):Boolean
     **/
    public static function buildMenu(items:Array, limit:int, inheritAccess:Object=null):Array
    {
      var r:Array=[];
      var tm:Object, ia:Object;
      for each (var item:Object in items)
      {
        ia=(item.hasOwnProperty("access")) ? item.access : (inheritAccess == null) ? null : inheritAccess;
        if (item.visible != null && !item.visible)
          continue;
        if (item.hasOwnProperty("children"))
        {
          //tm=ObjectUtil.copy(item);
          tm=new Object();
          copyProperties(item, tm);
          tm["children"]=buildMenu(item.children, limit, ia);
          if (tm.children.length > 0)
            r.push(tm);
        }
        else
        {
          if (accessable(item, limit, ia))
            r.push(item);
        }
      }
      return r;
    }

    /**
     * 执行菜单项, 支持command/url/view/popup方式
     * 注意: 如果菜单项中定义view, 则需要放到creationComplete待view创建出来后调用buildMenu
     * event.item: 菜单项对象
     *    - command: 执行函数
     *    - url: 加载到ModuleLoader中的Module的URL
     *    - popup: 弹出窗口
     *    - view: ViewStack切换的view
     *    - args: 参数, 通过CommonEvent.CREATED事件传递到module/popup/view中
     **/
    public static function menuItemClick(event:MenuEvent):void
    {
      var item:Object=event.item;
      var menu:Menu=event.menu;
      var result:Object=null;
      var args:Object=item.hasOwnProperty("args") ? item.args : null
      // execute command
      if (item.command is Function)
      {
        executeCommand(item.command, event, args);
      }
      // load module
      else if (item.url is String)
      {
        loadModule(findAncestor(menu), item.url, item.callback);
      }
      // popup window
      else if (item.popup is Class)
      {
        var title:String=getMenuTitle(menu, item);
        result=popupWindow(item.popup, title, findAncestor(menu), args);
      }
      else if (item.view is Container)
      {
        selectView(item.view, args);
          // command: function(e:Event, args:Object=null):void{CommonUtil.selectView(groupManage, args);
      }
      if (result != null && item.callback is Function)
      {
        item.callback(result);
      }
    }

    private static function getMenuTitle(menu:Menu, item:Object):String
    {
      var items:Array=getAncestors(menu, item);
      var title:String="";
      for each (var obj:Object in items)
      {
        if (obj.hasOwnProperty(Constants.PROP_NAME_LABEL))
          title+=obj[Constants.PROP_NAME_LABEL]+"--";
      }
      if (title.length > 2)
        title = title.substring(0, title.length - 2);
      return title;
    }

    private static function loadModule(dobj:DisplayObject, url:String, arg:Object=null):void
    {
      dobj=(dobj == null) ? Application.application.systemManager : dobj;
      dobj.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_MODULE, url, arg));
    }

    /**
     * 执行函数
     * command: 函数, 接口为function(MenuEvent, Object)
     * event: 菜单事件
     * args: 参数
     **/
    public static function executeCommand(command:Function, event:MenuEvent, args:Object=null):void
    {
      if (command != null)
      {
        if (args == null)
          command(event);
        else
          command(event, args);
      }
    }

    /**
     * 弹出窗口, 并通过对此窗口派发CommonEvent.CREATED事件传递参数args
     * clazz: 窗口类
     * title: 窗口标题
     * parent: 窗口的父对象
     * args: 参数
     **/
    public static function popupWindow(clazz:Class, title:String="", parent:DisplayObject=null, args:Object=null, fullScreen:Boolean=false):IFlexDisplayObject
    {
      var owner:DisplayObject=(parent == null) ? Application.application.systemManager : parent;
      // parent=(parent == null) ? Application.application.systemManager : parent;
      var popup:IFlexDisplayObject=PopUpManager.createPopUp(Application.application.systemManager, clazz, true);
      if (args is Array)
        popup.dispatchEvent(new CommonEvent(CommonEvent.CREATED, null, args as Array));
      else if (args is IList)
        popup.dispatchEvent(new CommonEvent(CommonEvent.CREATED, null, (args as IList).toArray()));
      else if (args is Object)
        popup.dispatchEvent(new CommonEvent(CommonEvent.CREATED, args, null));
      else
        popup.dispatchEvent(new CommonEvent(CommonEvent.CREATED));
      var delta:int=fullScreen ? 0 : 80;
      if (popup is TitleWindow)
      {
        var window:TitleWindow=popup as TitleWindow;
        if (owner is DisplayObjectContainer)
          window.owner=owner as DisplayObjectContainer;
        if (window.title == null || window.title == "")
          window.title=title;
        var swidth:Number=Application.application.screen.width;
        var sheight:Number=Application.application.screen.height;
        if (isNaN(window.explicitWidth) || window.explicitWidth > swidth)
          window.width=swidth-delta;
        if (isNaN(window.explicitHeight) || window.explicitHeight > sheight)
          window.height=sheight-delta;
      }
      PopUpManager.centerPopUp(popup);
      // popup.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
      // popup.addEventListener(KeyboardEvent.KEY_UP, keyUp);
      return popup;
    }

    /**
     * 激活StackView中的view子窗口, 并通过对此窗口派发CommonEvent.CREATED事件传递参数args
     * view: 子窗口
     * args: 参数
     **/
    public static function selectView(view:Container, args:Object=null):void
    {
      var vs:DisplayObject=findAncestor(view, ViewStack);
      if (vs is ViewStack)
      {
        (vs as ViewStack).selectedChild=view;
        view.callLater(function():void
          {
            if (args is Array)
              view.dispatchEvent(new CommonEvent(CommonEvent.CREATED, null, args as Array));
            else if (args is IList)
              view.dispatchEvent(new CommonEvent(CommonEvent.CREATED, null, (args as IList).toArray()));
            else if (args is Object)
              view.dispatchEvent(new CommonEvent(CommonEvent.CREATED, args, null));
            else
              view.dispatchEvent(new CommonEvent(CommonEvent.CREATED));
          });
      }
      ;
    }

//==================================== 通用按键事件处理过程  ====================================

    public static function keyDown(event:KeyboardEvent):void
    {
      processKey(event);
    }

    public static function keyUp(event:KeyboardEvent):void
    {
      processKey(event);
    }

    private static function processKey(event:KeyboardEvent):void
    {
      var dobj:DisplayObject=(event.target is DisplayObject) ? findAncestor(event.target as DisplayObject, Container) : null;
      var focusManager:IFocusManager=(dobj is Container) ? (dobj as Container).focusManager : Application.application.focusManager;
      var f1:Function=function(obj:Object):void // move to next component
        {
          var p:IFocusManagerComponent=focusManager ? focusManager.getFocus() : null;
          if (!p) return;
          var forward:Function=function():void
            {
              focusManager.moveFocus(FocusRequestDirection.FORWARD);
              var n:IFocusManagerComponent=focusManager.getFocus();
              if (n is Button)
                (n as Button).dispatchEvent(CommonEvent.MOUSE_CLICK_EVENT);
              else if (n is TextArea)
                event.keyCode=0;
              if (p == n)
                focusManager.moveFocus(FocusRequestDirection.TOP);
            };
          if (p is Button)
          {
            (p as Button).dispatchEvent(CommonEvent.MOUSE_CLICK_EVENT);
            return;
          }
          /**
           * TODO:
           * TextArea自身处理Ctrl+Enter会输入2个空行, Enter输入1个空行
           * 需要进一步实现Enter跳到下一个控件, Ctrl+Enter输入1个空行
           **/
          else if (p is TextArea)
          {
            return;
          }
          /*
             var comp:UIComponent=obj as UIComponent;
             if (comp) comp.callLater(forward);
             else forward();
           */
          forward();
        };
      var f2:Function=function(obj:Object):void	// clear comboBox
        {
          if (obj is ComboBox)
          {
            var cbox:ComboBox=obj as ComboBox;
            if (!cbox.editable)
            {
              cbox.selectedIndex=-1;
              cbox.dispatchEvent(CommonEvent.LIST_CHANGE_EVENT);
            }
          }
        };
      var f3:Function=function(obj:Object):void // escape;
        {
          if (obj is EventDispatcher)
          {
            (obj as EventDispatcher).dispatchEvent(CommonEvent.CLOSE_EVENT);
          }
        };
      switch (event.keyCode)
      {
        case Keyboard.ENTER:
          f1(event.currentTarget);
          break;
        case Keyboard.UP:
        case Keyboard.DOWN:
        case Keyboard.LEFT:
        case Keyboard.RIGHT:
          break;
        case Keyboard.DELETE:
          f2(event.currentTarget);
          break;
        case Keyboard.ESCAPE:
          f3(event.currentTarget);
          break;
      }
    }

    public static function gridKeyDown(event:KeyboardEvent):void
    {
      gridProcessKey(event);
    }

    private static function gridProcessKey(event:KeyboardEvent):void
    {
      var grid:Object=event.currentTarget;
      if (!(grid is AdvancedDataGrid) && !(grid is DataGrid))
        return;
      var f1:Function=function(grid:Object):void // move to next editable cell
        {
          var rc:Object=grid.editedItemPosition;
          if (rc)
          {
            var columnIndex:int=rc.columnIndex;
            var rowIndex:int=rc.rowIndex;
            var columnNext:int=-1, rowNext:int=rowIndex;
            var i:int,k:int;
            for (i=0; i < grid.columnCount; i++)
            {
              k=(i+columnIndex+1)%grid.columnCount;
              if (i>=grid.columnCount-columnIndex-1)
                rowNext=rowIndex+1;
              if (grid.columns[k].editable)
              {
                columnNext=k;
                break;
              }
            }
            if (rowNext >= grid.dataProvider.length)
              rowNext=0;
            if (columnNext >= 0 && columnNext < grid.columnCount)
            {
              grid.columns[columnIndex].dispatchEvent(CommonEvent.EXPAND_EVENT);
              k=grid.maxHorizontalScrollPosition+columnNext-grid.columnCount;
              if (k > 0) grid.horizontalScrollPosition=Math.min(columnNext, grid.maxHorizontalScrollPosition);
              grid.editedItemPosition={rowIndex: rowNext, columnIndex: columnNext};
            }
          }
        };
      switch (event.keyCode)
      {
        case Keyboard.ENTER:
          f1(grid);
          break;
        case Keyboard.UP:
        case Keyboard.DOWN:
        case Keyboard.LEFT:
        case Keyboard.RIGHT:
          break;
        case Keyboard.DELETE:
          break;
        case Keyboard.ESCAPE:
          break;
      }
    }

//==================================== List公用方法 ====================================

    public static function getListItems(list:ListBase):IList
    {
      return (list.dataProvider is IList) ? list.dataProvider as IList : EMPTY_ARRAY_COLLECTION;
    }

    /**
     * 移除list中arr包含的对象
     **/
    public static function removeListItems(list:ListBase, arr:Array=null):void
    {
      if (arr==null)
        arr=list.selectedItems;
      var coll:IList=getListItems(list);
      list.invalidateDisplayList();
      for (var i:int=arr.length - 1; i >= 0; i--)
      {
        coll.removeItemAt(coll.getItemIndex(arr[i]));
      }
      list.validateDisplayList();
    }

    public static function setDrag2List(list:ListBase, select:Boolean=false, validator:Function=null, filter:Function=null):void
    {
      list.dropEnabled=true;
      var f1:Function=function(event:DragEvent):void
        {
          var ds:DragSource=event.dragSource;
          var items:Array=[];
          for each (var f:String in ds.formats)
          {
            if (f == "items")
              continue;
            items=items.concat(ds.dataForFormat(f));
          }
          if (!(event.currentTarget is IUIComponent))
            return;
          var list:ListBase=event.currentTarget as ListBase;
          if (items != null && 
            (validator == null || (validator is Function && validator(event.dragInitiator, list, items))))
          {
            if (filter is Function)
              ds.addData(items.filter(filter), "items");
            else
              ds.addData(items, "items");
            DragManager.acceptDragDrop(list);
            event.action=DragManager.LINK;
            event.shiftKey=true;
          }
        };
      var f2:Function=function(event:DragEvent):void
        {
          var ds:DragSource=event.dragSource;
          var list:ListBase=event.currentTarget as ListBase;
          var arr:Array=ds.dataForFormat("items") as Array;
          var coll:IList=getListItems(list);
          var narr:Array=arr.filter(function(item:Object, idx:uint, arr:Array):Boolean
            {
              return indexOfObject(coll.toArray(), item) < 0;
            });
          ds.addData(narr, "items");
          if (!select)
          {
            if (event.dragInitiator is ListBase)
              (event.dragInitiator as ListBase).selectedItems=[];
          }
        };
      list.addEventListener(DragEvent.DRAG_ENTER, f1);
      list.addEventListener(DragEvent.DRAG_DROP, f2);
    }

    public static function setDrag4List(list:ListBase, move:Boolean=true):void
    {
      list.dragEnabled=true;
      list.allowDragSelection=true;
      list.dragMoveEnabled=move;
      var f1:Function=function(event:DragEvent):void
        {
          var list:ListBase=event.currentTarget as ListBase;
          if (list.dragMoveEnabled)
          {
            removeListItems(list, list.selectedItems);
          }
        };
      list.addEventListener(DragEvent.DRAG_COMPLETE, f1);
    }

//==================================== Grid公用方法 ====================================

    public static function getGridList(grid:Object):IList
    {
      return (grid.dataProvider is IList) ? grid.dataProvider as IList : EMPTY_ARRAY_COLLECTION;
    }

    public static function getGridData(grid:Object, excludes:Array=null):Array
    {
      var data:Array=[];
      var r:Array;
      var name:String;
      var f:Function;
      for each (var obj:Object in grid.dataProvider)
      {
        r=new Array();
        for each (var column:Object in grid.columns)
        {
          name=(column.dataTipField == null) ? column.dataField : column.dataTipField;
          if (excludes && excludes.indexOf(name) >= 0)
            continue;
          f=(column.labelFunction == null) ? grid.labelFunction : column.labelFunction;
          // r[name]=f(obj, column);
          r.push(f(obj, column));
        }
        data.push(r);
      }
      return data;
    }

    public static function getGridHeaders(grid:Object, excludes:Array=null):Object
    {
      var headers:Array=[];
      var columns:Object, column:Object, r:Object;
      var ml:int=1;
      var f:Function=function(column:Object, excludes:Array=null, level:int=1):Object
        {
          var name:String=(column.dataTipField == null) ? column.dataField : column.dataTipField;
          var r:Object={text:column.headerText, children:[], level:level, colspan:0, rowspan:0}, h:Object;
          if (excludes && excludes.indexOf(name) >= 0) return r;
          if (level > ml) ml=level;
          if (column is AdvancedDataGridColumnGroup)
          {
            for each (var c:Object in column.children)
            {
              h=f(c, excludes, level+1);
              if (h.colspan > 0)
              {
                r.children.push(h);
                r.colspan+=h.colspan;
              }
            }
          }
          else if (column is AdvancedDataGridColumn)
          {
            r.colspan=1;
          }
          return r;
        };
      columns=grid.groupedColumns ? grid.groupedColumns : grid.columns ? grid.columns : [];
      for each (column in columns)
      {
        r=f(column, excludes, 1);
        if (r.colspan > 0)
          headers.push(r);
      }
      CommonUtil.visit(headers, function(obj:Object):void
        {
          if (obj.hasOwnProperty("rowspan") && obj.hasOwnProperty("level") && obj.hasOwnProperty("colspan"))
            obj.rowspan=obj.colspan > 1 ? 1 : ml-obj.level+1;
        });
      return headers;
    }

    public static function gridLabelFunction(item:Object, column:Object):String
    {
      var value:Object=(column is DataGridColumn || column is AdvancedDataGridColumn) ? getAccessorValue(item, (column.dataTipField == null) ? column.dataField : column.dataTipField) : null;
      return (value == null) ? null 
        : (value is Date) ? DateUtil.formatDate(value)
        : value is Number && column.hasOwnProperty("formatter") && !column.formatter ? Constants.NUMBER_FORMATTER_N2.format(value)
        : value.toString();
    }

    public static function serialStyleFunction(data:Object, column:Object):Object
    {
      column.setStyle("backgroundColor", Constants.LightGray);
      return {color:Constants.Blue, fontWeight:"bold", textAlign:"center"};
    }

    public static function serialLabelFunction(item:Object, column:Object):String
    {
      if (column is DataGridColumn || column is AdvancedDataGridColumn)
      {
        var grid:Object=column.owner;
        var df:String=column.dataTipField;
        if (item.hasOwnProperty(df) && item[df] != null)
          return item[df];
        if (grid != null && grid.dataProvider is IList)
        {
          var list:IList=grid.dataProvider as IList;
          return (list.getItemIndex(item)+1).toString();
        }
      }
      return "";
    }

    public static function complexColumnCompare(obj:Object):void
    {
      if (obj is AdvancedDataGridColumn)
      {
        var column:AdvancedDataGridColumn=obj as AdvancedDataGridColumn;
        if (column.dataTipField != null && column.dataTipField.indexOf(".") >= 0)
        {
          column.sortCompareFunction=function(o1:Object, o2:Object):int
          {
            var v1:Object=getAccessorValue(o1, column.dataTipField);
            var v2:Object=getAccessorValue(o2, column.dataTipField);
            return ObjectUtil.compare(v1, v2);
          }
        }
      }
    }

    public static function setDataGridColumns(obj:Object, bundle:String="gcc", prefix:String="", callback:Function=null):void
    {
      if (prefix == null)
        prefix="";
      if (prefix != "")
        prefix=prefix + ".";
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      var columns:Array=[];
      if (obj is DataGrid)
      {
        var dg:DataGrid=obj as DataGrid;
        columns=columns.concat(dg.columns);
        if (!dg.descriptor.properties.hasOwnProperty("itemRenderer"))
          dg.itemRenderer=new ClassFactory(Label);
      }
      else if (obj is AdvancedDataGrid)
      {
        var adg:AdvancedDataGrid=obj as AdvancedDataGrid;
        if (!adg.descriptor.properties.hasOwnProperty("itemRenderer"))
          adg.itemRenderer=new ClassFactory(Label);
        columns=columns.concat(adg.columns);
        columns=columns.concat(adg.groupedColumns);
        if (!adg.sortableColumns && !adg.descriptor.properties.hasOwnProperty("headerSortSeparatorSkin"))
        {
          adg.setStyle("headerSortSeparatorSkin", ProgrammaticSkin);
          adg.headerRenderer=Constants.ZERO_ADG_HEADER_RENDERER;
        }
      }
      visit(columns, function(obj:Object):void
        {
          if (obj is DataGridColumn || obj is AdvancedDataGridColumn || obj is AdvancedDataGridColumnGroup)
          {
            var field:String=(obj.dataTipField == null) ? obj.dataField : obj.dataTipField;
            var s:String=resourceManager.getString(bundle, prefix + obj.dataTipField);
            if (s == null) s=resourceManager.getString(bundle, prefix + obj.dataField);
            if (s == null) s=resourceManager.getString("gcc", obj.dataTipField);
            if (s == null) s=resourceManager.getString("gcc", obj.dataField);
            if (obj.headerText == obj.dataField && s != null)
              obj.headerText=s;
            if (!(obj is AdvancedDataGridColumnGroup) && !(obj.hasOwnProperty("width")))
            {
              s=resourceManager.getString(bundle, prefix + field + ".width");
              obj.width=getInt(s, Constants.DEFAULT_DATAGRID_COLUMN_WIDTH);
            }
            obj.showDataTips=true;
            if (callback != null)
            {
              callback(obj);
            }
          }
        });
    }

    private static function getInt(s:String, defValue:int=0):int
    {
      var r:int=defValue;
      try
      {
        if (s != null)
          r=int(s);
      }
      catch (error:Error)
      {
      }
      return r;
    }

//==================================== ComboBox公用方法 ====================================

    public static function selectItem(item:Object, array:ArrayCollection, box:ComboBox):void
    {
      box.selectedIndex = -1;
      var i:int=indexOfKey(array.toArray(), item, "id");
      if (i >= 0)
        box.selectedItem = array[i];
    }

    public static function selectDefaultItem(box:Object, value:Object):void
    {
      if (box.dataProvider != null && box.dataProvider is IList)
      {
        var values:IList=box.dataProvider as IList;
        if (value != null)
        {
          var k:int=CommonUtil.indexOfKey(values.toArray(), value, Constants.PROP_NAME_VALUE);
          value=(k >= 0) ? values.getItemAt(k) : null;
        }
      }
      else if (!box.hasEventListener(CollectionEvent.COLLECTION_CHANGE))
      {
        box.addEventListener(CollectionEvent.COLLECTION_CHANGE, function(e:Event):void
          {
            if (e == null || !e.currentTarget is ComboBox)
              return;
            var box:ComboBox=e.currentTarget as ComboBox;
            selectDefaultItem(box, value);
          });
      }
      box.selectedItem=value;
    }

    /**
     * 返回所有父对象集合
     **/
    public static function getAncestors(obj:Object, node:Object=null):Array
    {
      if (obj is Tree)
        return getTreeAncestors(obj as Tree, node);
      else if (obj is Menu)
        return getMenuAncestors(obj as Menu, node);
      else
        return [];
    }

    private static function getTreeAncestors(tree:Tree, node:Object=null):Array
    {
      if (node==null)
        node=tree.selectedItem;
      var nodes:Array=new Array();
      while (node != null)
      {
        nodes.unshift(node);
        node=tree.getParentItem(node);
      }
      return nodes;
    }

    private static function getMenuAncestors(menu:Menu, node:Object=null):Array
    {
      if (node==null)
        node=menu.selectedItem;
      var nodes:Array=new Array();
      var k:int;
      var obj:Object=menu;
      while (obj != null)
      {
        nodes.unshift(node);
        if (!(obj.owner is Menu) && !(obj.owner is MenuBar))
          break;
        k=indexOfKey(obj.owner.dataProvider.source, obj.dataProvider.source, "children");
        if (k >= 0)
        {
          node=obj.owner.dataProvider[k];
          obj=obj.owner;
        }
        else
          break;
      }
      return nodes;
    }

//==================================== 输入验证公用方法 ====================================

    public static function genDateValidator(format:String):Validator
    {
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      var v:DateValidator=new DateValidator();
      v.inputFormat=format;
      v.formatError=resourceManager.getString("gcc", "date.format.error", [format]);
      return v;
    }

    public static function genComboBoxValidator(combo:ComboBox, key:String=null):Validator
    {
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      var v:ComboBoxValidator=new ComboBoxValidator();
      v.combo=combo;
      v.key=(key == null) ? (combo.labelField == null) ? "label" : combo.labelField : key;
      v.notInListError=resourceManager.getString("gcc", "value.notInList.error");
      return v;
    }

    /**
     * 验证表单输入值的合法性, 返回false表示输入不合法, 并显示错误提示
     * form: 待验证的表单
     * fields: 需要验证的"列"数组, 如下格式:
     * 		["no", "name", "depart"]
     * 		或者 [{field:"no", validator:v1, error:e1}, {field:"name", validator:v2, error:e2}, ...]
     * callback: 验证前的回调函数, 接口为function(Object):void
     * defVal: 缺省的验证器
     **/
    public static function validateForm(form:Object, fields:Array, callback:Function=null, defVal:Validator=null, defError:String=null):Boolean
    {
      var resourceManager:IResourceManager=ResourceManager.getInstance();
      var items:Array=getItems(form);
      var names:Array=[];
      var field:Object;
      var k:int;
      var val:Validator;
      var vre:ValidationResultEvent;
      var error:String;
      var obj:Object;
      if (defVal == null)
        defVal=Constants.VALIDATOR_NOEMPTY;
      if (defError == null)
        defError=resourceManager.getString("gcc", "value.required.error");
      for each (field in fields)
      {
        if (field is String)
          names.push(field);
        else if (field.hasOwnProperty(Constants.PROP_NAME_FIELD))
          names.push(field[Constants.PROP_NAME_FIELD]);
      }
      for each (var item:Object in items)
      {
        k=names.indexOf(item[Constants.PROP_NAME_NAME]);
        if (k < 0)
          continue;
        field=fields[k];
        obj=item[Constants.PROP_NAME_OBJECT];
        error=field.hasOwnProperty(Constants.PROP_NAME_ERROR) ? field[Constants.PROP_NAME_ERROR] 
          : item.hasOwnProperty("errorString") ? item.errorString : defError;
        val=field.hasOwnProperty(Constants.PROP_NAME_VALIDATOR) ? field[Constants.PROP_NAME_VALIDATOR] 
          : (obj is DateField && obj.editable) ? genDateValidator(obj.formatString)
          : (obj is ComboBox && obj.editable) ?  genComboBoxValidator(obj as ComboBox)
          : defVal;
        if (val == null)
          continue;
        val.requiredFieldError=error;
        vre=val.validate(item[Constants.PROP_NAME_VALUE]);
        if (vre.type == ValidationResultEvent.INVALID)
        {
          obj.errorString=vre.message;
          showError(obj);
          obj.errorString=null;
          return false;
        }
      }
      return true;
    }

    /**
     * 验证表格输入值的合法性, 返回false表示输入不合法, 并显示错误提示
     * grid: 待验证的表格
     * fields: 需要验证的"列"数组, 如下格式:
     * 		["no", "name", "depart"]
     * 		或者 [{field:"no", validator:v1, error:e1}, {field:"name", validator:v2, error:e2}, ...]
     * callback: 验证前的回调函数, 接口为function(Object):void
     * maxError: 返回的错误数, -1为全部
     * delay: errorTooltip显示的延时, <=0 不显示
     * defVal: 缺省的验证器
     * TOFIX:
     * 1. 在设置编辑焦点和显示错误提示前, 对column发expand事件
     * 2. 在SuperDataGridHeaderRenderer中增加column/columnGroup对Expand/Collapse事件的处理
     * 3. 解决Error #1009: Cannot access a property or method of a null object reference.错误.
     *    由于一些column被收起(visible=false)引起此错误, editedItemPosition和horizontalScrollPosition需要考虑visible=false的column
     **/
    public static function validateGrid(grid:Object, fields:Array, callback:Function=null, maxError:int=1, delay:int=2000, defVal:Validator=null, defError:String=null):Array
    {
      var errors:Array=[];
      var count:int=0;
      if (grid is DataGrid || grid is AdvancedDataGrid)
      {
        var list:IList=getGridList(grid);
        var columns:Array=grid.columns as Array;
        var resourceManager:IResourceManager=ResourceManager.getInstance();
        var val:Validator;
        var vre:ValidationResultEvent;
        var f:String;
        var rowIndex:int;
        var columnIndex:int;
        var error:String;
        var i:int;
        var value:Object;
        if (defVal == null)
          defVal=Constants.VALIDATOR_NOEMPTY;
        if (defError == null)
          defError=resourceManager.getString("gcc", "grid.value.required.error");
        for each (var item:Object in list)
        {
          if (callback is Function)
            callback(item);
          for each (var field:Object in fields)
          {
            f=field.hasOwnProperty(Constants.PROP_NAME_FIELD) ? field[Constants.PROP_NAME_FIELD] : field is String ? field as String : null;
            val=field.hasOwnProperty(Constants.PROP_NAME_VALIDATOR) ? field[Constants.PROP_NAME_VALIDATOR] : defVal;
            if (f == null || val == null)
              continue;
            value=getAccessorValue(item, f);
            val.source=item;
            val.property=f;
            vre=val.validate(value);
            if (vre.type == ValidationResultEvent.INVALID)
            {
              rowIndex=list.getItemIndex(item);
              // var columnIndex:int=indexOfKey(columns, f, "dataField");
              columnIndex=-1;
              for (i=0; i < columns.length; i++)
              {
                if (columns[i].dataField == f || columns[i].dataTipField == f)
                {
                  columnIndex=i;
                  break;
                }
              }
              error=field.hasOwnProperty(Constants.PROP_NAME_ERROR) ? field[Constants.PROP_NAME_ERROR] : defError;
              if (columnIndex >= 0)
              {
                var name:String=columns[columnIndex].headerText;
                error=StringUtil.substitute(error, [rowIndex+1, columnIndex+1, name]);
                val.requiredFieldError=error;
                /**
                 * 如果发生错误的列已被收起(visible=false), 派发expand事件展开
                 **/
                columns[columnIndex].dispatchEvent(CommonEvent.EXPAND_EVENT);
                /**
                 * 设置grid的滚动条位置:
                 * horizontalScrollPosition的值为当前显示的第一列
                 * maxHorizontalScrollPosition的值为当前显示的所有列(不包括visible=false的列)
                 **/
                var vColumnIndex:int=indexOfKey(columns, f, "dataField", function(obj:Object, key:Object, attr:String):Boolean
                  {
                    return obj.visible;
                  });
                grid.horizontalScrollPosition=Math.min(vColumnIndex, grid.maxHorizontalScrollPosition);
                grid.editedItemPosition={rowIndex: rowIndex, columnIndex: columnIndex};
                /**
                 * 设置grid的editedItemPosition之后如果接着访问grid的itemEditorInstance对象将返回null
                 * 此时可以通过callLater延迟调用来访问grid的itemEditorInstance对象
                 * grid的editedItemPosition设置当前编辑项的位置, 不论此单元格所在的列是否隐藏
                 **/
                grid.callLater(function():void
                  {
                    /**
                     * TOFIX:
                     * 设置grid的horizontalScrollPosition将有一个pending的动作,
                     * 此时itemEditorInstance的x, y尚未最终确定, 调用showError将计算出错误的位置.
                     * 其他调用validateXXX(), callLater或调整语句顺序均无法解决,
                     * 目前暂时通过setTimeout的方法解决.
                     **/
                    flash.utils.setTimeout(function():void
                      {
                        if (grid.itemEditorInstance is UIComponent)
                        {
                          if (delay > 0)
                          {
                            var editor:UIComponent=grid.itemEditorInstance as UIComponent;
                            editor.errorString=vre.message;
                            showError(editor, delay);
                            editor.errorString=null;
                          }
                        }
                        else
                        {
                          grid.errorString=error;
                        }}, 100);
                  });
              }
              else
              {
                error=StringUtil.substitute(error, [rowIndex+1]);
              }
              errors.push({rowIndex: rowIndex, columnIndex: columnIndex, error: error, header: name, name: f, value: value});
              count++;
              if (count >= maxError && maxError > 0)
                return errors;
            }
          }
        }
        grid.errorString=null;
      }
      return errors;
    }

    public static function showError(obj:Object, delay:int=2000, error:String=null):void
    {
      var comp:UIComponent=null;
      var err:String=null;
      if (delay <= 0)
        return;
      if (error == null)
        error="Unknown Error!";
      if (obj is ValidationResultEvent)
      {
        var vre:ValidationResultEvent=obj as ValidationResultEvent;
        err=vre.message;
        if (vre.currentTarget is Validator)
        {
          var v:Validator=vre.currentTarget as Validator;
          if (v.source is UIComponent)
          {
            comp=v.source as UIComponent;
          }
        }
      }
      else if (obj is UIComponent)
      {
        comp=obj as UIComponent;
        err=comp.errorString;
      }
      if (!err)
        err=error;
      if (comp != null)
      {
        var p:Point=comp.localToGlobal(new Point(comp.width, 0));
        var owner:UIComponent=comp.owner as UIComponent;
        var errorTip:ToolTip=ToolTipManager.createToolTip(err, p.x, p.y, "errorTipRight") as ToolTip;
        // trace("comp.width=" + comp.width + ", p.x=" + p.x + ", p.y=" + p.y);
        var f1:Function=function(errorTip:ToolTip):Number
          {
            var tf:UITextField=new UITextField();
            tf.autoSize=TextFieldAutoSize.LEFT;
            tf.mouseEnabled=false;
            tf.multiline=true;
            tf.selectable=false;
            tf.wordWrap=false;
            tf.styleName=errorTip;
            tf.text=errorTip.text;
            tf.width=errorTip.width;
            return tf.height;
          };
        var f2:Function=function(errorTip:ToolTip):Number
          {
            var tf:UITextField=errorTip.getChildAt(1) as UITextField;
            return tf.height + 18;
          };
        if (errorTip.x + errorTip.width > Capabilities.screenResolutionX)
        {
          errorTip.x -= comp.width;
          errorTip.y += comp.height;
          if (errorTip.x + errorTip.width > Capabilities.screenResolutionX)
          {
            // errorTip.width=Capabilities.screenResolutionX-errorTip.x;
            errorTip.width=comp.width;
            // errorTip.callLater(function():void{errorTip.validateSize();});
            // errorTip.height=120;
            errorTip.validateNow();
            errorTip.height=f2(errorTip);
          }
          errorTip.setStyle("borderStyle", "errorTipBelow");
        }
        if (errorTip.y + errorTip.height > Capabilities.screenResolutionY)
        {
          // errorTip.setStyle("borderStyle", "errorTipAbove");
        }
        // errorTip.setStyle("styleName", "errorTip");
        comp.setFocus();
        flash.utils.setTimeout(function():void{ToolTipManager.destroyToolTip(errorTip);}, delay, null);
      }
    }

  }
}