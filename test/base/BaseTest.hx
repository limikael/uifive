package test.base;

import uifive.base.RootContainer;
import uifive.base.Widget;
import uifive.base.WidgetContainer;
import uifive.base.DataContainer;
import uifive.widgets.Label;
import uifive.widgets.Button;
import uifive.layout.VerticalLayout;
import uifive.collections.Collection;
import uifive.base.IItemRenderer;

class MyData {

	public var value:String;

	public function new(v:String) {
		value=v;
	}
}

class MyDataRenderer implements IItemRenderer<MyData>, extends WidgetContainer {

	private var l:Label;

	public function new():Void {
		super();

		l=new Label();
		addWidget(l);

		height=30;
	}

	public function setData(myData:MyData):Void {
		l.text=myData.value;
	}
}

/**
 * Base test.
 */
class BaseTest extends RootContainer {

	public function new() {
		super();

		var c=setupBasic();
		c.left=0;
		c.top=0;
		addWidget(c);

		var c=setupMany();
		c.right=0;
		c.bottom=0;
		addWidget(c);

		var c=setupLayout();
		c.left=50;
		c.top=400;
		addWidget(c);

		var c=setupData();
		c.left=350;
		c.top=50;
		addWidget(c);
	}

	/**
	 * Setup layout.
	 */
	private function setupLayout():WidgetContainer {
		var w:WidgetContainer=new WidgetContainer();
		w.width=250;
		w.height=100;
		w.node.style.background="#ff80ff";

		var l:Label=new Label("Hello first");
		w.addWidget(l);

		var l:Label=new Label("Hello again");
		w.addWidget(l);

		w.layout=new VerticalLayout();

		return w;
	}

	/**
	 * Setup data test.
	 */
	private function setupData():WidgetContainer {
		var c:Collection<MyData>=new Collection<MyData>();
		c.addItem(new MyData("hello first.."));
		c.addItem(new MyData("hello again"));

		var l:DataContainer<MyData>=new DataContainer<MyData>();
		l.dataProvider=c;
		l.itemRenderer=MyDataRenderer;
		l.layout=new VerticalLayout();
		l.left=350;
		l.width=200;
		l.height=200;
		l.top=50;
		l.node.style.background="#8080ff";


		c.addItem(new MyData("hello third.."));

		return l;
	}

	/**
	 * Setup basic.
	 */
	private function setupBasic():WidgetContainer {
		var container:WidgetContainer=new WidgetContainer();
		container.width=500;
		container.height=500;

		var w:WidgetContainer=new WidgetContainer();
		w.left=50;
		w.top=50;
		w.width=250;
		w.height=250;
		w.node.style.background="#00ff00";
		container.addWidget(w);

		var l:Label=new Label("Hello World");
		l.width=200;
		l.left=10;
		w.addWidget(l);

		var b:Button=new Button("Click");
		b.width=50;
		b.top=30;
		b.onClick.addListener(onButtonClick);
		w.addWidget(b);

		return container;
	}

	/**
	 * Setup many.
	 */
	private function setupMany():WidgetContainer {
		var container:WidgetContainer=new WidgetContainer();
		container.width=300;
		container.height=500;

		for (i in 0...10) {
			var l2:Label=new Label("Hello World again "+i);
			l2.right=10;
			l2.bottom=i*30;
			l2.width=250;
			container.addWidget(l2);
		}

		return container;
	}

	/**
	 * Button click.
	 */
	private static function onButtonClick():Void {
		trace("button click..");
	}

	/**
	 * Main.
	 */
	public static function main() {
		new BaseTest().attach("testcontainer");
	}
}