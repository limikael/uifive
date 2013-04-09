package uifive.utils;

import uifive.signals.Signal;

/**
 * Data for call later timers.
 */
class CallLaterData {

	public var timer:Timer;
	public var cb:Void->Void;

	/**
	 * Construct.
	 */
	public function new() {
	}
}

/**
 * Timer.
 */
class Timer {

	public var onTimer(default,null):Signal<Void>;

	private var _delay:Int;
	private var _intervalId:Int;

	/**
	 * Create timer.
	 */
	public function new(delay:Int) {
		onTimer=new Signal<Void>();

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

	/**
	 * Call a function later.
	 */
	public static function callLater(f:Void->Void):Void {
		var t:Timer=new Timer(0);

		var data:CallLaterData=new CallLaterData();
		data.timer=t;
		data.cb=f;

		t.onTimer.addListenerWithParameter(onCallLaterTimer,data);
		t.start();
	}

	/**
	 * On call later timer.
	 */
	private static function onCallLaterTimer(data:CallLaterData):Void {
		trace("call later timer..");
		data.timer.stop();
		data.timer.onTimer.removeListener(onCallLaterTimer);

		data.cb();
	}
}