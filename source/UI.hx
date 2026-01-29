package;

import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class UI extends FlxGroup
{
	var life:Float = 90;

	var scoreText:FlxBitmapText;
	var lifeBar:FlxBar;

	public function new()
	{
		super();

		lifeBar = new FlxBar(0, 0, BOTTOM_TO_TOP, 25, 300, this, 'life');
		lifeBar.createFilledBar(0xff212121, FlxColor.ORANGE, true, FlxColor.BLACK, 3);
		lifeBar.x = 6;
		lifeBar.screenCenter(Y);
		add(lifeBar);

		scoreText = new FlxBitmapText();
		scoreText.setPosition(6, 6);
		scoreText.scale.set(3, 3);
		scoreText.updateHitbox();
		scoreText.text = "Candy:\n000000";
		add(scoreText);

		var selector = new MaskSelection();
		add(selector);
	}
}
