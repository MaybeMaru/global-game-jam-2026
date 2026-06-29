import Mask.MaskType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Unserializer;
import openfl.Assets;

enum abstract MapChunkType(String) to String
{
	var TUTORIAL;
	var BASIC_STREET_1;
	var BASIC_STREET_2;
	var HALL_2;
	var HALL_4;
	var HALL_8;
	var HALL_14;
	var SKELETON_1;
	var SKELETON_2;
	var SKELETON_3;
	var CLOWN_1;
	var CLOWN_2;
	var CLOWN_3;
	var SPIDER_1;
	var SPIDER_2;
	var SPIDER_3;
}

enum abstract TileType(String) to String from String
{
	var ROAD = "r";
	var AIR = "0";
	var BLOCK = "1";
	var KID = "2";
	var HOUSE = "3";
	var DARKNESS_MARKER = "x";
}

typedef MapChunk =
{
	var tiles:Array<String>;
}

class Street extends FlxGroup
{
	public var levelLength:Float = 4000;

	public static inline var floorY:Float = 400;

	public var houses:FlxGroup;
	public var kids:FlxGroup;
	public var colliders:FlxGroup;

	public static var chunkData(get, null):Map<MapChunkType, MapChunk> = null;

	static function get_chunkData()
	{
		if (chunkData != null)
			return chunkData;

		return chunkData = Unserializer.run(Assets.getText('assets/data/chunkData.txt'));
	}

	public static final chunkTypesList:Array<MapChunkType> = [
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

	var isDebug:Bool = false;

	public function generateLevel(levelIndex:Int)
	{
		if (levelIndex == -1)
		{
			isDebug = true;
			return;
		}

		var chunksLength:Int = -1;
		switch (levelIndex)
		{
			case 1:
				chunksLength = 16;
		}

		FlxG.camera.minScrollX = -100;
		addWall(-100, -300);

		darknessPeriods.resize(0);

		// tutorial part
		addChunk(HALL_8);

		// randomized part
		if (chunksLength > 0)
		{
			var lastChunk:MapChunkType = null;
			var randoChunk = () -> chunkTypesList[FlxG.random.int(0, chunkTypesList.length - 1)];

			for (i in 0...chunksLength)
			{
				var newChunk:MapChunkType = randoChunk();
				while (newChunk == lastChunk)
					newChunk = randoChunk();

				var doDarkness = FlxG.random.bool(10);
				var darknessObject:{startX:Float, endX:Float} = null;
				if (doDarkness)
				{
					darknessObject = {startX: curX, endX: 0}
				}

				addChunk(newChunk, FlxG.random.bool());
				addChunk(FlxG.random.bool() ? HALL_2 : HALL_4);

				if (doDarkness)
				{
					darknessObject.endX = curX;
					darknessPeriods.push(darknessObject);
				}

				lastChunk = newChunk;
			}
		}
		else
		{
			addChunk(BASIC_STREET_1);
			addTutorialText('Change your mask to the appropiate of\nthis home and press "W" to knock the door.', curX - 425);
			addChunk(HALL_4);
			addChunk(BASIC_STREET_2);
			addTutorialText('Kids of your same mask type wont hurt you.', curX - 550);
			addChunk(HALL_4);
			addChunk(TUTORIAL);
			// addChunk(SKELETON_1);
		}

		addChunk(HALL_14);

		var endPortal = new EndPortal();
		endPortal.setPosition(curX - 100, 100);
		add(endPortal);

		addWall(curX, -300);
		FlxG.camera.maxScrollX = curX + 100;

		levelLength = curX;
	}

	function getTileAt(x:Int, y:Int, chunk:MapChunk):String
	{
		var chunkLine = chunk.tiles[y];
		return chunkLine.charAt(x);
	}

	public function addChunk(type:MapChunkType, flipped:Bool = false)
	{
		var chunk = new Chunk();
		var data = chunkData.get(type);

		var width = data.tiles[0].length;
		var height = data.tiles.length;

		var openShadowX:Float = -1;

		for (y in 0...height)
		{
			var chunkLine = data.tiles[y];

			for (x in 0...width)
			{
				var xPos = curX + (x * tileSize);
				var yPos = (y * tileSize) - ((height) * tileSize) + floorY;

				var tileX = flipped ? (chunkLine.length - 1 - x) : x;
				var tileY = y;
				var tile = getTileAt(tileX, tileY, data);

				switch (tile)
				{
					case "r":
						var collider = new FlxSprite().loadGraphic('assets/images/road.png', true, 40, 400);
						collider.offset.y = 12;
						collider.moves = false;
						// collider.active = false;
						collider.x = xPos;
						collider.y = yPos;
						collider.immovable = true;
						colliders.add(collider);
						chunk.add(collider);

						// cool perspective road thing
						final off:Int = (flipped ? -1 : 1);
						if (getTileAt(tileX - off, tileY, data) == "0")
						{
							collider.animation.add("road", [0], 0);
							collider.animation.play("road");
						}
						else if (getTileAt(tileX + off, tileY, data) == "0")
						{
							collider.animation.add("road", [0], 0, true, true);
							collider.animation.play("road");
						}
						else
						{
							collider.animation.add("road", [1], 0);
							collider.animation.play("road");
						}

					case "0": // air

					case "1": // tile block
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

					case "x": // darkness period marker
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

					// hardcoded tutorial bizz
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
	public var backChunk:FlxGroup;

	public function new(curLevel:Int)
	{
		super();

		houses = new FlxGroup();
		add(houses);

		colliders = new FlxGroup();
		// colliders.visible = false;
		// add(colliders);

		backChunk = new FlxGroup();
		add(backChunk);

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
		else
		{
			wall.scrollFactor.set(1.05, 1.05);
			wall.offset.x += 10;
			var wallClone = wall.clone();
			wallClone.setPosition(wall.x, wall.y);
			wallClone.color = 0xff9f8fd9;
			wallClone.scrollFactor.set(0.8, 0.95);
			wallClone.flipY = true;
			wallClone.active = false;
			wallClone.x += wall.flipX ? -50 : 50;
			backChunk.add(wallClone);
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
