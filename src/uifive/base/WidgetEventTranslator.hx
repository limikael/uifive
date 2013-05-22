package uifive.base;

/**
 * Translate from DOM events to WidgetEvents.
 */
class WidgetEventTranslator {

	public var eventType(default,null):String;

	public var haxeFunction(default,null):Dynamic->Void;
	public var untypedFunction(default,null):Dynamic;

	/**
	 * Construct.
	 */
	public function new(et:String, target:Dynamic->Void) {
		haxeFunction=target;
		eventType=et;

		untypedFunction=untyped function(x) {
			target(x);
		}
	}
}