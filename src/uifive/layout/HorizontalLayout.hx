package uifive.layout;

import uifive.base.WidgetContainer;

class HorizontalLayout extends Layout{

	public var gap(null,setGap):Int;

	private var _resizeParent:Bool;
	private var _gap:Int;

	/**
	 * Construct.
	 */
	public function new(resizeParent:Bool=false) {
		super();

		_resizeParent=resizeParent;
	}

	/**
	 * Set gap.
	 */
	private function setGap(value:Int):Int {
		_gap=value;

		if (_target!=null)
			updateLayout();

		return _gap;
	}

	/**
	 * Update layout.
	 */
	override public function updateLayout() {
		var x:Int=0;

		for (w in _target.widgets) {
			if (x!=0)
				x+=_gap;

			w.left=x;
			x+=w.width;
		}

		if (_resizeParent)
			_target.width=x;
	}
}
