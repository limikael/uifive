package uifive.widgets;

import uifive.base.Widget;
import uifive.signals.Signal;
import uifive.collections.ICollection;

import js.Dom.HtmlDom;
import js.Dom.Select;
import js.Dom.Option;
import js.Dom;

/**
 * Drop down.
 */
class DropDown<ItemType> extends Widget {

	public var onChange(default,null):Signal<Void>;

	public var labelFunc(null,setLabelFunc):ItemType->String;
	public var dataProvider(null,setDataProvider):ICollection<ItemType>;
	public var selectedIndex(getSelectedIndex,setSelectedIndex):Int;
	public var selectedItem(getSelectedItem,setSelectedItem):ItemType;

	private var _dataProvider:ICollection<ItemType>;
	private var _selectNode:Select;
	private var _labelFunc:ItemType->String;

	/**
	 * Construct.
	 */
	public function new():Void {
		onChange=new Signal<Void>();

		_node=js.Lib.document.createElement("select");
		_selectNode=cast _node;
		_selectNode.onchange=onSelectChange;
		_labelFunc=defaultLabelFunc;

		super();
	}

	/**
	 * Set label func.
	 */
	private function setLabelFunc(f:ItemType->String):ItemType->String {
		_labelFunc=f;

		return _labelFunc;
	}

	/**
	 * Select change.
	 */
	private function onSelectChange(e:js.Event):Void {
		onChange.dispatch();
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
	private function setDataProvider(p:ICollection<ItemType>):ICollection<ItemType> {
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

	/**
	 * Get selected index.
	 */
	private function getSelectedIndex():Int {
		return _selectNode.selectedIndex;
	}

	/**
	 * Set selected index.
	 */
	private function setSelectedIndex(v:Int):Int {
		_selectNode.selectedIndex=v;

		return _selectNode.selectedIndex;
	}

	/**
	 * Set selected item.
	 */
	public function setSelectedItem(s:ItemType):ItemType {
		for (i in 0..._dataProvider.getLength())
			if (_dataProvider.getItemAt(i)==s)
				setSelectedIndex(i);

		return getSelectedItem();
	}

	/**
	 * Set selected item.
	 */
	private function getSelectedItem():ItemType {
		return _dataProvider.getItemAt(_selectNode.selectedIndex);
	}
}