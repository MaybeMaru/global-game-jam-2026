package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Pause extends FlxSubState
{
	var items = ["Resume", "Reset", "Exit To Menu"];
	var index:Int = 0;

	public function new()
	{
		super(0x91000000);

		for (i => item in items)
		{
			var leItem = new FlxText();
			leItem.size = 30;
			leItem.text = item;
			leItem.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
			leItem.font = 'headstone.ttf';
			add(leItem);

			leItem.screenCenter();
			leItem.y += i * 50;
			leItem.y -= 50;
		}

		openCallback = () ->
		{
			didSelect = false;
			index = 0;
			changeSelect(0);
		}
	}

	function changeSelect(change:Int)
	{
		index = FlxMath.wrap(index + change, 0, items.length - 1);

		for (i => member in members)
		{
			cast(member, FlxSprite).color = (i == index) ? FlxColor.YELLOW : FlxColor.WHITE;
		}
	}

	function doSelection()
	{
		didSelect = true;
		switch (index)
		{
			case 0:
				close();
			case 1:
				FlxG.sound.music.fadeOut(0.3);
				PlayState.game.uiCam.fade(FlxColor.BLACK, 0.3, false, () -> FlxG.resetState());
			case 2:
				FlxG.sound.music.fadeOut(0.3);
				PlayState.game.uiCam.fade(FlxColor.BLACK, 0.3, false, () -> FlxG.switchState(() -> new MainMenu()));
		}
	}

	var didSelect = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
			return;
		}

		if (didSelect)
			return;

		if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)
			changeSelect(-1);
		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
			changeSelect(1);

		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed)
			doSelection();
	}
}
