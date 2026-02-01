import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

enum MapTileType
{
	TUTORIAL;
	BASIC_STREET_1;
	BASIC_STREET_2;
	HALL_2;
	HALL_4;
	HALL_8;
	HALL_14;
	SKELETON_1;
	SKELETON_2;
	SKELETON_3;
	CLOWN_1;
	CLOWN_2;
	CLOWN_3;
	SPIDER_1;
	SPIDER_2;
	SPIDER_3;
}

typedef MapTile =
{
	var tiles:Array<String>;
}

class Street extends FlxGroup
{
	public var levelLength:Float = 4000;

	public var floorY:Float = 400;

	public var houses:FlxGroup;
	public var kids:FlxGroup;
	public var colliders:FlxGroup;

	static final tiles:Map<MapTileType, MapTile> = [
		BASIC_STREET_1 => {
			tiles: [
				//
				"00000300000000", //
				"rrrrrrrrrrrrrr", //
				"00000000000000", //
				"00000000000000", //
			]
		},
		BASIC_STREET_2 => {
			tiles: [
				//
				"10000003002001", //
				"rrrrrrrrrrrrrr", //
				"00000000000000", //
				"00000000000000", //
			]
		},
		HALL_2 => {
			tiles: [
				//
				"rr", //
				"00", //
				"00"
			]
		},
		HALL_4 => {
			tiles: [
				//
				"rrrr", //
				"0000", //
				"0000"
			]
		},
		HALL_8 => {
			tiles: [
				//
				"rrrrrrrr", //
				"00000000", //
				"00000000"
			]
		},
		HALL_14 => {
			tiles: [
				//
				"rrrrrrrrrrrrrr", //
				"00000000000000", //
				"00000000000000"
			]
		},
		SKELETON_1 => {
			tiles: [
				//
				"11111111111110", //
				"11111111111110", //
				"11111111111110", //
				"10000000000000", //
				"10000000000000", //
				"10000000000000", //
				"10000000000000", //
				"10000000000000", //
				"10300000210000", //
				"11111111110000",
				"00000000000000", //
				"00000000000110", //
				"01002020021110", //
				"rrrrrrrrrrrrrr", //
				"00000000000000", //
				"00000000000000"
			]
		},
		SKELETON_2 => {
			tiles: [
				//
				"111111111111111111", //
				"111111111111111111", //
				"111111111111111111", //
				"111111111111111111", //
				"100000000000000001", //
				"100000000000000001", //
				"000000000000000000", //
				"000000000000000000", //
				"000000000000000011", //
				"102300020100000001", //
				"111111111111000000", //
				"000000000000000000", //
				"000000000000000110", //
				"000000000000000110", //
				"00000000000000rrrr", //
				"0000000000000r0000", //
				"000001032020000000", //
				"1200rrrrrrrrr00000", //
				"rrrr00000000000000", //
				"000000000000000000", //
				"000000000000000000"
			]
		},
		SKELETON_3 => {
			tiles: [
				//
				"00001111111111", //
				"00001111111111", //
				"00001111111111", //
				"00001000000001", //
				"00001000000001", //
				"00000000000001", //
				"00000000000001", //
				"00000000000001", //
				"00001002302001", //
				"00001111111111", //
				"00011000000000", //
				"00000000000000", //
				"00000000000000", //
				"00000000000000", //
				"10000000000000", //
				"11000203000001", //
				"rrrrrrrrrrrrrr", //
				"00000000000000", //
				"00000000000000"
			]
		},
		CLOWN_1 => {
			tiles: [
				//
				"0000000000001030022010000000", //
				"r00000000000rrrrrrrrr000000r", //
				"0000000000000000000000000000", //
				"0000000000000000000000000000" //
			]
		},
		CLOWN_2 => {
			tiles: [
				//
				"0000000300000000000300000000", //
				"0000001111110000001111110000", //
				"0000000000000000000000000000", //
				"0000000000000000000000000000", //
				"1000000000100202010000000001", //
				"rrrrrr0000rrrrrrrr0000rrrrrr", //
				"0000000000000000000000000000", //
				"0000000000000000000000000000", //
			]
		},
		CLOWN_3 => {
			tiles: [
				//
				"00000000000000000001320010000", //
				"00000000000100000001111110000", //
				"11100000000000000000000000000", //
				"00000000000000000000000000000", //
				"00000111000000000000000000000", //
				"00000000000000000000000000111", //
				"00000000000030000000010200111", //
				"000000000000rrrr00000rrrrrrrr", //
				"00000000000000000000000000000", //
				"00000000000000000000000000000", //
			]
		},
		SPIDER_1 => {
			tiles: [
				//
				"00001320001000000000", //
				"00001111111000000000", //
				"00000000000000000000", //
				"10000000000000000000", //
				"00000000000012300001", //
				"00000000000011111111", //
				"00011100000000000000", //
				"00000000000000000000", //
				"00000000000000000001", //
				"00000001000200000011", //
				"rrrrrrrrrrrrrrrrrrrr", //
				"00000000000000000000", //
				"00000000000000000000", //
			]
		},
		SPIDER_2 => {
			tiles: [
				//
				"11111111111111111111", //
				"01111111111111111111", //
				"00111111111111111111", //
				"00000000000000000001", //
				"00000000000000000001", //
				"00000000000000000001", //
				"00000000000000000001", //
				"00000000000000000001", //
				"00003000000001302201", //
				"00011111100001111111", //
				"00000000000000000001", //
				"00000000000000000000", //
				"00000000000000000000", //
				"11100000000000000000", //
				"11100000000000000000", //
				"11102000020010000000", //
				"11111111111110000000", //
				"00000000000000000000", //
				"00000000000000030000", //
				"10000200020011111111", //
				"rrrrrrrrrrrrrrrrrrrr", //
				"00000000000000000000", //
				"00000000000000000000"
			]
		},
		SPIDER_3 => {
			tiles: [
				//
				"11111111111111111111", //
				"11111111111111111111", //
				"11111111111111111111", //
				"10000000000000000001", //
				"10000000000000000001", //
				"10000000000000000001", //
				"10000000000000000001", //
				"10000000000000000001", //
				"10300000000000000001", //
				"11111110000000000001", //
				"00000000000000000001", //
				"00000000110000000000", //
				"00000000000000000000", //
				"00000000000000000000", //
				"00000000000000011000", //
				"00000000000000000000", //
				"00000000000000000000", //
				"01111100000000000001", //
				"11000000000000000001", //
				"10002020030000200001", //
				"rrrrrrrrrrrrrrrrrrrr", //
				"00000000000000000000", //
				"00000000000000000000"
			]
		},
		TUTORIAL => {
			tiles: [
				"0000a00000000000000000000b000000000000c0000000000000d0000000000000000000000e", //
				"0000000000000000000000000000000000000000000000000000x00000000000000000000x00", //
				"0000000000000000000000000000000000000000000000000000000000000003000000000000", //
				"0000000000000000000000000000000000000000000300000000000000000011111110000000", //
				"000000000000000000000000000000000000000000rrrrrrr000000000000000000000000000", //
				"0000000000000000000000000000000000000000000000000000000010000000000000000000", //
				"0000100000200200200000100000000000000000000000000000000010001000200200011000", //
				"rrrrrrrrrrrrrrrrrrrrrrrrrrrrr00000000rrrrr0000000rrrrrrrrrrrrrrrrrrrrrrrrrrr", //
				"0000000000000000000000000000000000000000000000000000000000000000000000000000", //
				"0000000000000000000000000000000000000000000000000000000000000000000000000000", //
			]
		}
	];

