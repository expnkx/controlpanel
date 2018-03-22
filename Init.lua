local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local ControlPanel = AceAddon:NewAddon("ControlPanel","AceEvent-3.0","AceConsole-3.0","AceHook-3.0")

--------------------------------------------------------------------------------------
local AceDB = LibStub("AceDB-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigCmd = LibStub("AceConfigCmd-3.0")
local GetCVar = GetCVar
local tonumber = tonumber
--------------------------------------------------------------------------------------

local empty_table = {}

local default_options=
{
	profile = 
	{
		none = empty_table,
		party = empty_table,
		raid = empty_table,
		pvp = empty_table,
		arena = empty_table,
		rest = empty_table,
		scenario = empty_table,
		
		enable_party = false,
		enable_raid = false,
		enable_pvp = false,
		enable_arena = false,
		enable_rest = false,
		enable_scenario = false,
	}
}

function ControlPanel:OnInitialize()
	SetCVar("RAIDSettingsEnabled",false)
	self.db = AceDB:New("ControlPanelDB",default_options)
	self:RegisterChatCommand("ControlPanel", "ChatCommand")
	self:RegisterChatCommand("CP", "ChatCommand")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_UPDATE_RESTING","PLAYER_ENTERING_WORLD")
end

function ControlPanel:ChatCommand(input)
	if IsAddOnLoaded("ControlPanel_Options") == false then
		local loaded , reason = LoadAddOn("ControlPanel_Options")
		if loaded == false then
			self:Print("ControlPanel_Options: "..reason)
			return
		end
	end
	if not input or input:trim() == "" then
		AceConfigDialog:Open("ControlPanel")
	else
		AceConfigCmd:HandleCommand("ControlPanel", "ControlPanel","")
		AceConfigCmd:HandleCommand("ControlPanel", "ControlPanel",input)
	end
end