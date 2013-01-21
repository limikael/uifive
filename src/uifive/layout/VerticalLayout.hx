package uifive.layout;

import uifive.base.WidgetContainer;

class VerticalLayout extends Layout{

	/**
	 * Construct.
	 */
	public function new() {
		super();
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
	}
}
