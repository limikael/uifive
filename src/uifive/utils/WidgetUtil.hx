package uifive.utils;

import uifive.base.RootContainer;
import uifive.base.Widget;
import uifive.base.WidgetContainer;

/**
 * Widget util.
 */
class WidgetUtil {

	/**
	 * Walk along the path to find the root container.
	 */
	public static function getRootContainer(w:Widget):RootContainer {
		if (Std.is(w,RootContainer))
			return cast w;

		var r:WidgetContainer=w.container;

		while (!Std.is(r,RootContainer)) {
			if (r==null)
				return null;

			r=r.container;
		}

		return cast r;
	}

	/**
	 * Get global poisition.
	 */
	public static function getGlobalPosition(w:Widget):Point {
//		var p:Point=new Point(w.left,w.top);
		var p:Point=new Point(w.node.offsetLeft,w.node.offsetTop);
//		var p:Point=new Point(w.node.offsetLeft,w.node.offsetTop);
//		var p:Point=new Point(w.node.scrollLeft,w.node.scrollTop);

		while (!Std.is(w,RootContainer)) {
			if (w==null)
				return null;

			w=w.container;
//			p=p.add(new Point(w.node.scrollLeft,w.node.scrollTop));
			p=p.add(new Point(w.node.offsetLeft,w.node.offsetTop));
			p=p.sub(new Point(w.node.scrollLeft,w.node.scrollTop));
//			p=p.add(new Point(w.left,w.top));
		}

		return p;
	}

	/**
	 * Hit test widget.
	 */
	public static function hitTest(w:Widget, x:Int, y:Int):Bool {
		var p:Point=getGlobalPosition(w);

		return (x>=p.x && y>=p.y && x<=p.x+w.node.offsetWidth && y<=p.y+w.node.offsetHeight);	
	}
}