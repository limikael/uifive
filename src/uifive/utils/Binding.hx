package uifive.utils;

import uifive.signals.Signal;

/**
 * Data binding.
 */
class Binding {

	private var _signal:Signal<Void>;
	private var _src:Dynamic;
	private var _srcProp:String;
	private var _dest:Dynamic;
	private var _destProp:String;

	/**
	 * Construct.
	 */
	private function new(s:Signal<Void>, d:Dynamic, dp:String, so:Dynamic, sp:String) {
		_signal=s;
		_src=so;
		_srcProp=sp;
		_dest=d;
		_destProp=dp;

		_signal.addListener(onSignal);

		Reflect.setProperty(_dest,_destProp,Reflect.getProperty(_src,_srcProp));
	}

	/**
	 * On signal.
	 */
	private function onSignal():Void {
		Reflect.setProperty(_dest,_destProp,Reflect.getProperty(_src,_srcProp));
	}

	/**
	 * Create binding.
	 */
	public static function create(signal:Signal<Void>, dest:Dynamic, destProp:String, src:Dynamic, srcProp:String):Binding {
		return new Binding(signal,dest,destProp,src,srcProp);
	}

	/**
	 * Disconnect.
	 */
	public function disconnect():Void {
		_signal.removeListener(onSignal);
	}
}
