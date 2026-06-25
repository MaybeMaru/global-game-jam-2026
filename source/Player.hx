package;

import Mask.MaskType;
import flixel.*;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	public var mask:Mask;
	public var maskType:MaskType = NONE;

	public var canMove:Bool = true;

	public function new()
	{
		super();

		// makeGraphic(25, 50, 0xffada87f);

		loadGraphic('assets/images/masker.png', true, 45, 52);

		animation.add('idle', [0], 12);
		animation.add('jump', [1, 2], 12);
		animation.add('fall', [3, 4], 12);
		animation.add('walk', [5, 6, 7, 6], 12);
		animation.add('shoot', [8, 9], 12);
		animation.add('knock', [10], 12);
		animation.add('hurt', [11, 12], 12);

		animation.play('idle');

		setSize(25, 50);
		offset.x = 10;
		// offset.x = 20;

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		projectiles = new FlxGroup();

		mask = new Mask(this);

		pumpkinGlow = new FlxSprite();
		pumpkinGlow.loadGraphic('assets/images/pumpkinglow.png');
		pumpkinGlow.color = FlxColor.YELLOW;
		pumpkinGlow.colorTransform.alphaOffset = -255;
		// pumpkinGlow.makeGraphic(100, 100, 0);
		// FlxSpriteUtil.drawCircle(pumpkinGlow, -1, -1, -1, FlxColor.YELLOW);
		pumpkinGlow.blend = ADD;

		jumpWeb = new FlxSprite();
		jumpWeb.alpha = 0.0;
		jumpWeb.loadGraphic('assets/images/web.png');

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
	public var jumpWeb:FlxSprite;

	var pumpkinTimer:Float = 0;

	override function draw()
	{
		final elapsed = FlxG.elapsed;

		// if (maskType == SPIDER)
		// {
		jumpWeb.draw();
		jumpWeb.alpha -= elapsed * 2;
		// }

		mask.alpha = alpha;

		if (!canMove)
			mask.draw();

		super.draw();

		if (canMove)
			mask.draw();
		projectiles.draw();

		pumpkinShadow.x = x + ((width - pumpkinShadow.width) / 2);
		pumpkinShadow.y = y + ((height - pumpkinShadow.height) / 2);
		pumpkinShadow.draw();

		var inDark = false;
		for (period in PlayState.game.street.darknessPeriods)
		{
			if (x >= period.startX && (x + width) <= period.endX)
			{
				inDark = true;
				break;
			}
		}

		// pumpkinTimer -= elapsed;

		// final inPumpkin = maskType == PUMPKIN;

		pumpkinShadow.colorTransform.alphaOffset = FlxMath.lerp(pumpkinShadow.colorTransform.alphaOffset,
			inDark ? ((pumpkinActive || pumpkinTimer > 0) ? -100 : 0) : -255, elapsed * (!inDark ? 2 : 1));

		PlayState.game.postDraw.addOnce(() ->
		{
			pumpkinGlow.draw();
		});

		var showSpeed = pumpkinActive ? 4 : 6;

		pumpkinGlow.colorTransform.alphaOffset = FlxMath.lerp(pumpkinGlow.colorTransform.alphaOffset, pumpkinActive ? 0 : -155, elapsed * showSpeed);

		pumpkinGlow.updateHitbox();

		pumpkinGlow.x = x + ((width - pumpkinGlow.width) / 2);
		pumpkinGlow.y = y + ((height - pumpkinGlow.height) / 2);

		if (inDark)
		{
			if (!pumpkinActive)
			{
				pumpkinTimer -= elapsed;
			}
			else
			{
				pumpkinTimer = 5.0;
			}
		}

		/*if (inPumpkin)
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
		}*/
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
		// pumpkinGlow.scale.set(0.3, 0.3);

		mask.setType(type);
		maskType = type;
	}

	var regenTimer:Float = 0.0;

	public function getHurt(severity:Int = 15)
	{
		if (regenTimer > 0 && severity < 15)
			return;

		regenTimer = 1.2;
		FlxFlicker.stopFlickering(this);
		FlxFlicker.flicker(this, regenTimer, 0.04, true, true, (tmr) ->
		{
			alpha = 1;
		}, (tmr) ->
			{
				alpha = alpha == 1 ? 0 : 1;
				visible = true;
			});

		PlayState.game.ui.score -= severity * 4;
		FlxG.camera.shake(0.01, 0.2);
		FlxG.sound.play('assets/sounds/explosion.wav');

		PlayState.game.ui.life -= severity;
	}

	var lastY:Float = 9999;

	override function update(elapsed:Float)
	{
		var floored = isTouching(FLOOR);

		boneTimer -= elapsed;
		regenTimer -= elapsed;

		var doAction = (FlxG.mouse.justPressed || FlxG.keys.justPressed.Q || FlxG.keys.justPressed.F);
		var doJump = (FlxG.mouse.justPressedRight || FlxG.keys.justPressed.SPACE || (maskType == SPIDER && doAction));

		if (maskType == CLOWN && !floored && doJump)
		{
			doAction = true;
		}

		if (doAction && canMove)
		{
			switch (maskType)
			{
				case NONE:
				case CLOWN:
					clownActive = !clownActive;

					if (clownActive)
					{
						clownY = y;
						FlxG.sound.play('assets/sounds/inflate.ogg', 0.8);
					}
					else
					{
						FlxG.sound.play('assets/sounds/deflate.ogg', 0.6);
					}
				case PUMPKIN:
					pumpkinActive = !pumpkinActive;

					if (pumpkinActive)
					{
						FlxG.sound.play('assets/sounds/glow.ogg');
					}
					else
					{
						FlxG.sound.play('assets/sounds/glow.ogg').pitch = 0.8;
					}

				case SKELETON:
					if (boneTimer <= 0)
					{
						boneTimer = 0.15;
						var bone:Bone = cast projectiles.recycle(Bone);
						bone.prepare(this);
						projectiles.add(bone);
						FlxG.sound.play('assets/sounds/bone.ogg').pitch = FlxG.random.float(0.9, 1.1);
					}

				case SPIDER:
			}
		}

		if (!floored)
		{
			if (y > lastY)
				animation.play('fall');
			else
				animation.play('jump');
			lastY = y;
		}

		if (floored && !wasTouching.hasAny(FLOOR))
			FlxG.sound.play('assets/sounds/land.wav');

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

		if (doJump && canMove)
		{
			if (floored || (!spiderDoubleJump && maskType == SPIDER))
			{
				velocity.y = -jumpForce;

				if (maskType == SPIDER && !floored)
				{
					jumpWeb.x = x + ((width - jumpWeb.width) / 2);
					jumpWeb.y = y + ((height - jumpWeb.height) / 2);
					jumpWeb.alpha = 1.0;
					FlxG.sound.play('assets/sounds/web.ogg');
					spiderDoubleJump = true;
				}
				else
				{
					FlxG.sound.play('assets/sounds/jump.wav');
				}
			}
		}

		if ((FlxG.keys.pressed.A || FlxG.keys.pressed.D) && canMove)
		{
			var speed:Float = FlxG.keys.pressed.A ? -maxSpeed : maxSpeed;
			facing = FlxG.keys.pressed.A ? LEFT : RIGHT;
			if (floored)
				animation.play('walk');
			velocity.x = FlxMath.lerp(velocity.x, speed, elapsed * 10);
		}
		else
		{
			if (floored && canMove)
				animation.play('idle');
			velocity.x = FlxMath.lerp(velocity.x, 0.0, elapsed * 10);
		}

		if (boneTimer > 0)
			animation.play('shoot');

		super.update(elapsed);

		projectiles.update(elapsed);

		if (y >= 450)
		{
			PlayState.game.ui.life = 0;
		}
	}
}
