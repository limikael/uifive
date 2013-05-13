package uifive.widgets;

/**
 * Vertical scroll bar.
 */
class VScrollBar extends HScrollBar {

	/**
	 * Init thumb layout.
	 * This function and the ones below should be overridden for vertical.
	 */
	override private function initializeThumbLayout():Void {
		_thumb.left=0;
		_thumb.right=0;
	}

	/**
	 * Get extent of the track.
	 */
	override private function getAvailableTrackSize():Int {
		return node.offsetHeight;
	}

	/**
	 * Getter.
	 */
	override private function getThumbSize():Int {
		return _thumb.height;
	}

	/**
	 * Getter.
	 */
	override private function getThumbPosition():Int {
		return _thumb.top;
	}

	/**
	 * Set thumb pos.
	 */
	override private function setThumbPosition(pos:Int):Void {
		_thumb.top=pos;
	}

	/**
	 * Set thumb extent.
	 */
	override private function setThumbSize(size:Int):Void {
		_thumb.height=size;
	}

	/**
	 * Map event coordinate.
	 */
	override private function mapEventCoordinate(e:Dynamic):Int {
		if (e.pageY!=null)
			return e.pageY;

		if (e.y!=null)
			return e.y;

		throw "strange mouse event";
	}
}