local executor, executor_version = "Sucks", "0.001"
local env

--

local metaInstances = {}
local function table_find(t,v)
	return (table.find(t,v) or t[v]) ~= nil
end
local function convertToMetaInstance(object,options)
	if object == game:GetService("TweenService") then return object end
	
	local options = options or {}
	local customMethods = options.CustomMethods or {}
	local blockMethods = options.BlockMethods or {}
	local metaInstance

	local dest = {customMethods.destroy, customMethods.Destroy}
	customMethods.destroy = function()
		for _,v in pairs(dest) do
			if v then
				v()
			end
		end
		if not object then
			local c = {}
			for i,v in pairs(metaInstances) do
				if i == metaInstance or not v then continue end
				c[i] = v
			end
			metaInstances = c
			c = nil
		else
			object:Destroy()
		end
	end
	customMethods.Destroy = customMethods.destroy

	metaInstance = setmetatable({},
	{
		__index = function(self, index)
			local found = table_find(customMethods, index)
			if found then
				return customMethods[index]
			else
				return object[index]
			end
		end,
		__newindex = function(self, index, value)
			if blockMethods[index] == true then
				error("Failed to set "..tostring(index).." to "..tostring(value))
			elseif typeof(blockMethods[index]) == "function" then
				return blockMethods[index](value)
			end
			object[index] = value
		end,
		__tostring = function()
			return tostring(object)
		end,
		__metatable = "Metatable is locked!"
	}
	)

	metaInstances[metaInstance] = object

	return metaInstance
	--return object
end

local function identifyexecutor()
	return executor, executor_version
