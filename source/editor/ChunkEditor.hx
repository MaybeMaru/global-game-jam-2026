package editor;

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
	var tile:FlxSprite;

	var levelContainer:FlxTypedGroup<Street>;
	var level:Street;

	var curTileText:FlxText;
	var curChunkText:FlxText;

	var curTile:Int = 0;
	var curTileType:TileType = TileType.BLOCK;
	final tileTypes:Array<TileType> = [TileType.BLOCK, TileType.ROAD, TileType.HOUSE, TileType.KID];

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

		curTileText = new FlxText();
		curTileText.size = 16;
		curTileText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		curTileText.camera = uiCam;
		add(curTileText);

		changeChunk(0);
		changeTile(0);
	}

	function changeChunk(change:Int)
	{
		curChunk += change;
		curChunk = FlxMath.wrap(curChunk, 0, Street.chunkTypesList.length - 1);
		curChunkType = Street.chunkTypesList[curChunk];
		regenChunk();

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
		level.addChunk(curChunkType);
		levelContainer.add(level);

		var chunkData = Street.chunkData.get(curChunkType);

		usedSize.setGraphicSize(chunkData.tiles[0].length * Street.tileSize, chunkData.tiles.length * Street.tileSize);
		usedSize.updateHitbox();

		usedSize.y = Street.floorY - usedSize.height;
	}

	var tileX:Int = 0;
	var tileY:Int = 0;

	function replaceTileAt(x:Int, y:Int, tileType:TileType)
	{
		var chunk = Street.chunkData.get(curChunkType);
		var line = chunk.tiles[y];
		if (line != null)
		{
			var tile = line.charAt(x);
			if (tile != "" && tile != tileType)
			{
				line = replaceChar(line, x, tileType);
				chunk.tiles[y] = line;
				changeChunk(0);
			}
		}
	}

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
		tileY = Math.floor((view.y - usedSize.y) / Street.tileSize);
		view.put();

		// erase tile
		if (FlxG.mouse.justPressedRight)
		{
			replaceTileAt(tileX, tileY, TileType.AIR);
		}
		// add tile
		else if (FlxG.mouse.justPressed)
		{
			replaceTileAt(tileX, tileY, curTileType);
		}

		// chunk type change
		if (FlxG.keys.justPressed.UP)
			changeChunk(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeChunk(1);

		// tile type change
		if (FlxG.mouse.wheel < 0)
			changeTile(-1);
		else if (FlxG.mouse.wheel > 0)
			changeTile(1);

		if (FlxG.keys.pressed.Q)
			camera.zoom -= elapsed * camera.zoom;

		if (FlxG.keys.pressed.E)
			camera.zoom += elapsed * camera.zoom;

		if (FlxG.keys.pressed.W)
			camera.scroll.y -= 200 * elapsed;
		if (FlxG.keys.pressed.S)
			camera.scroll.y += 200 * elapsed;
		if (FlxG.keys.pressed.A)
			camera.scroll.x -= 200 * elapsed;
		if (FlxG.keys.pressed.D)
			camera.scroll.x += 200 * elapsed;

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
