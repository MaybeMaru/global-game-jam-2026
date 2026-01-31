package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenu extends FlxState
{
	override function create()
	{
		super.create();

		var title:FlxText = new FlxText();
		title.text = "Candy Masker";
		title.size = 26;
		title.screenCenter();
		title.y -= 60;
		add(title);

		var play:FlxText = new FlxText();
		play.text = "Press Enter To Start";
		play.size = 18;
		play.screenCenter();
		play.y += 60;
		add(play);

		FlxG.camera.fade(FlxColor.BLACK, 0.2, true);

		FlxG.sound.playMusic('assets/music/menu scary halloween boo.ogg');
	}

	var selected = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (selected)
			return;

		if (FlxG.keys.justPressed.ENTER)
		{
			selected = true;
			FlxG.camera.fade(FlxColor.BLACK, 0.2, false, () ->
			{
				FlxG.switchState(() -> new PlayState(false));
			});
		}
	}
}
