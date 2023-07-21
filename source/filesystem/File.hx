package filesystem;

import sys.io.File;
import sys.FileSystem;

class File
{
    public static function exists(path:String) {
        FileSystem.exists(path);
    }
    public static function makeDirectory(path:String) {
        FileSystem.createDirectory(path);
    }
	public static function saveContent(path:String, fileData:String, ext:String)
	{
		File.saveContent(path + ext, fileData);
	}
    public static function absPath(path:String = '')
        {
            FileSystem.absolutePath(path);
        }
	public static function saveClipboard(fileData:String = '')
	{
		openfl.system.System.setClipboard(fileData);
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!exists(savePath))
			saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}
    public static function saveBytes(copy:String, save:String)
    {
        File.saveBytes(save, OpenFlAssets.getBytes(copy));
    }
}