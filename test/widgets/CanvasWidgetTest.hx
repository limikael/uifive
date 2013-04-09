package test.widgets;

import uifive.base.RootContainer;
import uifive.widgets.CanvasWidget;

/**
 * Canvas widget test.
 */
class CanvasWidgetTest extends RootContainer {

	private var _canvasWidget:CanvasWidget;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_canvasWidget=new CanvasWidget();
		_canvasWidget.left=0;
		_canvasWidget.top=0;
		_canvasWidget.right=0;
		_canvasWidget.bottom=0;

		addWidget(_canvasWidget);

		var c:CanvasRenderingContext2D=_canvasWidget.context;

		c.strokeStyle="#ff0000";
		c.lineWidth=1;
		c.beginPath();
		c.moveTo(500.5,0);
		c.lineTo(500.5,100);
		c.stroke();
	}

	/**
	 * Main.
	 */
	public static function main() {
		trace("canvas widget test");
		new CanvasWidgetTest().attach("testcontainer");
	}
}