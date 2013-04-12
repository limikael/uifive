package uifive.layout;

import uifive.base.WidgetContainer;
import uifive.utils.Timer;
import js.Dom;

class HorizontalLayout extends Layout {

	public var resizeParent(null,setResizeParent):Bool;
	public var resizeChildren(null,setResizeChildren):Bool;

	public var gap(null,setGap):Int;

	private var _resizeParent:Bool;
	private var _resizeChildren:Bool;
	private var _gap:Int;

	/**
	 * Construct.
	 */
	public function new() {
		super();

//		Timer.callLater(checkSize);
	}

	/**
	 * Check size.
	 */
/*	private function checkSize():Void {
		trace("ow: "+_target.node.offsetWidth);

//		Timer.callLater(checkSize);
	}*/

	/**
	 * Set resize parent.
	 */
	private function setResizeParent(v:Bool):Bool {
		_resizeParent=v;

		if (_target!=null)
			updateLayout();

		return v;
	}

	/**
	 * Set resize children.
	 */
	private function setResizeChildren(v:Bool):Bool {
		_resizeChildren=v;

		if (_target!=null)
			updateLayout();

		return v;
	}

	/**
	 * Set gap.
	 */
	private function setGap(value:Int):Int {
		_gap=value;

		if (_target!=null)
			updateLayout();

		return _gap;
	}

	/**
	 * Update layout.
	 */
	override public function updateLayout():Void {
		if (_resizeChildren) {
			var cw:Float=Math.round(_target.node.offsetWidth/_target.widgets.length);
			var pos:Float=0;
			var done:Int=0;

			for (w in _target.widgets) {
				pos+=cw;
				var wi:Int=Math.round(pos-done);
				done+=wi;

				w.width=wi;
			}
		}

		var x:Int=0;

		for (w in _target.widgets) {
			if (x!=0)
				x+=_gap;

			w.left=x;
			x+=w.width;
		}

		if (_resizeParent)
			_target.width=x;
	}
}
