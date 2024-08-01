# Templates

* Some templates that MIGHT be useful

## FlxSprite

```haxe
var sprite:FlxSprite;
function createPost(){        
	sprite.loadGraphic(Util.getImage('image name lol')); // automatically uses .png
	sprite.screenCenter();
	sprite.visible = true;
	sprite.antialiasing = true;
	add(sprite);
}

function update(elapsed){
    // update function
}

function updatePost(elapsed){
    // after the update function is called
}
```

## FlxText
```haxe
// import flixel.util.FlxColor; // uncomment if you're gonna use a font and color
function createPost(){    
    var text = new FlxText(0, 0, 0, "text here lol", 16);
    //text.setFormat(Util.getFont('vcr.ttf'), 16, FlxColor.WHITE, null, null, FlxColor.BLACK); // uncomment if you wanna add a font and shit 
	text.screenCenter();
	add(text);
}

function update(elapsed){
    // update function
}

function updatePost(elapsed){
    // after the update function is called
}
```
