package uifive.base;

import js.Lib;
import js.Dom.HtmlDom;
import js.Dom;

import uifive.signals.Signal;
import uifive.signals.MouseEvent;

/**
 * Root container.
 */
class RootContainer extends WidgetContainer {

	public static var lastAttached:RootContainer;

	public var onMouseDown(default,null):Signal<MouseEvent>;
	public var onMouseMove(default,null):Signal<MouseEvent>;
	public var onMouseUp(default,null):Signal<MouseEvent>;

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
		_node.onmousedown=function(e:Dynamic) {
			var x:Int=e.pageX;
			var y:Int=e.pageY;

			onMouseDown.dispatch(new MouseEvent(x,y));
		}

		onMouseUp=new Signal<MouseEvent>();
		_node.onmouseup=function(e:Dynamic) {
			var x:Int=e.pageX;
			var y:Int=e.pageY;

			onMouseUp.dispatch(new MouseEvent(x,y));
		}

		onMouseMove=new Signal<MouseEvent>();
		_node.onmousemove=function(e:Dynamic) {
			var x:Int=e.pageX;
			var y:Int=e.pageY;

			onMouseMove.dispatch(new MouseEvent(x,y));
		}
	}

	/**
	 * Notify layout.
	 */
	private function onWindowResize(e:Event):Void {
		notifyLayout();
	}

	/**
	 * Attach to dom.
	 */
	public function attach(domId:String):Void {
		lastAttached=this;

		Lib.window.onresize=onWindowResize;

		var parent:HtmlDom=Lib.document.getElementById(domId);

		if (parent==null) {
			trace("RootContaner.attach: The element doesn't exist!");
		}

		parent.appendChild(node);
	}
}