function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
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
	,addClass: function(className) {
		this._node.className = className;
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
});
uifive.base.RootContainer = function() {
	uifive.base.WidgetContainer.call(this);
	this.setLeft(0);
	this.setRight(0);
	this.setTop(0);
	this.setBottom(0);
	this.updateStyle();
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
if(!test.menu) test.menu = {}
test.menu.MenuTest = function() {
	uifive.base.RootContainer.call(this);
	var m = new uifive.menu.Menu();
	m.setLeft(20);
	m.setTop(20);
	this.addWidget(m);
	m.addItem(new uifive.menu.MenuItem("hello","Hello","H"));
	m.addItem(new uifive.menu.MenuItem("again","Again","A"));
};
test.menu.MenuTest.__name__ = true;
test.menu.MenuTest.main = function() {
	new test.menu.MenuTest().attach("testcontainer");
}
test.menu.MenuTest.__super__ = uifive.base.RootContainer;
test.menu.MenuTest.prototype = $extend(uifive.base.RootContainer.prototype,{
	__class__: test.menu.MenuTest
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
}
uifive.layout.VerticalLayout = function(resizeParent) {
	if(resizeParent == null) resizeParent = false;
	uifive.layout.Layout.call(this);
	this._resizeParent = resizeParent;
};
uifive.layout.VerticalLayout.__name__ = true;
uifive.layout.VerticalLayout.__super__ = uifive.layout.Layout;
uifive.layout.VerticalLayout.prototype = $extend(uifive.layout.Layout.prototype,{
	updateLayout: function() {
		var y = 0;
		var _g = 0, _g1 = this._target.getWidgets();
		while(_g < _g1.length) {
			var w = _g1[_g];
			++_g;
			w.setTop(y);
			y += w.getHeight();
		}
		if(this._resizeParent) this._target.setHeight(y);
	}
	,__class__: uifive.layout.VerticalLayout
});
if(!uifive.menu) uifive.menu = {}
uifive.menu.Menu = function() {
	uifive.base.WidgetContainer.call(this);
	this.setLayout(new uifive.layout.VerticalLayout(true));
	this.setWidth(200);
	this._node.style.borderStyle = "solid";
	this._node.style.borderWidth = "1px";
	this._node.style.borderColor = "#808080";
	var style = this._node.style;
	style.boxShadow = "0px 0px 5px 2px #c0c0c0";
};
uifive.menu.Menu.__name__ = true;
uifive.menu.Menu.__super__ = uifive.base.WidgetContainer;
uifive.menu.Menu.prototype = $extend(uifive.base.WidgetContainer.prototype,{
	addItem: function(item) {
		this.addWidget(item);
	}
	,__class__: uifive.menu.Menu
});
uifive.menu.MenuItem = function(id,label,accelerator) {
	uifive.base.WidgetContainer.call(this);
	this.setHeight(20);
	this.setWidth(200);
	this._acceleratorField = new uifive.widgets.Label(accelerator);
	this._acceleratorField.setAlign("right");
	this._acceleratorField.setLeft(10);
	this._acceleratorField.setRight(10);
	this._acceleratorField.setSelectable(false);
	this.addWidget(this._acceleratorField);
	this._labelField = new uifive.widgets.Label(label);
	this._labelField.setSelectable(false);
	this._labelField.setLeft(10);
	this._labelField.setRight(10);
	this.addWidget(this._labelField);
	this._node.onmouseover = $bind(this,this.onNodeMouseOver);
	this._node.onmouseout = $bind(this,this.onNodeMouseOut);
	this._node.onmouseup = $bind(this,this.onNodeMouseUp);
	this._node.style.backgroundColor = "#ffffff";
};
uifive.menu.MenuItem.__name__ = true;
uifive.menu.MenuItem.__super__ = uifive.base.WidgetContainer;
uifive.menu.MenuItem.prototype = $extend(uifive.base.WidgetContainer.prototype,{
	getId: function() {
		return this._id;
	}
	,onNodeMouseUp: function(e) {
		console.log("mouse up...");
	}
	,onNodeMouseOut: function(e) {
		this._node.style.backgroundColor = "#ffffff";
	}
	,onNodeMouseOver: function(e) {
		this._node.style.backgroundColor = "#e0e0ff";
	}
	,__class__: uifive.menu.MenuItem
});
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
if(!uifive.widgets) uifive.widgets = {}
uifive.widgets.Label = function(text) {
	uifive.base.Widget.call(this);
	this.setText(text);
};
uifive.widgets.Label.__name__ = true;
uifive.widgets.Label.__super__ = uifive.base.Widget;
uifive.widgets.Label.prototype = $extend(uifive.base.Widget.prototype,{
	setSelectable: function(value) {
		if(!value) {
			var n = this._node.style;
			n.WebkitTouchCallout = "none";
			n.WebkitUserSelect = "none";
			n.KhtmlUserSelect = "none";
			n.MozUserSelect = "none";
			n.MsUserSelect = "none";
			n.userSelect = "none";
			this._node.style.cursor = "default";
		}
		return value;
	}
	,setAlign: function(value) {
		this._align = value;
		this.updateStyle();
		return this._align;
	}
	,updateStyle: function() {
		uifive.base.Widget.prototype.updateStyle.call(this);
		switch(this._align) {
		case "left":
			this._node.style.textAlign = "left";
			break;
		case "center":
			this._node.style.textAlign = "center";
			break;
		case "right":
			this._node.style.textAlign = "right";
			break;
		}
	}
	,setText: function(text) {
		this._text = text;
		if(this._text == null) this._text = "";
		this._node.innerHTML = this._text;
		return this._text;
	}
	,getText: function() {
		return this._text;
	}
	,__class__: uifive.widgets.Label
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
uifive.widgets.Label.LEFT = "left";
uifive.widgets.Label.RIGHT = "right";
uifive.widgets.Label.CENTER = "center";
test.menu.MenuTest.main();

//@ sourceMappingURL=menutest.js.map