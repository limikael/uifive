package uifive.base;

import uifive.layout.Layout;
import uifive.utils.ArrayTools;

/**
 * Base class.
 */
class WidgetContainer extends Widget {

	public var layout(getLayout,setLayout):Layout;
	public var widgets(getWidgets,null):Array<IWidget>;

	private var _widgets:Array<IWidget>;
	private var _layout:Layout;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_widgets=[];
		_layout=null;

		/*node.onresize=function(e) {
			trace("resize...");
		}*/
	}

	/**
	 * Add widget.
	 */
	public function addWidget(w:IWidget):Void {
		var index:Int=ArrayTools.indexOf(_widgets,w);
		if (index>=0)
			return;

		_widgets.push(w);
		w.container=this;
		_node.appendChild(w.node);

		if (_layout!=null)
			_layout.updateLayout();
	}

	/**
	 * Remove widget.
	 */
	public function removeWidget(w:IWidget):Void {
		var index:Int=ArrayTools.indexOf(_widgets,w);
		if (index<0)
			return;

		_node.removeChild(w.node);
		_widgets.splice(index,1);

		if (_layout!=null)
			_layout.updateLayout();
	}

	/**
	 * Get widgets.
	 */
	public function getWidgets():Array<IWidget> {
		return _widgets.copy();
	}

	/**
	 * Set layout.
	 */
	private function setLayout(value:Layout):Layout {
		if (_layout!=null)
			_layout.target=null;

		_layout=value;
		_layout.target=this;

		return _layout;
	}

	/**
	 * Set layout.
	 */
	private function getLayout():Layout {
		return _layout;
	}

	/**
	 * Notify layout.
	 */
	override public function notifyLayout():Void {
		super.notifyLayout();

		for (w in _widgets)
			w.notifyLayout();

		if (_layout!=null)
			_layout.updateLayout();
	}
}