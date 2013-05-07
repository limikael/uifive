package uifive.utils;

import uifive.signals.Signal;
import js.XMLHttpRequest;
import haxe.Json;

/**
 * Upload file.
 */
class UploadFile {

	public var onError(default,null):Signal<String>;
	public var onSuccess(default,null):Signal<Void>;
	public var onProgress(default,null):Signal<Void>;

	public var uploadPercent(getUploadPercent,null):Int;

	private var _request:XMLHttpRequest;
	private var _url:String;
	private var _uploadPercent:Int;
	private var _result:Dynamic;
	private var _parameters:Array<String>;

	/**
	 * Construct.
	 */
	public function new(url:String):Void {
		onSuccess=new Signal<Void>();
		onError=new Signal<String>();
		onProgress=new Signal<Void>();

		_url=url;
		_uploadPercent=0;
		_parameters=new Array<String>();
	}

	/**
	 * Set parameter.
	 */
	public function setParameter(name:String, value:String):Void {
	 	_parameters.push(name+"="+StringTools.urlEncode(value));
	}

	/**
	 * Upload.
	 */
	public function uploadFile(file:Dynamic):Void {
		var url:String=_url;

		if (_parameters.length!=0)
			url+="?"+_parameters.join("&");

		trace("uploading to: "+url);
		_request=new XMLHttpRequest();
		_request.open("post",url,true);

		_request.setRequestHeader("X-File-Name", file.name);
		_request.setRequestHeader("X-File-Size", file.size);
		_request.setRequestHeader("X-File-Type", file.type);

		_request.onreadystatechange=onRequestReadyStateChange;
		(untyped _request).upload.onprogress=onUploadProgress;

		_request.send(file);
	}

	/**
	 * Ready state change.
	 */
	private function onRequestReadyStateChange():Void {
		trace("readystate change, readystate: "+_request.readyState+" status:"+_request.status);
		if (_request.readyState==4) {
			try {
				_result=Json.parse(_request.responseText);
			}

			catch (e:Dynamic) {
			}

			if (_result==null) {
				onError.dispatch("Unable to parse json\n"+_request.responseText);
				return;
			}

			if (_result.ok!=1) {
				onError.dispatch(_result.message);
				return;
			}

			onSuccess.dispatch();
		}
	}

	/**
	 * Get upload percent.
	 */
	private function getUploadPercent():Int {
		return _uploadPercent;
	}

	/**
	 * Progress.
	 */
	private function onUploadProgress(e:Dynamic):Void {
		/*trace("upload progress...");
		trace("e: "+Reflect.fields(e));*/

		if (e.lengthComputable) {
			_uploadPercent=Math.round(e.loaded/e.total);
			onProgress.dispatch();
		}
	}

	/**
	 * Cancel.
	 */
	public function abort():Void {
		if (_request!=null) {
			_request.abort();
		}

		onSuccess.removeAll();
		onError.removeAll();
	}
}