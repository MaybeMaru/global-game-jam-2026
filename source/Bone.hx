package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDirection;

class Bone extends FlxSprite
{
	var lifeTime:Float = 0.0;

	public function new()
	{
		super();

		// makeGraphic(20, 10, FlxColor.WHITE);
		loadGraphic('assets/images/bone.png');
		// angularVelocity = 100;
	}

	var speed = 500;

	public function prepare(player:Player)
	{
		velocity.x = player.facing == LEFT ? -speed : speed;
		angularVelocity = player.facing == LEFT ? -speed : speed;
		setPosition(player.x, player.y + 20);
		lifeTime = 4.0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!isOnScreen())
		{
			lifeTime = 0;
		}

		lifeTime -= elapsed;
		if (lifeTime <= 0)
			kill();
	}
}
