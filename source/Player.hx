package;

import Mask.MaskType;
import flixel.*;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;

class Player extends FlxSprite
{
	public var mask:Mask;
	public var maskType:MaskType = NONE;

	public function new()
	{
		super();

		makeGraphic(25, 50);

		projectiles = new FlxGroup();

		mask = new Mask(this);

		setMaskType(SKELETON);
	}

	public var maxSpeed:Float = 300;
	public var fallSpeed:Float = 400;
	public var jumpForce:Float = 900;

	public var projectiles:FlxGroup;

	override function draw()
	{
		super.draw();
		mask.draw();
		projectiles.draw();
	}

	public var clownActive:Bool = false;
	public var clownY:Float = 0.0;

	public var boneTimer:Float = 0.0;

	public function setMaskType(type:MaskType)
	{
		clownActive = false;

		mask.setType(type);
		maskType = type;
	}

	override function update(elapsed:Float)
	{
		boneTimer -= elapsed;

		if (FlxG.mouse.justPressed)
		{
			switch (maskType)
			{
				case NONE:
				case CLOWN:
					clownActive = !clownActive;

					if (clownActive)
					{
						clownY = y;
					}
				case PUMPKIN:
				case SKELETON:
					if (boneTimer <= 0)
					{
						boneTimer = 0.25;
						var bone:Bone = cast projectiles.recycle(Bone);
						bone.prepare(this);
						projectiles.add(bone);
					}

				case SPIDER:
			}
		}

		var floored = isTouching(FLOOR);

		if (clownActive)
		{
			y = FlxMath.lerp(y, clownY - 15, elapsed * 5);
		}

		velocity.y = FlxMath.lerp(velocity.y, clownActive ? 0 : fallSpeed, elapsed * 5);

		if (FlxG.mouse.justPressedRight && floored)
		{
			velocity.y = -jumpForce;
		}

		if (FlxG.keys.pressed.A || FlxG.keys.pressed.D)
		{
			var speed:Float = FlxG.keys.pressed.A ? -maxSpeed : maxSpeed;
			facing = FlxG.keys.pressed.A ? LEFT : RIGHT;
			velocity.x = FlxMath.lerp(velocity.x, speed, elapsed * 10);
		}
		else
		{
			velocity.x = FlxMath.lerp(velocity.x, 0.0, elapsed * 10);
		}

		super.update(elapsed);

		projectiles.update(elapsed);
	}
}
