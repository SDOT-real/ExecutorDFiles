--!nocheck
--!nolint


-- Universal Executor API Definition File
-- Written by S.DOT
-- Version 1.1

-- stolen from the Wave documentation, will add more functions from other executors
-- now also stolen from the Syn V3 docs

-- types

type saveinstanceOptions = {
	Decompile: boolean?,
	DecompileTimeout: number?,
	DecompileIgnore: {string}?,
	NilInstances: boolean?,
	RemovePlayerCharacters: boolean?,
	SavePlayers: boolean?,
	MaxThreads: number?,
	ShowStatus: boolean?,
	IgnoreDefaultProps: boolean?,
	IsolateStarterPlayer: boolean?
}
type getinfoReturn = {
	name: string,
	short_src: string,
	source: string,
	what: string,
	currentline: number,
	nups: number,
	func: ()->()
}
type FilterGCOptions = {
	Keys: {any}?,
	Values: {any}?,
	KeyValuePairs: {[any]: any}?,
	Metatable: {}?,

	Name: string?,
	Constants: {constant}?,
	Upvalues: {any}?,
	IgnoreExecutor: boolean?,
	Proto: ProtoProxy?,
	Environment: {[any]: any}?,
	Hash: string?
}
type TrampolineCallStack = {
	currentline: number?,
	env: {[any]: any}?,
	source: string?,
	name: string?,
	numparams: number?,
	is_vararg: boolean?,
	func: ()->()?
}
type TrampolineThreadOptions = {
	script: (LocalScript | ModuleScript)?,
	identity: number?,
	env: {[any]: any}?,
	thread: thread?
}
type ToastNotificationOptions = {
	Type: number,
	Duration: number?,
	Title: string,
	Content: string,
	IconColor: Color3
}
type RequestParams = {
	Url: string,
	Method: "GET" | "POST" | "HEAD" | "DELETE" | "PUT",
	Headers: {},
	Cookies: {},
	Body: string?
}
type RequestResponse = {
	Success: boolean,
	StatusCode: number,
	StatusMessage: string,
	Headers: {},
	Cookies: {},
	Body: string?
}

type LuaSourceContainer = LocalScript | ModuleScript | ProtoProxy | ()->()
type metamethod = "__iter" | "__index" | "__newindex" | "__call" | "__call" | "__concat" | "__unm" | "__add" | "__sub" | "__mul" | "__div" | "__idiv" | "__mod" | "__pow" | "__tostring" | "__metatable" | "__lt" | "__le" | "__eq" | "__mode" | "__len" | "__namecall" | "__type"
type constant = string | number | boolean
-- type booleanBinary = (0 | 1) -- eh, why i cant use numbers as literal types???


-- classes

declare class ProtoProxy
	CodeHash: number
end
declare ToastType: {
	None: number,
	Success: number,
	Warning: number,
	Error: number,
	Info: number
}
declare class ConnectionInformation
	Enabled: boolean
	State: boolean
	ForeignState: boolean
	LuaConnection: boolean
	Function: ()->()
	Thread: thread
	function Fire(self, ...: any): (nil)
	function Defer(self, ...: any): (nil)
	function Disconnect(self): (nil)
	function Disable(self): (nil)
	function Enable(self): (nil)
end

declare class ExecutorConnection
	function Disconnect(self): (nil)
end
declare ExecutorSignal: {
	new: ()->(ExecutorSignal)
}
export type ExecutorSignal<T... = ...any> = {
	Connect: (self: ExecutorSignal<T...>, func: (T...)->())->(ExecutorConnection),
	Wait: (self: ExecutorSignal<T...>)->(T...),
	Fire: (self: ExecutorSignal<T...>, T...)->(nil)
}


-- filters

declare class FilterBase
	
end

declare NotFilter: {
	new: (target: FilterBase)->(NotFilter)
}
declare class NotFilter extends FilterBase
	Target: FilterBase
end

declare AnyFilter: {
	new: (filters: {FilterBase}?)->(AnyFilter)
}
declare class AnyFilter extends FilterBase
	Filters: {FilterBase}
end

declare AllFilter: {
	new: (filters: {FilterBase}?)->(AllFilter)
}
declare class AllFilter extends FilterBase
	Filters: {FilterBase}
end

