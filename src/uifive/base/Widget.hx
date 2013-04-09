package uifive.base;

import js.Dom.HtmlDom;
import js.Dom;

/** 
 * Base class.
 */
class Widget implements IWidget {

	public var width(getWidth,setWidth):Int;
	public var height(getHeight,setHeight):Int;
	public var left(getLeft,setLeft):Int;
	public var top(getTop,setTop):Int;
	public var right(getRight,setRight):Int;
	public var bottom(getBottom,setBottom):Int;
	public var container(getContainer,setContainer):WidgetContainer;
	public var node(getNode,null):HtmlDom;

	private var _node:HtmlDom;
	private var _container:WidgetContainer;

	private var _left:Null<Int>;
	private var _right:Null<Int>;
	private var _top:Null<Int>;
	private var _bottom:Null<Int>;
	private var _width:Null<Int>;
	private var _height:Null<Int>;

	/**
	 * Construct.
	 */
	public function new() {
		if (node==null)
			_node=js.Lib.document.createElement("div");

		_container=null;

		_left=null;
		_right=null;
		_top=null;
		_bottom=null;
		_width=100;
		_height=20;
		updateStyle();
	}

	/**
	 * Get DOM node.
	 */
	private function getNode() {
		return _node;
	}

	/**
	 * Set distance from container's left edge to
	 * this widget's left edge.
	 */
	private function setLeft(value:Int):Int {
		if (_left==value)
			return _left;

		_left=value;
		updateStyle();

		return _left;
	}

	/**
	 * Set explicit width of component.
	 * Will be ignored it left and right is set.
	 */
	private function setWidth(value:Int):Int {
		if (_width==value)
			return _width;

		_width=value;
		updateStyle();

		return _width;
	}

	/**
	 * Set distance from container's right edge to
	 * this widget's right edge.
	 */
	private function setRight(value:Int):Int {
		if (_right==value)
			return _right;

		_right=value;
		updateStyle();

		return _right;
	}

	/**
	 * Set distance from container's top edge to
	 * this widget's top edge.
	 */
	private function setTop(value:Int):Int {
		if (_top==value)
			return _top;

		_top=value;
		updateStyle();

		return _top;
	}

	/**
	 * Set explicit height of widget.
	 * Will be ignored it top and bottom is set.
	 */
	private function setHeight(value:Int):Int {
		if (_height==value)
			return _height;

		_height=value;
		updateStyle();

		return _height;
	}

	/**
	 * Set distance from container's bottom edge to
	 * this widget's bottom edge.
	 */
	private function setBottom(value:Int):Int {
		if (_bottom==value)
			return _bottom;

		_bottom=value;
		updateStyle();

		return _bottom;
	}

	/**
	 * Get actual width.
	 */
	private function getWidth():Int {
		return _width;
	}

	/**
	 * Get actual height.
	 */
	private function getHeight():Int {
		return _height;
	}

	/**
	 * Get actual left.
	 */
	private function getLeft():Int {
		return _left;
	}

	/**
	 * Get actual top.
	 */
	private function getTop():Int {
		return _top;
	}

	/**
	 * Get right.
	 */
	private function getRight():Int {
		return _right;
	}

	/**
	 * Get bottom.
	 */
	private function getBottom():Int {
		return _bottom;
	}

	/**
	 * Set container.
	 */
	private function setContainer(w:WidgetContainer):WidgetContainer {
		_container=w;

		updateStyle();

		return _container;
	}

	/**
	 * Get container.
	 */
	private function getContainer():WidgetContainer {
		return _container;
	}

	/**
	 * Add css class.
	 */
	public function addClass(className:String):Void {
		_node.className+=" "+className;
	}

	/**
	 * Remove css class.
	 */
	public function removeClass(className:String):Void {
		var reg:EReg=new EReg("(?:^|\\s)"+className+"(?!\\S)","g");

		_node.className=reg.replace(_node.className,"");

/*		var cls=_node.className;

		cls=cls.replace(,'');

		cls=_node.className;*/
	}

	/**
	 * Update style.
	 */
	private function updateStyle():Void {
		_node.style.position="absolute";
		_node.style.overflow="hidden";

		_node.style.left=(_left==null)?"auto":_left+"px";
		_node.style.right=(_right==null)?"auto":_right+"px";

		if (_left!=null && _right!=null)
			_node.style.width="auto";

		else
			_node.style.width=(_width==null)?"auto":_width+"px";

		_node.style.top=(_top==null)?"auto":_top+"px";
		_node.style.bottom=(_bottom==null)?"auto":_bottom+"px";

		if (_top!=null && _bottom!=null)
			_node.style.height="auto";

		else
			_node.style.height=(_height==null)?"auto":_height+"px";
	}	
}