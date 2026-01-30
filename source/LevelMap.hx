package;

import flixel.*;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.*;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class LevelMap extends FlxGroup
{
	var line:FlxSprite;

	var playerArrow:FlxSprite;
	var darknessArrow:FlxSprite;

	public function new()
	{
		super();

		line = FlxGridOverlay.create(5, 10, 300, 10, true, FlxColor.WHITE, FlxColor.TRANSPARENT);
		line.screenCenter(X);
		line.y = 12;
		add(line);

		playerArrow = new FlxSprite().loadGraphic('assets/images/arrow.png');
		playerArrow.offset.x += playerArrow.width / 2;
		playerArrow.color = 0xffada87f;
		add(playerArrow);

		darknessArrow = new FlxSprite().loadGraphic('assets/images/arrow.png');
		darknessArrow.offset.x += darknessArrow.width / 2;
		darknessArrow.color = FlxColor.GRAY;
		add(darknessArrow);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		playerArrow.y = line.y + line.height + 3;
		darknessArrow.y = playerArrow.y;

		playerArrow.x = FlxMath.remapToRange(PlayState.game.player.x, 0, PlayState.game.street.levelLength, line.x, line.x + line.width);

		darknessArrow.x = FlxMath.remapToRange(PlayState.game.darkness.x + PlayState.game.darkness.width, 0, PlayState.game.street.levelLength, line.x,
			line.x + line.width);

		darknessArrow.visible = darknessArrow.x >= line.x;

		playerArrow.y += FlxMath.fastSin(FlxG.game.ticks / 100) * 2;
		darknessArrow.y += FlxMath.fastSin(FlxG.game.ticks / 100) * 2;
	}
}