declare TypeFilter: {
	new: (index: number, type: string)->(TypeFilter)
}
declare class TypeFilter extends FilterBase
	ArgumentIndex: number
	ArgumentType: string
end

declare NamecallFilter: {
	new: (method: string)->(NamecallFilter)
}
declare class NamecallFilter extends FilterBase
	NamecallMethod: string
end

declare InstanceTypeFilter: {
	new: (argumentIndex: number, instanceType: string)->(InstanceTypeFilter)
}
declare class InstanceTypeFilter extends FilterBase
	ArgumentIndex: number
	InstanceType: string
end

declare UserdataTypeFilter: {
	new: (argumentIndex: number, userdata: string)->(UserdataTypeFilter)
}
declare class UserdataTypeFilter extends FilterBase
	ArgumentIndex: number
	Userdata: any
end

declare ArgCountFilter: {
	new: (argumentCount: number)->(ArgCountFilter)
}
declare class ArgCountFilter extends FilterBase
	ArgumentCount: number
end

declare CallerFilter: {
	new: (invert: boolean?)->(CallerFilter)
}
declare class CallerFilter extends FilterBase
	Invert: boolean
end

declare function getfilter(filter: FilterBase, originalFunc: ()->(), filterFunc: ()->()): (()->())


-- console functions

declare function rconsoleprint(text: string): (nil)
declare function rconsolewarn(text: string): (nil)
declare function rconsoleinfo(text: string): (nil)
declare function rconsoleerr(text: string): (nil)
declare function rconsoleclear(): (nil)
declare function rconsolename(title: string): (nil)
declare function rconsoleinput(): (string)
declare function rconsoleclose(): (nil)


-- environment functions

declare function getgenv(): ({[any]: any})
declare function getrenv(): ({[any]: any})
declare function getsenv(script: LocalScript | ModuleScript): ({[any]: any})
declare function gettenv(thread: thread): ({[any]: any})
declare function getreg(): ({(number | thread | {} | ()->())})
declare function getgc(includeTables: boolean?): ({()->() | {} | Object})
declare function filtergc(type: ()->() | Object | {}, options: FilterGCOptions, returnOne: boolean?): ({} | any | nil)

declare function getinstances(): ({Instance})
declare function getnilinstances(): ({Instance})
declare function getscripts(): ({LocalScript | ModuleScript})
declare function getloadedmodules(): ({ModuleScript})
declare function fireclickdetector(clickDetector: ClickDetector): (nil)
declare function fireproximityprompt(proximityPrompt: ProximityPrompt): (nil)
declare function firetouchinterest(toTouch: BasePart, toucher: BasePart, touching: number?): (nil)
declare function setscriptable(object: Object, property: string, isScriptable: boolean): (boolean)
declare function gethiddenproperty(object: Object, property: string): (any)
declare function sethiddenproperty(object: Object, property: string, value: any): (nil)


-- file functions

declare function readfile(path: string): (string)
declare function readfileasync(path: string): (string)
declare function writefile(path: string, content: string)
declare function writefileasync(path: string, content: string)
declare function appendfile(path: string, content: string)
declare function appendfileasync(path: string, content: string)
declare function loadfile(path: string): (()->())
declare function loadfileasync(path: string): (()->())
declare function listfiles(fold: string): {string}
declare function isfile(path: string): (boolean)
declare function isfolder(path: string): (boolean)
declare function makefolder(path: string): (nil)
declare function delfolder(path: string): (nil)
declare function delfile(path: string): (nil)
declare function getcustomasset(path: string): (string)


-- hooking functions

declare setstackhidden: ((closure: ()->(), isHidden: boolean?)->(nil)) & ((index: number, isHidden: boolean?)->(nil))

declare function clonefunction(toClone: ()->()): (()->())
declare function isfunctionhooked(func: ()->()): (boolean)
declare function issignalhooked(signal: RBXScriptSignal): (boolean)

declare function restorefunction(toRestore: ()->()): (nil)
declare restoreclosure: typeof(restorefunction)
declare function restoreproto(toRestore: ProtoProxy): (nil)
declare function restoresignal(signal: RBXScriptSignal): (nil)

