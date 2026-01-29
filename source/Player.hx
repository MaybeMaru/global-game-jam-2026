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

		makeGraphic(25, 50, 0xffada87f);

		projectiles = new FlxGroup();

		mask = new Mask(this);

		pumpkinGlow = new FlxSprite();
		pumpkinGlow.loadGraphic('assets/images/pumpkinglow.png');
		pumpkinGlow.color = FlxColor.YELLOW;
		// pumpkinGlow.makeGraphic(100, 100, 0);
		// FlxSpriteUtil.drawCircle(pumpkinGlow, -1, -1, -1, FlxColor.YELLOW);
		pumpkinGlow.blend = ADD;

		pumpkinShadow = new FlxSprite();
		pumpkinShadow.loadGraphic('assets/images/shadow pumpkin.png');
		pumpkinShadow.colorTransform.alphaOffset = -255;

		setMaskType(SKELETON);
	}

	public var maxSpeed:Float = 300;
	public var fallSpeed:Float = 400;
	public var jumpForce:Float = 900;

	public var projectiles:FlxGroup;
	public var pumpkinGlow:FlxSprite;
	public var pumpkinShadow:FlxSprite;

	override function draw()
	{
		super.draw();
		mask.draw();
		projectiles.draw();

		final elapsed = FlxG.elapsed;

		pumpkinShadow.x = x + ((width - pumpkinShadow.width) / 2);
		pumpkinShadow.y = y + ((height - pumpkinShadow.height) / 2);
		pumpkinShadow.draw();

		final inPumpkin = maskType == PUMPKIN;
		pumpkinShadow.colorTransform.alphaOffset = FlxMath.lerp(pumpkinShadow.colorTransform.alphaOffset, inPumpkin ? (pumpkinActive ? -75 : 0) : -255,
			elapsed * 3);

		if (inPumpkin)
		{
			PlayState.game.postDraw.addOnce(() ->
			{
				pumpkinGlow.draw();
			});

			var showSpeed = pumpkinActive ? 4 : 6;

			pumpkinGlow.colorTransform.alphaOffset = FlxMath.lerp(pumpkinGlow.colorTransform.alphaOffset, pumpkinActive ? 0 : -155, elapsed * showSpeed);
			// pumpkinGlow.scale.x = FlxMath.lerp(pumpkinGlow.scale.x, pumpkinActive ? 1.0 : 1, elapsed * showSpeed);
			// pumpkinGlow.scale.y = FlxMath.lerp(pumpkinGlow.scale.y, pumpkinActive ? 1.0 : 1, elapsed * showSpeed);

			pumpkinGlow.updateHitbox();

			pumpkinGlow.x = x + ((width - pumpkinGlow.width) / 2);
			pumpkinGlow.y = y + ((height - pumpkinGlow.height) / 2);
		}
	}

	public var clownActive:Bool = false;
	public var clownY:Float = 0.0;

	var clownOffsetY:Float = 0.0;

	public var boneTimer:Float = 0.0;

	public var pumpkinActive:Bool = false;

	public var spiderDoubleJump:Bool = false;

	public function setMaskType(type:MaskType)
	{
		clownActive = false;

		pumpkinActive = false;
		pumpkinGlow.colorTransform.alphaOffset = -255;
		// pumpkinGlow.scale.set(0.3, 0.3);

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
			y += FlxMath.fastSin(FlxG.game.ticks / (1000)) * 0.5;
		}

		velocity.y = FlxMath.lerp(velocity.y, clownActive ? 0 : fallSpeed, elapsed * 5);

		if (FlxG.mouse.justPressedRight
			|| FlxG.keys.justPressed.SPACE
			|| (maskType == SPIDER && FlxG.mouse.justPressed)) // remove when i figure out another move for spider
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
