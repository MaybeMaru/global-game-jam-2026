package editor;

import Street.MapChunk;
import Street.MapChunkType;
import Street.TileType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Serializer;
import haxe.Unserializer;

class ChunkEditor extends FlxState
{
	var curChunk:Int = 0;
	var curChunkType:MapChunkType;

	var usedSize:FlxSprite;
	var floorLevel:FlxSprite;
	var tile:FlxSprite;

	var levelContainer:FlxTypedGroup<Street>;
	var level:Street;

	var curTileText:FlxText;
	var curChunkText:FlxText;
	var flippedText:FlxText;

	var curTile:Int = 0;
	var curTileType:TileType = TileType.BLOCK;
	final tileTypes:Array<TileType> = [TileType.BLOCK, TileType.ROAD, TileType.HOUSE, TileType.KID];
	final chunkTypesList:Array<MapChunkType> = [
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
		SPIDER_3,
		HALL_2,
		HALL_4,
		HALL_8,
		HALL_14,
		TUTORIAL
	];

	var flipped:Bool = false;

	override function create()
	{
		super.create();

		var grid = new FlxBackdrop();
		grid.makeGraphic(8, 8, 0xFF808080);
		for (x in 0...8)
		{
			for (y in 0...8)
			{
				if ((x + y) % 2 == 0)
				{
					grid.graphic.bitmap.setPixel32(x, y, 0xFF484848);
				}
			}
		}
		grid.scale.set(Street.tileSize, Street.tileSize);
		grid.updateHitbox();
		add(grid);

		usedSize = new FlxSprite().makeGraphic(1, 1, FlxColor.RED);
		usedSize.alpha = 0.1;
		add(usedSize);

		floorLevel = new FlxSprite().makeGraphic(1, 1, FlxColor.BLUE);
		floorLevel.alpha = 0.1;
		add(floorLevel);

		levelContainer = new FlxTypedGroup<Street>();
		levelContainer.active = false;
		add(levelContainer);

		FlxG.mouse.visible = true;

		tile = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
		tile.setGraphicSize(Street.tileSize, Street.tileSize);
		tile.updateHitbox();
		add(tile);

		var uiCam = FlxG.cameras.add(new FlxCamera(), false);
		uiCam.bgColor.alpha = 0;

		curChunkText = new FlxText();
		curChunkText.size = 16;
		curChunkText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		curChunkText.camera = uiCam;
		add(curChunkText);

		flippedText = new FlxText();
		flippedText.size = 16;
		flippedText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		flippedText.camera = uiCam;
		add(flippedText);

		curTileText = new FlxText();
		curTileText.size = 16;
		curTileText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		curTileText.camera = uiCam;
		add(curTileText);

		changeChunk(0);
		changeTile(0);
		changeFlipped(false);
	}

	function changeChunk(change:Int)
	{
		curChunk += change;
		curChunk = FlxMath.wrap(curChunk, 0, chunkTypesList.length - 1);
		curChunkType = chunkTypesList[curChunk];
		_regenChunk = true;

		curChunkText.text = curChunkType;
		curChunkText.x = 2;
		curChunkText.y = 2;
	}

	function changeTile(change:Int)
	{
		curTile += change;
		curTile = FlxMath.wrap(curTile, 0, tileTypes.length - 1);
		curTileType = tileTypes[curTile];

		curTileText.text = switch (curTileType)
		{
			case TileType.BLOCK: "BLOCK";
			case TileType.ROAD: "ROAD";
			case TileType.HOUSE: "HOUSE";
			case TileType.KID: "KID";
			default: "INVALID TILE";
		};
		curTileText.x = FlxG.width - curTileText.width - 2;
		curTileText.y = 2;
	}

	function regenChunk()
	{
		if (level != null)
		{
			level.destroy();
			levelContainer.remove(level);
		}

		level = new Street(-1);
		level.addChunk(curChunkType, flipped);
		levelContainer.add(level);

		var chunkData = Street.chunkData.get(curChunkType);

		usedSize.setGraphicSize(chunkData.tiles[0].length * Street.tileSize, chunkData.tiles.length * Street.tileSize);
		usedSize.updateHitbox();
		usedSize.y = Street.floorY - usedSize.height;

		floorLevel.setGraphicSize(usedSize.width, Street.tileSize / 2);
		floorLevel.updateHitbox();
		floorLevel.y = Street.floorY - (Street.tileSize * 3) + (Street.tileSize / 4);
	}

	var tileX:Int = 0;
	var tileY:Int = 0;

	function getCurrentChunk()
	{
		var chunk = Street.chunkData.get(curChunkType);
		return chunk;
	}

	function getChunkWidth(chunk:MapChunk):Int
	{
		var w:Int = 0;
		for (line in chunk.tiles)
		{
			w = FlxMath.maxInt(w, line.length);
		}
		return w;
	}

