package alt.macros.helpers;

class CompileTime
{
  public static var startTimeString:String;
  public static var endTimeString:String;

  public static var startTime:Float;
  public static var endTime:Float;

  public static function getToString(time:String = null)
    {
        switch(time) 
        {
            case 'start':
                startTimeString = Date.now().toString();
                return startTimeString;
            case 'end':
                endTimeString = Date.now().toString();
                return endTimeString;
            default:
                return null;
        }
    }
  
  public static function getFromString(time:String = null)
    {
        switch(time) 
        {
            case 'start':
                startTime = Date.now().getTime() / 1000;
                return startTime;
            case 'end':
                endTime = Date.now().getTime() / 1000;
                return endTime;
            default:
                return null;
        }
    }
  
}
