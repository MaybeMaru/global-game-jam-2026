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
}
