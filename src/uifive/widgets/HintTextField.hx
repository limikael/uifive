package uifive.widgets;

import uifive.base.WidgetContainer;

/**
 * A textfield that shows a hint.
 */
class HintTextField extends WidgetContainer {

	public var hint(getHint,setHint):String;

	private var _textField:TextField;
	private var _hintTextField:TextField;

	/**
	 * New.
	 */
	public function new() {
		super();

		_textField=new TextField();
		_textField.left=0;
		_textField.right=0;
		_textField.top=0;
		_textField.bottom=0;
		addWidget(_textField);

		_hintTextField=new TextField();
		_hintTextField.left=0;
		_hintTextField.right=0;
		_hintTextField.top=0;
		_hintTextField.bottom=0;
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
	 *
	 */
	private function getHint():String {
		return _hintTextField.text;
	}
}