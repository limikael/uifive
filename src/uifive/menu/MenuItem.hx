package uifive.menu;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.widgets.Label;
import uifive.signals.Signal;

import js.Dom.Event;

/**
 * Menu item.
 */
class MenuItem extends WidgetContainer {

	public var onClick(default,null):Signal;

	public var id(getId,null):String;
	public var accelerator(getAccelerator,null):String;

	private var _id:String;
	private var _text:String;
	private var _accelerator:String;

	private var _labelField:Label;
	private var _acceleratorField:Label;

	/**
	 * Construct.
	 */
	public function new(id:String, label:String, accelerator:String) {
		super();

		_id=id;
		_accelerator=accelerator;
		onClick=new Signal();

		height=20;
		width=200;

		_acceleratorField=new Label();

		if (accelerator!=null && accelerator!="") {
			if (accelerator.toUpperCase()==accelerator)
				_acceleratorField=new Label("Ctrl+Shift+"+accelerator.toUpperCase());

			else
				_acceleratorField=new Label("Ctrl+"+accelerator.toUpperCase());
		}

		_acceleratorField.align=Label.RIGHT;
		_acceleratorField.left=10;
		_acceleratorField.right=10;
		_acceleratorField.selectable=false;
		addWidget(_acceleratorField);

		_labelField=new Label(label);
		_labelField.selectable=false;
		_labelField.left=10;
		_labelField.right=10;
		addWidget(_labelField);

		_node.onmouseover=onNodeMouseOver;
		_node.onmouseout=onNodeMouseOut;
		_node.onmouseup=onNodeMouseUp;

		_node.style.backgroundColor="#ffffff";
	}

	/**
	 * Mouse over.
	 */
	private function onNodeMouseOver(e:Event):Void {
		_node.style.backgroundColor="#e0e0ff";
	}

	/**
	 * Mouse over.
	 */
	private function onNodeMouseOut(e:Event):Void {
		_node.style.backgroundColor="#ffffff";
	}

	/**
	 * Mouse over.
	 */
	private function onNodeMouseUp(e:Event):Void {
		_node.style.backgroundColor="#ffffff";
		onClick.dispatch();
	}

	/**
	 * Get id.
	 */
	private function getId():String {
		return _id;
	}

	/**
	 * Get accelerator.
	 */
	private function getAccelerator():String {
		return _accelerator;
	}
}