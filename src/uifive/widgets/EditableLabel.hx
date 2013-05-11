package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.utils.Timer;
import uifive.signals.Signal;

import js.Dom.Event;

/**
 * Editable label.
 */
class EditableLabel extends WidgetContainer {

	public var onChange(default,null):Signal<Void>;
	public var enabled(getEnabled,setEnabled):Bool;
	public var text(getText,setText):String;

	private var _label:Label;
	private var _textField:TextField;
	private var _enabled:Bool=true;

	/**
	 * Editable label.
	 */
	public function new() {
		super();

		onChange=new Signal<Void>();

		_label=new Label();
		_label.left=0;
		_label.right=0;
		_label.top=0;
		_label.bottom=0;
		_label.node.onmousedown=onLabelMouseDown;
		addWidget(_label);

		_textField=new TextField();
		_textField.left=0;
		_textField.right=0;
		_textField.top=0;
		_textField.formNode.onblur=onTextFieldFocusOut;
		_textField.bottom=0;
		_textField.formNode.onkeyup=onTextFieldKeyUp;

		_enabled=true;
	}

	/**
	 * Get text.
	 */
	private function getText():String {
		return _label.text;
	}

	/**
	 * Set text.
	 */
	private function setText(s:String):String {
		_label.text=s;
		_textField.text=s;

		return s;
	}

	/**
	 * Textfield key up.
	 */
	private function onTextFieldKeyUp(e:Event):Void {
		if (e.keyCode==13 || e.keyCode==27)
			_textField.formNode.blur();

		_label.text=_textField.text;

		onChange.dispatch();
	}

	/**
	 * Label mouse down.
	 */
	private function onLabelMouseDown(e:Event):Void {
		if (!_enabled)
			return;

		removeWidget(_label);
		addWidget(_textField);

		Timer.callLater(setTextFieldFocus);
	}

	/**
	 * Set textfield focus.
	 */
	private function setTextFieldFocus():Void {
		_textField.formNode.focus();
		_textField.formNode.select();
	}

	/**
	 * Text field focus out.
	 */
	private function onTextFieldFocusOut(e:Event):Void {
		_label.text=_textField.text;

		removeWidget(_textField);
		addWidget(_label);
	}

	/**
	 * Set enabled.
	 */
	public function setEnabled(value:Bool):Bool {
		_enabled=value;

		return getEnabled();
	}

	/**
	 * Get enabled.
	 */
	public function getEnabled():Bool {
		return _enabled;
	}
}