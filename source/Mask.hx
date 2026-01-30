package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Mask extends FlxSprite
{
	var player:Player;

	public function new(player:Player)
	{
		super();
		this.player = player;
		makeGraphic(15, 15);
		setType(NONE);
	}

	override function draw()
	{
		if (player.maskType == NONE)
			return;

		final elapsed = FlxG.elapsed;

		x = player.x + ((player.width - width) / 2);

		if (player.canMove)
			x += player.facing == LEFT ? -10 : 10;

		flipX = player.facing == LEFT;
		y = player.y - 2;

		if (player.maskType == CLOWN)
		{
			var inflateSpeed = player.clownActive ? 4 : 8;
			var inflateSize = player.clownActive ? 1.5 : 1.0;

			scale.x = FlxMath.lerp(scale.x, inflateSize, elapsed * inflateSpeed);
			scale.y = FlxMath.lerp(scale.y, inflateSize, elapsed * inflateSpeed);

			if (player.clownActive)
				y -= 10;
		}
		else
		{
			scale.set(1, 1);
		}

		super.draw();
	}

	public function setType(type:MaskType)
	{
		if (type == NONE)
		{
			return;
		}

		/*color = switch (type)
			{
				case NONE: FlxColor.WHITE;
				case SKELETON: FlxColor.GRAY;
				case PUMPKIN: FlxColor.ORANGE;
				case SPIDER: FlxColor.PURPLE;
				case CLOWN: FlxColor.RED;
		}*/

		var lol = switch (type)
		{
			case NONE: '';
			case SKELETON: 'skeleton';
			case PUMPKIN: "pumpkin";
			case SPIDER: "spider";
			case CLOWN: "clown";
		}

		loadGraphic('assets/images/masks/' + lol + '.png');
	}
}

enum MaskType
{
	NONE;
	SKELETON;
	PUMPKIN;
	SPIDER;
	CLOWN;
}
