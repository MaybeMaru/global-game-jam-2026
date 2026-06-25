package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
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
		// loadGraphic('assets/images/house.png');

		loadGraphic('assets/images/houses.png', true, 250, 223);

		switch (type)
		{
			case NONE:
			case CLOWN:
				animation.add("open", [0]);
				animation.add("closed", [1]);
			case SKELETON:
				animation.add("open", [2]);
				animation.add("closed", [3]);
			case PUMPKIN:
				animation.add("open", [4]);
				animation.add("closed", [5]);
			case SPIDER:
				animation.add("open", [6]);
				animation.add("closed", [7]);
		}

		animation.play("open");

		// scrollFactor.x = 0.95;

		updateHitbox();
		x = xPos;
		y = yPos - height + Street.tileSize; // PlayState.game.street.floorY - height;

		offset.x += 15;
		offset.y -= 2;

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
		PlayState.game.player.animation.play('knock');

		new FlxTimer().start(0.2, (tmr) ->
		{
			FlxG.camera.shake(0.003, 0.05);
			FlxG.sound.play('assets/sounds/knock.wav');
			PlayState.game.player.animation.play('knock');

			if (tmr.loopsLeft <= 0)
			{
				new FlxTimer().start(0.4, (tmr) ->
				{
					animation.play("closed");
					if (isSameType)
					{
						goodHouse();
						FlxTimer.wait(0.15, () -> PlayState.game.player.canMove = true);
					}
					else
					{
						PlayState.game.player.animation.play('hurt');
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

	public static function explodeCandy(amount:Int = 25, ?object:FlxObject)
	{
		for (i in 0...amount)
		{
			var candy:CandyParticle = cast PlayState.game.particles.recycle(CandyParticle);
			candy.setup(object ?? PlayState.game.player);
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

		var wrong:FlxText = cast PlayState.game.particles.recycle(FlxText);
		wrong.font = 'assets/data/headstone.ttf';
		wrong.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		wrong.alignment = CENTER;
		wrong.size = 20;
		wrong.text = "Wrong Mask";
		wrong.color = 0xffff5959;
		wrong.revive();

		wrong.setPosition(PlayState.game.player.x - (wrong.width - PlayState.game.player.width) / 2, PlayState.game.player.y - 30);

		wrong.moves = true;
		wrong.active = true;
		wrong.velocity.y = -150;
		wrong.velocity.x = FlxG.random.float(1.0, 5.0) * (FlxG.random.bool() ? -1 : 1);
		wrong.acceleration.y = 500;
	}
}
