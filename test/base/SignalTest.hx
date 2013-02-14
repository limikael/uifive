package test.base;

import uifive.base.RootContainer;
import uifive.signals.Signal;
import uifive.signals.EventSignal;

/**
 * Base test.
 */
class SignalTest extends RootContainer {

	private var _testSignal:Signal;
	private var _testEventSignal:EventSignal<Int>;

	public function new() {
		super();

		_testSignal=new Signal();
		_testSignal.addListener(testListener);
		_testSignal.dispatch();

		_testEventSignal=new EventSignal<Int>();
		_testEventSignal.addListener(testEventListener);
		_testEventSignal.dispatch(5);

		trace("here..");
	}

	/**
	 * bla.
	 */
	private function testListener():Void {

	}

	/**
	 * bla bla.
	 */
	private function testEventListener(i:Int):Void {
		trace("dispatched: "+i);
	}

	/**
	 * Main.
	 */
	public static function main() {
		new SignalTest().attach("testcontainer");
	}
}