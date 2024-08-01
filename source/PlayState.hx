package;

import flixel.text.FlxText;
import flixel.FlxState;
import Script;
import flixel.FlxG;
import sys.FileSystem;
import sys.io.File;
import sys.FileSystem;
using StringTools;

class PlayState extends FlxState
{
    var script:Script;
    var scripts:Array<Script>;

    override public function create()
    {
        scripts = [];
        var scriptDir:String = 'assets/data';

        if (FileSystem.exists(scriptDir) && FileSystem.isDirectory(scriptDir)) {
            var files = FileSystem.readDirectory(scriptDir);
            for (file in files) {
                if (file.endsWith(".hx")) {
                    var scriptPath = scriptDir + "/" + file;
                    try {
                        var scriptContent = File.getContent(scriptPath);
                        var newScript = new Script();
                        newScript.loadScript(scriptContent);
                        scripts.push(newScript);
                        trace("SCRIPT " + file + " FOUND AND RUNNING LOL!");
                    } catch (e:Dynamic) {
                        trace("Error reading script " + file + ": " + e);
                        showNoScriptText(file);
                    }
                }
            }
        } else {
            showNoScriptText(null);
        }

        for (script in scripts) {
            script.interp.variables.set("add", function(value:Dynamic)
            {
                add(value);
            });
            script.call("onCreate");
        }

        super.create();

        for (script in scripts) {
            script.call("createPost");
        }
    }

    override public function update(elapsed:Float)
    {
        for (script in scripts) {
            script.call("update", [elapsed]);
        }

        if (FlxG.keys.justPressed.R)
            FlxG.switchState(new PlayState());

        super.update(elapsed);

        for (script in scripts) {
            script.call("updatePost", [elapsed]);
        }
    }

    function showNoScriptText(fileName:String) {
        var textMessage = "No HScript file found, or it's not formatted properly!";
        if (fileName != null) {
            textMessage = "Error reading script " + fileName + ", or it's not formatted properly!";
        }
        var text = new FlxText(0, 0, 0, textMessage, 64);
        text.screenCenter();
        add(text);
        trace(textMessage);
    }
}
