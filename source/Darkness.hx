package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;

class Darkness extends FlxSprite
{
	var gradient:FlxSprite;

	public function new()
	{
		super();

		makeGraphic(1, 1, FlxColor.BLACK);

		setGraphicSize(600, 2000);
		updateHitbox();

		velocity.x = 50;

		gradient = FlxGradient.createGradientFlxSprite(200, 1, [FlxColor.BLACK, FlxColor.TRANSPARENT], 1, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		gradient.x = x + width;
		gradient.y = y;

		gradient.scale.y = height;

		gradient.scale.x = FlxMath.remapToRange(FlxMath.fastSin(FlxG.game.ticks / 1000), -1, 1, 0.8, 1.2);

		gradient.updateHitbox();

		// this.alpha = 0.2;
	}

	override function draw()
	{
		super.draw();

		gradient.draw();
	}
}
