package uifive.base;

/**
 * ItemRenderer.
 */
interface IItemRenderer<ItemType> implements IWidget {

	public function setData(value:ItemType):Void;

}