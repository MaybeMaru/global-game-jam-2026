package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Mask extends FlxSprite
{
	var wearer:FlxSprite;

	public function new(wearer:FlxSprite)
	{
		super();
		this.wearer = wearer;
		makeGraphic(15, 15);
		setType(NONE);
	}

	override function draw()
	{
		final elapsed = FlxG.elapsed;

		x = wearer.x + ((wearer.width - width) / 2);
		flipX = wearer.facing == LEFT;
		y = wearer.y - 2;

		if (wearer is Player)
		{
			final facingLeft:Bool = (wearer.facing == LEFT);
			if (cast(wearer, Player).canMove)
				x += facingLeft ? -10 : 10;

			switch (wearer.animation.curAnim.name)
			{
				case "walk":
					switch (wearer.animation.curAnim.curFrame)
					{
						case 0 | 2:
							y--;
					}
				case "shoot":
					y--;
					facingLeft ? x-- : x++;
				case "jump":
					y++;
				case "fall":
					x += facingLeft ? 2 : -2;
					y -= (wearer.animation.curAnim.curFrame + 1);
			}
		}
		else
		{
			x += wearer.facing == LEFT ? -5 : 20; // kids
			y -= 11;

			if (wearer is Kid)
			{
				y += wearer.animation.curAnim.curFrame;
				colorTransform = wearer.colorTransform;
			}
		}

		if (wearer is Player)
		{
			var wearer:Player = cast wearer;
			if (wearer.maskType == CLOWN)
			{
				var inflateSpeed = wearer.clownActive ? 4 : 8;
				var inflateSize = wearer.clownActive ? 1.5 : 1.0;

				scale.x = FlxMath.lerp(scale.x, inflateSize, elapsed * inflateSpeed);
				scale.y = FlxMath.lerp(scale.y, inflateSize, elapsed * inflateSpeed);

				if (wearer.clownActive)
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
			return;

		var maskID = switch (type)
		{
			case NONE: '';
			case SKELETON: 'skeleton';
			case PUMPKIN: "pumpkin";
			case SPIDER: "spider";
			case CLOWN: "clown";
		}

		loadGraphic('assets/images/masks/' + maskID + '.png');
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
