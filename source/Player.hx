package;

import Mask.MaskType;
import flixel.*;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

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

		pumpkinGlow = new FlxSprite();
		pumpkinGlow.makeGraphic(100, 100, 0);
		FlxSpriteUtil.drawCircle(pumpkinGlow, -1, -1, -1, FlxColor.YELLOW);
		pumpkinGlow.blend = ADD;

		setMaskType(SKELETON);
	}

	public var maxSpeed:Float = 300;
	public var fallSpeed:Float = 400;
	public var jumpForce:Float = 900;

	public var projectiles:FlxGroup;
	public var pumpkinGlow:FlxSprite;

	override function draw()
	{
		super.draw();
		mask.draw();
		projectiles.draw();

		final elapsed = FlxG.elapsed;

		if (maskType == PUMPKIN)
		{
			PlayState.game.postDraw.addOnce(() ->
			{
				pumpkinGlow.draw();
			});

			var showSpeed = pumpkinActive ? 4 : 6;

			pumpkinGlow.alpha = FlxMath.lerp(pumpkinGlow.alpha, pumpkinActive ? 0.6 : 0.0, elapsed * showSpeed);
			pumpkinGlow.scale.x = FlxMath.lerp(pumpkinGlow.scale.x, pumpkinActive ? 1.0 : 0.25, elapsed * showSpeed);
			pumpkinGlow.scale.y = FlxMath.lerp(pumpkinGlow.scale.y, pumpkinActive ? 1.0 : 0.333, elapsed * showSpeed);

			pumpkinGlow.updateHitbox();

			pumpkinGlow.x = x + ((width - pumpkinGlow.width) / 2);
			pumpkinGlow.y = y + ((height - pumpkinGlow.height) / 2);
		}
	}

	public var clownActive:Bool = false;
	public var clownY:Float = 0.0;

	public var boneTimer:Float = 0.0;

	public var pumpkinActive:Bool = false;

	public var spiderDoubleJump:Bool = false;

	public function setMaskType(type:MaskType)
	{
		clownActive = false;

		pumpkinActive = false;
		pumpkinGlow.alpha = 0.0;
		pumpkinGlow.scale.set(0.3, 0.3);

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
					pumpkinActive = !pumpkinActive;

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

		if (floored)
		{
			spiderDoubleJump = false;
		}

		if (clownActive)
		{
			y = FlxMath.lerp(y, clownY - 15, elapsed * 5);
		}

		velocity.y = FlxMath.lerp(velocity.y, clownActive ? 0 : fallSpeed, elapsed * 5);

		if (FlxG.mouse.justPressedRight)
		{
			var doJump = floored || (!spiderDoubleJump && maskType == SPIDER);
			if (doJump)
			{
				velocity.y = -jumpForce;

				if (maskType == SPIDER && !floored)
					spiderDoubleJump = true;
			}
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
