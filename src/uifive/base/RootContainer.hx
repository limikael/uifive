package uifive.base;

import js.Lib;
import js.Dom.HtmlDom;
import uifive.signals.Signal;
import uifive.signals.MouseEvent;

/**
 * Root container.
 */
class RootContainer extends WidgetContainer {

	public var onMouseDown(default,null):Signal<MouseEvent>;

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

		onMouseDown=new Signal<MouseEvent>();
		_node.onmousedown=function(e) {
			var info:Dynamic=cast e;
			var x:Int=info.pageX;
			var y:Int=info.pageY;

			//trace("down: "++" "+info.pageY);
			onMouseDown.dispatch(new MouseEvent(x,y));
		}
	}

	/**
	 * Attach to dom.
	 */
	public function attach(domId:String):Void {
		var parent:HtmlDom=Lib.document.getElementById(domId);

		parent.appendChild(node);
	}
}