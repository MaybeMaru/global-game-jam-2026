package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class UI extends FlxGroup
{
	public var life(default, set):Float = 100;

	var dead:Bool = false;

	inline function set_life(v:Float)
	{
		life = FlxMath.bound(v, 0, 100);
		if (life <= 0 && !dead)
		{
			die();
		}
		return life;
	}

	function die()
	{
		dead = true;
		FlxG.sound.music.fadeOut(0.2);
		FlxG.sound.play('assets/sounds/maybe death.ogg').onComplete = () ->
		{
			PlayState.game.uiCam.fade(FlxColor.BLACK, 1, false, () ->
			{
				FlxG.resetState();
			});
		};

		PlayState.game.player.canMove = false;
		PlayState.game.player.y = 1000;
		PlayState.game.player.visible = false;
	}

	public var score(default, set):Int = 0;

	inline function set_score(v):Int
	{
		v = FlxMath.maxInt(v, 0);
		// candyTint.setTint(v / 500);
		return score = v;
	}

	var scoreLerp:Float = 0.0;

	var scoreText:FlxBitmapText;
	var lifeBar:FlxBar;

	// var candyTint:Tint;

	public function new()
	{
		super();

		lifeBar = new FlxBar(0, 0, BOTTOM_TO_TOP, 25, 300, this, 'life');
		lifeBar.createFilledBar(0xff212121, FlxColor.ORANGE, true, FlxColor.BLACK, 3);
		lifeBar.x = 12;
		lifeBar.screenCenter(Y);
		// add(lifeBar);

		// candyTint = new Tint();

		scoreText = new FlxBitmapText();
		scoreText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		scoreText.setPosition(12, 12);
		scoreText.scale.set(3, 3);
		scoreText.updateHitbox();
		scoreText.text = "Candy:\n000000";
		add(scoreText);

		// scoreText.color = 0xffffb6b6;
		// scoreText.shader = candyTint.shader;

		var levelMap = new LevelMap();
		add(levelMap);

		var selector = new MaskSelection();
		add(selector);
	}

	override function draw()
	{
		super.draw();
		lifeBar.camera = this.camera;
		lifeBar.draw();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lifeBar.update(elapsed);

		scoreLerp = FlxMath.lerp(scoreLerp, score, elapsed * 6);

		var formatShit:String = Std.string(Std.int(scoreLerp));
		for (i in 0...6)
		{
			if (formatShit.length < 6)
			{
				formatShit = '0' + formatShit;
			}
		}

		scoreText.text = "Candy:\n" + formatShit;
	}
}
