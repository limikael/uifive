var $hxClasses = $hxClasses || {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var HxOverrides = $hxClasses["HxOverrides"] = function() { }
HxOverrides.__name__ = ["HxOverrides"];
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
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIter
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
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
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
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
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = $hxClasses["Type"] = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
var uifive = uifive || {}
if(!uifive.base) uifive.base = {}
uifive.base.IWidget = $hxClasses["uifive.base.IWidget"] = function() { }
uifive.base.IWidget.__name__ = ["uifive","base","IWidget"];
uifive.base.IWidget.prototype = {
	bottom: null
	,right: null
	,top: null
	,left: null
	,height: null
	,width: null
	,container: null
	,node: null
	,__class__: uifive.base.IWidget
	,__properties__: {get_node:"getNode",set_container:"setContainer",set_width:"setWidth",get_width:"getWidth",set_height:"setHeight",get_height:"getHeight",set_left:"setLeft",get_left:"getLeft",set_top:"setTop",get_top:"getTop",set_right:"setRight",set_bottom:"setBottom"}
}
uifive.base.Widget = $hxClasses["uifive.base.Widget"] = function() {
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
uifive.base.Widget.__name__ = ["uifive","base","Widget"];
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
	,setContainer: function(w) {
		this._container = w;
		this.updateStyle();
		return this._container;
	}
	,getTop: function() {
		if(this._container == null) return 0;
		if(this._top != null) return this._top;
		if(this._bottom != null && this._height != null) return this._container.getHeight() - this._bottom - this._height;
		return 0;
	}
	,getLeft: function() {
		if(this._container == null) return 0;
		if(this._left != null) return this._left;
		if(this._right != null && this._width != null) return this._container.getWidth() - this._right - this._width;
		return 0;
	}
	,getHeight: function() {
		if(this._container == null) return 0;
		if(this._top != null && this._bottom != null) return this._container.getHeight() - this._top - this._bottom;
		if(this._height != null) return this._height;
		return this._container.getHeight() - this._top - this._bottom;
	}
	,getWidth: function() {
		if(this._container == null) return 0;
		if(this._left != null && this._right != null) return this._container.getWidth() - this._left - this._right;
		if(this._width != null) return this._width;
		return this._container.getWidth() - this._left - this._right;
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
	,_height: null
	,_width: null
	,_bottom: null
	,_top: null
	,_right: null
	,_left: null
	,_container: null
	,_node: null
	,node: null
	,container: null
	,bottom: null
	,right: null
	,top: null
	,left: null
	,height: null
	,width: null
	,__class__: uifive.base.Widget
	,__properties__: {set_width:"setWidth",get_width:"getWidth",set_height:"setHeight",get_height:"getHeight",set_left:"setLeft",get_left:"getLeft",set_top:"setTop",get_top:"getTop",set_right:"setRight",set_bottom:"setBottom",set_container:"setContainer",get_node:"getNode"}
}
uifive.base.WidgetContainer = $hxClasses["uifive.base.WidgetContainer"] = function() {
	uifive.base.Widget.call(this);
	this._widgets = [];
	this._layout = null;
	this.getNode().onresize = function(e) {
		console.log("resize...");
	};
};
uifive.base.WidgetContainer.__name__ = ["uifive","base","WidgetContainer"];
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
	,_layout: null
	,_widgets: null
	,widgets: null
	,layout: null
	,__class__: uifive.base.WidgetContainer
	,__properties__: $extend(uifive.base.Widget.prototype.__properties__,{set_layout:"setLayout",get_layout:"getLayout",get_widgets:"getWidgets"})
});
uifive.base.DataContainer = $hxClasses["uifive.base.DataContainer"] = function() {
	uifive.base.WidgetContainer.call(this);
};
uifive.base.DataContainer.__name__ = ["uifive","base","DataContainer"];
uifive.base.DataContainer.__super__ = uifive.base.WidgetContainer;
uifive.base.DataContainer.prototype = $extend(uifive.base.WidgetContainer.prototype,{
	updateAll: function() {
		var _g = 0, _g1 = this.getWidgets();
		while(_g < _g1.length) {
			var w = _g1[_g];
			++_g;
			this.removeWidget(w);
		}
		if(this._itemRendererClass != null) {
			var $it0 = this._dataProvider.iterator();
			while( $it0.hasNext() ) {
				var data = $it0.next();
				var renderer = Type.createInstance(this._itemRendererClass,[]);
				renderer.setData(data);
				this.addWidget(renderer);
			}
		}
	}
	,onDataProviderRemove: function() {
		this.updateAll();
	}
	,onDataProviderAdd: function() {
		this.updateAll();
	}
	,setItemRenderer: function(value) {
		this._itemRendererClass = value;
		this.updateAll();
		return this._itemRendererClass;
	}
	,setDataProvider: function(value) {
		if(this._dataProvider != null) {
			this._dataProvider.onAdd.removeListener($bind(this,this.onDataProviderAdd));
			this._dataProvider.onRemove.removeListener($bind(this,this.onDataProviderRemove));
		}
		this._dataProvider = value;
		if(this._dataProvider != null) {
			this._dataProvider.onAdd.addListener($bind(this,this.onDataProviderAdd));
			this._dataProvider.onRemove.addListener($bind(this,this.onDataProviderRemove));
		}
		this.updateAll();
		return this._dataProvider;
	}
	,_itemRendererClass: null
	,_dataProvider: null
	,itemRenderer: null
	,dataProvider: null
	,__class__: uifive.base.DataContainer
	,__properties__: $extend(uifive.base.WidgetContainer.prototype.__properties__,{set_dataProvider:"setDataProvider",set_itemRenderer:"setItemRenderer"})
});
uifive.base.IItemRenderer = $hxClasses["uifive.base.IItemRenderer"] = function() { }
uifive.base.IItemRenderer.__name__ = ["uifive","base","IItemRenderer"];
uifive.base.IItemRenderer.__interfaces__ = [uifive.base.IWidget];
uifive.base.IItemRenderer.prototype = {
	setData: null
	,__class__: uifive.base.IItemRenderer
}
uifive.base.RootContainer = $hxClasses["uifive.base.RootContainer"] = function() {
	uifive.base.WidgetContainer.call(this);
	this.setLeft(0);
	this.setRight(0);
	this.setTop(0);
	this.setBottom(0);
	this.updateStyle();
};
uifive.base.RootContainer.__name__ = ["uifive","base","RootContainer"];
uifive.base.RootContainer.__super__ = uifive.base.WidgetContainer;
uifive.base.RootContainer.prototype = $extend(uifive.base.WidgetContainer.prototype,{
	attach: function(domId) {
		var parent = js.Lib.document.getElementById(domId);
		parent.appendChild(this.getNode());
	}
	,__class__: uifive.base.RootContainer
});
if(!uifive.collections) uifive.collections = {}
uifive.collections.ICollection = $hxClasses["uifive.collections.ICollection"] = function() { }
uifive.collections.ICollection.__name__ = ["uifive","collections","ICollection"];
uifive.collections.ICollection.prototype = {
	iterator: null
	,getLength: null
	,getItemAt: null
	,removeItemAt: null
	,addItem: null
	,onRemove: null
	,onAdd: null
	,__class__: uifive.collections.ICollection
}
uifive.collections.Collection = $hxClasses["uifive.collections.Collection"] = function() {
	this.onAdd = new uifive.signals.Signal();
	this.onRemove = new uifive.signals.Signal();
	this._items = new Array();
};
uifive.collections.Collection.__name__ = ["uifive","collections","Collection"];
uifive.collections.Collection.__interfaces__ = [uifive.collections.ICollection];
uifive.collections.Collection.prototype = {
	iterator: function() {
		return HxOverrides.iter(this._items);
	}
	,getLength: function() {
		return this._items.length;
	}
	,getItemAt: function(index) {
		return this._items[index];
	}
	,removeItemAt: function(index) {
		var o = this.getItemAt(index);
		this._items.splice(index,1);
		this.onRemove.dispatch();
	}
	,addItem: function(item) {
		this._items.push(item);
		this.onAdd.dispatch();
	}
	,_items: null
	,onRemove: null
	,onAdd: null
	,__class__: uifive.collections.Collection
}
if(!uifive.layout) uifive.layout = {}
uifive.layout.Layout = $hxClasses["uifive.layout.Layout"] = function() {
	this._target = null;
};
uifive.layout.Layout.__name__ = ["uifive","layout","Layout"];
uifive.layout.Layout.prototype = {
	updateLayout: function() {
	}
	,setTarget: function(value) {
		this._target = value;
		this.updateLayout();
		return this._target;
	}
	,_target: null
	,target: null
	,__class__: uifive.layout.Layout
	,__properties__: {set_target:"setTarget"}
}
uifive.layout.VerticalLayout = $hxClasses["uifive.layout.VerticalLayout"] = function() {
	uifive.layout.Layout.call(this);
};
uifive.layout.VerticalLayout.__name__ = ["uifive","layout","VerticalLayout"];
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
	}
	,__class__: uifive.layout.VerticalLayout
});
if(!uifive.signals) uifive.signals = {}
uifive.signals.Signal = $hxClasses["uifive.signals.Signal"] = function() {
	this._listeners = new Array();
};
uifive.signals.Signal.__name__ = ["uifive","signals","Signal"];
uifive.signals.Signal.prototype = {
	dispatch: function() {
		var _g = 0, _g1 = this._listeners;
		while(_g < _g1.length) {
			var listener = _g1[_g];
			++_g;
			listener();
		}
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
	}
	,addListener: function(listener) {
		this.removeListener(listener);
		this._listeners.push(listener);
	}
	,_listeners: null
	,__class__: uifive.signals.Signal
}
if(!uifive.utils) uifive.utils = {}
uifive.utils.ArrayTools = $hxClasses["uifive.utils.ArrayTools"] = function() { }
uifive.utils.ArrayTools.__name__ = ["uifive","utils","ArrayTools"];
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
uifive.widgets.Button = $hxClasses["uifive.widgets.Button"] = function(text) {
	var _g = this;
	this._node = js.Lib.document.createElement("button");
	uifive.base.Widget.call(this);
	this.setText(text);
	this.onClick = new uifive.signals.Signal();
	this._node.onclick = function(e) {
		_g.onClick.dispatch();
	};
};
uifive.widgets.Button.__name__ = ["uifive","widgets","Button"];
uifive.widgets.Button.__super__ = uifive.base.Widget;
uifive.widgets.Button.prototype = $extend(uifive.base.Widget.prototype,{
	setText: function(text) {
		this._text = text;
		if(this._text == null) this._text = "";
		this._node.innerHTML = this._text;
	}
	,_text: null
	,onClick: null
	,__class__: uifive.widgets.Button
});
uifive.widgets.Label = $hxClasses["uifive.widgets.Label"] = function(text) {
	uifive.base.Widget.call(this);
	this.setText(text);
};
uifive.widgets.Label.__name__ = ["uifive","widgets","Label"];
uifive.widgets.Label.__super__ = uifive.base.Widget;
uifive.widgets.Label.prototype = $extend(uifive.base.Widget.prototype,{
	setText: function(text) {
		this._text = text;
		if(this._text == null) this._text = "";
		this._node.innerHTML = this._text;
		return this._text;
	}
	,getText: function() {
		return this._text;
	}
	,_text: null
	,text: null
	,__class__: uifive.widgets.Label
	,__properties__: $extend(uifive.base.Widget.prototype.__properties__,{set_text:"setText",get_text:"getText"})
});
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
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
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.document = null;
js.Lib.window = null;
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
var test = test || {}
if(!test.base) test.base = {}
test.base.MyData = $hxClasses["test.base.MyData"] = function(v) {
	this.value = v;
};
test.base.MyData.__name__ = ["test","base","MyData"];
test.base.MyData.prototype = {
	value: null
	,__class__: test.base.MyData
}
test.base.MyDataRenderer = $hxClasses["test.base.MyDataRenderer"] = function() {
	uifive.base.WidgetContainer.call(this);
	this.l = new uifive.widgets.Label();
	this.addWidget(this.l);
	this.setHeight(30);
};
test.base.MyDataRenderer.__name__ = ["test","base","MyDataRenderer"];
test.base.MyDataRenderer.__interfaces__ = [uifive.base.IItemRenderer];
test.base.MyDataRenderer.__super__ = uifive.base.WidgetContainer;
test.base.MyDataRenderer.prototype = $extend(uifive.base.WidgetContainer.prototype,{
	setData: function(myData) {
		this.l.setText(myData.value);
	}
	,l: null
	,__class__: test.base.MyDataRenderer
});
test.base.BaseTest = $hxClasses["test.base.BaseTest"] = function() {
	uifive.base.RootContainer.call(this);
	var c = this.setupBasic();
	c.setLeft(0);
	c.setTop(0);
	this.addWidget(c);
	var c1 = this.setupMany();
	c1.setRight(0);
	c1.setBottom(0);
	this.addWidget(c1);
	var c2 = this.setupLayout();
	c2.setLeft(50);
	c2.setTop(400);
	this.addWidget(c2);
	var c3 = this.setupData();
	c3.setLeft(350);
	c3.setTop(50);
	this.addWidget(c3);
};
test.base.BaseTest.__name__ = ["test","base","BaseTest"];
test.base.BaseTest.onButtonClick = function() {
	console.log("button click..");
}
test.base.BaseTest.main = function() {
	new test.base.BaseTest().attach("testcontainer");
}
test.base.BaseTest.__super__ = uifive.base.RootContainer;
test.base.BaseTest.prototype = $extend(uifive.base.RootContainer.prototype,{
	setupMany: function() {
		var container = new uifive.base.WidgetContainer();
		container.setWidth(300);
		container.setHeight(500);
		var _g = 0;
		while(_g < 10) {
			var i = _g++;
			var l2 = new uifive.widgets.Label("Hello World again " + i);
			l2.setRight(10);
			l2.setBottom(i * 30);
			l2.setWidth(250);
			container.addWidget(l2);
		}
		return container;
	}
	,setupBasic: function() {
		var container = new uifive.base.WidgetContainer();
		container.setWidth(500);
		container.setHeight(500);
		var w = new uifive.base.WidgetContainer();
		w.setLeft(50);
		w.setTop(50);
		w.setWidth(250);
		w.setHeight(250);
		w.getNode().style.background = "#00ff00";
		container.addWidget(w);
		var l = new uifive.widgets.Label("Hello World");
		l.setWidth(200);
		l.setLeft(10);
		w.addWidget(l);
		var b = new uifive.widgets.Button("Click");
		b.setWidth(50);
		b.setTop(30);
		b.onClick.addListener(test.base.BaseTest.onButtonClick);
		w.addWidget(b);
		return container;
	}
	,setupData: function() {
		var c = new uifive.collections.Collection();
		c.addItem(new test.base.MyData("hello first.."));
		c.addItem(new test.base.MyData("hello again"));
		var l = new uifive.base.DataContainer();
		l.setDataProvider(c);
		l.setItemRenderer(test.base.MyDataRenderer);
		l.setLayout(new uifive.layout.VerticalLayout());
		l.setLeft(350);
		l.setWidth(200);
		l.setHeight(200);
		l.setTop(50);
		l.getNode().style.background = "#8080ff";
		c.addItem(new test.base.MyData("hello third.."));
		return l;
	}
	,setupLayout: function() {
		var w = new uifive.base.WidgetContainer();
		w.setWidth(250);
		w.setHeight(100);
		w.getNode().style.background = "#ff80ff";
		var l = new uifive.widgets.Label("Hello first");
		w.addWidget(l);
		var l1 = new uifive.widgets.Label("Hello again");
		w.addWidget(l1);
		w.setLayout(new uifive.layout.VerticalLayout());
		return w;
	}
	,__class__: test.base.BaseTest
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
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
var Void = $hxClasses.Void = { __ename__ : ["Void"]};
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
js.Lib.onerror = null;
test.base.BaseTest.main();

//@ sourceMappingURL=basetest.js.map