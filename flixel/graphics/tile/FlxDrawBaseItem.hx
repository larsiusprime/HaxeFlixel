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
	//public var nextTyped:T;
	
	public var next:FlxDrawBaseItem;
	
	public var graphics:FlxGraphic;
	public var antialiasing:Bool = false;
	public var colored:Bool = false;
	public var hasColorOffsets:Bool = false;
	public var blending:Int = 0;
	
	public var type:Int;
	
	public var numVertices(get, never):Int;
	
	public var numTriangles(get, never):Int;
	
	public static inline var TYPE_TILES:Int = 0;
	public static inline var TYPE_TRIANGLES:Int = 1;
	
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
		type = -1;
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