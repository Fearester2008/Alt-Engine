package parse;

#if sys
import sys.io.File;
#else
import lime.utils.Assets;
#end

class HaxeParser
{
    public static var parser:Parser = new Parser();
	public var interp:Interp = new Interp();

    public function new(path:String) {
        @:privateAccess
		parser.line = 1;
		parser.allowTypes = true;
        #if sys
        return inters.execute(parser.parseString(File.getContent(path)));
        #else
		return interp.execute(parser.parseString(Assets.getText(path)));
        #end

        for (lib in ['StringTools', 'Std', 'Reflect', 'Type'])
            addCallback(lib, Type.resolveClass(lib));

        addCallback('import', function(lib:String, like:String) {
            var libPack:Array<String> = lib.split('.');
			var libName:String = libPack[libPack.length - 1];
			
			if (like != null && like != '')
				libName = like;

			try
				addCallback(libName, Type.resolveClass(lib));
        });
    }

    public function callFunction(event:String, args:Array<Dynamic>)
    {
        if (!variables.exists(name)) {
            return;
        }
        var method = variables.get(name);
        switch(value.length)
        {
            case 0:
                method();
            case 1:
                method(args[0]);
            case 2:
                method(args[0], args[1]);
            case 3:
                method(args[0], args[1], args[2]);
            case 4:
                method(args[0], args[1], args[2], args[3]);
            case 5:
                method(args[0], args[1], args[2], args[3], args[4]);
            case 6:
                method(args[0], args[1], args[2], args[3], args[4], args[5]);
            case 7:
                method(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
            case 8:
                method(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
            case 9:
                method(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
            case 10:
                method(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
        } // WOWOWOOWOWOOWOWOWOOWWOWOWWWOOWOOOWOWOWOWOOWOWOWOWOWOWOOWOWOWOWOWOOWOWOWOWOWOWOWO
    }

    public function addCallback(name:String, value:Dynamic) {
        interp.variables.set(name, value);
    }
}
