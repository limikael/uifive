package uifive.base;

import js.Dom.HtmlDom;
import js.Dom;

/**
 * Widget base class.
 */
interface IWidget {

	public var node(getNode,null):HtmlDom;
	public var container(null,setContainer):WidgetContainer;
	public var attached(getAttached,null):Bool;

	public var width(getWidth,setWidth):Int;
	public var height(getHeight,setHeight):Int;
	public var left(getLeft,setLeft):Int;
	public var top(getTop,setTop):Int;
	public var right(null,setRight):Int;
	public var bottom(null,setBottom):Int;

	public function notifyLayout():Void;

}