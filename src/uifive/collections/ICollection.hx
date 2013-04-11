package uifive.collections;

import uifive.signals.Signal;

/**
 * Collection.
 */
interface ICollection<ItemType> {
	public var onAdd(default,null):Signal<Void>;
	public var onRemove(default,null):Signal<Void>;

	function addItem(item:ItemType):Void;
	function removeItemAt(index:Int):Void;
	function removeItem(item:ItemType):Void;
	function getItemAt(index:Int):ItemType;
	function getItemIndex(item:ItemType):Int;
	function getLength():Int;

	function iterator():Iterator<ItemType>;
}