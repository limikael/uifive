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
	public var itemRendererFunc(null,setItemRendererFunc):Void->IItemRenderer<ItemType>;

	private var _dataProvider:ICollection<ItemType>;
	private var _itemRendererClass:Class<IItemRenderer<ItemType>>;
	private var _itemRendererFunc:Void->IItemRenderer<ItemType>;
	private var _renderers:Array<IItemRenderer<ItemType>>;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_renderers=new Array<IItemRenderer<ItemType>>();
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
	 * Set item renderer func.
	 */
	public function setItemRendererFunc(value:Void->IItemRenderer<ItemType>):Void->IItemRenderer<ItemType> {
		_itemRendererFunc=value;

		updateAll();

		return _itemRendererFunc;
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
		for (r in _renderers) {
			removeWidget(r);
			r.setData(null);
		}

		_renderers=new Array<IItemRenderer<ItemType>>();

		if (_itemRendererClass!=null || _itemRendererFunc!=null) {
			for (data in _dataProvider) {
				var renderer:IItemRenderer<ItemType>=createItemRenderer();

				renderer.setData(data);
				_renderers.push(renderer);

				addWidget(renderer);
			}
		}
	}

	/**
	 * Create item renderer.
	 */
	private function createItemRenderer():IItemRenderer<ItemType> {
		if (_itemRendererFunc!=null)
			return _itemRendererFunc();

		else if (_itemRendererClass!=null)
			return Type.createInstance(_itemRendererClass,[]);

		else
			throw "no item renderer set!";
	}
}