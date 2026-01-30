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
// map view
// title screen
// random map generation
// darkness speed progression
// death sequence
// win sequence
// art
class PlayState extends FlxState
{
	public static var game:PlayState;

	public var uiCam:FlxCamera;

	public var ui:UI;

	public var darkness:Darkness;

	public var particles:FlxGroup;

	var pause:Pause;

	override public function create()
	{
		super.create();

		destroySubStates = false;

		FlxG.mouse.visible = false;

		FlxG.sound.playMusic('assets/music/darkzone.ogg');

		postDraw = new FlxSignal();

		game = this;

		uiCam = new FlxCamera();
		uiCam.bgColor.alpha = 0;
		FlxG.cameras.add(uiCam, false);

		pause = new Pause();
		pause.camera = uiCam;

		camera.zoom = 1.25;

		FlxG.worldBounds.set(-9999, -9999, 99999, 99999);

		var back = new FlxBackdrop();
		back.scale.set(10, 10);
		back.scrollFactor.set(0.5, 0.5);
		back.velocity.set(50, 50);
		back.alpha = 0.2;
		add(back);

		var back2 = new FlxBackdrop(null, X);
		back2.y = 350;
		back2.scale.set(8, 8);
		back2.scrollFactor.set(0.8, 0.8);
		back2.alpha = 0.35;
		add(back2);

		var background:FlxGroup = new FlxGroup();
		add(background);

		street = new Street();
		add(street);

		player = new Player();
		player.x = 400;
		player.y = 300;
		add(player);

		particles = new FlxGroup();
		add(particles);

		darkness = new Darkness();
		darkness.x = -400;
		darkness.x -= darkness.width;
		add(darkness);

		ui = new UI();
		ui.camera = uiCam;
		add(ui);

		var maskTypes:Array<MaskType> = [
			PUMPKIN, SKELETON, CLOWN, SPIDER, //
			PUMPKIN, SKELETON, CLOWN,    SPIDER
		];
		for (i => type in maskTypes)
			background.add(new House(type, 200 + (i * 450)));

		FlxG.debugger.drawDebug = true;

		FlxG.camera.maxScrollY = 450;
		FlxG.camera.targetOffset.set(50, 0);
		// FlxG.camera.followLead.x = 2;
		FlxG.camera.follow(player, PLATFORMER);

		FlxG.camera.pixelPerfectRender = true;
		uiCam.pixelPerfectRender = true;
	}

	public var player:Player;

	public var street:Street;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, street.colliders);
		FlxG.collide(street.kids, street.colliders);

		// die
		if (FlxG.overlap(darkness, player))
			FlxG.resetState();

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.ENTER)
			openSubState(pause);
	}

	public var postDraw:FlxSignal;

	override function draw()
	{
		super.draw();
		postDraw.dispatch();
	}
}