	var curX:Float = 0;

	public static inline final tileSize:Int = 40;

	static final maskTypes:Array<MaskType> = [SKELETON, PUMPKIN, SPIDER, CLOWN];

	var _lastType:MaskType = NONE;

	function randomMaskType()
	{
		var getMask = _lastType;
		while (getMask == _lastType)
			getMask = maskTypes[FlxG.random.int(0, maskTypes.length - 1)];
		_lastType = getMask;
		return getMask;
	}

	public var darknessPeriods:Array<{startX:Float, endX:Float}> = [];

	public function generateLevel(levelIndex:Int)
	{
		var chunksLength:Int = -1;
		switch (levelIndex)
		{
			case 1:
				chunksLength = 16;
		}

		FlxG.camera.minScrollX = -100;
		addWall(-100, -300);

		darknessPeriods.resize(0);

		var leTiles:Array<MapTileType> = [
			BASIC_STREET_1,
			BASIC_STREET_2,
			SKELETON_1,
			SKELETON_2,
			SKELETON_3,
			CLOWN_1,
			CLOWN_2,
			CLOWN_3,
			SPIDER_1,
			SPIDER_2,
			SPIDER_3
		];

		// tutorial part
		addTile(HALL_8);

		// randomized part
		if (chunksLength > 0)
		{
			var lastTile:MapTileType = null;
			var randoTile = () -> leTiles[FlxG.random.int(0, leTiles.length - 1)];

			for (i in 0...chunksLength)
			{
				var newTile:MapTileType = randoTile();
				while (newTile == lastTile)
					newTile = randoTile();

				var doDarkness = FlxG.random.bool(10);
				var darknessObject:{startX:Float, endX:Float} = null;
				if (doDarkness)
				{
					darknessObject = {startX: curX, endX: 0}
				}

				addTile(newTile, FlxG.random.bool());
				addTile(FlxG.random.bool() ? HALL_2 : HALL_4);

				if (doDarkness)
				{
					darknessObject.endX = curX;
					darknessPeriods.push(darknessObject);
				}

				lastTile = newTile;
			}
		}
		else
		{
			addTile(BASIC_STREET_1);
			addTutorialText('Change your mask to the appropiate of\nthis home and press "W" to knock the door.', curX - 425);
			addTile(HALL_4);
			addTile(BASIC_STREET_2);
			addTutorialText('Kids of your same mask type wont hurt you.', curX - 550);
			addTile(HALL_4);
			addTile(TUTORIAL);
			// addTile(SKELETON_1);
		}

		addTile(HALL_14);

		var endPortal = new EndPortal();
		endPortal.setPosition(curX - 100, 100);
		add(endPortal);

		addWall(curX, -300);
		FlxG.camera.maxScrollX = curX + 100;

		levelLength = curX;
	}