declare function hookfunction(toHook: ()->(), hook: ()->(), filter: FilterBase?): (()->())
declare function hookproto(toHook: ProtoProxy, hook: ()->()): (nil)
declare function hooksignal(signal: RBXScriptSignal, callback: ()->()): (nil)
declare function hookmetamethod(object: Object | {}, metamethod: metamethod, hook: ()->(), argGuard: boolean?, filter: FilterBase?): (()->())

declare function newcclosure<Func>(func: Func & ()->(), name: string?): (Func & ()->())


-- oth library

declare oth: {
	hook: (target: ()->(), hook: ()->())->(()->()),
	unhook: (target: ()->(), hookOrCallback: ()->())->(boolean),
	getRootCallback: (target: ()->(), hookOrCallback: ()->())->(()->()),
	isHookThread: ()->(boolean),
	getOriginalThread: ()->(thread)
}


-- input functions

declare function iswindowactive(): (boolean)
declare function keypress(keycode: number): (nil)
declare function keyrelease(keycode: number): (nil)
declare function keyclick(keycode: number): (nil)
declare function mouse1click(): (nil)
declare mouse1press: (()->(nil)) & ((x: number, y: number)->(nil))
declare mouse1release: (()->(nil)) & ((x: number, y: number)->(nil))
declare function mouse2click(): (nil)
declare mouse2press: (()->(nil)) & ((x: number, y: number)->(nil))
declare mouse2release: (()->(nil)) & ((x: number, y: number)->(nil))
declare mousescroll: ((pixels: number)->(nil)) & ((pixels: number, x: number, y: number)->(nil))
declare function mousemoverel(x: number, y: number, internal: boolean?): (nil)
declare function mousemoveabs(x: number, y: number, internal: boolean?): (nil)
declare function iskeydown(keycode: number): (boolean)
declare function iskeytoggled(keycode: number): (boolean)


-- misc functions

declare function unlockmodulescript(module: ModuleScript): (nil)
declare function setclipboard(content: string): (nil)
declare function setfflag(fflag: string, value: any): (nil)
declare function gethui(): (BasePlayerGui)
declare function toast_notification(options: ToastNotificationOptions): (nil)
declare function isnetworkowner(part: BasePart): (boolean)
	
declare function getnamecallmethod(): (string)
declare function setnamecallmethod(): (nil)
declare function trampoline_call(target: ()->(), call_stack: TrampolineCallStack, thread_options: TrampolineThreadOptions, ...: any): (boolean, ...any)

declare function identifyexecutor(): (string, string)
declare function getthreadidentity(): (number)
declare function setthreadidentity(identity: number): (number)
declare function setfpscap(cap: number): (nil)

declare function saveinstance(object: Instance, filePath: string, options: saveinstanceOptions): (boolean)
declare function saveplace(options: saveinstanceOptions): (boolean)

declare function messagebox(text: string, title: string, flag: number): (number)
declare function setwindowtitle(title: string): (nil)
declare function setwindowicon(data: string): (nil)

declare function queue_on_teleport(code: string): (nil)
declare function clear_teleport_queue(): (nil)



-- reflection functions

declare function getproperties(object: Object): ({[string]: any})
declare function gethiddenproperties(object: Object): ({[string]: any}) 
	
declare function getcallbackvalue(object: Object, property: string): (()->())
declare getcallbackmember: typeof(getcallbackvalue)
declare function getrendersteppedlist(detailed: boolean?): ({[string]: ()->()} | {Function: ()->(), Name: string, Priority: number})

declare function getpcd(object: TriangleMeshPart): (string, string)
declare function newtable(narray: number, nhash: number): ({})
declare function geteventmember(object: Object, eventName: string): (RBXScriptSignal)


-- script functions

declare function checkcallstack(index: number): (boolean)
declare function checkcaller(): (boolean)

declare function isexecutorclosure(closure: ()->()): (boolean)
declare function isexecutorthread(thread: thread): (boolean)
declare function islclosure(closure: ()->()): (boolean)
declare function getcallingscript(): ((LocalScript | ModuleScript)?)

declare function getscriptthread(script: LocalScript | ModuleScript): (thread)
declare function getscriptclosure(script: LocalScript | ModuleScript): (()->())
declare function getscripthash(script: LocalScript | ModuleScript): (string)
declare function getscriptbytecode(script: LuaSourceContainer): (string)
declare function getscriptname(script: LocalScript | ModuleScript): (string)

