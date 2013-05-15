package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.base.WidgetEvent;
import uifive.signals.Signal;

/**
 * A textfield that shows a hint.
 */
class HintTextField extends WidgetContainer {

	public var text(getText,null):String;

	public var onChange(default,null):Signal<Void>;
	public var hint(getHint,setHint):String;

	private var _textField:TextField;
	private var _hintTextField:TextField;

	/**
	 * New.
	 */
	public function new() {
		super();

		onChange=new Signal<Void>();

		_textField=new TextField();
		_textField.left=0;
		_textField.right=0;
		_textField.top=0;
		_textField.bottom=0;
		//_textField.height=23;
		_textField.addEventListener(WidgetEvent.BLUR,onTextFieldBlur);
		addWidget(_textField);

		_hintTextField=new TextField();
		_hintTextField.left=0;
		_hintTextField.right=0;
		_hintTextField.top=0;
		_hintTextField.bottom=0;
		//_hintTextField.height=23;
		_hintTextField.addEventListener(WidgetEvent.FOCUS,onHintTextFieldFocus);
		addWidget(_hintTextField);

		_textField.onChange.addConnection(onChange);
	}

	/**
	 * Hint text field focus.
	 */
	private function onHintTextFieldFocus(e:Dynamic):Void {
		removeWidget(_hintTextField);

		_textField.node.focus();
	}

	/**
	 * Hint text field focus.
	 */
	private function onTextFieldBlur(e:Dynamic):Void {
		if (_textField.text=="")
			addWidget(_hintTextField);
	}

	/**
	 * Set hint.
	 */
	private function setHint(s:String):String {
		_hintTextField.text=s;

		return s;
	}

	/**
	 * Get hint.
	 */
	private function getHint():String {
		return _hintTextField.text;
	}

	/**
	 * Get text.
	 */
	private function getText():String {
		return _textField.text;
	}
}