package test.menu;

import uifive.base.RootContainer;
import uifive.menu.Menu;
import uifive.menu.MenuItem;

/**
 * Menu test.
 */
class MenuTest extends RootContainer {

	/**
	 * Construct.
	 */
	public function new() {
		super();

		var m:Menu=new Menu();
		m.left=20;
		m.top=20;
		addWidget(m);

		m.addItem(new MenuItem("hello","Hello","H"));
		m.addItem(new MenuItem("again","Again","A"));
	}

	/**
	 * Main.
	 */
	public static function main() {
		new MenuTest().attach("testcontainer");
	}
}