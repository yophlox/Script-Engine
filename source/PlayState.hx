package;

import flixel.text.FlxText;
import flixel.FlxState;
import Script;
import flixel.FlxG;

class PlayState extends FlxState
{
    var script:Script;
    var scriptPath:String = 'assets/data/script.hx';

    override public function create()
    {
        script = new Script();

        if (sys.FileSystem.exists(scriptPath)) {
            try {
                var scriptContent = sys.io.File.getContent(scriptPath);
                script.loadScript(scriptContent);
                trace("SCRIPT FOUND AND RUNNING LOL!");
            } catch (e:Dynamic) {
                trace("Error reading script: " + e);
                showNoScriptText();
            }
        } else {
            showNoScriptText();
        }

        script.interp.variables.set("add", function(value:Dynamic)
        {
            add(value);
        });

        script.call("onCreate");
		super.create();
        script.call("createPost");
    }

    override public function update(elapsed:Float)
    {
        script.call("update", [elapsed]);
		if (FlxG.keys.justPressed.R)
			FlxG.switchState(new PlayState());
        super.update(elapsed);
		script.call("updatePost", [elapsed]);

    }

    function showNoScriptText() {
        var text = new FlxText(0, 0, 0, "No HScript file found, or it's not formatted properly!", 64);
        text.screenCenter();
        add(text);
        trace("no script found in the data folder!");
    }
}
