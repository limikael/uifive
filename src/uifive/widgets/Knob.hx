package uifive.widgets;

import uifive.base.Widget;
import uifive.base.WidgetContainer;
import uifive.base.RootContainer;
import uifive.utils.WidgetUtil;
import uifive.signals.MouseEvent;
import uifive.signals.Signal;

import js.Dom.Event;

/**
 * Knob.
 */
class Knob extends WidgetContainer {

	public var onChange(default,null):Signal<Void>;
	public var onChangeEnd(default,null):Signal<Void>;

	public var value(getValue,setValue):Float;

	private var _knob:Widget;
	private var _value:Float;
	private var _lastY:Int;

	/**
	 * Construct.
	 */
	public function new(k:Widget) {
		super();

		onChange=new Signal<Void>();
		onChangeEnd=new Signal<Void>();

		_knob=k;
		width=k.width;
		height=k.height;
		addWidget(_knob);

		node.onmousedown=onMouseDown;

		_value=0;
		updateRotation();
	}

	/**
	 * Mouse down.
	 */
	private function onMouseDown(e:Event):Void {
		trace("mousedown");

		e.stopPropagation();
		_lastY=untyped e.pageY;

		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseMove.addListener(onMouseMove);
		root.onMouseUp.addListener(onMouseUp);
	}

	/**
	 * Mouse move.
	 */
	private function onMouseMove(e:MouseEvent):Void {
		var delta:Float=e.y-_lastY;
		_value-=delta/200;

		if (_value<0)
			_value=0;

		if (_value>1)
			_value=1;

		updateRotation();

		_lastY=e.y;

		onChange.dispatch();
	}

	/**
	 * Mouse up.
	 */
	private function onMouseUp(e:MouseEvent):Void {
		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseMove.removeListener(onMouseMove);
		root.onMouseUp.removeListener(onMouseUp);

		onChangeEnd.dispatch();
	}

	/**
	 * Update rotation.
	 */
	private function updateRotation():Void {
		//trace("val: "+_value);
		var deg:Int=Math.round(-135+_value*270);

		untyped node.style.WebkitTransform="rotate("+deg+"deg)";
		untyped node.style.transform="rotate("+deg+"deg)";
	}

	/**
	 * Get value.
	 */
	private function getValue():Float {
		return _value;
	}

	/**
	 * Set value.
	 */
	private function setValue(v:Float):Float {
		_value=v;

		updateRotation();

		return _value;
	}
}