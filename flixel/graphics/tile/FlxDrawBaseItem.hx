package flixel.graphics.tile;

import flixel.FlxCamera;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxMatrix;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;

/**
 * ...
 * @author Zaphod
 */
@:generic
class FlxDrawBaseItem
{
	public var next:FlxDrawBaseItem;
	
	public var graphics:FlxGraphic;
	public var antialiasing:Bool = false;
	public var colored:Bool = false;
	public var hasColorOffsets:Bool = false;
	public var blending:Int = 0;
	
	public var type:FlxDrawItemType;
	
	public var numVertices(get, never):Int;
	
	public var numTriangles(get, never):Int;
	
	public function new() {}
	
	public function reset():Void
	{
		graphics = null;
		antialiasing = false;
		next = null;
	}
	
	public function dispose():Void
	{
		graphics = null;
		next = null;
		type = null;
	}
	
	public function render(camera:FlxCamera):Void {}
	
	public function addQuad(frame:FlxFrame, matrix:FlxMatrix, ?transform:ColorTransform):Void {}
	
	private function get_numVertices():Int
	{
		return 0;
	}
	
	private function get_numTriangles():Int
	{
		return 0;
	}
}

enum FlxDrawItemType 
{
	TILES;
	TRIANGLES;
}
