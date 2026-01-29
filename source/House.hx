package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class House extends FlxSprite
{
	var houseType:MaskType;

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

		scrollFactor.x = 0.95;

		x = xPos;
		y = PlayState.game.floor.y - height;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.W)
		{
			if (FlxG.overlap(this, PlayState.game.player))
			{
				var isSameType = houseType == PlayState.game.player.maskType;

				if (isSameType) {}
				else
				{
					FlxG.camera.shake(0.01, 0.2);
				}
			}
		}
	}
}
