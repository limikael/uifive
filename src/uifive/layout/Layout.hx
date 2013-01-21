package uifive.layout;

import uifive.base.WidgetContainer;

class Layout {

	public var target(default,setTarget):WidgetContainer;

	private var _target:WidgetContainer;

	/**
	 * Construct.
	 */
	public function new() {
		_target=null;
	}

	/**
	 * Set target.
	 */
	private function setTarget(value:WidgetContainer):WidgetContainer {
		_target=value;

		updateLayout();

		return _target;
	}

	/**
	 * Update layout.
	 */
	public function updateLayout() {
	}
}
