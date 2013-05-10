package uifive.widgets;

import uifive.base.Widget;

/**
 * An image.
 */
class Image extends Widget {

	public var offsetX(null,setOffsetX):Int;
	public var offsetY(null,setOffsetY):Int;
	public var src(null,setSrc):String;

	private var _offsetX:Int=0;
	private var _offsetY:Int=0;
	private var _src:String="";

	/**
	 * Constructor.
	 */
	public function new(src:String=null, offsX:Int=0, offsY:Int=0) {
		super();

		_offsetX=offsX;
		_offsetY=offsY;
		setSrc(src);

		updateNode();
	}

	/**
	 * Set offset x.
	 */
	private function setOffsetX(value:Int):Int {
		_offsetX=value;

		updateNode();

		return _offsetX;
	}

	/**
	 * Set offset x.
	 */
	private function setOffsetY(value:Int):Int {
		_offsetY=value;

		updateNode();

		return _offsetY;
	}

	/**
	 * Set offset x.
	 */
	private function setSrc(value:String):String {
		if (value==null)
			value="";

		_src=value;

		updateNode();

		return _src;
	}

	/**
	 * Update node.
	 */
	private function updateNode():Void {
		_node.style.backgroundImage="url('"+_src+"')";
		_node.style.backgroundPosition="-"+_offsetX+"px -"+_offsetY+"px";
	}
}