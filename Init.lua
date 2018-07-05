local ControlPanel = LibStub("AceAddon-3.0"):NewAddon("ControlPanel","AceEvent-3.0","AceConsole-3.0")

function ControlPanel:OnInitialize()
	SetCVar("RAIDSettingsEnabled",false)
	self.db = LibStub("AceDB-3.0"):New("ControlPanelDB",{
		profile = 
		{
		}
	},true)
	self:RegisterChatCommand("ControlPanel", "ChatCommand")
	self:RegisterChatCommand("CP", "ChatCommand")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_UPDATE_RESTING","PLAYER_ENTERING_WORLD")
	local sm = self.db.profile.shared_media
	if sm then
		local tb = LibStub("LibSharedMedia-3.0",true)
		if tb then
			for k,v in pairs(sm) do
				for kk,vv in pairs(v) do
					tb:Register(k,kk,vv)
				end
			end
		end
	end
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
