package;

import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.geom.ColorTransform;

class MaskSelection extends FlxTypedGroup<FlxSprite>
{
	var masks:Array<String> = ["skeleton", "clown", "spider", "pumpkin"];
	var masksTypes:Array<MaskType> = [SKELETON, CLOWN, SPIDER, PUMPKIN];

	var maskSprites:Array<FlxSprite> = [];

	public function new()
	{
		super();

		var circle = new FlxSprite().makeGraphic(Std.int(100 / 3), Std.int(100 / 3), 0);
		FlxSpriteUtil.drawCircle(circle, circle.width / 2, circle.height / 2, 48 / 3, FlxColor.TRANSPARENT, {color: FlxColor.WHITE, thickness: 2},
			{smoothing: false});
		circle.scale.set(3, 3);
		circle.updateHitbox();
		add(circle);

		for (i => mask in masks)
		{
			var maskSprite = new FlxSprite().loadGraphic('assets/images/masks/$mask.png');
			add(maskSprite);
			maskSprites.push(maskSprite);

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

		circle.x = FlxG.width - circle.width - 12;
		circle.y = 12;

		// this is some of the shittiest code ive made in my lifetime
		for (i in maskSprites)
		{
			var size = 42;
			i.x *= size;
			i.y *= size;

			i.x += FlxG.width - 77;
			i.y += 6;
		}

		for (member in members)
		{
			member.x -= 6;
			member.y += 6;
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

		whiteTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
	}

	var whiteTransform:ColorTransform;

	override function draw()
	{
		var leMask = maskSprites[curMask];
		var trans = leMask.colorTransform;
		@:privateAccess leMask.colorTransform = whiteTransform;

		var baseScale = leMask.scale.copyTo(FlxPoint.get());

		leMask.scale.scale(1.1, 1.1);
		leMask.draw();
		leMask.scale.copyFrom(baseScale);
		baseScale.put();

		@:privateAccess leMask.colorTransform = trans;

		super.draw();
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

		if (wheel != 0 && PlayState.game.player.canMove)
		{
			if (wheelTimer <= 0)
			{
				wheelTimer = 0.069; // nice
				if (wheel > 0)
				{
					changeMask(1);
				}
				else if (wheel < 0)
				{
					changeMask(-1);
				}
			}
		}

		wheelUpdate(elapsed);

		// trace(wheel);
	}

	function wheelUpdate(elapsed:Float)
	{
		for (i => member in maskSprites)
		{
			var selected = (i == curMask);

			member.scale.x = FlxMath.lerp(member.scale.x, selected ? 2.0 : 1.5, elapsed * 12);
			member.scale.y = member.scale.x;

			member.colorTransform.blueOffset = FlxMath.lerp(member.colorTransform.blueOffset, selected ? 0 : -150, elapsed * 12) / 1.8;
			member.colorTransform.greenOffset = member.colorTransform.blueOffset * 4;
			member.colorTransform.redOffset = member.colorTransform.blueOffset * 4;
		}
	}
}
