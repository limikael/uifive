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
	public var max(null,setMax):Float;
	public var min(null,setMin):Float;
	public var value(getValue,setValue):Float;

	private var _knob:Widget;
	private var _value:Float;
	private var _lastY:Int;
	private var _min:Float;
	private var _max:Float;

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
		_min=0;
		_max=1;

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
		_value-=(delta*(_max-_min))/200;

		if (_value<_min)
			_value=_min;

		if (_value>_max)
			_value=_max;

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
		var frac:Float=(_value-_min)/(_max-_min);

		var deg:Int=Math.round(-135+frac*270);

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

		if (_value>_max)
			_value=max;

		if (_value<_min)
			value=min;

		updateRotation();

		return _value;
	}

	/**
	 * Set max.
	 */
	private function setMax(v:Float):Float {
		_max=v;

		updateRotation();

		return _max;
	}

	/**
	 * Set max.
	 */
	private function setMin(v:Float):Float {
		_min=v;

		updateRotation();

		return _min;
	}
}