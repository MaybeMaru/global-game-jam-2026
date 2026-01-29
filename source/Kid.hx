package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDirection;

class Kid extends FlxSprite
{
	public function new(maskType:MaskType)
	{
		super();
		makeGraphic(35, 35);

		color = switch (maskType)
		{
			case NONE: FlxColor.WHITE;
			case SKELETON: FlxColor.GRAY;
			case PUMPKIN: FlxColor.ORANGE;
			case SPIDER: FlxColor.PURPLE;
			case CLOWN: FlxColor.RED;
		}

		velocity.y = 400;
		// velocity.x = 50;

		facing = FlxG.random.bool() ? RIGHT : LEFT;
	}

	var speed = 200;

	var leCheck:Float = 0.0;

	override function update(elapsed:Float)
	{
		leCheck -= elapsed;
		if (leCheck <= 0.0 && (isTouching(LEFT) || isTouching(RIGHT)))
		{
			// trace("TOUCH");
			// velocity.x *= -1;
			// x += (velocity.x < 0) ? -1 : 1;

			facing = (facing == LEFT) ? RIGHT : LEFT;
			leCheck = 0.1;
		}

		velocity.x = (facing == LEFT) ? -speed : speed;

		// trace(touching);

		// if (isTouching(WALL))
		//	velocity.x *= -1;

		super.update(elapsed);
	}
}
