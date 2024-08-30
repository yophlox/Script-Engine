# Templates

* Some templates that MIGHT be useful

## FlxSprite

```haxe
var sprite:FlxSprite;
function createPost(){       
	if (sprite == null) {
		sprite = new FlxSprite();
	}
	var graphic = AssetSystem.getGraphic("haxeflixellogo.png");
	if (graphic == null) {
		trace('createPost: Failed to load graphic');
		return;
	}
	sprite.loadGraphic(graphic);	
	sprite.screenCenter();
	sprite.visible = true;
	sprite.antialiasing = true;
	sprite.updateHitbox();
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
    //text.setFormat(AssetSystem.getContent('fonts/fnf.ttf'), 16, FlxColor.WHITE, null, null, FlxColor.BLACK); // uncomment if you wanna add a font and shit 
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
