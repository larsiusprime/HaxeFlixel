package flixel.input.actions;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionInput.FlxInputDeviceID;
import flixel.input.actions.FlxActionInput.FlxInputType;
import flixel.input.actions.FlxActionInputAnalog.FlxActionInputAnalogMouseMotion;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalKeyboard;
import flixel.input.actions.FlxActionInputDigitalTest.InputStateGrid;
import flixel.input.keyboard.FlxKey;
import haxe.Json;

import massive.munit.Assert;

/**
 * ...
 * @author 
 */
class FlxActionSetTest extends FlxTest
{

	private var valueTest:String = "";
	
	@Before
	function before()
	{
		
	}
	
	@Test
	function testFromJSON()
	{
		var text = '{"name":"MenuControls","analogActions":["menu_move"],"digitalActions":["menu_up","menu_down","menu_left","menu_right","menu_select","menu_menu","menu_cancel","menu_thing_1","menu_thing_2","menu_thing_3"]}';
		var json = Json.parse(text);
		var set:FlxActionSet = @:privateAccess FlxActionSet.fromJSON(json, null, null);
		
		Assert.isTrue(set.name == "MenuControls");
		Assert.isTrue(set.analogActions != null);
		Assert.isTrue(set.analogActions.length == 1);
		Assert.isTrue(set.digitalActions != null);
		Assert.isTrue(set.digitalActions.length == 10);
		
		var analog = ["menu_move"];
		var digital = ["menu_up", "menu_down", "menu_left", "menu_right", "menu_select", "menu_menu", "menu_cancel", "menu_thing_1", "menu_thing_2", "menu_thing_3"];
		
		var hasAnalog = false;
		
		for (a in analog){
			hasAnalog = false;
			for (aa in set.analogActions)
			{
				if (aa.name == a)
				{
					hasAnalog = true;
				}
			}
			if (!hasAnalog)
			{
				break;
			}
		}
		
		Assert.isTrue(hasAnalog);
		
		var hasDigital = false;
		
		for (d in digital){
			hasDigital = false;
			for (dd in set.digitalActions)
			{
				if (dd.name == d)
				{
					hasDigital = true;
				}
			}
			if (!hasDigital)
			{
				break;
			}
		}
		
		Assert.isTrue(hasDigital);
	}
	
	@Test
	function testToJSON()
	{
		var text = '{"name":"MenuControls","analogActions":["menu_move"],"digitalActions":["menu_up","menu_down","menu_left","menu_right","menu_select","menu_menu","menu_cancel","menu_thing_1","menu_thing_2","menu_thing_3"]}';
		var json = Json.parse(text);
		var set:FlxActionSet = @:privateAccess FlxActionSet.fromJSON(json, null, null);
		
		var outJson = set.toJSON();
		
		var out:{name:String, analogActions:Array<String>, digitalActions:Array<String>} = Json.parse(outJson);
		
		var name = "MenuControls";
		var analogActions = ["menu_move"];
		var digitalActions = ["menu_up", "menu_down", "menu_left", "menu_right", "menu_select", "menu_menu", "menu_cancel", "menu_thing_1", "menu_thing_2", "menu_thing_3"];
		
		Assert.isTrue(out.name == name);
		
		var analogEquivalent = out.analogActions.length == analogActions.length;
		var digitalEquivalent = out.digitalActions.length == digitalActions.length;
		
		if (analogEquivalent)
		{
			for (i in 0...analogActions.length)
			{
				if (out.analogActions.indexOf(analogActions[i]) == -1)
				{
					analogEquivalent == false;
					break;
				}
			}
		}
		
		Assert.isTrue(analogEquivalent);
		
		if (digitalEquivalent)
		{
			for (i in 0...digitalActions.length)
			{
				if (out.digitalActions.indexOf(digitalActions[i]) == -1)
				{
					digitalEquivalent == false;
					break;
				}
			}
		}
		
		Assert.isTrue(digitalEquivalent);
	}
	
	@Test
	function testAddRemoveDigital()
	{
		var set = new FlxActionSet("test", [], []);
		
		Assert.isTrue(set.digitalActions.length == 0);
		
		var d1 = new FlxActionDigital("d1");
		var d2 = new FlxActionDigital("d2");
		
		set.addDigital(d1);
		Assert.isTrue(set.digitalActions.length == 1);
		set.addDigital(d2);
		Assert.isTrue(set.digitalActions.length == 2);
		
		set.removeDigital(d1);
		Assert.isTrue(set.digitalActions.length == 1);
		Assert.isTrue(set.digitalActions[0] == d2);
		set.removeDigital(d2);
		Assert.isTrue(set.digitalActions.length == 0);
	}
	
	@Test
	function testAddRemoveAnalog()
	{
		var set = new FlxActionSet("test", [], []);
		
		Assert.isTrue(set.analogActions.length == 0);
		
		var a1 = new FlxActionAnalog("a1");
		var a2 = new FlxActionAnalog("a2");
		
		set.addAnalog(a1);
		Assert.isTrue(set.analogActions.length == 1);
		set.addAnalog(a2);
		Assert.isTrue(set.analogActions.length == 2);
		
		set.removeAnalog(a1);
		Assert.isTrue(set.analogActions.length == 1);
		Assert.isTrue(set.analogActions[0] == a2);
		set.removeAnalog(a2);
		Assert.isTrue(set.analogActions.length == 0);
	}
	
