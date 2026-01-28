package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Darkness extends FlxSprite
{
	public function new()
	{
		super();

		makeGraphic(1, 1, FlxColor.BLACK);

		setGraphicSize(600, 2000);
		updateHitbox();

		velocity.x = 50;
	}
}
