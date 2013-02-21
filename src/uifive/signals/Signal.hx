package uifive.signals;

/**
 * Parameter listener.
 */
class ParameterListener {
	public var listener:Dynamic->Void;
	public var parameter:Dynamic;

	public function new(l:Dynamic->Void, p:Dynamic) {
		listener=l;
		parameter=p;
	}
}

/**
 * Signal.
 */
class Signal {

	private var _parameterListeners:Array<ParameterListener>;
	private var _listeners:Array<Void->Void>;
	private var _connections:Array<Signal>;

	/**
	 * Construct.
	 */
	public function new() {
		_listeners=new Array<Void->Void>();
		_parameterListeners=new Array<ParameterListener>();
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
	 * Add listener.
	 */
	public function addListenerWithParameter(listener:Dynamic->Void, parameter:Dynamic):Void {
		removeListener(listener);
		_parameterListeners.push(new ParameterListener(listener,parameter));
	}

	/**
	 * Remove event listener.
	 */
	public function removeListener(listener:Dynamic):Void {
		for (i in 0..._listeners.length) {
			if (Reflect.compareMethods(_listeners[i],listener)) {
				_listeners.splice(i,1);
				return;
			}
		}

		for (i in 0..._parameterListeners.length) {
			if (Reflect.compareMethods(_parameterListeners[i].listener,listener)) {
				_parameterListeners.splice(i,1);
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

		for (parameterListener in _parameterListeners)
			parameterListener.listener(parameterListener.parameter);
	}
}