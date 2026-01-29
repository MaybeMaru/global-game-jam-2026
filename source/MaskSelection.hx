package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MaskSelection extends FlxTypedGroup<FlxSprite>
{
	var masks:Array<String> = ["skeleton", "clown", "spider", "pumpkin"];
	var masksTypes:Array<MaskType> = [SKELETON, CLOWN, SPIDER, PUMPKIN];

	public function new()
	{
		super();

		for (i => mask in masks)
		{
			var maskSprite = new FlxSprite().loadGraphic('assets/images/masks/$mask.png');
			add(maskSprite);

			maskSprite.scale.set(1.5, 1.5);
			maskSprite.updateHitbox();

			switch (i)
			{
				case 0:
					maskSprite.setPosition(0, 0);
				case 1:
					maskSprite.setPosition(1, 1);
				case 2:
					maskSprite.setPosition(0, 2);
				case 3:
					maskSprite.setPosition(-1, 1);
			}
		}

		for (i in members)
		{
			var size = 40;
			i.x *= size;
			i.y *= size;

			i.x += FlxG.width - 97;
			i.y += 12;
		}

		/*for (i => mask in masks)
			{
				var text = new FlxText();
				text.size = 16;
				text.text = mask;
				text.y = i * 20;
				text.x = FlxG.width - text.width;
				add(text);
		}*/

		changeMask(0);
		wheelUpdate(1 / 12);
	}

	var curMask:Int = 0;

	function changeMask(change:Int)
	{
		if (change != 0)
			FlxG.sound.play('assets/sounds/change.wav');

		curMask += change;
		curMask = FlxMath.wrap(curMask, 0, masks.length - 1);

		/*for (i in 0...members.length)
			{
				var guh:FlxSprite = cast members[i];
				guh.color = i == curMask ? FlxColor.YELLOW : FlxColor.WHITE;
		}*/

		PlayState.game.player.setMaskType(masksTypes[curMask]);

		/*PlayState.game.player.setMaskType(switch (masks[curMask])
			{
				case "none": NONE;
				case "skeleton": SKELETON;
				case "pumpkin": PUMPKIN;
				case "spider": SPIDER;
				case "clown": CLOWN;
				default: NONE; // invalid
		});*/
	}

	var wheelTimer:Float = 0.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var wheel = FlxG.mouse.wheel;

		// trace(wheel);

		wheelTimer -= elapsed;

		if (wheel != 0)
		{
			if (wheelTimer <= 0)
			{
				wheelTimer = 0.069; // nice
				if (wheel > 0)
				{
					changeMask(-1);
				}
				else if (wheel < 0)
				{
					changeMask(1);
				}
			}
		}

		wheelUpdate(elapsed);

		// trace(wheel);
	}

	function wheelUpdate(elapsed:Float)
	{
		for (i => member in members)
		{
			var selected = (i == curMask);

			member.scale.x = FlxMath.lerp(member.scale.x, selected ? 2.0 : 1.5, elapsed * 12);
			member.scale.y = member.scale.x;

			member.colorTransform.redOffset = FlxMath.lerp(member.colorTransform.redOffset, selected ? 0 : -150, elapsed * 12);
			member.colorTransform.greenOffset = member.colorTransform.redOffset;
			member.colorTransform.blueOffset = member.colorTransform.redOffset;
		}
	}
}
