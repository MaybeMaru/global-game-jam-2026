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

		makeGraphic(20, 10, FlxColor.GRAY);
		// angularVelocity = 100;
	}

	var speed = 500;

	public function prepare(player:Player)
	{
		velocity.x = player.facing == LEFT ? -speed : speed;
		angularVelocity = player.facing == LEFT ? -speed : speed;
		setPosition(player.x, player.y);
		lifeTime = 4.0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lifeTime -= elapsed;
		if (lifeTime <= 0)
			kill();
	}
}
