local ControlPanel = LibStub("AceAddon-3.0"):NewAddon("ControlPanel","AceEvent-3.0","AceConsole-3.0")

function ControlPanel:OnInitialize()
	SetCVar("RAIDSettingsEnabled",false)
	local empty_table = {}
	self.db = LibStub("AceDB-3.0"):New("ControlPanelDB",{
		profile = 
		{
			none = empty_table,
			party = empty_table,
			raid = empty_table,
			pvp = empty_table,
			arena = empty_table,
			rest = empty_table,
			scenario = empty_table,
		}
	},true)
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
	self:SendMessage("CONTROL_PANEL_CHAT_COMMAND",input)
end