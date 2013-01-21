package uifive.signals;

/**
 * Signal.
 */
class Signal {

	private var _listeners:Array<Void->Void>;

	/**
	 * Construct.
	 */
	public function new() {
		_listeners=new Array<Void->Void>();
	}

	/**
	 * Add listener.
	 */
	public function addListener(listener:Void->Void):Void {
		removeListener(listener);
		_listeners.push(listener);
	}

	/**
	 * Remove event listener.
	 */
	public function removeListener(listener:Void->Void):Void {
		for (i in 0..._listeners.length) {
			if (Reflect.compareMethods(_listeners[i],listener)) {
				_listeners.splice(i,1);
				return;
			}
		}
	}

	/**
	 * Dispatch.
	 */
	public function dispatch():Void {
		//trace("dispatching, n listeners: "+_listeners.length);
		for (listener in _listeners)
			listener();
	}
}