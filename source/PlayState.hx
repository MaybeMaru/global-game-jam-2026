package;

import Mask.MaskType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
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

		FlxG.mouse.visible = false;

		FlxG.sound.playMusic('assets/music/darkzone.ogg');

		postDraw = new FlxSignal();

		game = this;

		ui = new FlxCamera();
		ui.bgColor.alpha = 0;
		FlxG.cameras.add(ui, false);

		camera.zoom = 1.25;

		FlxG.worldBounds.set(-9999, -9999, 99999, 99999);

		var back = new FlxBackdrop();
		back.scale.set(10, 10);
		back.scrollFactor.set(0.5, 0.5);
		back.velocity.set(50, 50);
		back.alpha = 0.2;
		add(back);

		var background:FlxGroup = new FlxGroup();
		add(background);

		floor = new FlxSprite(0, 400);
		floor.makeGraphic(1, 1, 0xff59566a);
		floor.setGraphicSize(3000, 400);
		floor.updateHitbox();
		floor.immovable = true;
		add(floor);

		player = new Player();
		player.x = 400;
		player.y = 300;
		add(player);

		darkness = new Darkness();
		darkness.x = -400;
		darkness.x -= darkness.width;
		add(darkness);

		var uiStuff = new UI();
		uiStuff.camera = ui;
		add(uiStuff);

		var maskTypes:Array<MaskType> = [PUMPKIN, SKELETON, CLOWN, SPIDER];
		for (i => type in maskTypes)
			background.add(new House(type, 200 + (i * 450)));

		FlxG.debugger.drawDebug = true;

		FlxG.camera.maxScrollY = 450;
		FlxG.camera.targetOffset.set(50, 0);
		// FlxG.camera.followLead.x = 2;
		FlxG.camera.follow(player, PLATFORMER);

		FlxG.camera.pixelPerfectRender = true;
		ui.pixelPerfectRender = true;
	}

	public var player:Player;

	public var floor:FlxSprite;

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
