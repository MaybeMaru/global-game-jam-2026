package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;

class Darkness extends FlxSprite
{
	var gradient:FlxSprite;

	var eyes:FlxTypedGroup<FlxSprite>;

	public function new()
	{
		super();

		makeGraphic(1, 1, FlxColor.BLACK);

		setGraphicSize(600, 2000);
		updateHitbox();

		eyes = new FlxTypedGroup<FlxSprite>();

		for (i in 0...20)
		{
			var eye = new FlxSprite();
			eye.frames = FlxAtlasFrames.fromSparrow('assets/images/eyes.png', 'assets/images/eyes.xml');
			eye.animation.addByPrefix("eye", "");
			eye.animation.play("eye", true, false, FlxG.random.int(0, 30));
			eye.scale.set(2, 2);

			var guh = FlxG.random.float(0.6, 1.2);
			eye.scale.scale(guh, guh);
			eyes.add(eye);
			eye.updateHitbox();
			eye.blend = ADD;

			eye.scrollFactor.y = 0.5;

			eye.offset.set(FlxG.random.int(-30, 150), FlxG.random.int(10, -450));
		}

		x = (PlayState.game.curLevel == 0) ? -600 : -500; // TODO
		x -= width;

		// delay based on how many houses there are to collect as a head start
		var numHouses:Int = PlayState.game.street.houses.members.length;
		var delay:Float = numHouses / 2;
		var speed:Float = numHouses * 9;
		x -= numHouses * 10;

		// exponentially make it harder
		velocity.x = 25;
		FlxTween.tween(velocity, {x: speed}, PlayState.game.street.levelLength / 120, {ease: FlxEase.quadIn, startDelay: delay});

		y -= 75;
		scrollFactor.y = 0;

		gradient = FlxGradient.createGradientFlxSprite(200, 1, [FlxColor.BLACK, FlxColor.BLACK, FlxColor.TRANSPARENT], 1, 0);
		gradient.scrollFactor.y = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		eyes.update(elapsed);

		for (member in eyes)
		{
			member.x = x + width;
			member.y = 0;
		}

		gradient.x = x + width - 20;
		gradient.y = y;

		gradient.scale.y = height;

		gradient.scale.x = FlxMath.remapToRange(FlxMath.fastSin(FlxG.game.ticks / 1000), -1, 1, 0.8, 1.2);

		gradient.updateHitbox();

		// trace(distance, 100 - distance);

		// this.alpha = 0.2;
	}

	override function draw()
	{
		super.draw();

		gradient.draw();

		// if (isOnScreen(camera))
		eyes.draw();
	}
}
