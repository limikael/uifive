package uifive.collections;

import uifive.signals.Signal;

/**
 * Collection.
 */
class Collection<ItemType> implements ICollection<ItemType> {

	public var onUpdate(default,null):Signal<Void>;

	private var _items:Array<ItemType>;

	/**
	 * Construct.
	 */
	public function new(src:Array<ItemType>=null) {
		onUpdate=new Signal<Void>();

		_items=new Array<ItemType>();

		if (src!=null)
			for (i in src)
				addItem(i);
	}

	/**
	 * Add item.
	 */
	public function addItem(item:ItemType) {
		if (getItemIndex(item)>=0)
			return;

		_items.push(item);
		onUpdate.dispatch();
	}

	/**
	 * Remove item.
	 */
	public function removeItemAt(index:Int) {
		var o=this.getItemAt(index);

		_items.splice(index,1);
		onUpdate.dispatch();
	}

	/**
	 * Get item at.
	 */
	public function getItemAt(index:Int):ItemType {
		return _items[index];
	}

	/**
	 * Get item index.
	 */
	public function getItemIndex(item:ItemType):Int {
		for (i in 0..._items.length)
			if (_items[i]==item)
				return i;

		return -1;
	}

	/**
	 * Remove item.
	 */
	public function removeItem(item:ItemType):Void {
		var index:Int=getItemIndex(item);

		if (index>=0)
			removeItemAt(index);
	}

	/**
	 * Get length.
	 */
	public function getLength():Int {
		return _items.length;
	}

	/**
	 * Get iterator.
	 */
	public function iterator():Iterator<ItemType> {
		return _items.iterator();
	}
}