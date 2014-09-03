package com.gc.util
{
  import mx.rpc.remoting.RemoteObject;

  public class FaultUtil
  {
    private static function singleton():void
    {
    }

    public function FaultUtil(caller:Function=null)
    {
      if (caller != singleton)
        throw new Error("FaultUtil is a non-instance class!!!");
    }

    public static function getGenericFaultHandler(service:RemoteObject, faultHandler:Function):Function
    {
      var h:FaultHandler=new FaultHandler(service, faultHandler);
      return h.genericFaultHandler;
    }
  }
}

import mx.controls.Alert;
import mx.rpc.remoting.RemoteObject;
import mx.rpc.events.FaultEvent;
import mx.utils.ObjectUtil;

import com.gc.Constants;
import com.gc.util.FaultUtil;
import mx.messaging.messages.IMessage;
import mx.rpc.Fault;

class FaultHandler
{
  private var service:RemoteObject;
  private var faultHandler:Function;

  public var genericFaultHandler:Function;

  public function FaultHandler(service:RemoteObject, faultHandler:Function)
  {
    this.service=service;
    this.faultHandler=faultHandler;
    this.genericFaultHandler=onGenericFault;
  }

  private function onGenericFault(e:FaultEvent, args:Object=null):void
  {
    if (faultHandler != null)
    {
      faultHandler(e);
      e.preventDefault();
    }
    else
    {
      if (service.hasEventListener(FaultEvent.FAULT))
      {
      }
      else
      {
        e.preventDefault();
        // Alert.show(ObjectUtil.toString(e));
        if (e.fault.faultCode == "ConcurrencyError" && e.fault.rootCause == null)
          return;
        var message:String=e.fault.rootCause.hasOwnProperty("message") ? e.fault.rootCause.message : e.fault.faultString;
        if (e.fault.faultCode == "Channel.Call.Failed")
          message=Constants.RESOURCE_MANAGER.getString("gcc", "channel.call.error");
        else if (e.fault.faultCode == "Client.Error.MessageSend")
          message=Constants.RESOURCE_MANAGER.getString("gcc", "client.message.send.error");
        // else if (e.fault.faultCode == "Server.Processing")
        //  message=Constants.RESOURCE_MANAGER.getString("gcc", "server.processing.error");
        Alert.show(message, Constants.RESOURCE_MANAGER.getString("gcc", "service.call.error", [service.destination, e.token.message["operation"]]), Alert.OK, null, null, Constants.ICON32_ERROR);
      }
    }
  }
}