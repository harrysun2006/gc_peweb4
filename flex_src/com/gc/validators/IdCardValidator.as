package com.gc.validators
{

  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;
  import mx.utils.StringUtil;
  import mx.validators.ValidationResult;
  import mx.validators.Validator;

  public class IdCardValidator extends Validator
  {
    public function IdCardValidator()
    {
    }

    override protected function doValidation(value:Object):Array
    {
      var results:Array=[];
      var result:ValidationResult=validateId(value);
      if (result)
        results.push(result);
      return results;
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

    private function validateId15(id:String):ValidationResult
    {
      return null;
    }

    private function validateId18(id:String):ValidationResult
    {
      var wi:Array=[7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2,1];
      var ai:Array=["1","0","X","9","8","7","6","5","4","3","2"];
      var i:int, sum:int=0;
      for (i=0; i < id.length-1; i++)
      {
        sum+=Number(id.charAt(i))*wi[i];
      }
      return (id.charAt(17) == ai[sum%11]) ? null : new ValidationResult(true, null, "icv.error", getString("gcc", "icv.error"));
    }

    private function validateId(value:Object):ValidationResult
    {
      var id:String=value ? value.toString() : "";
      id=StringUtil.trim(id);
      if (id.length == 15)
        return validateId15(id);
      else if (id.length == 18)
        return validateId18(id);
      else if (id.length > 0)
        return new ValidationResult(true, null, "icv.error.wrong.length", getString("gcc", "icv.error.wrong.length"));
      return null;
    }
  }
}