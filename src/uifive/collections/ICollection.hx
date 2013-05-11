package uifive.collections;

import uifive.signals.Signal;

/**
 * Collection.
 */
interface ICollection<ItemType> {
	public var onUpdate(default,null):Signal<Void>;

	function getItemAt(index:Int):ItemType;
	function getItemIndex(item:ItemType):Int;
	function getLength():Int;

	function iterator():Iterator<ItemType>;
}