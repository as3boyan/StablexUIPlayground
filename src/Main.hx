package ;

/* 
 *  Copyright (c) 2013 AS3Boyan
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */ 

import haxe.Timer;
import motion.Actuate;
import nme.text.AntiAliasType;
import nme.text.TextFormat;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFieldType;
import ru.stablex.ui.RTXml;
import ru.stablex.ui.UIBuilder;
import sys.FileSystem;

#if !flash
import fileutils.TextFileUtils;
#end

class Main extends Sprite 
{	
	private var gui:Sprite;
	private var gui_container:Draggable;
	private var tf:TextField;
	private var debug_tf:TextField;
	
	public function new()
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		
		gui_container = new Draggable();
		addChild(gui_container);
		
		tf = new TextField();
		
		var example_xml_data:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Text left=\"50\" top=\"100\" text=\"'My first widget!'\"/>";
		
		#if flash
		tf.text = example_xml_data;
		#else
		if (FileSystem.exists("first.xml"))
		{
			tf.text = TextFileUtils.readTextFile("first.xml");
		}
		else
		{
			tf.text = example_xml_data;
		}
		#end

		var text_format:TextFormat = new TextFormat("Verdana", 18);
		tf.defaultTextFormat = text_format;
		
		tf.border = true;
		tf.borderColor = 0x515151;
		tf.background = true;
		tf.backgroundColor = 0xF0F0F0;
		tf.type = TextFieldType.INPUT;
		tf.multiline = true;
		tf.wordWrap = true;
		
		#if flash
		tf.alwaysShowSelection = true;
		tf.useRichTextClipboard = true;
		#end
		
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.selectable = true;
		tf.addEventListener(Event.CHANGE, onChange);
		addChild(tf);
		
		debug_tf = new TextField();
		addChild(debug_tf);
		
		stage.addEventListener(Event.RESIZE, onResize);
		
		reloadGUI();
		onResize(null);
		
		#if !flash
			var timer = new Timer(5000);
			timer.run = function () { TextFileUtils.updateTextFile("first.xml", tf.text); };
		#end
	}
	
	private function onResize(e:Event):Void 
	{
		Actuate.tween(tf, 1, { x:1, y:stage.stageHeight * 2 / 3, width:stage.stageWidth - 1, height:stage.stageHeight * 1 / 3 } );
		Actuate.tween(debug_tf, 1, { width:stage.stageWidth } );
	}
	
	public static function main() 
	{		
		UIBuilder.init(null, true);
		Lib.current.addChild(new Main());
	}
	
	private function onChange(e:Event):Void 
	{
		reloadGUI();
	}
	
	private function reloadGUI()
	{
		if (gui != null && gui.parent != null)
		{
			gui_container.removeChild(gui);
		}
		
		var bugs_found:Bool = false;
		
		try 
		{
			gui = RTXml.buildFn(tf.text)();
			gui_container.addChild(gui);
		}
		catch (unknown:Dynamic)
		{
			trace(unknown);
			debug_tf.text = Std.string(unknown);
			bugs_found = true;
		}
		
		debug_tf.visible = bugs_found;
	}
}