end
local err = function(...)
	local args = table.pack(...)
	local genStr = ""
	for i,v in pairs(args) do
		if i == #args then return end
		genStr = genStr..tostring(v)..(i == #args and "" or " ")
	end
	return error(genStr)
end
local function getFunc(name)
	return getfenv()[name]
end
local function rs(times)
	for i=1, tonumber(times) or 1 do
		game["Run Service"].RenderStepped:Wait()
	end
end
local function gethui()
	local plr = game.Players.LocalPlayer
	local pgui = plr:WaitForChild("PlayerGui")
	local function getGui()
		for i,v in pairs(pgui:GetChildren()) do
			if v and v:IsA("ScreenGui") and not v.ResetOnSpawn then
				return v
			end
		end
	end
	local gui = getGui()
	if not gui then
		gui = pgui:WaitForChild(identifyexecutor().."LoadingGui",2) or plr.PlayerGui
	end
	coroutine.wrap(function()
		repeat rs(1) until _G._hidden_ui
		if _G._hidden_ui.Parent == plr.PlayerGui then
			while _G._hidden_ui.Parent == plr.PlayerGui do
				local gui = getGui()
				if gui then
					_G._hidden_ui.Parent = plr.PlayerGui
				end
				rs(1)
			end
		end
	end)()
	local fhui = _G._hidden_ui or gui:FindFirstChild("hui")
	local hui
	if not fhui then
		fhui = Instance.new("ScreenGui",gui)
		fhui.Enabled = false
		fhui.DisplayOrder = 999999999
		fhui.ResetOnSpawn = false
		fhui.Name = "hui"
		hui = Instance.new("Folder",fhui)
		hui.ChildAdded:Connect(function(c)
			if c and c:IsA("ScreenGui") then
				while c do
					c.DisplayOrder = 999999999
					c.ResetOnSpawn = false
					rs(1)
				end
			end
		end)
		_G._hidden_ui = hui
	else
		hui = typeof(_G._hidden_ui) == "Instance" and _G._hidden_ui:IsA("Folder") and _G._hidden_ui or typeof(_G._hidden_ui) == "Instance" and not _G._hidden_ui:IsA("Folder") and _G._hidden_ui:FindFirstChildOfClass("Folder")
	end
	return hui
end
local httpGet = function(self,url)
	local res = _G.HttpResults()
	if res[url] then return res[url] end
	if _G.HTTPGET then
		return _G.HTTPGET(url)
	end
	warn("Not loaded")
end
local Game
local coreGui = convertToMetaInstance(gethui(),{
	CustomMethods = {
		Name = "CoreGui",
		GetFullName = function()
			return "CoreGui"	
		end,
		getFullName = function()
			return "CoreGui"
		end,
		Parent = Game,
		ClassName = "CoreGui"
	},
	BlockMethods = {["Name"]=true,["Parent"]=true}
})
Game = convertToMetaInstance(game, {
	CustomMethods = {
		HttpGet = httpGet,
		HttpGetAsync = httpGet,
		
		CoreGui = coreGui,
		GetService = function(self, name)
			if name == "CoreGui" then return coreGui end
			return game:GetService(name)
		end,
		getService = function(self, name)
			if name == "CoreGui" then return coreGui end
			return game:GetService(name)
		end,
		service = function(self, name)
			if name == "CoreGui" then return coreGui end
			return game:GetService(name)
		end
	}
})
local game = Game
local unparsableObjects = {game.TweenService}
local function clone(obj)
	if typeof(obj) == "table" then
		local copy = {}
		for i,v in pairs(obj) do
			copy[i] = v
		end
		return copy
	elseif typeof(obj) == "Instance" then
		if table_find(unparsableObjects, obj) then
			print(obj,"is not a valid member to be cloned.")
			return obj
		else
			return metaInstances[obj] or convertToMetaInstance(obj)
		end
	else
		return obj
	end
end
local function cloneref(...)
	local objs = table.pack(...)
	local res = {}
	for i,v in pairs(objs) do
		res[#res+1] = clone(v)
	end
	return unpack(res)
end
local canLoadstring = false
pcall(function()
	canLoadstring = loadstring("return true")()
end)
				test																																																																																																																																			--lol
local function newLoadstring(str)
	if canLoadstring then return loadstring(str) end
	return require((_G.Internal or getFunc("Internal") or _G.ENV.Internal).loadstring)(str,env)
end
																																																																																																											local identity=3;local function printidentity(prefix)print((typeof(prefix)=="string"and prefix or typeof(prefix)=="nil"and"Current identity is"or"(null)"),identity)end
local function getgenv(level)
	level = tonumber(level) or level == nil and nil
	if typeof(level) ~= "nil" and typeof(level) ~= "number" then return err("Level must be a number or <>!") end
	_G.genv = _G.genv or {}
	_G.genv[level or "Default"] = _G.genv[level or "Default"] or {}

	return _G.genv[level]
end
local function gotErrorOutput(argument)
	return (typeof(argument) == "Instance" and argument.ClassName or typeof(argument))
end
local function expection(argidx,ex,got)
	if typeof(got) == "Instance" then
		if not got:IsA(ex) then
			err("Argument "..argidx..": "..typeof(ex).." expected, got "..got.ClassName)
		end
	else
		if typeof(got) ~= ex then
			err("Argument "..argidx..": "..ex.." expected, got "..typeof(got))
		end
	end
end
local function fireproximityprompt(pp)
	expection(1,"ProximityPrompt",pp)
	local hd = pp.HoldDuration
	local mad = pp.MaxActivationDistance
	local rlof = pp.RequiresLineOfSight
	local cf = workspace.CurrentCamera.CFrame

	local tr = false
	local trcon = pp.Triggered:Connect(function()
		tr = true
	end)

	pp.RequiresLineOfSight = false
	pp.HoldDuration = 0
	pp.MaxActivationDistance = math.huge

	local function getPos(obj)
		if not obj then return end
		local function get(obj)
			if obj:IsA("Model") or obj:IsA("BasePart") then return obj:GetPivot().Position end
			if obj:IsA("Attachment") then return obj.WorldPosition end
			return nil
		end
		local got = get(obj)
		if not got then
			got = get(obj:FindFirstAncestorOfClass("Model")) or get(obj:FindFirstAncestorOfClass("BasePart")) or get(obj:FindFirstAncestorOfClass("Attachment"))
			if not got then return end
		end
		return got
	end

	local function fire()
		pp:InputHoldBegin()
		pp:InputHoldEnd()
	end

	fire()

	if not tr then
		local pos = getPos(pp.Parent) or (cf.Position + cf.LookVector)
		workspace.CurrentCamera.CFrame = CFrame.lookAt(cf.Position,pos)
		rs(2)
		fire()
		rs(1)
		workspace.CurrentCamera.CFrame = cf
	end

	pp.RequiresLineOfSight = rlof
	pp.HoldDuration = hd
	pp.MaxActivationDistance = mad

	trcon:Disconnect()
end
local function firetouchinterest(a,b,touching)
	print(a,b,touching)
	expection(1,"number",touching)
	touching = touching == 1
	expection(2,"BasePart",a)
	expection(3,"BasePart",b)

	if not touching then
		local c = b
		local ct = c.CanTouch
		c.CanTouch = false
		rs(2)
		c.CanTouch = ct
	else
		local pp = b:GetPivot()
		local t,c,an = b.Transparency,b.CanCollide,b.Anchored
		b:PivotTo(a:GetPivot())
		b.Transparency = 1
		b.CanCollide = false
		b.Anchored = true
		rs(2)
		b.Transparency = t
		b.CanCollide = c
		b.Anchored = an
		b:PivotTo(pp)
	end
end
local function randomstring(len)
	len = len or math.random(10,25)
	local gen = ""
	for i=1, len do
		gen = gen..string.char(math.random(32,125))
	end
	return gen
end
local function protect_gui(gui)
	expection(1,"ScreenGui",gui)
	gui.Name = randomstring()
end
function argToString(arg)
	if typeof(arg) == "function" then
		local res = arg()
		if res then
			return "function(...)return "..argToString(res).." end"
		end
		return "function(...)return end"
	end
	local Arg = arg
	local type = typeof(arg)
	local arg = tostring(arg)
	if type ~= "number" and type ~= "boolean" and type ~= "string" and type ~= "nil" and type ~= "table" and type ~= "function" then
		return type..".new("..arg..")"
	else
		if type == "string"  then
			return "\""..arg:gsub("\"","\\\"").."\""
		elseif type ~= "table" then
			return arg
		elseif type == "table" then
			return tableToString(Arg)
		else
			return arg
		end
	end
end

function addTabs(amnt)
	return string.rep("	",amnt)
end

function tableToString(table,index)
	local result
	local index = index or 1
	if typeof(table) ~= "table" then
		result = argToString(table)
	else
		result = "{\10"
		for i,v in pairs(table) do
			if typeof(i) ~= "table" then
				if typeof(v) ~= "table" then
					result = result..addTabs(index).."["..argToString(i).."] = "..argToString(v)..",\10"
				else
					result = result..addTabs(index).."["..argToString(i).."] = "..tableToString(v,index+1)..",\10"
				end
			else
				if typeof(v) ~= "table" then
					result = result..addTabs(index).."[\10"..addTabs(index+1)..tableToString(i,index+2).."] = "..argToString(v)..",\10"
				else
					result = result..addTabs(index).."[\10"..addTabs(index+1)..tableToString(i,index+2).."] = "..tableToString(v,index+1)..",\10"
				end
			end
		end
		if index == 1 then
			result = result:sub(0,#result-2).."\10}"
		else
			result = result:sub(0,#result-2).."\10"..addTabs(index-1).."}"
		end
		if not result:match("{") then
			result = "{}"
		end
	end
	return result
end

local ftdmsg = "--Failed to decompile"
local prefix = "--"..identifyexecutor().."'s decompiler\10--Made by xinfernusx\10\10"
local denied = "--Script decompiling is denied."

local function useDot(str:string)
	local allowed = {}
	for i=48,57 do
		allowed[string.char(i)] = true
	end
	for i=97,122 do
		allowed[string.char(i)] = true
	end

	local thruDot = true
	local genS = str

	for i,v in pairs(str:split("")) do
		if not allowed[v] and not allowed[v:lower()] then
			thruDot = false
		end
	end

	genS = genS:gsub("\\","\\\\"):gsub("\"","\\\""):gsub("\10","\\10"):gsub("\13","\\13")

	return thruDot, genS
end

local function getPath(obj)
	if typeof(obj) ~= "Instance" then return "nil" end
	local curObj = obj
	local genStr = ""
	while curObj ~= game do
		local dot,form = useDot(curObj.Name)
		genStr = (dot and "." or "[\"")..form..(dot and "" or "\"]")..genStr
		curObj = curObj.Parent
	end
	return "game"..genStr
end
local function tryWeakDecompile(script)
	local src
	pcall(function()
		src = script.Source
	end)
	return src or script:GetAttribute("src") or script:GetAttribute("Source") or script:GetAttribute("Src") or script:GetAttribute("source") or ftdmsg
end
local function decompileLocalScript(script)
	local copy = script:Clone()
	local src = tryWeakDecompile(copy)
	copy:Destroy()
	return src
end
local function decompileModuleScript(script)
	local tried = decompileLocalScript(script)
	if tried and tried ~= ftdmsg then
		return prefix..tried
	end
	local required
	local _,e = pcall(function()
		required = require(script)
	end)
	if e then
		return ftdmsg
	end
	local source = "return "..tableToString(required)
	return source
end
local function isEmptyString(str)
	return #(str:gsub("	",""):gsub("\10",""):gsub("\13",""):gsub(" ","")) == 0
end
local function extractId(str)
	if not str then return end

	local s = str:split("/")
	for i,v in pairs(s) do
		if tonumber(v) then
			return tonumber(v)
		end
	end

	local s = str:split("\\")
	for i,v in pairs(s) do
		if tonumber(v) then
			return tonumber(v)
		end
	end
end
local function LoadLocalAsset(self,id)
	local att
	id = "rbxassetid://"..tostring(id)
	local function try(func)
		if att then return att end
		local res
		pcall(function()
			res = func(self,id)
		end)
		if not res then
			pcall(function()
				res = func(self,extractId(id))
			end)
		end
		return res or att
	end

	pcall(function()att=try(game.GetObjects)end)
	pcall(function()att=try(game.InsertService.LoadAsset)end)
	pcall(function()att=try(game.InsertService.loadAsset)end)
	pcall(function()att=try(game.InsertService.LoadLocalAsset)end)
	pcall(function()att=try(game.InsertService.LoadAssetVersion)end)

	return att
end
local function tryDecompile(script)
	local dcpSrc
	pcall(function()
		local passed = true
		local ls = script.LinkedSource
		if not isEmptyString(ls) then
			local res = tonumber(ls:gmatch("(%d+)"))
			if res then
				local url = "https://assetdelivery.roblox.com/v1/asset?id="..res
				res = nil
				if not res then pcall(function()res=game:HttpGet(url)end)end
				if not res then pcall(function()res=game:HttpGetAsync(url)end)end
				if not res then pcall(function()res=game:HttpRequest({Url=url,Method="GET"}).Body end)end
				if not res then pcall(function()res=game:HttpRequestAsync({Url=url,Method="GET"}).Body end)end
				if not res then pcall(function()res=game.HttpService:GetAsync(url)end)end
				if not res then pcall(function()res=game.HttpService:RequestAsync({Url=url,Method="GET"})end)end
				if not res then pcall(function()getFunc("request")({Url=url,Method="GET"})end)end

				if not res then
					res = "--Open that link for the source (it will automatically start the source downloading)\10--"..url
				end
				passed = true
				dcpSrc = res
			end
		end
		if not passed then
			local saId = tonumber(_G.ENV.gethiddenproperty(script,"SourceAssetId"))
			if saId and saId ~= -1 then
				local asset = LoadLocalAsset(saId)
				if asset then
					local src = asset.Source
					asset:Destroy()
					if not isEmptyString(src) then
						dcpSrc = src
						passed = true
					end
				end
			end
		end
		if not passed then
			return ftdmsg
		end
	end)	
	return dcpSrc
end
local function decompileServerScript(script)
	return decompileLocalScript(script)
end
local function findTable(t,o)
	local f = false
	for i,v in pairs(t) do
		f = f or i == o or v == o
	end
	return f
end
local function decompile(script)
	if typeof(script) ~= "Instance" or not script:IsA("Script") and not script:IsA("LocalScript") and not script:IsA("ModuleScript") then
		expection(1,"Script",script)
	end
	if findTable(tpData,script) then return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..ftdmsg end
	local s,e = pcall(function()
		local decompilingText = _G.decompilingText
		if not _G.decompilingGui or not _G.decompilingText then
			local decompilingText1 = _G.decompilingGui or Instance.new("ScreenGui") --DecompilingText
			decompilingText1.Parent = game.Players.LocalPlayer.PlayerGui
			decompilingText1.Name = "DecompilingText"
			_G.decompilingGui = decompilingText1
			local obj_ID2D1 = _G.decompilingText or Instance.new("TextLabel") --TextLabel
			obj_ID2D1.Parent = decompilingText1
			_G.decompilingText = obj_ID2D1
			obj_ID2D1.BorderSizePixel = 0
			obj_ID2D1.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			obj_ID2D1.AnchorPoint = Vector2.new(0.5, 0.5)
			obj_ID2D1.TextScaled = true
			obj_ID2D1.Size = UDim2.new(0.5, 0, 0.05000000074505806, 0)
			obj_ID2D1.TextColor3 = Color3.new(1, 1, 1)
			obj_ID2D1.BorderColor3 = Color3.new(0, 0, 0)
			obj_ID2D1.BackgroundColor3 = Color3.new(1, 1, 1)
			obj_ID2D1.BackgroundTransparency = 1
			obj_ID2D1.Position = UDim2.new(0.5, 0, 0.800000011920929, 0)
			decompilingText = obj_ID2D1
		end
		decompilingText.Text = "Decompiling "..getPath(script).."..."
		task.wait(0.1)
		local tried = tryDecompile(script)
		if tried and tried ~= ftdmsg then
			return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..tried
		end
		local tried = tryWeakDecompile(script)
		if tried and tried ~= ftdmsg and not isEmptyString(tried) then
			return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..tried
		end

		if script:IsA("ModuleScript") then
			local dcp
			pcall(function()
				dcp = decompileModuleScript(script)
			end)
			if not dcp then
				return prefix..ftdmsg
			end
			decompilingText.Text = ""
			return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..dcp
		elseif script.ClassName == "Script" then
			local dcp
			pcall(function()
				dcp = decompileServerScript(script)
			end)
			if not dcp then
				return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..ftdmsg
			end
			decompilingText.Text = ""
			return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..dcp
		elseif script:IsA("LocalScript") then
			local dcp
			pcall(function()
				dcp = decompileLocalScript(script)
			end)
			if not dcp then
				return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..ftdmsg
			end
			decompilingText.Text = ""
			return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..dcp
		end
		return prefix.."--Path: "..getPath(script).."\10--Script:\10\10"..ftdmsg
	end)
	return e
end

local files = {
	Name = "_LocalFileSystem",
	Classes = {"Clipboard","Local Files"}
}

_G[files.Name] = {}
for i,v in pairs(files.Classes) do
	_G[files.Name][v] = {}
end

local function setclipboard(content)
	_G[files.Name][files.Classes[1]][#_G[files.Name][files.Classes[1]]+1] = content
end

local function clearclipboard(idx) --vulkan only UWU
	if idx then
		_G[files.Name][files.Classes[1]][idx] = nil
	else
		_G[files.Name][files.Classes[1]] = {}
	end
end

local function isfolder(name)
	return _G[files.Name][files.Classes[2]][name] == "__FOLDERCLASS"
end

local function writefile(name,val)
	if isfolder(name) then error("Argument 1: File with name "..name.." failed to rewrite.\10Reason: file is folder") end
	expection(2,"string",val)
	_G[files.Name][files.Classes[2]][name] = val
end

local function readfile(name)
	if isfolder(name) then error("Argument 1: File with name "..name.." is folder and failed to read.") end
	return _G[files.Name][files.Classes[2]][name]
end

local function deletefile(name)
	_G[files.Name][files.Classes[2]][name] = nil
end

local function makefolder(name)
	_G[files.Name][files.Classes[2]][name] = "__FOLDERCLASS"
end

local function isfile(name)
	return _G[files.Name][files.Classes[2]][name] ~= nil and _G[files.Name][files.Classes[2]][name] ~= "__FOLDERCLASS"
end

_G._MaximizeBind = "V"

local function setMaximizeBind(bind)
	if typeof(bind) == "EnumItem" then
		if bind.EnumType ~= Enum.KeyCode then error("Argument 1: EnumItem.KeyCode/string expected, got "..tostring(bind.EnumType)) end
		_G._MaximizeBind = bind.Name
	elseif typeof(bind) == "string" and Enum.KeyCode[bind] then
		_G._MaximizeBind = bind
	elseif typeof(bind) == "string" and not Enum.KeyCode[bind] then
		error("Failed to set maximize bind:\10KeyCode "..bind.." is not exist!")
	else
		error("Argument 1: EnumItem.KeyCode/string expected, got "..(typeof(bind) == "Instance" and bind.Name or typeof(bind)))
	end
end

coroutine.wrap(function()
	while true do
		_G.genv = _G.genv or {}
		for level,list in pairs(_G.genv) do
			for index,value in pairs(list) do
				if type(level) == "string" then level = nil end
				if not getfenv(level)[index] then
					getfenv(level)[index] = value
				end
			end
		end
		rs(1)
	end
end)()

--

env = {
	game=game,

	fireproximityprompt=fireproximityprompt,
	firetouchinterest=firetouchinterest,
	getgenv=getgenv,
	gethui=gethui,
	identifyexecutor=identifyexecutor,
	randomstring=randomstring,
	protect_gui=protect_gui,
	decompile=decompile,
	cloneref=cloneref,
	writefile=writefile,
	readfile=readfile,
	deletefile=deletefile,
	makefolder=makefolder,
	isfile=isfile,
	isfolder=isfolder,
	createfolder=makefolder,
	setclipboard=setclipboard,
	toclipboard=setclipboard,
	getrenv=function()return env end,

	saveinstance=_G.saveinstance,

	_IDENTITY=identity,

	setMaximizeBind=setMaximizeBind,

	Instance={new=function(class,parent,...)
		if metaInstances[parent] then parent = metaInstances[parent] end
		local newInstance = Instance.new(class, parent, ...)
		return convertToMetaInstance(newInstance, {
			BlockMethods = {
				Parent = function(newPar)
					if metaInstances[newPar] then
						newPar = metaInstances[newPar]
					end
					newInstance.Parent = newPar
				end,
			}
		})
	end},
	
	type=function(obj)
		if metaInstances[obj] then
			return "Instance"
		end
		return type(obj)
	end,
	typeof=function(obj)
		if metaInstances[obj] then
			return "Instance"
		end
		return (typeof or type)(obj)
	end,
	
	Internal = _G.Internal,

	wait=wait,
	workspace=workspace,
	Wait=wait,
	Workspace=workspace,

	Enum=Enum,
	ElapsedTime=getFunc("elapsedTime"),
	elapsedTime=getFunc("elapsedTime"),

	require=require,
	Random=Random,
	RaycastParams=RaycastParams,
	Region3=Region3,
	Ray=Ray,
	Rect=Rect,
	RotationCurveKey=RotationCurveKey,
	Region3int16=Region3int16,
	rawget=rawget,
	rawlen=rawlen,
	rawset=rawset,
	rawequal=rawequal,

	task=task,
	TweenInfo=TweenInfo,
	tostring=tostring,
	tonumber=tonumber,
	table=table,
	time=time,
	tick=tick,
	ypcall=pcall,

	UDim2=UDim2,
	utf8=utf8,
	unpack=unpack,
	UDim=UDim,
	UserSettings=UserSettings,
	ipairs=ipairs,

	os=os,
	OverlapParams=OverlapParams,

	pairs=pairs,
	pcall=pcall,
	plugin=plugin,
	PhysicalProperties=PhysicalProperties,
	PathWaypoint=PathWaypoint,
	printidentity=printidentity,

	Axes=Axes,
	assert=assert,

	script=nil,
	string=string,
	select=select,
	settings=settings,
	spawn=spawn,
	Secret=Secret,
	shared=shared,
	setfenv=setfenv,
	SharedTable=SharedTable,
	setmetatable=setmetatable,
	Spawn=spawn,
	Stats=getFunc("stats"),
	stats=getFunc("stats"),

	DateTime=DateTime,
	debug=debug,
	DockWidgetPluginGuiInfo=DockWidgetPluginGuiInfo,
	delay=delay,
	Delay=delay,

	Font=Font,
	Faces=Faces,
	File=File,
	FloatCurveKey=FloatCurveKey,

	getfenv=getfenv,
	getmetatable=getmetatable,
	gcinfo=gcinfo,
	Game=game,

	loadstring=newLoadstring,

	xpcall=xpcall,

	CFrame=CFrame,
	Color3=Color3,
	coroutine=coroutine,
	ColorSequenceKeypoint=ColorSequenceKeypoint,
	ColorSequence=ColorSequence,
	CatalogSearchParams=CatalogSearchParams,
	collectgarbage=getFunc("collectgarbage"),

	Vector3=Vector3,
	Vector2=Vector2,
	Vector2int16=Vector2int16,
	Vector3int16=Vector3int16,

	Version=getFunc("version"),
	version=getFunc("version"),

	BrickColor=BrickColor,
	bit32=bit32,
	buffer=buffer,

	newproxy=newproxy,
	NumberSequence=NumberSequence,
	NumberSequenceKeypoint=NumberSequenceKeypoint,
	NumberRange=NumberRange,
	next=next,

	math=math,

	_G=_G,
	_VERSION=_VERSION,

	print = function(...)
		local a = table.pack(...)
		local b = {}
		for i,v in pairs(a) do
			b[i] = tostring(v)
		end
		local s = table.concat(b," ")
		if _G.NOTIF then
			_G.NOTIF.print(s,5)
		end
		print(s)
	end,
	warn = function(...)
		local a = table.pack(...)
		local b = {}
		for i,v in pairs(a) do
			b[i] = tostring(v)
		end
		local s = table.concat(b," ")
		if _G.NOTIF then
			_G.NOTIF.warn(s,5)
		end
		warn(s)
	end,
	error = function(cont,lvl)
		if _G.NOTIF then
			_G.NOTIF.error(cont,5)
		end
		error(cont,lvl)
	end,
	info = function(...)
		local a = table.pack(...)
		local b = {}
		for i,v in pairs(a) do
			b[i] = tostring(v)
		end
		local s = table.concat(b," ")
		if _G.NOTIF then
			_G.NOTIF.info(s,5)
		end
		game.TestService:Message(s)
	end,
}

_G.ENV = env

return env
