import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

enum MapTileType
{
	HALL_8;
	HALL_14;
	SKELETON_1;
	SKELETON_2;
	CLOWN_1;
	CLOWN_2;
	SPIDER_1;
	SPIDER_2;
	PUMPKIN_1;
	PUMPKIN_2;
}

typedef MapTile =
{
	var tiles:Array<Int>;
	var width:Int;
	var height:Int;
}

class Street extends FlxGroup
{
	public var levelLength:Float = 4000;

	public var floorY:Float = 400;

	public var houses:FlxGroup;
	public var kids:FlxGroup;
	public var colliders:FlxGroup;

	static final tiles:Map<MapTileType, MapTile> = [
		HALL_8 => {
			tiles: [
				1, 1, 1, 1, 1, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, //
			],
			width: 8,
			height: 3
		},
		HALL_14 => {
			tiles: [
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
			],
			width: 14,
			height: 3
		},
		SKELETON_1 => {
			tiles: [
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, //
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
				1, 0, 3, 0, 0, 0, 2, 0, 1, 0, 0, 0, 0, 0, //
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, //
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, //
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, //
				0, 1, 0, 0, 2, 0, 1, 0, 0, 2, 0, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
			],
			width: 14,
			height: 15
		},
		SKELETON_2 => {tiles: [], width: 0, height: 0},
		CLOWN_1 => {tiles: [], width: 0, height: 0},
		CLOWN_2 => {tiles: [], width: 0, height: 0},
		SPIDER_1 => {tiles: [], width: 0, height: 0},
		SPIDER_2 => {tiles: [], width: 0, height: 0},
		PUMPKIN_1 => {tiles: [], width: 0, height: 0},
		PUMPKIN_2 => {tiles: [], width: 0, height: 0}
	];

	var curX:Float = 0;

	public static inline final tileSize:Int = 40;

	static final maskTypes:Array<MaskType> = [SKELETON, PUMPKIN, SPIDER, CLOWN];

	function randomMaskType()
	{
		return maskTypes[FlxG.random.int(0, maskTypes.length - 1)];
	}

	public function generateLevel()
	{
		addTile(HALL_14);
		addTile(HALL_8);
		addTile(SKELETON_1);

		levelLength = curX;
	}

	public function addTile(type:MapTileType)
	{
		var tile = tiles.get(type);

		for (y in 0...tile.height)
		{
			for (x in 0...tile.width)
			{
				var index = y * tile.width + x;

				var xPos = curX + (x * tileSize);
				var yPos = (y * tileSize) - ((tile.height) * tileSize) + floorY;

				var tile = tile.tiles[index];

				switch (tile)
				{
					case 0: // air
					case 1:
						var collider = new FlxSprite().makeGraphic(tileSize, tileSize, 0xff59566a);
						collider.x = xPos;
						collider.y = yPos;
						collider.immovable = true;
						colliders.add(collider);
					case 2: // kid
						addKid(randomMaskType(), xPos, yPos);
					case 3: // house
						var house = new House(randomMaskType(), xPos, yPos);
						houses.add(house);
				}
			}
		}

		curX += tileSize * tile.width;
	}

	public function new()
	{
		super();

		houses = new FlxGroup();
		add(houses);

		colliders = new FlxGroup();
		add(colliders);

		kids = new FlxGroup();
		add(kids);

		addWall(-100, -300);

		generateLevel();

		/*var floor = new FlxSprite(0, floorY);
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

			addWall(800, floorY - 50); */
	}

	function addKid(type:MaskType, x:Float, y:Float)
	{
		var kid = new Kid(type);
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