	public function addTile(type:MapTileType, flipped:Bool = false)
	{
		var chunk = new Chunk();
		var tile = tiles.get(type);

		var width = tile.tiles[0].length;
		var height = tile.tiles.length;

		var openShadowX:Float = -1;

		for (y in 0...height)
		{
			for (x in 0...width)
			{
				// var index = y * width + x;

				var xPos = curX + (x * tileSize);
				var yPos = (y * tileSize) - ((height) * tileSize) + floorY;

				var tileLine = tile.tiles[y];
				var tile = tileLine.charAt(flipped ? (tileLine.length - 1 - x) : x);

				// var tile = tile.tiles[index];

				switch (tile)
				{
					case "r":
						var collider = new FlxSprite().loadGraphic('assets/images/road.png');
						collider.offset.y = 12;
						collider.moves = false;
						// collider.active = false;
						collider.x = xPos;
						collider.y = yPos;
						collider.immovable = true;
						colliders.add(collider);
						chunk.add(collider);
					case "0": // air
					case "1":
						// var collider = new FlxSprite().makeGraphic(tileSize, tileSize, 0xff59566a);
						var collider = new FlxSprite().loadGraphic('assets/images/tile.png');
						collider.moves = false;
						// collider.active = false;
						collider.x = xPos;
						collider.y = yPos;
						collider.immovable = true;
						colliders.add(collider);
						chunk.add(collider);
					case "2": // kid
						addKid(randomMaskType(), xPos, yPos, chunk);
					case "3": // house
						var house = new House(randomMaskType(), xPos - (flipped ? tileSize * 4 : 0), yPos);
						houses.add(house);
					case "x":
						if (openShadowX == -1)
						{
							openShadowX = xPos;
						}
						else
						{
							darknessPeriods.push({
								startX: openShadowX,
								endX: xPos
							});
							openShadowX = -1;
						}

					case "a":
						addTutorialText("Use the SKELETON mask\nto shoot bones.", xPos - 200);
					case "b":
						addTutorialText("Use the CLOWN mask\nto float through gaps.", xPos - 75);
					case "c":
						addTutorialText("Use the SPIDER mask\nto double jump obstacles.", xPos - 75);
					case "d":
						addTutorialText("Use the PUMPKIN mask\nto brighten the world.", xPos - 100);
					case "e":
						addTutorialText("Jump in to the portal\nto finish the level.", xPos + 200);
				}
			}
		}

		chunk.members.reverse(); // render order crap

		final chunkWidth = tileSize * width;
		chunk.bounds.set(curX, -300, chunkWidth, 2000);
		chunks.add(chunk);

		curX += chunkWidth;
	}

