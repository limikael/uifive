package uifive.signals;

/**
 * Event Signal.
 */
class EventSignal<Event> {

	private var _listeners:Array<Event->Void>;
	private var _connections:Array<EventSignal<Event>>;

	/**
	 * Construct.
	 */
	public function new() {
		_listeners=new Array<Event->Void>();
		_connections=new Array<EventSignal<Event>>();
	}

	/**
	 * Add listener.
	 */
	public function addListener(listener:Event->Void):Void {
		removeListener(listener);
		_listeners.push(listener);
	}

	/**
	 * Remove event listener.
	 */
	public function removeListener(listener:Event->Void):Void {
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
	public function addConnection(signal:EventSignal<Event>):Void {
		_connections.push(signal);
	}

	/**
	 * Dispatch.
	 */
	public function dispatch(event:Event):Void {
		for (listener in _listeners)
			listener(event);

		for (connection in _connections)
			connection.dispatch(event);
	}
}