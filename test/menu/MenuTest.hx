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

		var bar:MenuBar=new MenuBar();

		var m:Menu=new Menu();
		m.addItem(new MenuItem("open","Open","H"));
		m.addItem(new MenuItem("close","Close","A"));
		bar.addMenu("Project",m);

		var m:Menu=new Menu();
		m.addItem(new MenuItem("cut","Cut","H"));
		m.addItem(new MenuItem("paste","Paste","A"));
		bar.addMenu("Edit",m);

		bar.left=10;
		bar.top=10;
		addWidget(bar);
	}

	/**
	 * Main.
	 */
	public static function main() {
		new MenuTest().attach("testcontainer");
	}
}