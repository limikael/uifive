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

	public var enabled(null,setEnabled):Bool;
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
	public function new(thumbWidget:Widget=null) {
		super();

		_min=0;
		_max=10;
		_pageSize=1;
		_value=0;

		if (thumbWidget==null)
			thumbWidget=new Widget();

		_thumb=thumbWidget;
		addWidget(_thumb);

		updateThumbFromValues();

		_thumb.node.onmousedown=onThumbMouseDown;
		node.onmousedown=onTrackMouseDown;

		onChange=new Signal<Void>();
		initializeThumbLayout();
	}

	/**
	 * Set enabled.
	 */
	private function setEnabled(v:Bool):Bool {
		if (v)
			addWidget(_thumb);

		else
			removeWidget(_thumb);

		return v;
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

		//trace("max set to: "+_max);

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
		/*var x:Float=e.pageX-node.offsetLeft;

		trace("x: "+x+" l: "+_thumb.left);

		if (x>_thumb.left+_thumb.width)
			_value+=_pageSize;

		else if (x<_thumb.left)
			_value-=_pageSize;

		clampValue();
		updateThumbFromValues();

		onChange.dispatch();*/
	}

	/**
	 * Trace thumb mouse down.
	 */
	private function onThumbMouseDown(e:Dynamic):Void {
		_downLeft=getThumbPosition();
		_downMouseX=mapEventCoordinate(e);

		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseMove.addListener(onRootMouseMove);
		root.onMouseUp.addListener(onRootMouseUp);
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
	 * Notify layout.
	 */
	override public function notifyLayout():Void {
		super.notifyLayout();

		updateThumbFromValues();
	}

	/**
	 * Update thumb from values.
	 */
	private function updateThumbFromValues():Void {
		var w:Float=getAvailableTrackSize();

		var percent:Float=(_value-_min)/(_max-_min);

		setThumbPosition(Math.round(percent*(w-getThumbSize())));
		setThumbSize(Math.round(w*_pageSize/(_max-_min)));
	}

	/**
	 * Root mouse move.
	 */
	private function onRootMouseMove(e:MouseEvent):Void {
		var delta:Float=mapEventCoordinate(e)-_downMouseX;

		setThumbPosition(Math.round(_downLeft+delta));

		if (getThumbPosition()<0)
			setThumbPosition(0);

		if (getThumbPosition()>getAvailableTrackSize()-getThumbSize())
			setThumbPosition(getAvailableTrackSize()-getThumbSize());

		_value=_min+(_max-_min)*getThumbPosition()/(getAvailableTrackSize()-getThumbSize());
		clampValue();

		onChange.dispatch();
	}

	/**
	 * Init thumb layout.
	 * This function and the ones below should be overridden for vertical.
	 */
	private function initializeThumbLayout():Void {
		_thumb.top=0;
		_thumb.bottom=0;
	}

	/**
	 * Get extent of the track.
	 */
	private function getAvailableTrackSize():Int {
		return node.offsetWidth;
	}

	/**
	 * Getter.
	 */
	private function getThumbSize():Int {
		return _thumb.width;
	}

	/**
	 * Getter.
	 */
	private function getThumbPosition():Int {
		return _thumb.left;
	}

	/**
	 * Set thumb pos.
	 */
	private function setThumbPosition(pos:Int):Void {
		_thumb.left=pos;
	}

	/**
	 * Set thumb extent.
	 */
	private function setThumbSize(size:Int):Void {
		_thumb.width=size;
	}

	/**
	 * Map event coordinate.
	 */
	private function mapEventCoordinate(e:Dynamic):Int {
		if (e.pageX!=null)
			return e.pageX;

		if (e.x!=null)
			return e.x;

		throw "strange mouse event";
	}
}