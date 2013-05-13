package uifive.widgets;

import uifive.base.Widget;
import uifive.base.IWidget;
import uifive.base.WidgetContainer;

/**
 * Pager.
 */
class Pager extends WidgetContainer {

	public var currentIndex(getCurrentIndex,setCurrentIndex):Int;

	private var _pages:Array<IWidget>;
	private var _currentIndex:Int=-1;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_pages=new Array<IWidget>();
	}

	/**
	 * Add page.
	 */
	public function addPage(w:IWidget):Void {
		_pages.push(w);

		if (_currentIndex<0)
			currentIndex=0;
	}

	/**
	 * Set current index.
	 */
	private function setCurrentIndex(v:Int):Int {
		for (w in widgets.copy())
			removeWidget(w);

		addWidget(_pages[v]);
//		_pages[v].notifyLayout();
		_currentIndex=v;

		return v;
	}

	/**
	 * Get current index.
	 */
	private function getCurrentIndex():Int {
		return _currentIndex;
	}
}