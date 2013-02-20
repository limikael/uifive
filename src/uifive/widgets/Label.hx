package uifive.widgets;

import uifive.base.Widget;

/**
 * Label.
 */
class Label extends Widget {

	public static inline var LEFT:String="left";
	public static inline var RIGHT:String="right";
	public static inline var CENTER:String="center";

	public var text(getText,setText):String;
	public var align(null,setAlign):String;
	public var selectable(null,setSelectable):Bool;

	private var _text:String;
	private var _align:String;

	/**
	 * Construct.
	 */
	public function new(text:String=null) {
		super();

		setText(text);
	}

	/**
	 * Get text:
	 */
	private function getText():String {
		return _text;
	}

	/**
	 * Set text.
	 */
	private function setText(text:String):String {
		_text=text;

		if (_text==null)
			_text="";

		_node.innerHTML=_text;

		return _text;
	}

	/**
	 * Update style.
	 */
	override private function updateStyle() {
		super.updateStyle();

		switch (_align) {
			case LEFT:
				_node.style.textAlign="left";

			case CENTER:
				_node.style.textAlign="center";

			case RIGHT:
				_node.style.textAlign="right";
		}
	}

	/**
	 * Set align.
	 */
	private function setAlign(value:String):String {
		_align=value;

		updateStyle();

		return _align;
	}

	/**
	 * Set selectable.
	 */
	public function setSelectable(value:Bool):Bool {
		if (!value) {
			var n:Dynamic=cast _node.style;

			n.WebkitTouchCallout="none";
			n.WebkitUserSelect="none";
			n.KhtmlUserSelect="none";
			n.MozUserSelect="none";
			n.MsUserSelect="none";
			n.userSelect="none";

			_node.style.cursor="default";
		}

		return value;
	}
}