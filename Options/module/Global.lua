local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")
local L = AceLocale:GetLocale("ControlPanel_Options")
local string_format = string.format
local SetCVar = SetCVar
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local GetRefreshs = GetRefreshs
local pairs = pairs
local get_cvar_number = ControlPanel_Options.get_cvar_number

local function tablefind(array,key)
	local i = 1
	for i = 1,#array do
		if key == array[i] then
			return i
		end
	end
	return i
end

local string_upper = string.upper
local RestartGx = RestartGx
local languages = {deDE="deDE",enUS="enUS",esES="esES",esMX="esMX",frFR="frFR",itIT="itIT",koKR="koKR",ptBR="ptBR",ruRU="ruRU",zhCN="zhCN",zhTW="zhTW"}
local graphicsAPIs = { GetGraphicsAPIs() }
local resolutions = { GetScreenResolutions() }

local function get_refresh_rates()
	local refs = { GetRefreshRates() }
	local ret = {}
	local i
	local n = #refs
	for i=1,n,2 do
		ret[string_format("%d/%d",refs[i],refs[i+1])]=string_format("%.0fHz",refs[i]/refs[i+1])
	end
	return ret
end

local refresh_rates = get_refresh_rates()

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Global =
{
	name = L["Global"],
	desc = L["Requires a client restart."].."\n\n"..L["ControlPanel won't manage these options."],
	type = "group",
	args =
	{
		system =
		{
			order = get_order(),
			name = SYSTEMOPTIONS_MENU,
			type = "execute",
			func = function()
				AceConfigDialog:Close("ControlPanel")
				ControlPanel:Unhook(VideoOptionsFrame,"Show")
				VideoOptionsFrame:Show()
				ControlPanel:SecureHook(VideoOptionsFrame,"Show")
			end,
			width = "full"
		},
		Display =
		{
			order = get_order(),
			name = DISPLAY,
			desc = L["Requires a restart of the game's graphic subsystem"],
			type = "group",
			args =
			{
				gxFullscreenResolution =
				{
					order = get_order(),
					name = RESOLUTION,
					desc = OPTION_TOOLTIP_RESOLUTION,
					type = "select",
					values = resolutions,
					set = function(info,val)
						SetCVar("gxFullscreenResolution",resolutions[val])
					end,
					get = function(info)
						return GetCurrentResolution()
					end,
					confirm = true,
				},
				gxRefresh =
				{
					order = get_order(),
					name = REFRESH_RATE,
					desc = OPTION_TOOLTIP_REFRESH_RATE,
					type = "select",
					values = refresh_rates,
					set = function(info,val)
						SetCVar("gxRefresh",val)
					end,
					get = function(info)
						return GetCVar("gxRefresh")
					end,
					confirm = true,
				},
				gxWindow =
				{
					order = get_order(),
					name = VIDEO_OPTIONS_WINDOWED,
					type = "toggle",
					set = function(info,val)
						SetCVar("gxWindow",val)
					end,
					get = function(info)
						return GetCVarBool("gxWindow")
					end,
					confirm = true,
				},
				gxMaximize =
				{
					order = get_order(),
					name = VIDEO_OPTIONS_FULLSCREEN,
					type = "toggle",
					set = function(info,val)
						SetCVar("gxMaximize",val)
					end,
					get = function(info)
						return GetCVarBool("gxMaximize")
					end,
					confirm = true,
				},
				gxVSync =
				{
					order = get_order(),
					name = VERTICAL_SYNC,
					desc = OPTION_TOOLTIP_VERTICAL_SYNC,
					type = "toggle",
					set = function(info,val)
						SetCVar("gxVSync",val)
					end,
					get = function(info)
						return GetCVarBool("gxVSync")
					end,
					confirm = true,
				},

				gxTripleBuffer =
				{
					order = get_order(),
					name = TRIPLE_BUFFER,
					desc = OPTION_TOOLTIP_TRIPLE_BUFFER,
					type = "toggle",
					set = function(info,val)
						SetCVar("gxTripleBuffer",val)
					end,
					get = function(info)
						return GetCVarBool("gxTripleBuffer")
					end,
					confirm = true,
				},
				gxFixLag =
				{
					order = get_order(),
					name = FIX_LAG,
					desc = OPTION_TOOLTIP_FIX_LAG,
					type = "toggle",
					set = function(info,val)
						SetCVar("gxFixLag",val)
					end,
					get = function(info)
						return GetCVarBool("gxFixLag")
					end,
					confirm = true,
				},
				gxCursor = 
				{
					order = get_order(),
					name = HARDWARE_CURSOR,
					desc = OPTION_TOOLTIP_HARDWARE_CURSOR,
					type = "toggle",
					set = function(info,val)
						SetCVar("gxCursor",val)
					end,
					get = function(info)
						return GetCVarBool("gxCursor")
					end,
					confirm = true,
				},
				gxApi =
				{
					order = get_order(),
					name = GXAPI,
					desc = OPTION_TOOLTIP_GXAPI,
					type = "select",
					values = graphicsAPIs,
					set = function(info,val)
						SetCVar("gxApi",graphicsAPIs[val])
					end,
					get = function(info)
						return tablefind(graphicsAPIs,GetCVar("gxApi"))
					end,
					confirm = true,
				},
				violenceLevel =
				{
					order = get_order(),
					name = L["Violence Level"],
					type = "range",
					min = 0,
					max = 5,
					step = 1,
					set = function(info,val)
						SetCVar("violenceLevel",val)
					end,
					get = function(info)
						return get_cvar_number("violenceLevel")
					end,
					confirm = true,
				},
				restart_graphic_subsystem =
				{
					order = get_order(),
					name = L["Restart graphics subsystem"],
					type = "execute",
					func = RestartGx,
					width = "full"
				}
			}
		},
		Langauges =
		{
			order = get_order(),
			name = LANGUAGES_LABEL,
			desc = L["Warning : Langauges features always require a client restart and update. You need open your battle.net to download extra data."],
			type = "group",
			args =
			{
				portal = 
				{
					order = get_order(),
					name = string_format(L["Portal : %s"],string_upper(GetCVar("portal"))),
					type = "description",
					fontSize = "large",
					width = "full",
				},
				textLocale =
				{
					order = get_order(),
					name = LOCALE_TEXT_LABEL,
					type = "select",
					values = languages,
					set = function(info,val)
						SetCVar("textLocale",val)
					end,
					get = function(info)
						return GetCVar("textLocale")
					end,
					confirm = true,
				},
				audioLocale =
				{
					order = get_order(),
					name = LOCALE_AUDIO_LABEL,
					desc = OPTION_TOOLTIP_AUDIO_LOCALE,
					type = "select",
					values = languages,
					set = function(info,val)
						SetCVar("audioLocale",val)
					end,
					get = function(info)
						return GetCVar("audioLocale")
					end,
					confirm = true,
				},
				overrideArchive =
				{
					order = get_order(),
					name = L["Show the Censorship Models in China"],
					desc = L["Mainly for Undead models with no bones sticking out."],
					type = "toggle",
					set = function(info,val)
						SetCVar("overrideArchive",val)
					end,
					get = function(info)
						return GetCVarBool("overrideArchive")
					end,
					width = "full",
					confirm = true,
				},
			},
		},
	}
}

ControlPanel_Options:push("Global",Global)
