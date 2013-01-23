package uifive.utils;

import uifive.signals.Signal;

/**
 * Data binding.
 */
class Binding {

	private var _signal:Signal;
	private var _host:Dynamic;
	private var _hostProp:String;
	private var _dest:Dynamic;
	private var _destProp:String;

	/**
	 * Construct.
	 */
	private function new(s:Signal, h:Dynamic, hp:String, d:Dynamic, dp:String) {
		_signal=s;
		_host=h;
		_hostProp=hp;
		_dest=d;
		_destProp=dp;

		_signal.addListener(onSignal);

		Reflect.setProperty(_dest,_destProp,Reflect.getProperty(_host,_hostProp));
	}

	/**
	 * On signal.
	 */
	private function onSignal():Void {
		Reflect.setProperty(_dest,_destProp,Reflect.getProperty(_host,_hostProp));
	}

	/**
	 * Create binding.
	 */
	public static function create(signal:Signal, host:Dynamic, hostProp:String, dest:Dynamic, destProp:String) {
		new Binding(signal,host,hostProp,dest,destProp);
	}
}
