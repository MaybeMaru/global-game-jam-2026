package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public static var game:PlayState;

	public var ui:FlxCamera;

	override public function create()
	{
		super.create();

		game = this;

		ui = new FlxCamera();
		ui.bgColor.alpha = 0;
		FlxG.cameras.add(ui, false);

		FlxG.worldBounds.set(-9999, -9999, 99999, 99999);

		var back = new FlxBackdrop();
		back.scale.set(10, 10);
		back.scrollFactor.set(0.5, 0.5);
		back.velocity.set(50, 50);
		back.alpha = 0.2;
		add(back);

		player = new Player();
		player.x = 400;
		player.y = 300;
		add(player);

		var selector = new MaskSelection();
		selector.camera = ui;
		add(selector);

		FlxG.debugger.drawDebug = true;

		floor = new FlxSprite(0, 400);
		floor.makeGraphic(800, 400, FlxColor.GRAY);
		floor.immovable = true;
		add(floor);

		FlxG.camera.follow(player, PLATFORMER);
	}

	public var player:Player;

	var floor:FlxSprite;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, floor);

		if (FlxG.keys.justPressed.R)
			FlxG.resetGame();
	}
}