	function replaceTileAt(x:Int, y:Int, tileType:TileType)
	{
		var chunk = getCurrentChunk();
		var chunkWidth = getChunkWidth(chunk);

		if (y < 0)
		{
			for (i in 0...FlxMath.absInt(y))
			{
				var line = "";
				for (i in 0...chunkWidth)
					line += TileType.AIR;

				chunk.tiles.unshift(line);
				setChunkDirty();
			}
			y = 0;
		}

		if ((x > 0) && (x >= chunkWidth))
		{
			for (tileID in 0...chunk.tiles.length)
			{
				while (chunk.tiles[tileID].length - 1 < x)
				{
					chunk.tiles[tileID] = chunk.tiles[tileID] + TileType.AIR;
					setChunkDirty();
				}
			}
		}

		var line = chunk.tiles[y];
		if (line == null)
			return;

		var tile = line.charAt(x);
		if (tile != "" && tile != tileType)
		{
			line = replaceChar(line, x, tileType);
			chunk.tiles[y] = line;
			setChunkDirty();
		}
	}

	function setChunkDirty()
	{
		_regenChunk = true;
	}

	function changeFlipped(value:Bool)
	{
		flippedText.text = 'Flipped: $value';
		flippedText.x = 2;
		flippedText.y = 18;

		flipped = value;
		changeChunk(0);
	}

	function isLineEmpty(line:String):Bool
	{
		for (i in 0...line.length)
		{
			if (line.charAt(i) != TileType.AIR)
				return false;
		}
		return true;
	}

	function isColumnEmpty(chunk:MapChunk, x:Int):Bool
	{
		for (line in chunk.tiles)
		{
			if (line.charAt(x) != TileType.AIR)
				return false;
		}
		return true;
	}

	var _regenChunk:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// visual chunk x, y
		var view = FlxG.mouse.getWorldPosition(camera);
		tileX = Math.floor(view.x / Street.tileSize);
		tileY = Math.floor(view.y / Street.tileSize);

		tile.setPosition(tileX * Street.tileSize, tileY * Street.tileSize);
		tile.alpha = FlxMath.remapToRange(FlxMath.fastSin(FlxG.game.ticks / 100), -1, 1, 0.6, 0.8);

		// actual tile Y of the chunk data
		tileX = Math.floor((flipped ? (usedSize.width - view.x) : view.x) / Street.tileSize);
		tileY = Math.floor((view.y - usedSize.y) / Street.tileSize);
		view.put();

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new MainMenu());

		// erase tile
		if (FlxG.mouse.justPressedRight)
		{
			replaceTileAt(tileX, tileY, TileType.AIR);

			// remove unused lines
			var chunk = getCurrentChunk();
			while (chunk.tiles.length > 1 && isLineEmpty(chunk.tiles[0]))
			{
				chunk.tiles.shift();
			}

			// remove unused columns
			var checkX = getChunkWidth(chunk) - 1;
			while (checkX > 1 && isColumnEmpty(chunk, checkX))
			{
				for (y => line in chunk.tiles)
				{
					chunk.tiles[y] = chunk.tiles[y].substr(0, checkX);
				}
				checkX--;
			}
		}
		// add tile
		else if (FlxG.mouse.justPressed)
		{
			replaceTileAt(tileX, tileY, curTileType);
		}

		// flip
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT)
		{
			changeFlipped(!flipped);
		}

		// chunk type change
		if (FlxG.keys.justPressed.UP)
			changeChunk(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeChunk(1);

		if (_regenChunk)
		{
			_regenChunk = false;
			regenChunk();
		}

		// tile type change
		if (FlxG.mouse.wheel < 0)
			changeTile(-1);
		else if (FlxG.mouse.wheel > 0)
			changeTile(1);

		if (FlxG.keys.pressed.Q)
			camera.zoom -= elapsed * camera.zoom;

		if (FlxG.keys.pressed.E)
			camera.zoom += elapsed * camera.zoom;

		var fast = FlxG.keys.pressed.SHIFT;
		var speed = fast ? 3.0 : 1.0;

		if (FlxG.keys.pressed.W)
			camera.scroll.y -= 200 * elapsed * speed;
		if (FlxG.keys.pressed.S)
			camera.scroll.y += 200 * elapsed * speed;
		if (FlxG.keys.pressed.A)
			camera.scroll.x -= 200 * elapsed * speed;
		if (FlxG.keys.pressed.D)
			camera.scroll.x += 200 * elapsed * speed;

		if (FlxG.keys.justPressed.ENTER)
		{
			final save:String = Serializer.run(Street.chunkData);
			#if sys
			sys.io.File.saveContent('assets/data/chunkData.txt', save);
			trace("saved new chunk data!");
			#end
		}
	}

	static inline function replaceChar(string:String, index:Int, char:String):String
	{
		return string.substr(0, index) + char + string.substr(index + 1);
	}
}
