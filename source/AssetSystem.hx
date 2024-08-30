package;

import haxe.Json;
import sys.io.File;
import haxe.io.Path;
import openfl.Assets;
import sys.FileSystem;
import openfl.media.Sound;
import flixel.system.FlxSound;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class AssetSystem {
    private static var supportExt:Array<String> = ['txt', 'json', 'hx', 'xml', 'png', 'jpg', 'mp3', 'ogg', 'wav', 'ttf'];

    public static function getPath(path:String, ?addDir:String):String 
    {
        if (addDir == null)
            addDir = '';

        var fullPath:String = path;
        fullPath = Path.normalize(fullPath);

        trace(fullPath);

        if (!FileSystem.exists(fullPath))
        {
            trace('Directory $fullPath does not exist.');

            fullPath = Path.normalize('assets/$addDir/$path');

            if (!FileSystem.exists(fullPath))
            {
                trace('File not found in assets directory: $fullPath');
                return null;
            }
            else
            {
                trace('File found in assets directory: $fullPath');
            }
        }

        return fullPath;
    }

    private static function isValidExt(ext:String)
    {
        for (exten in supportExt)
        {
            if (exten.toLowerCase() == ext.toLowerCase())
            {
                return true;
                break;
            }
        }

        return false;
    }

    public static function getAsset(path:String):Dynamic
    {
        trace('File to load: ' + path + ' - path may not be accurate to final path.');

        var ext:String = Path.extension(path).toLowerCase();

        switch (ext)
        {
            default:
                var fullPath:String = getPath(path);

                #if debug
                trace('Attempting to return bytes');
                #end

                if (FileSystem.exists(fullPath))
                    return File.getBytes(fullPath);
                else{
                    #if debug
                    trace('Returning Null');
                    #end

                    return null;
                }
            case 'png' | 'jpg' | 'jpeg':
                return getGraphic(path);
            case 'txt' | 'json' | 'hx' | 'xml':
                return getContent(path);
            case 'ogg' | 'wav' | 'mp3':
                return getSound(path);
        }
    }

    public static function getContent(path:String):String
    {
        var path:String = getPath(path);
        trace('getContent: Attempting to load from path: $path');

        var ext:String = Path.extension(path).toLowerCase();

        if (isValidExt(ext))
        {
            if ((ext == 'txt' || ext == 'json' || ext == 'hx' || ext == 'xml') && FileSystem.exists(path))
            {
                var content = File.getContent(path);
                trace('getContent: Successfully loaded content from $path');
                trace('getContent: Content size: ${content.length} characters');
                return content;
            }
            else if (ext == 'ttf' && FileSystem.exists(path))
            {
                trace('getContent: TTF file found, returning path');
                return path;
            }
        }

        trace('getContent: Failed to load content from $path');
        return null;
    }

    public static function getSound(path:String) 
    {
        var path:String = getPath(path);
        trace(path);

        var ext:String = Path.extension(path).toLowerCase();

        if (isValidExt(ext)){
            if ((ext == 'ogg' || ext == 'wav' || ext == 'mp3') && FileSystem.exists(path)){
                return Sound.fromFile(path);
            }
        }

        return null;
    }

    public static function getGraphic(path:String):FlxGraphicAsset
    {
        var fullPath = getPath(path, "images");
        trace('getGraphic: Attempting to load from path: $fullPath');
        
        if (fullPath == null)
        {
            trace('getGraphic: Path is null, returning null');
            return null;
        }

        var graphic = FlxG.bitmap.add(fullPath);
        if (graphic == null)
        {
            trace('getGraphic: Failed to load graphic from $fullPath');
        }
        else
        {
            trace('getGraphic: Successfully loaded graphic from $fullPath');
        }
        
        return graphic;
    }

	inline static public function getSparrowAtlas(path:String) 
    {
        return FlxAtlasFrames.fromSparrow(getGraphic('$path.png'), getContent('$path.xml'));
    }

    inline static public function getPackerAtlas(path:String) 
    {
        return FlxAtlasFrames.fromSpriteSheetPacker(getGraphic('$path.png'), getContent('$path.txt'));
    }

    public static function assetExists(path:String):Bool 
    {
        var fullPath:String = getPath(path);

        #if debug
        trace('Checking for file: ' + fullPath);
        #end

        if (FileSystem.exists(fullPath))
            return true;

        return false;
    }

    public static function getFontBytes(path:String):haxe.io.Bytes
    {
        var fullPath = getPath(path, "fonts");
        trace('getFontBytes: Attempting to load from path: $fullPath');
        
        if (fullPath == null)
        {
            trace('getFontBytes: Path is null, returning null');
            return null;
        }

        if (FileSystem.exists(fullPath))
        {
            var bytes = File.getBytes(fullPath);
            trace('getFontBytes: Successfully loaded font bytes from $fullPath');
            return bytes;
        }

        trace('getFontBytes: Failed to load font bytes from $fullPath');
        return null;
    }
}