package alt.macros.helpers;

class CompileTime
{
  public static var startTime:Date;
  public static var endTime:Date;

  public static function get(time:String = null)
    {
        switch(time) 
        {
            case 'start':
                startTime = Date.now();
                return startTime;
            case 'end':
                endTime = Date.now();
                return endTime;
        }
      return;
    }
}
