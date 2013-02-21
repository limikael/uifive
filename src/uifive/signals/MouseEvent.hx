package uifive.signals;

/**
 * Mouse event.
 */
class MouseEvent {

	public var x(default,null):Int;
	public var y(default,null):Int;

	/**
	 * Construct.
	 */
	public function new(pX:Int, pY:Int):Void {
		x=pX;
		y=pY;
	}
}