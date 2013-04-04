package uifive.collections;

import uifive.signals.Signal;

/**
 * Collection.
 */
class Collection<ItemType> implements ICollection<ItemType> {

	public var onAdd(default,null):Signal;
	public var onRemove(default,null):Signal;

	private var _items:Array<ItemType>;

	/**
	 * Construct.
	 */
	public function new(src:Array<ItemType>=null) {
		onAdd=new Signal();
		onRemove=new Signal();

		_items=new Array<ItemType>();

		if (src!=null)
			for (i in src)
				addItem(i);
	}

	/**
	 * Add item.
	 */
	public function addItem(item:ItemType) {
		_items.push(item);

		//trace("dispatching add..");

		onAdd.dispatch();
	}

	/**
	 * Remove item.
	 */
	public function removeItemAt(index:Int) {
		var o=this.getItemAt(index);

		_items.splice(index,1);

		onRemove.dispatch();
	}

	/**
	 * Get item at.
	 */
	public function getItemAt(index:Int):ItemType {
		return _items[index];
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