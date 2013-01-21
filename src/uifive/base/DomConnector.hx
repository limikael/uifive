package uifive.base;

import js.Lib;
import js.Dom.HtmlDom;
/**
 * Connect a widget to a dom element.
 */
class DomConnector {

	/**
	 * Attach a widget a html node.
	 */
	public static function attachWidget(domId:String, widget:Widget) {
		trace("attaching");

		var node:HtmlDom=Lib.document.getElementById(domId);

		node.appendChild(widget.node);

		widget.node.style.marginLeft="0";
		widget.node.style.marginTop="0";
		widget.node.style.marginRight="0";
		widget.node.style.marginBottom="0";
		widget.node.style.width="100%";
		widget.node.style.height="100%";
	}
}