package alt.macros.helpers;

class CompileTime
{
  public static var startTimeString;
  public static var endTimeString;

  public static var startTime;
  public static var endTime;

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
                startTimeString = null;
                endTimeString = null;
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
                startTime = null;
                endTime = null;
        }
    }
  
}
