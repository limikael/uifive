package uifive.signals;

/**
 * Signal.
 */
class Signal {

	private var _listeners:Array<Void->Void>;
	private var _connections:Array<Signal>;

	/**
	 * Construct.
	 */
	public function new() {
		_listeners=new Array<Void->Void>();
		_connections=new Array<Signal>();
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
	 * Connect to another signal.
	 */
	public function addConnection(signal:Signal):Void {
		_connections.push(signal);
	}

	/**
	 * Dispatch.
	 */
	public function dispatch():Void {
		for (listener in _listeners)
			listener();

		for (connection in _connections)
			connection.dispatch();
	}
}