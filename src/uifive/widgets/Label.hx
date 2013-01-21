package uifive.widgets;

import uifive.base.Widget;

/**
 * Label.
 */
class Label extends Widget {

	public var text(getText,setText):String;

	private var _text:String;

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
}