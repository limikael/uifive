package uifive.collections;

import uifive.signals.Signal;

/**
 * Weight ordered collection.
 */
class SortedCollection<ItemType> extends Collection<ItemType>, implements ICollection<ItemType> {

	private var _compareFunction:ItemType->ItemType->Int;

	/**
	 * Construct.
	 */
	public function new(cmp:ItemType->ItemType->Int) {
		super();

		_compareFunction=cmp;
	}

	/**
	 * Check weight and add item.
	 */
	override public function addItem(item:ItemType):Void {
		if (getItemIndex(item)>=0)
			return;

		_items.push(item);
		internalSort();
		onUpdate.dispatch();
	}

	/**
	 * Sort items.
	 */
	public function sort():Void {
		internalSort();
		onUpdate.dispatch();
	}

	/**
	 * Internal sort.
	 */
	private function internalSort():Void {
		_items.sort(_compareFunction);
	}
}