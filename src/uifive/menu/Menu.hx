package uifive.menu;

import uifive.base.WidgetContainer;
import uifive.layout.VerticalLayout;
import uifive.signals.Signal;

/**
 * Menu.
 */
class Menu extends WidgetContainer {

	public var onAction:Signal<String>;

	private var _items:Array<MenuItem>;

	/**
	 * Construct.
	 */
	public function new() {
		super();
		layout=new VerticalLayout(true);

		onAction=new Signal<String>();

		width=200;

		_node.style.borderStyle="solid";
		_node.style.borderWidth="1px";
		_node.style.borderColor="#808080";

		var style:Dynamic=cast _node.style;
		style.boxShadow="0px 0px 5px 2px #c0c0c0";

		_items=new Array<MenuItem>();
	}

	/**
	 * Add a menu item.
	 */
	public function addItem(item:MenuItem):Void {
		addWidget(item);

		_items.push(item);

		item.onClick.addListenerWithParameter(onItemClick,item.id);
	}

	/**
	 * Create and add menu item.
	 */
	public function createItem(id:String, label:String, accelerator:String=null):MenuItem {
		var item:MenuItem=new MenuItem(id,label,accelerator);

		addItem(item);

		return item;
	}

	/**
	 * Item click.
	 */
	private function onItemClick(id:String):Void {
		onAction.dispatch(id);
	}

	/**
	 * Get menu item by accelerator.
	 */
	public function getMenuItemByAccelerator(accelerator:String):MenuItem {
		for (item in _items) {
			//trace("matching "+accelerator+" "+item.accelerator);
			if (item.accelerator==accelerator)
				return item;
		}

		return null;
	}

	/**
	 * Get menu item by id.
	 */
	public function getMenuItemById(id:String):MenuItem {
		for (item in _items)
			if (item.id==id)
				return item;

		return null;
	}
}