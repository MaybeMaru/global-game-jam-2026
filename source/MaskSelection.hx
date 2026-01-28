package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MaskSelection extends FlxGroup
{
	var masks:Array<String> = ["none", "skeleton", "clown", "pumpkin", "spider"];

	public function new()
	{
		super();

		for (i => mask in masks)
		{
			var text = new FlxText();
			text.size = 16;
			text.text = mask;
			text.y = i * 20;
			add(text);
		}

		changeMask(0);
	}

	var curMask:Int = 0;

	function changeMask(change:Int)
	{
		curMask += change;
		curMask = FlxMath.wrap(curMask, 0, masks.length - 1);

		for (i in 0...members.length)
		{
			var guh:FlxSprite = cast members[i];
			guh.color = i == curMask ? FlxColor.YELLOW : FlxColor.WHITE;
		}

		PlayState.game.player.setMaskType(switch (masks[curMask])
		{
			case "none": NONE;
			case "skeleton": SKELETON;
			case "pumpkin": PUMPKIN;
			case "spider": SPIDER;
			case "clown": CLOWN;
			default: NONE; // invalid
		});
	}

	var wheelTimer:Float = 0.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var wheel = FlxG.mouse.wheel;

		wheelTimer -= elapsed;

		if (wheel != 0)
		{
			if (wheelTimer <= 0)
			{
				wheelTimer = 0.1;
				if (wheel == 1)
				{
					changeMask(-1);
				}
				else if (wheel == -1)
				{
					changeMask(1);
				}
			}
		}

		// trace(wheel);
	}
}
