package uifive.base;

import uifive.base.WidgetContainer;
import uifive.collections.ICollection;
import uifive.signals.Signal;

/**
 * List.
 */
class DataContainer<ItemType> extends WidgetContainer {

	public var dataProvider(null,setDataProvider):ICollection<ItemType>;
	public var itemRenderer(null,setItemRenderer):Class<IItemRenderer<ItemType>>;

	private var _dataProvider:ICollection<ItemType>;
	private var _itemRendererClass:Class<IItemRenderer<ItemType>>;

	/**
	 * Construct.
	 */
	public function new() {
		super();
	}

	/**
	 * Set data provider.
	 */
	public function setDataProvider(value:ICollection<ItemType>):ICollection<ItemType> {
		if (_dataProvider!=null) {
			_dataProvider.onAdd.removeListener(onDataProviderAdd);
			_dataProvider.onRemove.removeListener(onDataProviderRemove);
		}

		_dataProvider=value;

		if (_dataProvider!=null) {
			_dataProvider.onAdd.addListener(onDataProviderAdd);
			_dataProvider.onRemove.addListener(onDataProviderRemove);
		}

		updateAll();

		return _dataProvider;
	}

	/**
	 * Set item renderer.
	 */
	public function setItemRenderer(value:Class<IItemRenderer<ItemType>>):Class<IItemRenderer<ItemType>> {
		_itemRendererClass=value;

		updateAll();

		return _itemRendererClass;
	}

	/**
	 * Add.
	 */
	private function onDataProviderAdd():Void {
		updateAll();
	}

	/**
	 * Remove.
	 */
	private function onDataProviderRemove():Void {
		updateAll();
	}

	/**
	 * Update all.
	 */
	private function updateAll():Void {
		for (w in widgets)
			removeWidget(w);

		if (_itemRendererClass!=null) {
			for (data in _dataProvider) {
				var renderer:IItemRenderer<ItemType>=Type.createInstance(_itemRendererClass,[]);

				renderer.setData(data);

				addWidget(renderer);
			}
		}
	}
}