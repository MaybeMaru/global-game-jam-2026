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
		loadGraphic('assets/images/candy.png');
		// makeGraphic(10, 10, 0xFFFF7171);

		tint = new Tint();
		shader = tint.shader;
	}

	var tint:Tint;

	var timer:Float = 0.0;

	public function setup(player:Player)
	{
		alpha = 1;
		x = player.x;
		y = player.y;

		acceleration.y = FlxG.random.float(1800, 2000);
		acceleration.x = FlxG.random.float(-100, 100);

		angularVelocity = FlxG.random.float(50, 100) * (FlxG.random.bool() ? -1 : 1);

		velocity.set(acceleration.x / 2, -500);

		timer = FlxG.random.float(0.4, 0.6);

		tint.setTint(FlxG.random.float(0, 255));

		// var leColor = FlxG.random.color();

		// colorTransform.redOffset = leColor.red;
		// colorTransform.g = leColor.red;
		// colorTransform.blueOffset = leColor.blue;

		// updateColorTransform();

		// colorTransform.redOffset = FlxG.random.float(0, 100);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		timer -= elapsed;

		if (timer <= 0)
		{
			alpha -= elapsed * 10;
			if (alpha <= 0)
				kill();

			// kill();
		}
	}
}
