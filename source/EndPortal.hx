package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class EndPortal extends FlxSprite
{
	public function new()
	{
		super();

		// makeGraphic(50, 150, FlxColor.MAGENTA);

		loadGraphic('assets/images/portal.png', true, 50, 150);
		animation.add('idle', [0, 1, 2], 6);
		animation.play('idle');
	}

	var passed:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		offset.y = FlxMath.fastSin(FlxG.game.ticks / 140) * 3;

		if (FlxG.overlap(this, PlayState.game.player) && !passed)
		{
			PlayState.game.endLevel();
			passed = true;
		}
	}

	override function draw()
	{
		var sine = FlxMath.remapToRange(FlxMath.fastSin(FlxG.game.ticks / 400), -1, 1, 1.05, 1.2);
		alpha = FlxMath.remapToRange(FlxMath.fastCos(FlxG.game.ticks / 300), -1, 1, 0.6, 1.0);
		blend = ADD;
		scale.set(sine, sine);
		super.draw();

		alpha = 1.0;
		blend = NORMAL;
		scale.set(1, 1);
		super.draw();

		var cos = FlxMath.remapToRange(FlxMath.fastCos(FlxG.game.ticks / 300), -1, 1, 1.05, 1.2);
		alpha = FlxMath.remapToRange(FlxMath.fastSin(FlxG.game.ticks / 600), -1, 1, 0.6, 0.9);
		blend = ADD;
		scale.set(cos, cos);
		super.draw();
	}
}