declare function decompile(target: LuaSourceContainer): (string)


-- table functions 

declare function getrawmetatable(getFrom: {} | Object): ({})
declare function setrawmetatable(target: {} | Object, metatable: {}): (nil)
declare function setreadonly(table: {}, isReadonly: boolean): (nil)
declare function isreadonly(table: {}): (boolean)


-- signal functions

declare function disableconnection(connection: RBXScriptConnection): (nil)
declare function enableconnection(connection: RBXScriptConnection): (nil)
declare function isconnectionenabled(connection: RBXScriptConnection): (boolean)
declare function setconnectionenabled(connection: RBXScriptConnection, isEnabled: boolean): (nil)
declare function isluaconnection(connection: RBXScriptConnection): (boolean)
declare function iswaitingconnection(connection: RBXScriptConnection): (boolean)
declare function getconnectionfunction(connection: RBXScriptConnection, returnRaw: boolean?): (()->())
declare function getconnectionthread(connection: RBXScriptConnection, returnRaw: boolean?): (thread)
declare function isgamescriptconnection(connection: RBXScriptConnection): (boolean)

declare function firesignal(signal: RBXScriptSignal, ...: any): (nil)
declare function cfiresignal(signal: RBXScriptSignal, ...: any): (nil)
declare function replicatesignal(signal: RBXScriptSignal, ...: any): (nil)
declare function cansignalreplicate(signal: RBXScriptSignal): (boolean)
declare function getsignalarguments(signal: RBXScriptSignal): ({string})

declare function getconnections(signal: RBXScriptSignal): ({ConnectionInformation})


-- math functions

declare function getboundingbox(parts: {BasePart}, orientation: CFrame?): (CFrame, Vector3)
declare function worldtoscreen<T>(points: {[T]: Vector3 | BasePart}, offset: Vector3?): ({[T]: Vector2})


-- cache library

declare cache: {
	replace: (target: Instance, replacement: Instance)->(nil),
	invalidate: (target: Instance)->(nil),
	iscached: (target: Instance)->(boolean)
}
declare function cloneref(toClone: Object): (Object)
declare function compareinstances(compareTo: Object, compare: Object): (boolean)


-- crypt library

declare base64: {
	encode: (data: string)->(string),
	decode: (data: string)->(string)
}

declare crypt: {
	encrypt: (data: string, key: string)->(string),
	decrypt: (data: string, key: string)->(string),
	hash: (data: string)->(string),
	derive: (value: string, length: number)->(string),
	random: (size: number)->(string),
	base64: typeof(base64)
}


-- bit library

declare bit: {
	badd: (...number)->(number),
	bsub: (...number)->(number),
	bmul: (...number)->(number),
	bdiv: (...number)->(number),
	band: (...number)->(number),
	bor: (...number)->(number),
	bxor: (...number)->(number),
	bnot: (...number)->(number),
	lshift: (value: number, n: number)->(number),
	rshift: (value: number, n: number)->(number),
	arshift: (value: number, n: number)->(number),
	rol: (value: number, n: number)->(number),
	ror: (value: number, n: number)->(number),
	bpopcount: (value: number)->(number),
	bswap: (value: number)->(number),
	tohex: (value: number, nibbles: number?)->(number),
	tobit: (value: number)->(number)
}


-- debug library

declare debug: typeof(debug) & {
	getconstants: (target: ()->() | number | ProtoProxy)->({constant}),
	getconstant: (target: ()->() | number | ProtoProxy, index: number)->(constant),
	setconstant: (target: ()->() | number | ProtoProxy, index: number, value: constant)->(nil),
	getupvalues: (target: ()->() | number)->({any}),
	getupvalue: (target: ()->() | number, index: number)->(any),
	setupvalue: (target: ()->() | number, index: number, value: any)->(),
	getprotos: (target: ()->() | number | ProtoProxy)->({ProtoProxy}),
	getproto: (target: ()->() | number | ProtoProxy, index: number, getFromGc: boolean?)->(ProtoProxy | {()->()}),
	setproto: (closure: ()->() | number | ProtoProxy, index: number, replacement: ()->())->(nil),
	getstack: (index: number)->({any}),
	setstack: (level: number, index: number, value: any)->(nil),
	getmetatable: typeof(getrawmetatable),
	setmetatable: typeof(setrawmetatable),
	getregistry: typeof(getreg),
	getinfo: (closure: ()->())->(getinfoReturn),
	validlevel: (level: number, thread: thread?)->(boolean),
	getcallstack: (thread: thread?)->({()->()})
}


