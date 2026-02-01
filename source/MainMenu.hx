package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenu extends FlxState
{
	var playSound:FlxSound;

	var title:FlxSprite;
	var play:FlxText;

	override function create()
	{
		super.create();

		/*var title:FlxText = new FlxText();
			title.text = "Candy Masker";
			title.size = 26;
			title.screenCenter();
			title.y -= 60;
			add(title) */

		title = new FlxSprite().loadGraphic('assets/images/logo.png');
		title.scale.set(2.5, 2.5);
		title.updateHitbox();
		title.screenCenter();
		title.y -= 60;
		add(title);

		play = new FlxText();
		play.text = "Press Enter To Start";
		play.size = 18;
		play.screenCenter();
		play.y += 170;
		add(play);

		FlxG.camera.fade(FlxColor.BLACK, 0.2, true, null, true);

		FlxG.sound.playMusic('assets/music/menu scary halloween boo.ogg');

		playSound = FlxG.sound.load('assets/sounds/playButtonm.ogg');
	}

	var selected = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		title.offset.y = FlxMath.fastSin(FlxG.game.ticks / 600) * 4;

		if (selected)
			return;

		if (FlxG.keys.justPressed.ENTER)
		{
			selected = true;

			FlxFlicker.flicker(play, 4, 0.25);

			FlxG.sound.music.stop();
			playSound.play(true);
			playSound.onComplete = () ->
			{
				FlxG.switchState(() -> new PlayState(true));
			}

			FlxG.camera.fade(FlxColor.BLACK, 2.5, false, null, true);

			// FlxG.camera.fade(FlxColor.BLACK, 0.2, false, () ->
			// {
			//
			// });
		}
	}
}
