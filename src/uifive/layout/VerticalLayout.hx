package uifive.layout;

import uifive.base.WidgetContainer;

class VerticalLayout extends Layout{

	private var _resizeParent:Bool;

	/**
	 * Construct.
	 */
	public function new(resizeParent:Bool=false) {
		super();

		_resizeParent=resizeParent;
	}

	/**
	 * Update layout.
	 */
	override public function updateLayout() {
		var y:Int=0;

		for (w in _target.widgets) {
			w.top=y;
			y+=w.height;
		}

		if (_resizeParent)
			_target.height=y;
	}
}
