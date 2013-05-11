package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.RootContainer;
import uifive.signals.MouseEvent;
import uifive.signals.Signal;

import uifive.utils.WidgetUtil;
import uifive.utils.Timer;

/**
 * Slider.
 */
class Slider extends WidgetContainer {

	public var onChange(default,null):Signal<Void>;
	public var onChangeEnd(default,null):Signal<Void>;
	public var value(getValue,setValue):Float;

	private var _knob:Widget;
	private var _downX:Int;
	private var _downLeft:Int;

	/**
	 * Construct.
	 */
	public function new(k:Widget) {
		super();

		onChange=new Signal<Void>();
		onChangeEnd=new Signal<Void>();

		_knob=k;
		_knob.left=0;
		_knob.top=0;
		addWidget(_knob);

		_knob.node.onmousedown=onMouseDown;
	}

	/**
	 * Mouse down.
	 */
	private function onMouseDown(e:Dynamic) {
		e.stopPropagation();
		_downX=e.pageX;
		_downLeft=_knob.left;

		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseMove.addListener(onMouseMove);
		root.onMouseUp.addListener(onMouseUp);
	}

	/**
	 * Mouse move.
	 */
	private function onMouseMove(e:MouseEvent):Void {
		var delta:Int=e.x-_downX;

		var cand:Int=_downLeft+delta;
		if (cand<0)
			cand=0;

		if (cand>width-_knob.width)
			cand=width-_knob.width;

		_knob.left=cand;
		_knob.updatePositionHack();

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
	 * Get value.
	 */
	private function getValue():Float {
		return _knob.left/(width-_knob.width);
	}

	/**
	 * Set value.
	 */
	private function setValue(v:Float):Float {
		_knob.left=Math.round(v*(width-_knob.width));
		_knob.updatePositionHack();

		return v;
	}
}