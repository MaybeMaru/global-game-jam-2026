package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Mask extends FlxSprite
{
	var player:FlxSprite;

	public function new(player:FlxSprite)
	{
		super();
		this.player = player;
		makeGraphic(15, 15);
		setType(NONE);
	}

	override function draw()
	{
		final elapsed = FlxG.elapsed;

		x = player.x + ((player.width - width) / 2);
		flipX = player.facing == LEFT;
		y = player.y - 2;

		if (player is Player)
		{
			if (cast(player, Player).canMove)
				x += player.facing == LEFT ? -10 : 10;
		}
		else
		{
			x += player.facing == LEFT ? -5 : 20; // kids
			y -= 11;
		}

		if (player is Player)
		{
			var player:Player = cast player;
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
