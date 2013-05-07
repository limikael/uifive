package uifive.widgets;

import uifive.base.Widget;
import js.Dom.HtmlDom;
import js.Dom;

import js.Lib;

/**
 * Flash widget.
 */
class FlashWidget extends Widget{

	public var flashNode(getFlashNode,null):Dynamic;
	private var _flashNodeId:String;

	/**
	 * Construct.
	 */
	public function new(url:String):Void {
		super();

		trace("flash widget constr..");

		var r:Int=Math.round(Math.random()*10000);
		_flashNodeId="flashnode_"+r;

		var flashNode:HtmlDom;
		flashNode=js.Lib.document.createElement("div");
		flashNode.id=_flashNodeId;
//		flashNode.name=_flashNodeId;

		node.appendChild(flashNode);

		var swfo:Dynamic=untyped swfobject;
		trace("got swf object: "+(swfo!=null)+" url: "+url);
		var d:Dynamic=swfo.embedSWF(url,_flashNodeId,"100%","100%","11.0.0");
		trace("embed swf: "+d);

		var w=Lib.window;
		trace("w: "+w);
	}

	/**
	 * Get flash node id.
	 */
	private function getFlashNode():Dynamic {
		return Lib.document.getElementById(_flashNodeId);
	}
}