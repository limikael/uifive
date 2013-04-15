package uifive.dragdrop;

import uifive.base.Widget;

/**
 * Drop event.
 */
class DropEvent {

	public var localX(default,null):Int;
	public var localY(default,null):Int;
	public var target(default,null):Widget;

	/**
	 * Drop event.
	 */
	public function new(t:Widget, x:Int, y:Int):Void {
		target=t;
		localX=x;
		localY=y;
	}
}
