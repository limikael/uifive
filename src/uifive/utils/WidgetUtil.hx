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
		var p:Point=new Point(w.left,w.top);

		while (!Std.is(w,RootContainer)) {
			if (w==null)
				return null;

			w=w.container;
			p=p.add(new Point(w.left,w.top));
		}

		return p;
	}
}