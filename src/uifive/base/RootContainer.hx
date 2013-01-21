package uifive.base;

import js.Lib;
import js.Dom.HtmlDom;

/**
 * Root container.
 */
class RootContainer extends WidgetContainer {

	/**
	 * Constructor.
	 */
	public function new() {
		super();

		left=0;
		right=0;
		top=0;
		bottom=0;

		updateStyle();
	}

	/**
	 * Attach to dom.
	 */
	public function attach(domId:String):Void {
		var parent:HtmlDom=Lib.document.getElementById(domId);

		parent.appendChild(node);
	}
}