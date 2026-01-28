package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		var game = new FlxGame(0, 0, PlayState, 60, 60, true);
		FlxG.stage.showDefaultContextMenu = false;
		FlxSprite.defaultAntialiasing = false;
		FlxG.autoPause = false;
		addChild(game);
	}
}
