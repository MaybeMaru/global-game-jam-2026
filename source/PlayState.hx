package;

import Mask.MaskType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

// TODO
// title screen
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

	public var curLevel:Int = 0;

	public function new(isTutorial:Bool)
	{
		super();
		curLevel = isTutorial ? 0 : 1;
	}

	override public function create()
	{
		super.create();

		destroySubStates = false;

		FlxG.mouse.visible = false;

		postDraw = new FlxSignal();

		game = this;

		uiCam = new FlxCamera();
		uiCam.bgColor.alpha = 0;
		FlxG.cameras.add(uiCam, false);

		pause = new Pause();
		pause.camera = uiCam;

		camera.zoom = 1.25;

		FlxG.worldBounds.set(-9999, -9999, 99999, 99999);

		var backgradient = FlxGradient.createGradientFlxSprite(1, 300, [0xff000000, 0xff320843]);
		add(backgradient);

		backgradient.scale.x = FlxG.width;
		backgradient.scrollFactor.x = 0;
		backgradient.scrollFactor.y = 0.2;
		backgradient.updateHitbox();

		var stars = new FlxBackdrop('assets/images/stars.png', X);
		stars.y = 25;
		stars.scrollFactor.set(0.03, 0.03);
		stars.alpha = 0.3;
		stars.blend = ADD;
		add(stars);

		var stars = new FlxBackdrop('assets/images/stars.png', X);
		stars.y = 75;
		stars.scrollFactor.set(0.045, 0.045);
		stars.alpha = 0.6;
		stars.flipX = true;
		stars.blend = ADD;
		add(stars);

		var stars = new FlxBackdrop('assets/images/stars.png', X);
		stars.y = 125;
		stars.scrollFactor.set(0.06, 0.06);
		stars.blend = ADD;
		add(stars);

		var moon = new FlxSprite(500, 65).loadGraphic('assets/images/moon.png');
		moon.color = FlxColor.GRAY;
		moon.blend = ADD;
		moon.scrollFactor.set(0.005, 0.005);
		add(moon);

		var city = new FlxBackdrop('assets/images/buildings.png', X);
		city.y = 125;
		city.color = 0xff1b123a;
		city.scrollFactor.set(0.1, 0.1);
		city.flipX = true;
		add(city);

		var trees = new FlxBackdrop('assets/images/trees.png', X);
		trees.y = 210;
		trees.color = 0xff594898;
		trees.scrollFactor.set(0.15, 0.15);
		add(trees);

		var city = new FlxBackdrop('assets/images/buildings.png', X);
		city.y = 150;
		city.color = 0xff594898;
		city.scrollFactor.set(0.2, 0.2);
		add(city);

		var trees = new FlxBackdrop('assets/images/trees.png', X);
		trees.y = 240;
		trees.color = 0xff9f8fd9;
		trees.scrollFactor.set(0.3, 0.3);
		add(trees);

		var trees = new FlxBackdrop('assets/images/trees.png', X);
		trees.y = 260;
		// trees.color = 0xff9f8fd9;
		trees.scrollFactor.set(0.45, 0.45);
		add(trees);

		street = new Street(curLevel);
		add(street);

		player = new Player();
		player.x = Street.tileSize;
		player.y = 200;
		add(player);

		particles = new FlxGroup();
		add(particles);

		darkness = new Darkness();
		add(darkness);

		ui = new UI();
		ui.camera = uiCam;
		add(ui);

		var maskTypes:Array<MaskType> = [
			PUMPKIN, SKELETON, CLOWN, SPIDER, //
			PUMPKIN, SKELETON, CLOWN,    SPIDER
		];
		// for (i => type in maskTypes)
		//	background.add(new House(type, 200 + (i * 450)));

		FlxG.debugger.drawDebug = true;

		FlxG.camera.maxScrollY = 350;
		FlxG.camera.targetOffset.set(50, 0);
		// FlxG.camera.followLead.x = 2;
		FlxG.camera.follow(player, PLATFORMER);

		FlxG.camera.pixelPerfectRender = true;
		uiCam.pixelPerfectRender = true;

		if (curLevel == 0)
		{
			FlxG.sound.playMusic('assets/music/tutorial song.ogg', 1.0, true);
		}
		else
		{
			FlxG.sound.playMusic('assets/music/game loop i think.ogg', 1.0, false);
			FlxG.sound.music.onComplete = () ->
			{
				FlxG.sound.music.play(true, 20209.90);
			}
		}

		uiCam.fade(FlxColor.BLACK, 0.4, true);

		var coolText = new FlxText();
		coolText.size = 40;
		coolText.text = curLevel == 0 ? "Tutorial" : "Level 1";
		coolText.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
		coolText.camera = uiCam;
		add(coolText);

		FlxTween.tween(coolText.scale, {x: 0.8, y: 0.8}, 3, {
			onUpdate: (twn) ->
			{
				coolText.updateHitbox();
				coolText.screenCenter();
			}
		});
		FlxTween.tween(coolText, {alpha: 0}, 1, {startDelay: 2});
	}

	public function endLevel()
	{
		uiCam.visible = false;
		openSubState(new FlxSubState(FlxColor.BLACK));
		FlxG.sound.music.volume = 0.4;
		FlxG.sound.music.fadeOut();
		// FlxG.sound.music.stop();
		// FlxG.sound.music.volume = 0;
		FlxG.sound.play('assets/sounds/endLevel.wav');
		FlxG.camera.flash(FlxColor.WHITE, 3, () ->
		{
			if (curLevel == 0)
			{
				FlxG.switchState(() -> new PlayState(false));
			}
			else
			{
				FlxG.switchState(() -> new MainMenu());
			}

			// curLevel++;

			///if (curLevel == 1)
			// {
			//	FlxG.switchState(() -> new PlayState(false));
			// }

			// FlxG.switchState(() -> new MainMenu());
		});
	}

	public var player:Player;

	public var street:Street;

	override function tryUpdate(elapsed:Float)
	{
		var musicPitch:Float = subState != null ? 0.8 : 1.0;

		var distance = Math.abs(player.x - (darkness.x + darkness.width));

		if (distance <= 400)
		{
			var v = distance / 400;
			musicPitch *= FlxMath.remapToRange(v, 0, 1, 0.3, 1);

			var v = v * 1.5;
			FlxG.camera.color = FlxColor.fromRGBFloat(v, v, v);
			uiCam.color = FlxColor.fromRGBFloat(v, v, v);
		}

		FlxG.sound.music.pitch = FlxMath.lerp(FlxG.sound.music.pitch, musicPitch, elapsed * 4);

		super.tryUpdate(elapsed);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, street.colliders);
		FlxG.collide(street.kids, street.colliders);

		// die
		if (FlxG.overlap(darkness, player))
		{
			openSubState(new FlxSubState());
			uiCam.fade(FlxColor.BLACK, 1);
			FlxG.sound.music.fadeOut(1, 0, (twn) ->
			{
				FlxTimer.wait(0.4, () -> FlxG.resetState());
			});
		}

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
