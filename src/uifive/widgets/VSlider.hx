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
 * Vertical slider.
 */
class VSlider extends HSlider {

	/**
	 * Construct.
	 */
	public function new(k:Widget, t:Widget=null) {
		super(k,t);
	}

	/**
	 * Override for vertical.
	 */
	override private function getAvailableTrackSize():Int {
		return height;
	}

	/**
	 * Override for vertical.
	 */
	override private function getKnobSize():Int {
		return _knob.height;
	}

	/**
	 * Override for vertical.
	 */
	override private function getKnobPosition():Int {
		return _knob.top;
	}

	/**
	 * Override for vertical.
	 */
	override private function setKnobPosition(p:Int):Void {
		_knob.top=p;
	}

	/**
	 * Override for vertical.
	 */
	override private function mapMouseEvent(e:Dynamic):Int {
		return e.pageY;
	}
}