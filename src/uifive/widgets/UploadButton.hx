package uifive.widgets;

import uifive.base.Widget;
import uifive.base.WidgetContainer;
import uifive.widgets.Label;
import uifive.widgets.Button;
import uifive.signals.Signal;

import js.Dom;

/**
 * Upload button.
 */
class UploadButton extends WidgetContainer {

	public var file(getFile,null):Dynamic;
	public var onChange(default,null):Signal<Void>;
	private var _fileUpload:FileUpload;

	/**
	 * Construct.
	 */
	public function new() {
		_node=js.Lib.document.createElement("input");

		_fileUpload=cast _node;
		_fileUpload.type="file";
		_fileUpload.onchange=onFileChange;

		onChange=new Signal<Void>();

		super();
	}

	/**
	 * On change.
	 */
	private function onFileChange(e:Dynamic):Void {
		onChange.dispatch();

		_fileUpload.value="";
	}

	/**
	 * Get file.
	 */
	private function getFile():Dynamic {
		return (untyped _fileUpload.files)[0];
	}
}