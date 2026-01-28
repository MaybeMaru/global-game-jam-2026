package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

// TODO
// selection wheel
// houses
// walking kids
// health/speed bar
// points candy
// art
class PlayState extends FlxState
{
	public static var game:PlayState;

	public var ui:FlxCamera;

	public var darkness:Darkness;

	override public function create()
	{
		super.create();

		postDraw = new FlxSignal();

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

		floor = new FlxSprite(0, 400);
		floor.makeGraphic(1, 1, FlxColor.GRAY);
		floor.setGraphicSize(2000, 400);
		floor.updateHitbox();
		floor.immovable = true;
		add(floor);

		player = new Player();
		player.x = 400;
		player.y = 300;
		add(player);

		darkness = new Darkness();
		darkness.x = -300;
		darkness.x -= darkness.width;
		add(darkness);

		var selector = new MaskSelection();
		selector.camera = ui;
		add(selector);

		FlxG.debugger.drawDebug = true;

		FlxG.camera.maxScrollY = 500;
		FlxG.camera.targetOffset.set(50, 0);
		FlxG.camera.follow(player, PLATFORMER);
	}

	public var player:Player;

	var floor:FlxSprite;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, floor);

		// die
		if (FlxG.overlap(darkness, player))
			FlxG.resetState();

		if (FlxG.keys.justPressed.R)
			FlxG.resetGame();
	}

	public var postDraw:FlxSignal;

	override function draw()
	{
		super.draw();
		postDraw.dispatch();
	}
}
