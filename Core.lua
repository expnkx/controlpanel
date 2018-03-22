local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local SetCVar = SetCVar
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local type = type
local next = next
local tonumber = tonumber
local tostring = tostring
local pairs = pairs
local select = select
local GetInstanceInfo = GetInstanceInfo
local IsResting = IsResting
--------------------------------------------------------------------------------------

local function equal(cvar,val)
	local tp = type(val)
	if tp == "boolean" then
		return GetCVarBool(cvar)==val
	elseif tp == "number" then
		return GetCVar(cvar)==tostring(val)
	else
		return GetCVar(cvar)==val
	end
	return false
end

function ControlPanel:UpdateWorld(t)
	local k
	local v
	for k,v in pairs(self.db.profile[t]) do
		if equal(k,v)==false then
			SetCVar(k,v)
		end
	end
end

function ControlPanel:OnEnable()
	self:UpdateWorld("none")
end

function ControlPanel:GetInstanceType()
	if IsResting() then
		return "rest"
	end
	local _,v = GetInstanceInfo()
	return v;
end

function ControlPanel:GetProfileType()
	local profile = self.db.profile
	local instance = self:GetInstanceType()
	if profile[instance] then
		if instance ~= "none" and profile["enable_"..instance] == true then
			return instance;
		end
	end
	return "none"
end

function ControlPanel:SetCVarInstance(t,key,value)
	local sdpt = self.db.profile[t]
	if sdpt == nil then
		SetCVar(key,value)
	else
		sdpt[key] = value
		if self:GetProfileType() == t then
			SetCVar(key,value)
		end
	end
end

function ControlPanel:GetCVarNumberInstance(t,key)
	local v = self.db.profile[t]
	if v ==nil or v[key] == nil then
		return tonumber(GetCVar(key))
	end
	return v[key]
end

function ControlPanel:GetCVarBoolInstance(t,key)
	local v = self.db.profile[t]
	if v ==nil or v[key] == nil then
		return GetCVarBool(key)
	end
	return v[key]
end

function ControlPanel:GetCVarInstance(t,key)
	local v = self.db.profile[t]
	if v ==nil or v[key] == nil then
		return GetCVar(key)
	end
	return v[key]
end

function ControlPanel:FireCVarInstance(t,key)
	self.db.profile[t][key] = nil
end

function ControlPanel:PLAYER_ENTERING_WORLD()
	self:UpdateWorld(self:GetProfileType())
end
