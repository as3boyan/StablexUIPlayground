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

import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;

class Draggable extends Sprite
{
	public var drag_active:Bool;
	
	public function new() 
	{
		super();
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouse.bind(true));
		addEventListener(MouseEvent.MOUSE_UP, onMouse.bind(false));
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		
		useHandCursor = true;
	}
	
	private function onRemoved(e:Event):Void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		dispose();
	}
	
	private function onMouse(down:Bool,e:MouseEvent):Void 
	{
		if (down)
		{
			startDrag();
		}
		else
		{
			stopDrag();
		}
		
		drag_active = down;
	}
	
	public function dispose()
	{
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouse.bind(true));
		removeEventListener(MouseEvent.MOUSE_UP, onMouse.bind(false));
	}
	
}