	@Test
	function testUpdateAndCallbacks()
	{
		var text = '{"name":"MenuControls","analogActions":["menu_move"],"digitalActions":["menu_up","menu_down","menu_left","menu_right","menu_select","menu_menu","menu_cancel","menu_thing_1","menu_thing_2","menu_thing_3"]}';
		var json = Json.parse(text);
		var set:FlxActionSet = @:privateAccess FlxActionSet.fromJSON(json, null, null);
		
		var keys = [FlxKey.A, FlxKey.B, FlxKey.C, FlxKey.D, FlxKey.E, FlxKey.F, FlxKey.G, FlxKey.H, FlxKey.I, FlxKey.J];
		
		for (i in 0...set.digitalActions.length)
		{
			var action:FlxActionDigital = set.digitalActions[i];
			action.addInput(new FlxActionInputDigitalKeyboard(keys[i], FlxInputState.JUST_PRESSED));
			action.callback = function(a:FlxActionDigital)
			{
				onCallback(a.name);
			};
		}
		
		set.analogActions[0].addInput(new FlxActionInputAnalogMouseMotion(MOVED));
		set.analogActions[0].callback = function(a:FlxActionAnalog)
		{
			onCallback(a.name);
		};
		
		valueTest = "";
		
		for (key in keys)
		{
			clearFlxKey(key, set);
			clickFlxKey(key, true, set);
		}
		
		step();
		set.update();
		
		moveMousePosition(100, 100, set);
		
		step();
		set.update();
		
		Assert.isTrue(valueTest == "menu_up,menu_down,menu_left,menu_right,menu_select,menu_menu,menu_cancel,menu_thing_1,menu_thing_2,menu_thing_3,menu_move");
	}
	
	@Test
	function testAttachSteamController()
	{
		var text = '{"name":"MenuControls","analogActions":["menu_move"],"digitalActions":["menu_up","menu_down","menu_left","menu_right","menu_select","menu_menu","menu_cancel","menu_thing_1","menu_thing_2","menu_thing_3"]}';
		var json = Json.parse(text);
		var set:FlxActionSet = @:privateAccess FlxActionSet.fromJSON(json, null, null);
		
		for (i in 0...set.digitalActions.length)
		{
			var d:FlxActionDigital = set.digitalActions[i];
			@:privateAccess d.steamHandle = i;
			d.callback = function(a:FlxActionDigital)
			{
				onCallback(a.name);
			}
		}
		
		var a:FlxActionAnalog = set.analogActions[0];
		@:privateAccess a.steamHandle = 99;
		a.callback = function(a:FlxActionAnalog)
		{
			onCallback(a.name+"_" + a.x + "x" + a.y);
		}
		
		var controller = 0;
		
		set.attachSteamController(controller, true);
		
		valueTest = "";
		
		for (i in 0...set.digitalActions.length)
		{
			clearSteamDigital(controller, i, set);
			clickSteamDigital(controller, i, true, set);
		}
		
		step();
		set.update();
		
		moveSteamAnalog(controller, 99, 100, 100, set);
		
		Assert.isTrue(valueTest == "menu_up,menu_down,menu_left,menu_right,menu_select,menu_menu,menu_cancel,menu_thing_1,menu_thing_2,menu_thing_3,menu_move_100x100");
	}
	
	private function onCallback(str:String)
	{
		if (valueTest != "")
		{
			valueTest += ",";
		}
		valueTest += str;
	}
	
	private function moveMousePosition(X:Float, Y:Float, set:FlxActionSet)
	{
		if (FlxG.mouse == null) return;
		step();
		FlxG.mouse.setGlobalScreenPositionUnsafe(X, Y);
		set.update();
	}
	
	private function moveSteamAnalog(controller:Int, actionHandle:Int, X:Float, Y:Float, set:FlxActionSet)
	{
		step();
		
		SteamMock.setAnalogAction(controller, actionHandle, X, Y, true);
		
		set.update();
	}
	
	@:access(flixel.input.FlxKeyManager)
	private function clickFlxKey(key:FlxKey, pressed:Bool, set:FlxActionSet)
	{
		if (FlxG.keys == null || FlxG.keys._keyListMap == null) return;
		
		var input:FlxInput<Int> = FlxG.keys._keyListMap.get(key);
		if (input == null) return;
		
		step();
		set.update();
		
		if (pressed)
		{
			input.press();
		}
		else
		{
			input.release();
		}
		
		set.update();
		
	}
	
	private function clickSteamDigital(controller:Int, actionHandle:Int, pressed:Bool, set:FlxActionSet)
	{
		step();
		set.update();
		
		SteamMock.setDigitalAction(controller, actionHandle, pressed);
		
		set.update();
	}
	
	@:access(flixel.input.FlxKeyManager)
	private function clearFlxKey(key:FlxKey, set:FlxActionSet)
	{
		var input:FlxInput<Int> = FlxG.keys._keyListMap.get(key);
		if (input == null) return;
		input.release();
		step();
		set.update();
		step();
		set.update();
	}
	
	private function clearSteamDigital(controller:Int, actionHandle:Int, set:FlxActionSet)
	{
		SteamMock.setDigitalAction(controller, actionHandle, false);
		step();
		set.update();
		step();
		set.update();
	}
}