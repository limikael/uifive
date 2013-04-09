package uifive.widgets;

import uifive.base.Widget;
import uifive.base.WidgetContainer;
import uifive.utils.Timer;

import js.Lib;

/**
 * Canvas widget.
 */
class CanvasWidget extends Widget {

	public var context(getContext,null):CanvasRenderingContext2D;
	public var canvas(getCanvas,null):Canvas;

	private var _canvasNode:Canvas;
	private var _context:CanvasRenderingContext2D;

	/**
	 * Construct.
	 */
	public function new() {
		_node=js.Lib.document.createElement("canvas");
		_canvasNode=cast _node;

		_canvasNode.width=Lib.window.innerWidth;
		_canvasNode.height=Lib.window.innerHeight;

		if (_canvasNode==null)
			throw "Canvas not available";

		_context=_canvasNode.getContext("2d");
		if (_context==null)
			throw "Unable to get canvas context";

		super();

//		trace("doc w: "+Lib.window.innerWidth);
	}

	/**
	 * Set height.
	 */
	override private function setHeight(v:Int):Int {
		_canvasNode.height=v;

		return super.setHeight(v);
	}

	/**
	 * Get context.
	 */
	private function getContext():CanvasRenderingContext2D {
		return _context;
	}

	/**
	 * Set container.
	 */
	override private function setContainer(w:WidgetContainer):WidgetContainer {
		super.setContainer(w);

		trace("set container... calling later...");

		Timer.callLater(afterSetContainer);

		return w;
	}

	/**
	 * After set container.
	 */
	private function afterSetContainer():Void {
		trace("*** after set container, w="+_canvasNode.offsetWidth);
	}

	/**
	 * Get canvas.
	 */
	private function getCanvas():Canvas {
		return _canvasNode;
	}
}