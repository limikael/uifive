package uifive.menu;

import uifive.base.WidgetContainer;
import uifive.layout.VerticalLayout;

/**
 * Menu.
 */
class Menu extends WidgetContainer {

	/**
	 * Construct.
	 */
	public function new() {
		super();
		layout=new VerticalLayout(true);

		width=200;

		_node.style.borderStyle="solid";
		_node.style.borderWidth="1px";
		_node.style.borderColor="#808080";

		var style:Dynamic=cast _node.style;
		style.boxShadow="0px 0px 5px 2px #c0c0c0";
	}

	/**
	 * Add a menu item.
	 */
	public function addItem(item:MenuItem):Void {
		addWidget(item);
	}
}