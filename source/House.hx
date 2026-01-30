package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class House extends FlxSprite
{
	var houseType:MaskType;
	var doorHitbox:FlxObject;

	public function new(type:MaskType, xPos:Float, yPos:Float)
	{
		super();

		houseType = type;

		// makeGraphic(200, 200);
		loadGraphic('assets/images/house.png');

		color = switch (type)
		{
			case NONE: FlxColor.WHITE;
			case SKELETON: FlxColor.GRAY;
			case PUMPKIN: FlxColor.ORANGE;
			case SPIDER: FlxColor.PURPLE;
			case CLOWN: FlxColor.RED;
		}

		// scrollFactor.x = 0.95;

		updateHitbox();
		x = xPos;
		y = yPos - height + Street.tileSize; // PlayState.game.street.floorY - height;

		doorHitbox = new FlxObject(0, 0, 100, 70);
		doorHitbox.y = y + height - doorHitbox.height;
		doorHitbox.x = x + (width - doorHitbox.width) / 2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		doorHitbox.update(elapsed);

		if (decided)
			return;

		if (FlxG.keys.justPressed.W && PlayState.game.player.canMove)
		{
			if (FlxG.overlap(doorHitbox, PlayState.game.player))
			{
				PlayState.game.player.canMove = false;
				knock();
			}
		}
	}

	var decided:Bool = false;

	function knock()
	{
		decided = true;

		var isSameType = houseType == PlayState.game.player.maskType;

		new FlxTimer().start(0.2, (tmr) ->
		{
			FlxG.camera.shake(0.003, 0.05);
			FlxG.sound.play('assets/sounds/knock.wav');
			if (tmr.loopsLeft <= 0)
			{
				new FlxTimer().start(0.4, (tmr) ->
				{
					if (isSameType)
					{
						goodHouse();
						FlxTimer.wait(0.15, () -> PlayState.game.player.canMove = true);
					}
					else
					{
						wrongHouse();
						FlxG.camera.flash(0xffff0000);
						@:privateAccess FlxG.camera._fxFlashAlpha = 0.2;
						FlxTimer.wait(0.5, () -> PlayState.game.player.canMove = true);
					}
				});
			}
		}, 3);
	}

	override function draw()
	{
		super.draw();
		doorHitbox.draw();
	}

	function explodeCandy()
	{
		for (i in 0...10)
		{
			var candy:CandyParticle = cast PlayState.game.particles.recycle(CandyParticle);
			candy.setup(PlayState.game.player);
			PlayState.game.particles.add(candy);
		}
	}

	function goodHouse()
	{
		PlayState.game.ui.score += 200;
		explodeCandy();
		FlxG.sound.play('assets/sounds/yay.ogg');

		PlayState.game.ui.life += 10;
	}

	function wrongHouse()
	{
		PlayState.game.player.getHurt(15);
	}
}
