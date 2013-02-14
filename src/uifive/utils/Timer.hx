package uifive.utils;

import uifive.signals.Signal;

/**
 * Timer.
 */
class Timer {

	public var onTimer(default,null):Signal;

	private var _delay:Int;
	private var _intervalId:Int;

	/**
	 * Create timer.
	 */
	public function new(delay:Int) {
		onTimer=new Signal();

		_delay=delay;
	}

	/**
	 * Start.
	 */
	public function start():Void {
		stop();

		_intervalId=untyped window.setInterval(onInterval,_delay);
	}

	/**
	 * On interval.
	 */
	private function onInterval():Void {
		onTimer.dispatch();
	}

	/**
	 * Stop.
	 */
	public function stop():Void {
		if (_intervalId>=0)
			untyped window.clearInterval(_intervalId);

		_intervalId=-1;
	}
}