import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Street extends FlxGroup
{
	public var floorY:Float = 400;

	public var kids:FlxGroup;
	public var colliders:FlxGroup;

	public function new()
	{
		super();

		colliders = new FlxGroup();
		add(colliders);

		kids = new FlxGroup();
		add(kids);

		var floor = new FlxSprite(0, floorY);
		floor.makeGraphic(1, 1, 0xff59566a);
		floor.setGraphicSize(4000, 400);
		floor.updateHitbox();
		floor.immovable = true;
		colliders.add(floor);

		var wall = new FlxSprite(0, -300);
		wall.makeGraphic(1, 1, 0xff59566a);
		wall.setGraphicSize(100, 1000);
		wall.updateHitbox();
		wall.immovable = true;
		colliders.add(wall);

		var wall = new FlxSprite(floor.width - wall.width, -300);
		wall.makeGraphic(1, 1, 0xff59566a);
		wall.setGraphicSize(100, 1000);
		wall.updateHitbox();
		wall.immovable = true;
		colliders.add(wall);

		addWall(500, floorY - 50);

		addKid(700, floorY - 100);

		addWall(800, floorY - 50);
	}

	function addKid(x:Float, y:Float)
	{
		var kid = new Kid(CLOWN);
		kid.setPosition(x, y);
		kids.add(kid);
	}

	function addWall(x:Float, y:Float)
	{
		var wall = new FlxSprite(x, y);
		wall.makeGraphic(1, 1, 0xff59566a);
		wall.setGraphicSize(100, 1000);
		wall.updateHitbox();
		wall.immovable = true;
		colliders.add(wall);
	}
}
