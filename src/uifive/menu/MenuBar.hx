package uifive.menu;

import uifive.base.WidgetContainer;
import uifive.base.Widget;
import uifive.base.RootContainer;
import uifive.layout.HorizontalLayout;
import uifive.widgets.Button;
import uifive.utils.WidgetUtil;
import uifive.utils.Point;
import uifive.signals.MouseEvent;
import uifive.signals.EventSignal;

import js.Lib;
import js.Dom.Event;

/**
 * Menu.
 */
class MenuBar extends WidgetContainer {

	public var onAction:EventSignal<String>;

	private var _buttons:Array<Button>;
	private var _menus:Array<Menu>;
	private var _visibleMenu:Menu;
	private var _selectedButtonClass:String;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		onAction=new EventSignal<String>();

		var h:HorizontalLayout=new HorizontalLayout(true);
		h.gap=10;
		layout=h;

		height=25;

		_buttons=new Array<Button>();
		_menus=new Array<Menu>();
	}

	/**
	 * Add button class.
	 */
	public function addButtonClass(cls:String):Void {
		for (b in _buttons)
			b.addClass(cls);
	}

	/**
	 * Set selected button class.
	 */
	public function setSelectedButtonClass(cls:String):Void {
		_selectedButtonClass=cls;
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

		menu.onAction.addListener(onMenuAction);

		addWidget(b);
	}

	/**
	 * Create menu.
	 */
	public function createMenu(label:String):Menu {
		var m:Menu=new Menu();

		addMenu(label,m);

		return m;
	}

	/**
	 * Menu click.
	 */
	private function onMenuAction(id:String):Void {
		hideMenu();

		onAction.dispatch(id);
	}

	/**
	 * Button click.
	 */
	private function onButtonClick(index:Int):Void {
		hideMenu();

		//trace("button click: "+index+" menu: "+_menus[index]);

		var root:RootContainer=WidgetUtil.getRootContainer(this);
		root.onMouseDown.addListener(onRootMouseDown);
		var p:Point=WidgetUtil.getGlobalPosition(_buttons[index]);

		var m:Menu=_menus[index];
		m.left=p.x;
		m.top=p.y+30;
		root.addWidget(m);
		_visibleMenu=m;

		_buttons[index].addClass(_selectedButtonClass);
	}

	/**
	 * Hide
	 */
	private function hideMenu():Void {
		var root:RootContainer=WidgetUtil.getRootContainer(this);

		root.onMouseDown.removeListener(onRootMouseDown);

		if (_visibleMenu!=null)
			_visibleMenu.container.removeWidget(_visibleMenu);

		for (b in _buttons)
			b.removeClass(_selectedButtonClass);
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
	}

	/**
	 * Set container.
	 */
	override private function setContainer(w:WidgetContainer):WidgetContainer {
		Lib.document.onkeydown=onWindowKeyDown;

		return super.setContainer(w);
	}

	/**
	 * Get menu item by accelerator.
	 */
	public function getMenuItemByAccelerator(accelerator:String):MenuItem {
		for (menu in _menus) {
			var item:MenuItem=menu.getMenuItemByAccelerator(accelerator);
			if (item!=null)
				return item;
		}

		return null;
	}

	/**
	 * Get menu item by id.
	 */
	public function getMenuItemById(id:String):MenuItem {
		for (menu in _menus) {
			var item:MenuItem=menu.getMenuItemById(id);
			if (item!=null)
				return item;
		}

		return null;
	}

	/**
	 * Window key up.
	 */
	private function onWindowKeyDown(e:Event):Void {
		if (e.ctrlKey) {
			var s:String=String.fromCharCode(e.keyCode);

			if (e.shiftKey)
				s=s.toUpperCase();

			else
				s=s.toLowerCase();

			var item:MenuItem=getMenuItemByAccelerator(s);

			if (item!=null)
				onAction.dispatch(item.id);
		}
	}
}