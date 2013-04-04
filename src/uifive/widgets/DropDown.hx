package uifive.widgets;

import uifive.base.Widget;
import uifive.collections.Collection;

import js.Dom.HtmlDom;
import js.Dom.Select;
import js.Dom.Option;
import js.Dom;

/**
 * Drop down.
 */
class DropDown<ItemType> extends Widget {

	public var dataProvider(null,setDataProvider):Collection<ItemType>;

	private var _dataProvider:Collection<ItemType>;
	private var _selectNode:Select;
	private var _labelFunc:ItemType->String;
	/**
	 * Construct.
	 */
	public function new():Void {
		_node=js.Lib.document.createElement("select");
		_selectNode=cast _node;
		_labelFunc=defaultLabelFunc;

		super();
	}

	/**
	 * Default item func.
	 */
	private function defaultLabelFunc(i:ItemType):String {
		return Std.string(i);
	}

	/**
	 * Set data provider.
	 */
	private function setDataProvider(p:Collection<ItemType>):Collection<ItemType> {
		_dataProvider=p;

		updateAll();

		return p;
	}

	/**
	 * Update all.
	 */
	private function updateAll():Void {
		if (_dataProvider==null)
			return;

		for (item in _dataProvider) {
			var o:Option=cast js.Lib.document.createElement("option");
			o.text=_labelFunc(item);

			_selectNode.appendChild(o);
		}
	}
}