	function addTutorialText(text:String, x:Float)
	{
		var tutor = new FlxText();
		tutor.font = 'assets/data/headstone.ttf';
		tutor.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		tutor.alignment = CENTER;
		tutor.size = 20;
		tutor.text = text;
		add(tutor);

		tutor.x = x;
		tutor.y = 75;
	}

	public var chunks:FlxTypedGroup<Chunk>;
	public var bigChunk:FlxGroup;

	public function new(curLevel:Int)
	{
		super();

		houses = new FlxGroup();
		add(houses);

		colliders = new FlxGroup();
		// colliders.visible = false;
		// add(colliders);

		chunks = new FlxTypedGroup<Chunk>();
		add(chunks);

		bigChunk = new FlxGroup();
		add(bigChunk);

		kids = new FlxGroup();
		add(kids);

		// tutorial, 8, 14

		generateLevel(curLevel);
	}

	function addKid(type:MaskType, x:Float, y:Float, chunk:Chunk)
	{
		var kid = new Kid(type, chunk);
		kid.setPosition(x, y);
		kids.add(kid);
	}

	function addWall(x:Float, y:Float)
	{
		// var wall = new FlxSprite(x, y);
		// wall.makeGraphic(1, 1, 0xff59566a);
		// wall.setGraphicSize(100, 1000);
		// wall.loadGraphic('assets/images/wall.png');
		// wall.updateHitbox();
		// wall.immovable = true;
		// colliders.add(wall);

		var wall = new FlxSprite(x, y, 'assets/images/bounds trees.png');
		wall.updateHitbox();
		wall.immovable = true;
		colliders.add(wall);
		bigChunk.add(wall);

		if (x > 0)
		{
			wall.flipX = true;
			wall.offset.x += 10;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		colliders.members.resize(0);

		for (chunk in chunks)
		{
			@:privateAccess
			if (chunk._isOnScreen)
				colliders.members.push(chunk);
		}

		for (member in bigChunk.members)
			colliders.members.push(member);
	}
}

class Chunk extends FlxGroup
{
	public function new()
	{
		super();

		bounds = FlxRect.get();
		_rect = FlxRect.get();
	}

	public var bounds:FlxRect;

	var _rect:FlxRect;

	public var _isOnScreen:Bool = false;

	override function update(elapsed:Float)
	{
		/*_rect.copyFrom(bounds);
			_rect.x -= camera.scroll.x;
			_rect.y -= camera.scroll.y;

			_isOnScreen = camera.containsRect(_rect); */
		_isOnScreen = true;
		if (_isOnScreen)
			super.update(elapsed);
	}

	override function draw()
	{
		_rect.copyFrom(bounds);
		_rect.x -= camera.scroll.x;
		_rect.y -= camera.scroll.y;

		_isOnScreen = camera.containsRect(_rect);
		if (_isOnScreen)
			super.draw();
	}
}
