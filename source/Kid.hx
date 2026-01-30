package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDirection;

using flixel.util.FlxColorTransformUtil;

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

	var hits:Int = 3;

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

		for (bone in PlayState.game.player.projectiles)
		{
			if (FlxG.overlap(bone, this))
			{
				FlxTween.cancelTweensOf(colorTransform);

				colorTransform.setOffsets(150, 150, 150);
				FlxTween.tween(colorTransform, {redOffset: 0, greenOffset: 0, blueOffset: 0}, 0.1);

				FlxG.sound.play('assets/sounds/damageEnemy.wav');

				bone.kill();
				hits--;
				if (hits < 0)
					kill();
			}
		}

		velocity.x = (facing == LEFT) ? -speed : speed;

		// trace(touching);

		// if (isTouching(WALL))
		//	velocity.x *= -1;

		super.update(elapsed);
	}
}
