package uifive.widgets;

import uifive.base.Widget;
import uifive.signals.Signal;

/**
 * Label.
 */
class Button extends Widget {

	public var enabled(getEnabled,setEnabled):Bool;
	public var onClick(default,null):Signal;

	private var _text:String;


	/**
	 * Construct.
	 */
	public function new(text:String=null) {
		_node=js.Lib.document.createElement("button");

		super();

		height=25;

		setText(text);

		onClick=new Signal();

		_node.onclick=function(e) {
			onClick.dispatch();
		}
	}

	/**
	 * Set text.
	 */
	private function setText(text:String) {
		_text=text;

		if (_text==null)
			_text="";

		_node.innerHTML=_text;
	}

	/**
	 * Set enabled.
	 */
	public function setEnabled(value:Bool):Bool {
		var d:Dynamic=cast _node;
		d.disabled=!value;

		return getEnabled();
	}

	/**
	 * Get enabled.
	 */
	public function getEnabled():Bool {
		var d:Dynamic=cast _node;

		return !d.disabled;
	}
}