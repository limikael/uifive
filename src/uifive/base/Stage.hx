package uifive.base;

/**
 * Stage.
 */
class Stage {

	public static var root(getRoot,null):WidgetContainer;

	private static var _root:RootContainer;

	/**
	 * Initialize body.
	 */
	public static function initializeBody():Void {
		if (_root!=null)
			throw "Already initialized.";

		_root=new RootContainer();
		_root.attachToBody();
	}

	/**
	 * Get root.
	 */
	private static function getRoot():WidgetContainer {
		if (_root==null)
			initializeBody();

		return _root;
	}
}