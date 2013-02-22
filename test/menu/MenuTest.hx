package test.menu;

import uifive.base.RootContainer;
import uifive.menu.Menu;
import uifive.menu.MenuItem;
import uifive.menu.MenuBar;

/**
 * Menu test.
 */
class MenuTest extends RootContainer {

	/**
	 * Construct.
	 */
	public function new() {
		super();

		var m:Menu;
		var bar:MenuBar=new MenuBar();
		bar.onAction.addListener(onMenuAction);

		m=bar.createMenu("File");
		m.createItem("open","Open","h");
		m.createItem("close","Close","A");

		m=bar.createMenu("Edit");
		m.createItem("cut","Cut","x");
		m.createItem("paste","Paste","y");

		bar.left=10;
		bar.top=10;
		addWidget(bar);
	}

	/**
	 * On menu action.
	 */
	private function onMenuAction(id:String):Void {
		trace("menu action: "+id);
	}

	/**
	 * Main.
	 */
	public static function main() {
		new MenuTest().attach("testcontainer");
	}
}