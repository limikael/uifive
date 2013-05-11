package uifive.dragdrop;

import uifive.base.Widget;
import uifive.base.IWidget;
import uifive.base.WidgetContainer;
import uifive.base.RootContainer;
import uifive.utils.WidgetUtil;
import uifive.utils.Point;
import uifive.signals.MouseEvent;
import uifive.signals.Signal;
import js.Dom;
import js.Dom.HtmlDom;

/**
 * Make something draggable.
 */
class DragManager {

	public static inline var VERTICAL:Int=1;
	public static inline var HORIZONTAL:Int=2;
	public static inline var BOTH:Int=3;

	public var directions(null,setDirections):Int;
	public var targetClass(null,setTargetClass):Class<IWidget>;
	public var onDrop(default,null):Signal<DropEvent>;

	private var _target:Widget;
	private var _root:RootContainer;
	private var _clone:Widget;
	private var _cloneStartPosition:Point;
	private var _mouseDownPosition:Point;
	private var _targetClass:Class<IWidget>;
	private var _directions:Int;
	private var _dragClass:String=null;
	private var _cloneAdded:Bool;

	/**
	 * Make something draggable.
	 */
	public function new(target:Widget) {
		_target=target;
		_directions=BOTH;

		onDrop=new Signal<DropEvent>();

		target.node.onmousedown=onMouseDown;
	}

	/**
	 * Add drag class.
	 */
	public function addDragClass(s:String):Void {
		_dragClass=s;
	}

	/**
	 * Set directions.
	 */
	private function setDirections(v:Int):Int {
		_directions=v;

		return v;
	}

	/**
	 * Set target class.
	 */
	private function setTargetClass(v:Class<IWidget>):Class<IWidget> {
		_targetClass=v;

		return _targetClass;
	}

	/**
	 * Mouse down.
	 */
	private function onMouseDown(e:Dynamic):Void {
		_root=WidgetUtil.getRootContainer(_target);

		var n:HtmlDom=_target.node.cloneNode(true);

		_clone=new Widget(n);

		if (_dragClass!=null)
			_clone.addClass(_dragClass);

		_clone.width=_target.node.offsetWidth;
		_clone.height=_target.node.offsetHeight;
		_cloneAdded=false;

		//_root.addWidget(_clone);

		_mouseDownPosition=new Point(e.pageX,e.pageY);
		_cloneStartPosition=WidgetUtil.getGlobalPosition(_target);

		_clone.left=_cloneStartPosition.x;
		_clone.top=_cloneStartPosition.y;
		//trace("mouse down in drag manager");

		_root.onMouseMove.addListener(onRootMouseMove);
		_root.onMouseUp.addListener(onRootMouseUp);

		/*_root.node.style.cursor="not-allowed";
		_clone.node.style.cursor="not-allowed";*/
	}

	/**
	 * Move.
	 */
	private function onRootMouseMove(e:MouseEvent):Void {
		if (!_cloneAdded) {
			_root.addWidget(_clone);
			_cloneAdded=true;
		}

		var delta:Point=new Point(e.x-_mouseDownPosition.x,e.y-_mouseDownPosition.y);

		if (_directions&HORIZONTAL!=0)
			_clone.left=_cloneStartPosition.x+delta.x;

		if (_directions&VERTICAL!=0)
			_clone.top=_cloneStartPosition.y+delta.y;
	}

	/**
	 * Up.
	 */
	private function onRootMouseUp(e:MouseEvent):Void {
		_root.onMouseMove.removeListener(onRootMouseMove);
		_root.onMouseUp.removeListener(onRootMouseUp);
		_root.removeWidget(_clone);

		if (!_cloneAdded)
			return;

		findTarget(_root,e.x,e.y);
	}

	/**
	 * Find target.
	 */
	private function findTarget(w:Widget, x:Int, y:Int):Void {
		if (WidgetUtil.hitTest(w,x,y)) {
			if (Std.is(w,_targetClass)) {
				var p:Point=WidgetUtil.getGlobalPosition(w);

				onDrop.dispatch(new DropEvent(w,x-p.x,y-p.y));
			}
		}

		if (Std.is(w,WidgetContainer)) {
			var c:WidgetContainer=cast w;

			for (child in c.widgets)
				findTarget(cast child,x,y);
		}
	}
}