-- drawing library

declare ExecutorFonts: {
	Monospace: number,
	UI: number,
	System: number,
	Plex: number
}

declare class DrawEntry
	function Destroy(self): ()
	Visible: boolean
	ZIndex: number
	Transparency: number
	Color: Color3
end

declare class Line extends DrawEntry
	Thickness: number
	PointA: Vector2
	PointB: Vector2
	From: Vector2
	To: Vector2
end
declare class Text extends DrawEntry
	Text: string
	Size: number
	Position: Vector2
	Font: number
	Centered: boolean
	Outlined: boolean
	OutlineColor: Color3
end
declare class Image extends DrawEntry
	Data: Text
	Size: Vector2
	Position: Vector2
	Rounding: number
	Centered: boolean
	Outlined: boolean
	OutlineColor: Color3
end
declare class Circle extends DrawEntry
	Position: Vector2
	Thickness: number
	NumSides: number
	Radius: number
	Filled: boolean
end
declare class Square extends DrawEntry
	Data: Text
	Size: Vector2
	Position: Vector2
	Thickness: number
	Filled: boolean
end
declare class Triangle extends DrawEntry
	Data: Text
	Position: Vector2
	Thickness: number
	PointA: Vector2
	PointB: Vector2
	PointC: Vector2
	Filled: boolean
end
declare class Quad extends DrawEntry
	Data: Text
	Position: Vector2
	Thickness: number
	PointA: Vector2
	PointB: Vector2
	PointC: Vector2
	PointD: Vector2
	Point1: Vector2
	Point2: Vector2
	Point3: Vector2
	Point4: Vector2
	Filled: boolean
end

declare Drawing: {
	new: (type: "Circle" | "Square" | "Line" | "Text" | "Image" | "Quad" | "Triangle")->(DrawEntry),
	Fonts: typeof(ExecutorFonts)
}

declare function cleardrawcache(): (nil)
declare function getrenderproperty(object: DrawEntry, property: string): (any)
declare function setrenderproperty(object: DrawEntry, property: string, value: any): (nil)
declare function isrenderobj(object: any): (boolean)


-- web library

declare class Socket
	function Send(self, content: string): (nil)
	function Close(self): (nil)
	OnMessage: ExecutorSignal<string>
	OnClose: ExecutorSignal
end

declare websocket: {
	connect: (url: string)->(Socket)
}

declare function request(params: RequestParams): (RequestResponse)


-- parallel library

declare LuaStateProxy: {
	new: ()->(LuaStateProxy)
}
declare class LuaStateProxy
	Id: number
	IsActorState: boolean
	function GetActors(self): ({Actor})
	function Execute(self, code: string, ...: any)
	Event: ExecutorSignal
end

declare function getactors(): ({Actor})
declare function getactorstates(): ({LuaStateProxy})
declare getactorthreads: typeof(getactorstates)
declare function getluastate(target: LocalScript | ModuleScript | Actor): (LuaStateProxy)
declare function getgamestate(): (LuaStateProxy)

declare function run_on_actor(actor: Actor, code: string, ...: any): (boolean)
declare function run_on_state(actorState: LuaStateProxy, code: string, ...: any): (boolean)
declare run_on_thread: typeof(run_on_state)
declare function is_parallel(): (boolean)
declare checkparallel: typeof(is_parallel)

declare function create_comm_channel(): (string, ExecutorSignal)
declare function get_comm_channel(channelId: string): (ExecutorSignal)


-- directory watcher

declare DirectoryWatcher: {
	new: (path: string, recursive: boolean?)->(DirectoryWatcher)
}
declare class DirectoryWatcher
	function start(self): ()
	function stop(self): ()
	function GetPath(self): ()
	function IsRecursive(self): ()
	Path: string
	function OnChanged(self, callback: ()->()): (nil)
	function OnCreated(self, callback: ()->()): (nil)
	function OnDeleted(self, callback: ()->()): (nil)
	function OnRenamed(self, callback: ()->()): (nil)
	function OnOverflow(self, callback: ()->()): (nil)
end