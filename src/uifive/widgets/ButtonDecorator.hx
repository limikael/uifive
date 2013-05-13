package uifive.widgets;

import uifive.base.Widget;
import uifive.signals.Signal;

import js.Dom.Event;

/**
 * Makes a widget behave like a button.
 */
class ButtonDecorator extends Widget {

	public var onClick(default,null):Signal<Void>;

	/**
	 * Constructor.
	 */
	public function new(w:Widget) {
		var ow:Int=w.width;
		var oh:Int=w.height;
		var ol:Int=w.left;
		var or:Int=w.right;
		var ot:Int=w.top;
		var ob:Int=w.bottom;

		_node=w.node;

		super();

		_left=ol;
		_right=or;
		_top=ot;
		_bottom=ob;
		_width=ow;
		_height=oh;

		//updateStyle();

		_node.onmouseover=onMouseOver;
		_node.onmouseout=onMouseOut;
		_node.onmouseup=onMouseUp;
		_node.onmousedown=onMouseDown;

		onClick=new Signal<Void>();
	}

	/**
	 * Mouse over.
	 */
	private function onMouseOver(e:Event):Void {
		setBrightness(1.25);
	}

	/**
	 * Mouse over.
	 */
	private function onMouseOut(e:Event):Void {
		setBrightness(1);
	}

	/**
	 * Mouse over.
	 */
	private function onMouseDown(e:Event):Void {
		e.stopPropagation();
		setBrightness(.75);
	}

	/**
	 * Mouse over.
	 */
	private function onMouseUp(e:Event):Void {
		setBrightness(1.25);
		onClick.dispatch();
	}

	/**
	 * Set brightness.
	 */
	private function setBrightness(val:Float):Void {
		//trace("setting brightness: "+val);
		var s:Dynamic=cast _node.style;

		Reflect.setField(s,"-webkit-filter","brightness("+val+")");
		Reflect.setField(s,"filter","brightness("+val+")");
	}
}