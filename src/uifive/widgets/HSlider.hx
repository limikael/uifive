package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.WidgetEvent;
import uifive.base.RootContainer;
import uifive.signals.MouseEvent;
import uifive.signals.Signal;

import uifive.utils.WidgetUtil;
import uifive.utils.Timer;
import uifive.base.Stage;

/**
 * Slider.
 */
class HSlider extends WidgetContainer {

	public var onChange(default,null):Signal<Void>;
	public var onChangeEnd(default,null):Signal<Void>;
	public var max(null,setMax):Float;
	public var min(null,setMin):Float;

	public var value(getValue,setValue):Float;

	private var _knob:Widget;
	private var _downMouse:Int;
	private var _downWidget:Int;
	private var _min:Float;
	private var _max:Float;

	/**
	 * Construct.
	 */
	public function new(k:Widget, t:Widget=null) {
		super();

		onChange=new Signal<Void>();
		onChangeEnd=new Signal<Void>();

		if (t!=null)
			addWidget(t);

		_min=0;
		_max=1;

		_knob=k;
		addWidget(_knob);

		_knob.addEventListener(WidgetEvent.MOUSE_DOWN,onMouseDown);
	}

	/**
	 * Set max.
	 */
	private function setMax(v:Float):Float {
		_max=v;

		return _max;
	}

	/**
	 * Set max.
	 */
	private function setMin(v:Float):Float {
		_min=v;

		return _min;
	}

	/**
	 * Mouse down.
	 */
	private function onMouseDown(e:Dynamic) {
		e.stopPropagation();
		_downMouse=mapMouseEvent(e);
		_downWidget=getKnobPosition();

		Stage.root.addEventListener(WidgetEvent.MOUSE_MOVE,onMouseMove);
		Stage.root.addEventListener(WidgetEvent.MOUSE_UP,onMouseUp);
	}

	/**
	 * Mouse move.
	 */
	private function onMouseMove(e:Dynamic):Void {
		var delta:Int=Math.round(mapMouseEvent(e)-_downMouse);

		var cand:Int=_downWidget+delta;
		if (cand<0)
			cand=0;

		if (cand>getAvailableTrackSize()-getKnobSize())
			cand=getAvailableTrackSize()-getKnobSize();

		setKnobPosition(cand);
		_knob.updatePositionHack();

		onChange.dispatch();
	}

	/**
	 * Mouse up.
	 */
	private function onMouseUp(e:Dynamic):Void {
		Stage.root.removeEventListener(WidgetEvent.MOUSE_MOVE,onMouseMove);
		Stage.root.removeEventListener(WidgetEvent.MOUSE_UP,onMouseUp);
		onChangeEnd.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Float {
		var frac:Float=getKnobPosition()/(getAvailableTrackSize()-getKnobSize());

		return _min+frac*(_max-_min);
	}

	/**
	 * Set value.
	 */
	private function setValue(v:Float):Float {
		var frac:Float=(v-_min)/(_max-_min);

		setKnobPosition(Math.round(frac*(getAvailableTrackSize()-getKnobSize())));
		_knob.updatePositionHack();

		return v;
	}

	/**
	 * Override for vertical.
	 */
	private function getAvailableTrackSize():Int {
		return width;
	}

	/**
	 * Override for vertical.
	 */
	private function getKnobSize():Int {
		return _knob.width;
	}

	/**
	 * Override for vertical.
	 */
	private function getKnobPosition():Int {
		return _knob.left;
	}

	/**
	 * Override for vertical.
	 */
	private function setKnobPosition(p:Int):Void {
		_knob.left=p;
	}

	/**
	 * Override for vertical.
	 */
	private function mapMouseEvent(e:Dynamic):Int {
		return e.pageX;
	}
}