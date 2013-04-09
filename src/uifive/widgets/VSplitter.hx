package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.RootContainer;
import uifive.utils.WidgetUtil;
import uifive.utils.Timer;
import uifive.signals.MouseEvent;

import js.Dom;

/**
 * Vertical splitter.
 */
class VSplitter extends WidgetContainer {

	public var leftWidget(null,setLeftWidget):Widget;
	public var rightWidget(null,setRightWidget):Widget;

	private var _leftContainer:WidgetContainer;
	private var _rightContainer:WidgetContainer;
	private var _leftWidget:Widget;
	private var _rightWidget:Widget;
	private var _splitter:Widget;

	private var _downSplitterPos:Int;
	private var _downMousePos:Int;

	/**
	 * Contruct.
	 */
	public function new() {
		super();

		_leftContainer=new WidgetContainer();
		_leftContainer.left=0;
		_leftContainer.top=0;
		_leftContainer.bottom=0;
		_leftContainer.width=100;
		addWidget(_leftContainer);

		_rightContainer=new WidgetContainer();
		_rightContainer.top=0;
		_rightContainer.bottom=0;
		_rightContainer.right=0;
		_rightContainer.width=100;
		addWidget(_rightContainer);

		_splitter=new Widget();
		_splitter.top=0;
		_splitter.bottom=0;
		_splitter.width=10;
		_splitter.left=100;
		_splitter.node.onmousedown=onSplitterMouseDown;

		_splitter.node.style.backgroundColor="#808080";
		_splitter.node.style.cursor="e-resize";
		addWidget(_splitter);

		Timer.callLater(laterCheckSize);
	}

	/**
	 * Add splitter class.
	 */
	public function addSplitterClass(cls:String):Void {
		_splitter.addClass(cls);
	}

	/**
	 * check size after creation.
	 */
	private function laterCheckSize() {
		_splitter.left=Math.round(node.offsetWidth*.75);
		updateSizes();
	}

	/**
	 * Splitter mouse down.
	 */
	private function onSplitterMouseDown(e:Dynamic):Void {
		var root:RootContainer=WidgetUtil.getRootContainer(this);

		root.onMouseMove.addListener(onRootMouseMove);
		root.onMouseUp.addListener(onRootMouseUp);

		_downSplitterPos=_splitter.left;
		_downMousePos=e.pageX;
	}

	/**
	 * Update sizes.
	 */
	private function updateSizes() {
		_leftContainer.width=_splitter.left;
		_rightContainer.width=node.offsetWidth-_splitter.left-10;
	}

	/**
	 * Move.
	 */
	private function onRootMouseMove(e:MouseEvent):Void {
		var delta:Int=e.x-_downMousePos;

		//trace("move, delta="+delta);

		_splitter.left=_downSplitterPos+delta;

		updateSizes();
	}

	/**
	 * Up.
	 */
	private function onRootMouseUp(e:MouseEvent):Void {
		var root:RootContainer=WidgetUtil.getRootContainer(this);

		root.onMouseMove.removeListener(onRootMouseMove);
		root.onMouseMove.removeListener(onRootMouseUp);
	}

	/**
	 * Set left widget.
	 */
	private function setLeftWidget(w:Widget):Widget {
		if (_leftWidget!=null)
			_leftContainer.removeWidget(_leftWidget);

		_leftWidget=w;
		_leftWidget.top=0;
		_leftWidget.bottom=0;
		_leftWidget.left=0;
		_leftWidget.right=0;
		_leftContainer.addWidget(w);

		return w;
	}

	/**
	 * Set right widget.
	 */
	private function setRightWidget(w:Widget):Widget {
		if (_rightWidget!=null)
			_rightContainer.removeWidget(_rightWidget);

		_rightWidget=w;
		_rightWidget.top=0;
		_rightWidget.bottom=0;
		_rightWidget.left=0;
		_rightWidget.right=0;
		_rightContainer.addWidget(w);

		return w;
	}
}