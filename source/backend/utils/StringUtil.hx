package backend.utils;
class StringUtil
{
    public static function toTitleCase(input:String, ?split:String = " ", ?join:String = " "):String
    {
        return input.split(split).map(function(word) {
            return word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
        }).join(join);
    }
}