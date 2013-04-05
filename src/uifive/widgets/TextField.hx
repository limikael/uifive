package uifive.widgets;

import uifive.base.Widget;
import uifive.signals.Signal;

import js.Dom.FormElement;

/**
 * TextField.
 */
class TextField extends Widget {

	public var onChange(default,null):Signal<Void>;

	public var enabled(getEnabled,setEnabled):Bool;
	public var text(getText,setText):String;

	private var _formNode:FormElement;

	/**
	 * Construct.
	 */
	public function new(text:String=null) {
		_node=js.Lib.document.createElement("input");
		_formNode=cast _node;
		_formNode.type="text";

		super();

		height=25;

		setText(text);

		onChange=new Signal<Void>();

		_formNode.onkeyup=function(e) {
			onChange.dispatch();
		}
	}

	/**
	 * Set text.
	 */
	private function setText(text:String):String {
		if (text==null)
			text="";

		if (_formNode.value==text)
			return text;

		_formNode.value=text;

		return text;
	}

	/**
	 * Get text.
	 */
	private function getText():String {
		return _formNode.value;
	}

	/**
	 * Set enabled.
	 */
	public function setEnabled(value:Bool):Bool {
		_formNode.disabled=!value;

		return getEnabled();
	}

	/**
	 * Get enabled.
	 */
	public function getEnabled():Bool {
		return !_formNode.disabled;
	}
}