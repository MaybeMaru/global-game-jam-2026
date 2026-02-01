package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class MainMenu extends FlxState
{
	var playSound:FlxSound;

	var title:FlxSprite;
	var play:FlxText;

	var guy:FlxSprite;

	override function create()
	{
		super.create();

		FlxG.save.bind('CandyMaskerSaveData');
		FlxG.save.data.bestScore ??= 0;

		/*var title:FlxText = new FlxText();
			title.text = "Candy Masker";
			title.size = 26;
			title.screenCenter();
			title.y -= 60;
			add(title) */

		bgColor = 0xff0d090d;

		guy = new FlxSprite().loadGraphic('assets/images/title guy.png');
		guy.scale.set(2.5, 2.5);
		guy.updateHitbox();
		guy.screenCenter();
		add(guy);

		title = new FlxSprite().loadGraphic('assets/images/logo.png');
		title.scale.set(2.5, 2.5);
		title.updateHitbox();
		title.screenCenter();
		title.y -= 60;
		add(title);

		guy.x -= 110;
		guy.y += 20;
		title.x += 120;

		play = new FlxText();
		play.text = "Press Enter To Start";
		play.size = 26;
		play.font = 'assets/data/headstone.ttf';
		play.screenCenter();
		play.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);

		play.y += 150;
		add(play);

		var credits = new FlxText();
		credits.text = "Art & Programming by MaybeMaru\nMusic & Sounds by thisaintcub";
		credits.alignment = RIGHT;
		credits.size = 18;
		credits.font = 'assets/data/headstone.ttf';
		credits.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(credits);

		credits.x = FlxG.width - credits.width - 2;
		credits.y = FlxG.height - credits.height - 2;

		var bestScore = new FlxText();
		bestScore.text = "Best Score: " + FlxG.save.data.bestScore;
		bestScore.alignment = RIGHT;
		bestScore.size = 18;
		// bestScore.font = 'assets/data/headstone.ttf';
		bestScore.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(bestScore);

		bestScore.x = 2;
		bestScore.y = FlxG.height - bestScore.height - 2;

		FlxG.camera.fade(FlxColor.BLACK, 0.2, true, null, true);

		FlxG.sound.playMusic('assets/music/menu scary halloween boo.ogg');

		playSound = FlxG.sound.load('assets/sounds/playButtonm.ogg');
	}

	var selected = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		title.offset.y = FlxMath.fastSin(FlxG.game.ticks / 600) * 4;

		camera.zoom = FlxMath.remapToRange(FlxMath.fastCos(FlxG.game.ticks / 1000), -1, 1, 0.99, 1.01);

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
