package uifive.utils;

/**
 * Point.
 */
class Point {

	public var x(default,default):Int;
	public var y(default,default):Int;

	/**
	 * Construct.
	 */
	public function new(pX:Int, pY:Int):Void {
		x=pX;
		y=pY;
	}

	/**
	 * Add a point.
	 */
	public function add(p:Point):Point {
		return new Point(x+p.x,y+p.y);
	}

	/**
	 * Sub a point.
	 */
	public function sub(p:Point):Point {
		return new Point(x-p.x,y-p.y);
	}
}