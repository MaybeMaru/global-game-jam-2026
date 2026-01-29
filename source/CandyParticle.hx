package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class CandyParticle extends FlxSprite
{
	public function new()
	{
		super();
		makeGraphic(10, 10, 0xFFFF7171);
	}

	var timer:Float = 0.0;

	public function setup(player:Player)
	{
		x = player.x;
		y = player.y;

		acceleration.y = FlxG.random.float(1800, 2000);
		acceleration.x = FlxG.random.float(-100, 100);

		angularVelocity = FlxG.random.float(50, 100) * (FlxG.random.bool() ? -1 : 1);

		velocity.set(acceleration.x / 2, -500);

		timer = FlxG.random.float(0.4, 0.6);

		var leColor = FlxG.random.color();

		colorTransform.redOffset = leColor.red;
		// colorTransform.g = leColor.red;
		colorTransform.blueOffset = leColor.blue;

		updateColorTransform();

		// colorTransform.redOffset = FlxG.random.float(0, 100);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		timer -= elapsed;

		if (timer <= 0)
		{
			kill();
		}
	}
}
