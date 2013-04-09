function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	customReplace: function(s,f) {
		var buf = new StringBuf();
		while(true) {
			if(!this.match(s)) break;
			buf.b += Std.string(this.matchedLeft());
			buf.b += Std.string(f(this));
			s = this.matchedRight();
		}
		buf.b += Std.string(s);
		return buf.b;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var IntIter = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = true;
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,__class__: IntIter
}
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && (v.__name__ || v.__ename__);
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
var Std = function() { }
Std.__name__ = true;
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	toString: function() {
		return this.b;
	}
	,addSub: function(s,pos,len) {
		this.b += HxOverrides.substr(s,pos,len);
	}
	,addChar: function(c) {
		this.b += String.fromCharCode(c);
	}
	,add: function(x) {
		this.b += Std.string(x);
	}
	,__class__: StringBuf
}
var js = js || {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.isClass = function(o) {
	return o.__name__;
}
js.Boot.isEnum = function(e) {
	return e.__ename__;
}
js.Boot.getClass = function(o) {
	return o.__class__;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Lib = function() { }
js.Lib.__name__ = true;
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
var uifive = uifive || {}
if(!uifive.base) uifive.base = {}
uifive.base.IWidget = function() { }
uifive.base.IWidget.__name__ = true;
uifive.base.IWidget.prototype = {
	__class__: uifive.base.IWidget
	,__properties__: {get_node:"getNode",set_container:"setContainer",set_width:"setWidth",get_width:"getWidth",set_height:"setHeight",get_height:"getHeight",set_left:"setLeft",get_left:"getLeft",set_top:"setTop",get_top:"getTop",set_right:"setRight",set_bottom:"setBottom"}
}
uifive.base.Widget = function() {
	if(this.getNode() == null) this._node = js.Lib.document.createElement("div");
	this._container = null;
	this._left = null;
	this._right = null;
	this._top = null;
	this._bottom = null;
	this._width = 100;
	this._height = 20;
	this.updateStyle();
};
uifive.base.Widget.__name__ = true;
uifive.base.Widget.__interfaces__ = [uifive.base.IWidget];
uifive.base.Widget.prototype = {
	updateStyle: function() {
		this._node.style.position = "absolute";
		this._node.style.overflow = "hidden";
		this._node.style.left = this._left == null?"auto":this._left + "px";
		this._node.style.right = this._right == null?"auto":this._right + "px";
		if(this._left != null && this._right != null) this._node.style.width = "auto"; else this._node.style.width = this._width == null?"auto":this._width + "px";
		this._node.style.top = this._top == null?"auto":this._top + "px";
		this._node.style.bottom = this._bottom == null?"auto":this._bottom + "px";
		if(this._top != null && this._bottom != null) this._node.style.height = "auto"; else this._node.style.height = this._height == null?"auto":this._height + "px";
	}
	,removeClass: function(className) {
		var reg = new EReg("(?:^|\\s)" + className + "(?!\\S)","g");
		this._node.className = reg.replace(this._node.className,"");
	}
	,addClass: function(className) {
		this._node.className += " " + className;
	}
	,getContainer: function() {
		return this._container;
	}
	,setContainer: function(w) {
		this._container = w;
		this.updateStyle();
		return this._container;
	}
	,getBottom: function() {
		return this._bottom;
	}
	,getRight: function() {
		return this._right;
	}
	,getTop: function() {
		return this._top;
	}
	,getLeft: function() {
		return this._left;
	}
	,getHeight: function() {
		return this._height;
	}
	,getWidth: function() {
		return this._width;
	}
	,setBottom: function(value) {
		if(this._bottom == value) return this._bottom;
		this._bottom = value;
		this.updateStyle();
		return this._bottom;
	}
	,setHeight: function(value) {
		if(this._height == value) return this._height;
		this._height = value;
		this.updateStyle();
		return this._height;
	}
	,setTop: function(value) {
		if(this._top == value) return this._top;
		this._top = value;
		this.updateStyle();
		return this._top;
	}
	,setRight: function(value) {
		if(this._right == value) return this._right;
		this._right = value;
		this.updateStyle();
		return this._right;
	}
	,setWidth: function(value) {
		if(this._width == value) return this._width;
		this._width = value;
		this.updateStyle();
		return this._width;
	}
	,setLeft: function(value) {
		if(this._left == value) return this._left;
		this._left = value;
		this.updateStyle();
		return this._left;
	}
	,getNode: function() {
		return this._node;
	}
	,__class__: uifive.base.Widget
	,__properties__: {set_width:"setWidth",get_width:"getWidth",set_height:"setHeight",get_height:"getHeight",set_left:"setLeft",get_left:"getLeft",set_top:"setTop",get_top:"getTop",set_right:"setRight",get_right:"getRight",set_bottom:"setBottom",get_bottom:"getBottom",set_container:"setContainer",get_container:"getContainer",get_node:"getNode"}
}
uifive.base.WidgetContainer = function() {
	uifive.base.Widget.call(this);
	this._widgets = [];
	this._layout = null;
	this.getNode().onresize = function(e) {
		console.log("resize...");
	};
};
uifive.base.WidgetContainer.__name__ = true;
uifive.base.WidgetContainer.__super__ = uifive.base.Widget;
uifive.base.WidgetContainer.prototype = $extend(uifive.base.Widget.prototype,{
	getLayout: function() {
		return this._layout;
	}
	,setLayout: function(value) {
		if(this._layout != null) this._layout.setTarget(null);
		this._layout = value;
		this._layout.setTarget(this);
		return this._layout;
	}
	,getWidgets: function() {
		return this._widgets.slice();
	}
	,removeWidget: function(w) {
		var index = uifive.utils.ArrayTools.indexOf(this._widgets,w);
		if(index < 0) return;
		this._node.removeChild(w.getNode());
		this._widgets.splice(index,1);
		if(this._layout != null) this._layout.updateLayout();
	}
	,addWidget: function(w) {
		this._widgets.push(w);
		w.setContainer(this);
		this._node.appendChild(w.getNode());
		if(this._layout != null) this._layout.updateLayout();
	}
	,__class__: uifive.base.WidgetContainer
	,__properties__: $extend(uifive.base.Widget.prototype.__properties__,{set_layout:"setLayout",get_layout:"getLayout",get_widgets:"getWidgets"})
});
uifive.base.RootContainer = function() {
	var _g = this;
	uifive.base.WidgetContainer.call(this);
	this.setLeft(0);
	this.setRight(0);
	this.setTop(0);
	this.setBottom(0);
	this.updateStyle();
	this.onMouseDown = new uifive.signals.Signal();
	this._node.onmousedown = function(e) {
		var info = e;
		var x = info.pageX;
		var y = info.pageY;
		_g.onMouseDown.dispatch(new uifive.signals.MouseEvent(x,y));
	};
};
uifive.base.RootContainer.__name__ = true;
uifive.base.RootContainer.__super__ = uifive.base.WidgetContainer;
uifive.base.RootContainer.prototype = $extend(uifive.base.WidgetContainer.prototype,{
	attach: function(domId) {
		var parent = js.Lib.document.getElementById(domId);
		parent.appendChild(this.getNode());
	}
	,__class__: uifive.base.RootContainer
});
var test = test || {}
if(!test.widgets) test.widgets = {}
test.widgets.CanvasWidgetTest = function() {
	uifive.base.RootContainer.call(this);
	this._canvasWidget = new uifive.widgets.CanvasWidget();
	this._canvasWidget.setLeft(0);
	this._canvasWidget.setTop(0);
	this._canvasWidget.setRight(0);
	this._canvasWidget.setBottom(0);
	this.addWidget(this._canvasWidget);
	var c = this._canvasWidget.getContext();
	c.strokeStyle = "#ff0000";
	c.lineWidth = 1;
	c.beginPath();
	c.moveTo(500.5,0);
	c.lineTo(500.5,100);
	c.stroke();
};
test.widgets.CanvasWidgetTest.__name__ = true;
test.widgets.CanvasWidgetTest.main = function() {
	console.log("canvas widget test");
	new test.widgets.CanvasWidgetTest().attach("testcontainer");
}
test.widgets.CanvasWidgetTest.__super__ = uifive.base.RootContainer;
test.widgets.CanvasWidgetTest.prototype = $extend(uifive.base.RootContainer.prototype,{
	__class__: test.widgets.CanvasWidgetTest
});
if(!uifive.layout) uifive.layout = {}
uifive.layout.Layout = function() {
	this._target = null;
};
uifive.layout.Layout.__name__ = true;
uifive.layout.Layout.prototype = {
	updateLayout: function() {
	}
	,setTarget: function(value) {
		this._target = value;
		this.updateLayout();
		return this._target;
	}
	,__class__: uifive.layout.Layout
	,__properties__: {set_target:"setTarget"}
}
if(!uifive.signals) uifive.signals = {}
uifive.signals.MouseEvent = function(pX,pY) {
	this.x = pX;
	this.y = pY;
};
uifive.signals.MouseEvent.__name__ = true;
uifive.signals.MouseEvent.prototype = {
	__class__: uifive.signals.MouseEvent
}
uifive.signals.ParameterListener = function(l,p) {
	this.listener = l;
	this.parameter = p;
};
uifive.signals.ParameterListener.__name__ = true;
uifive.signals.ParameterListener.prototype = {
	__class__: uifive.signals.ParameterListener
}
uifive.signals.Signal = function() {
	this._listeners = new Array();
	this._parameterListeners = new Array();
	this._connections = new Array();
};
uifive.signals.Signal.__name__ = true;
uifive.signals.Signal.prototype = {
	dispatch: function(e) {
		var _g = 0, _g1 = this._listeners;
		while(_g < _g1.length) {
			var listener = _g1[_g];
			++_g;
			listener(e);
		}
		var _g = 0, _g1 = this._connections;
		while(_g < _g1.length) {
			var connection = _g1[_g];
			++_g;
			connection.dispatch(e);
		}
		var _g = 0, _g1 = this._parameterListeners;
		while(_g < _g1.length) {
			var parameterListener = _g1[_g];
			++_g;
			parameterListener.listener(parameterListener.parameter,e);
		}
	}
	,removeAll: function() {
		this._listeners = new Array();
		this._parameterListeners = new Array();
		this._connections = new Array();
	}
	,removeConnection: function(signal) {
		var _g1 = 0, _g = this._connections.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._connections[i] == signal) {
				this._connections.splice(i,0);
				return;
			}
		}
	}
	,addConnection: function(signal) {
		this.removeConnection(signal);
		this._connections.push(signal);
	}
	,removeListener: function(listener) {
		var _g1 = 0, _g = this._listeners.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this._listeners[i],listener)) {
				this._listeners.splice(i,1);
				return;
			}
		}
		var _g1 = 0, _g = this._parameterListeners.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this._parameterListeners[i].listener,listener)) {
				this._parameterListeners.splice(i,1);
				return;
			}
		}
	}
	,addListenerWithParameter: function(listener,parameter) {
		if(!Reflect.isFunction(listener)) throw "Listener must be a function";
		this.removeListener(listener);
		this._parameterListeners.push(new uifive.signals.ParameterListener(listener,parameter));
	}
	,addListener: function(listener) {
		if(!Reflect.isFunction(listener)) throw "Listener must be a function";
		this.removeListener(listener);
		this._listeners.push(listener);
	}
	,__class__: uifive.signals.Signal
}
if(!uifive.utils) uifive.utils = {}
uifive.utils.ArrayTools = function() { }
uifive.utils.ArrayTools.__name__ = true;
uifive.utils.ArrayTools.contains = function(arr,val) {
	if(arr == null) return false;
	var _g = 0;
	while(_g < arr.length) {
		var v = arr[_g];
		++_g;
		if(v == val) return true;
	}
	return false;
}
uifive.utils.ArrayTools.indexOf = function(arr,val) {
	if(arr == null) return -1;
	var pos = 0;
	var _g = 0;
	while(_g < arr.length) {
		var v = arr[_g];
		++_g;
		if(v == val) return pos;
		pos++;
	}
	return -1;
}
uifive.utils.CallLaterData = function() {
};
uifive.utils.CallLaterData.__name__ = true;
uifive.utils.CallLaterData.prototype = {
	__class__: uifive.utils.CallLaterData
}
uifive.utils.Timer = function(delay) {
	this.onTimer = new uifive.signals.Signal();
	this._delay = delay;
};
uifive.utils.Timer.__name__ = true;
uifive.utils.Timer.callLater = function(f) {
	var t = new uifive.utils.Timer(0);
	var data = new uifive.utils.CallLaterData();
	data.timer = t;
	data.cb = f;
	t.onTimer.addListenerWithParameter(uifive.utils.Timer.onCallLaterTimer,data);
	t.start();
}
uifive.utils.Timer.onCallLaterTimer = function(data) {
	console.log("call later timer..");
	data.timer.stop();
	data.timer.onTimer.removeListener(uifive.utils.Timer.onCallLaterTimer);
	data.cb();
}
uifive.utils.Timer.prototype = {
	stop: function() {
		if(this._intervalId >= 0) window.clearInterval(this._intervalId);
		this._intervalId = -1;
	}
	,onInterval: function() {
		this.onTimer.dispatch();
	}
	,start: function() {
		this.stop();
		this._intervalId = window.setInterval($bind(this,this.onInterval),this._delay);
	}
	,__class__: uifive.utils.Timer
}
if(!uifive.widgets) uifive.widgets = {}
uifive.widgets.CanvasWidget = function() {
	this._node = js.Lib.document.createElement("canvas");
	this._canvasNode = this._node;
	this._canvasNode.width = js.Lib.window.innerWidth;
	this._canvasNode.height = js.Lib.window.innerHeight;
	if(this._canvasNode == null) throw "Canvas not available";
	this._context = this._canvasNode.getContext("2d");
	if(this._context == null) throw "Unable to get canvas context";
	uifive.base.Widget.call(this);
};
uifive.widgets.CanvasWidget.__name__ = true;
uifive.widgets.CanvasWidget.__super__ = uifive.base.Widget;
uifive.widgets.CanvasWidget.prototype = $extend(uifive.base.Widget.prototype,{
	getCanvas: function() {
		return this._canvasNode;
	}
	,afterSetContainer: function() {
		console.log("*** after set container, w=" + this._canvasNode.offsetWidth);
	}
	,setContainer: function(w) {
		uifive.base.Widget.prototype.setContainer.call(this,w);
		console.log("set container... calling later...");
		uifive.utils.Timer.callLater($bind(this,this.afterSetContainer));
		return w;
	}
	,getContext: function() {
		return this._context;
	}
	,__class__: uifive.widgets.CanvasWidget
	,__properties__: $extend(uifive.base.Widget.prototype.__properties__,{get_context:"getContext",get_canvas:"getCanvas"})
});
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var Void = { __ename__ : ["Void"]};
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
test.widgets.CanvasWidgetTest.main();

//@ sourceMappingURL=basetest.js.map