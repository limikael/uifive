package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.RootContainer;
import uifive.utils.WidgetUtil;
import uifive.utils.Timer;
import uifive.signals.MouseEvent;
import uifive.signals.Signal;

/**
 * Horizontal scrollbar.
 */
class ProgressBar extends WidgetContainer {

	public var value(getValue,setValue):Float;
	private var _value:Float;
	private var _bar:Widget;

	/**
	 * Progress bar.
	 */
	public function new():Void {
		super();

		_value=0;
		_bar=new Widget();
		_bar.top=0;
		_bar.bottom=0;
		_bar.left=0;
		_bar.width=100;
		addWidget(_bar);

		updateProgressBar();

//		Timer.callLater(updateProgressBar);
	}

	/**
	 * Set value.
	 */
	private function setValue(v:Float):Float {
		if (v<0)
			v=0;

		if (v>1)
			v=1;

		_value=v;

		updateProgressBar();
		Timer.callLater(updateProgressBar);

		return _value;
	}

	/**
	 * Get value.
	 */
	private function getValue():Float {
		return _value;
	}

	/**
	 * Update progress bar.
	 */
	private function updateProgressBar():Void {
//		var w:Float=node.offsetWidth;
		var setWidth:Int=Math.round(width*_value);

		trace("updateing progress bar, w: "+width+" setting width: "+setWidth);

		_bar.width=setWidth;
	}

	/**
	 * Notify layout.
	 */
	override public function notifyLayout():Void {
		super.notifyLayout();

		trace("notify layout in progress bar");

		updateProgressBar();
	}

	/**
	 * Add thumb class.
	 */
	public function addBarClass(c:String):Void {
		_bar.addClass(c);
	}
}