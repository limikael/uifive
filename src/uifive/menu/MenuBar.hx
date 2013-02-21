package uifive.menu;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.RootContainer;
import uifive.layout.HorizontalLayout;
import uifive.widgets.Button;
import uifive.utils.WidgetUtil;
import uifive.utils.Point;
import uifive.signals.MouseEvent;

/**
 * Menu.
 */
class MenuBar extends WidgetContainer {

	private var _buttons:Array<Button>;
	private var _menus:Array<Menu>;
	private var _visibleMenu:Menu;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		var h:HorizontalLayout=new HorizontalLayout(true);
		h.gap=10;
		layout=h;

		height=25;

		_buttons=new Array<Button>();
		_menus=new Array<Menu>();
	}

	/**
	 * Add a menu item.
	 */
	public function addMenu(label:String, menu:Menu):Void {
		var b:Button=new Button(label);
		b.onClick.addListenerWithParameter(onButtonClick,_buttons.length);

		b.width=label.length*8+10;
		_buttons.push(b);
		_menus.push(menu);

		addWidget(b);
	}

	/**
	 * Button click.
	 */
	private function onButtonClick(index:Int):Void {
		hideMenu();

		trace("button click: "+index+" menu: "+_menus[index]);

		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseDown.addListener(onRootMouseDown);
		var p:Point=WidgetUtil.getGlobalPosition(_buttons[index]);

		var m:Menu=_menus[index];
		m.left=p.x;
		m.top=p.y+30;
		root.addWidget(m);
		_visibleMenu=m;
	}

	/**
	 * Hide
	 */
	private function hideMenu():Void {
		var root:RootContainer=WidgetUtil.getRootContainer(this);

		root.onMouseDown.removeListener(onRootMouseDown);

		if (_visibleMenu!=null)
			_visibleMenu.container.removeWidget(_visibleMenu);
	}

	/**
	 * Root mouse down.
	 */
	private function onRootMouseDown(e:MouseEvent):Void {
		if (_visibleMenu!=null) {
			var p:Point=WidgetUtil.getGlobalPosition(_visibleMenu);

			if (e.x>=p.x && e.y>=p.y && e.x<=p.x+_visibleMenu.width && e.y<=p.y+_visibleMenu.height)
				return;

			hideMenu();
		}
//		trace("root mouse down");
	}
}