package uifive.signals;

/**
 * Error event.
 */
class ErrorEvent {

	public var code(default,null):Int;
	public var message(default,null):String;

	/**
	 * Construct.
	 */
	public function new(msg:String, cod:Int=-1):Void {
		message=msg;
		code=cod;
	}
}