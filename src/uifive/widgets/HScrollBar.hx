package uifive.widgets;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.RootContainer;
import uifive.utils.WidgetUtil;
import uifive.signals.MouseEvent;
import uifive.signals.Signal;

/**
 * Horizontal scrollbar.
 */
class HScrollBar extends WidgetContainer {

	public var onChange(default,null):Signal<Void>;

	public var min(null,setMin):Float;
	public var max(null,setMax):Float;
	public var pageSize(null,setPageSize):Float;
	public var value(getValue,setValue):Float;

	private var _min:Float;
	private var _max:Float;
	private var _pageSize:Float;
	private var _value:Float;
	private var _thumb:Widget;
	private var _downLeft:Float;
	private var _downMouseX:Float;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_min=0;
		_max=10;
		_pageSize=1;
		_value=0;

		_thumb=new Widget();
		addWidget(_thumb);

		updateThumbFromValues();

		_thumb.top=0;
		_thumb.bottom=0;

		_thumb.node.onmousedown=onThumbMouseDown;
		node.onmousedown=onTrackMouseDown;

		onChange=new Signal<Void>();
	}

	/**
	 * Set min.
	 */
	private function setMin(v:Float):Float {
		_min=v;

		updateThumbFromValues();

		return _min;
	}

	/**
	 * Set max.
	 */
	private function setMax(v:Float):Float {
		_max=v;

		trace("max set to: "+_max);

		updateThumbFromValues();

		return _max;
	}

	/**
	 * Set page size.
	 */
	private function setPageSize(v:Float):Float {
		_pageSize=v;

		updateThumbFromValues();

		return _pageSize;
	}

	/**
	 * Get value.
	 */
	private function getValue():Float {
		return _value;
	}

	/**
	 * Set value.
	 */
	private function setValue(v:Float):Float {
		_value=v;
		clampValue();
		updateThumbFromValues();

		return _value;
	}

	/**
	 * Track mouse down.
	 */
	private function onTrackMouseDown(e:Dynamic):Void {
		var x:Float=e.pageX-node.offsetLeft;

		trace("x: "+x+" l: "+_thumb.left);

		if (x>_thumb.left+_thumb.width)
			_value+=_pageSize;

		else if (x<_thumb.left)
			_value-=_pageSize;

		clampValue();
		updateThumbFromValues();

		onChange.dispatch();
	}

	/**
	 * Trace thumb mouse down.
	 */
	private function onThumbMouseDown(e:Dynamic):Void {
		_downLeft=_thumb.left;
		_downMouseX=e.pageX;

		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseMove.addListener(onRootMouseMove);
		root.onMouseUp.addListener(onRootMouseUp);
	}

	/**
	 * Root mouse move.
	 */
	private function onRootMouseMove(e:MouseEvent):Void {
		var delta:Float=e.x-_downMouseX;

		_thumb.left=Math.round(_downLeft+delta);

		if (_thumb.left<0)
			_thumb.left=0;

		if (_thumb.left>node.offsetWidth-_thumb.width)
			_thumb.left=node.offsetWidth-_thumb.width;

		_value=_min+(_max-_min)*_thumb.left/(node.offsetWidth-_thumb.width);
		clampValue();

		onChange.dispatch();
	}

	/**
	 * Root mouse up.
	 */
	private function onRootMouseUp(e:MouseEvent):Void {
		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseMove.removeListener(onRootMouseMove);
		root.onMouseUp.removeListener(onRootMouseUp);
	}

	/**
	 * Clamp value.
	 */
	private function clampValue():Void {
		if (_value<_min)
			_value=_min;

		if (_value>_max)
			_value=_max;
	}

	/**
	 * Add thumb class.
	 */
	public function addThumbClass(c:String):Void {
		_thumb.addClass(c);
	}

	/**
	 * Update thumb from values.
	 */
	private function updateThumbFromValues():Void {
		var w:Float=node.offsetWidth;

		_thumb.width=Math.round(w*_pageSize/(_max-_min));

		var percent:Float=(_value-_min)/(_max-_min);
		_thumb.left=Math.round(percent*(w-_thumb.width));
	}

	/**
	 * Notify layout.
	 */
	override public function notifyLayout():Void {
		super.notifyLayout();

		updateThumbFromValues();
	}
}