package uifive.widgets;

import uifive.base.Widget;
import uifive.base.WidgetContainer;
import uifive.widgets.Button;
import uifive.widgets.ButtonDecorator;
import uifive.layout.HorizontalLayout;
import uifive.signals.Signal;

import js.Dom;

/**
 * Tab bar.
 */
class TabBar extends WidgetContainer {

	public var onChange(default,null):Signal<Void>;
	public var selectedIndex(getSelectedIndex,setSelectedIndex):Int;

	private var _buttons:Array<Button>;
	private var _selectedButtonClass:String=null;
	private var _selectedIndex:Int=-1;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_buttons=new Array<Button>();

		var l:HorizontalLayout=new HorizontalLayout();
		l.resizeChildren=true;
		layout=l;

		onChange=new Signal<Void>();
	}

	/**
	 * Add tab.
	 */
	public function addTab(label:String):Void {
		var b:Button=new Button(label);

		b.onClick.addListenerWithParameter(onButtonClick,_buttons.length);

		var i:Int=_buttons.length;
		b.node.onmousedown=function(e:Event) {
			onButtonClick(i);
		}

		_buttons.push(b);
		addWidget(b);

		if (_selectedIndex<0)
			selectedIndex=0;
	}

	/**
	 * On button click.
	 */
	private function onButtonClick(index:Int):Void {
		selectedIndex=index;

		onChange.dispatch();
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

		if (_selectedIndex>=0 && _selectedIndex<_buttons.length)
			_buttons[_selectedIndex].addClass(_selectedButtonClass);
	}

	/**
	 * Set selected index.
	 */
	private function setSelectedIndex(i:Int):Int {
		for (b in _buttons)
			b.removeClass(_selectedButtonClass);

		_selectedIndex=i;

		if (_selectedIndex>=0 && _selectedIndex<_buttons.length)
			_buttons[_selectedIndex].addClass(_selectedButtonClass);

		return _selectedIndex;
	}

	/**
	 * Get selected index.
	 */
	private function getSelectedIndex():Int {
		return _selectedIndex;
	}
}