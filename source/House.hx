package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class House extends FlxSprite
{
	var houseType:MaskType;
	var doorHitbox:FlxObject;

	public function new(type:MaskType, xPos:Float)
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

		x = xPos;
		y = PlayState.game.floor.y - height;

		doorHitbox = new FlxObject(0, 0, 100, 70);
		doorHitbox.y = y + height - doorHitbox.height;
		doorHitbox.x = x + (width - doorHitbox.width) / 2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		doorHitbox.update(elapsed);

		if (FlxG.keys.justPressed.W)
		{
			if (FlxG.overlap(doorHitbox, PlayState.game.player))
			{
				var isSameType = houseType == PlayState.game.player.maskType;

				if (isSameType)
				{
					goodHouse();
				}
				else
				{
					wrongHouse();
				}
			}
		}
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
	}

	function wrongHouse()
	{
		PlayState.game.ui.score -= 50;
		FlxG.camera.shake(0.01, 0.2);
		FlxG.sound.play('assets/sounds/explosion.wav');
	}
}
