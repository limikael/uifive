package uifive.widgets;

import uifive.base.Widget;
import uifive.signals.Signal;

import js.Dom.FormElement;

/**
 * Text area.
 */
class TextArea extends Widget {

	public var onChange(default,null):Signal<Void>;

/*	public var enabled(getEnabled,setEnabled):Bool;*/
	public var text(getText,setText):String;

	private var _formNode:FormElement;

	/**
	 * Construct.
	 */
	public function new():Void {
		_node=js.Lib.document.createElement("textarea");
		_formNode=cast _node;

		untyped _node.style.resize="none";

		super();
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
}