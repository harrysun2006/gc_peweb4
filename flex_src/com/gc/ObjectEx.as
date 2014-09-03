package com.gc
{
  [RemoteClass(alias="flex.messaging.io.amf.ASObject")]
  [Bindable]
  public dynamic class ObjectEx
  {

    public var toString_fun:Function;

    public function ObjectEx()
    {
    }

    public function toString():String
    {
      return toString_fun is Function ? toString_fun(this) : "";
    }
  }
}