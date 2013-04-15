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

/**
 * Make something draggable.
 */
class DragManager {

	public var targetClass(null,setTargetClass):Class<IWidget>;
	public var onDrop(default,null):Signal<DropEvent>;

	private var _target:Widget;
	private var _root:RootContainer;
	private var _clone:Widget;
	private var _cloneStartPosition:Point;
	private var _mouseDownPosition:Point;
	private var _targetClass:Class<IWidget>;

	/**
	 * Make something draggable.
	 */
	public function new(target:Widget) {
		_target=target;

		onDrop=new Signal<DropEvent>();

		target.node.onmousedown=onMouseDown;
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

		_clone=new Widget(_target.node.cloneNode(true));
		_root.addWidget(_clone);

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
		var delta:Point=new Point(e.x-_mouseDownPosition.x,e.y-_mouseDownPosition.y);

		_clone.left=_cloneStartPosition.x+delta.x;
		_clone.top=_cloneStartPosition.y+delta.y;
		//trace("move..");
	}

	/**
	 * Up.
	 */
	private function onRootMouseUp(e:MouseEvent):Void {
		_root.onMouseMove.removeListener(onRootMouseMove);
		_root.onMouseUp.removeListener(onRootMouseUp);
		_root.removeWidget(_clone);

		findTarget(_root,e.x,e.y);
	}

	/**
	 * Find target.
	 */
	private function findTarget(w:Widget, x:Int, y:Int):Void {
/*		var cn:String=Type.getClassName(Type.getClass(w));

		if (cn.indexOf("TrackItemRenderer")>0) {
			trace("awfawfawefwef "+w.node.offsetWidth+" "+w.node.offsetHeight);
			trace("hit: "+WidgetUtil.hitTest(w,x,y));
		}*/

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
