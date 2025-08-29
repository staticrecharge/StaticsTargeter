--[[------------------------------------------------------------------------------------------------
Title:					Static's Targeter
Author:					Static_Recharge
Version:				0.0.1
Description:		Allows for quickly managing raid icons.
------------------------------------------------------------------------------------------------]]--


--[[------------------------------------------------------------------------------------------------
Libraries and Aliases
------------------------------------------------------------------------------------------------]]--
local LAM2 = LibAddonMenu2
local LCM = LibCustomMenu
local CS = CHAT_SYSTEM
local EM = EVENT_MANAGER


--[[------------------------------------------------------------------------------------------------
ST Class Initialization
ST    - Parent object containing all functions, tables, variables, constants and other data managers.
  |-  Defaults    - Default values for saved vars and settings menu items.
------------------------------------------------------------------------------------------------]]--
local ST = ZO_InitializingObject:Subclass()


--[[------------------------------------------------------------------------------------------------
ST:Initialize()
Inputs:				None
Outputs:			None
Description:	Initializes all of the variables, object managers, slash commands and main event
							callbacks.
------------------------------------------------------------------------------------------------]]--
function ST:Initialize()
  -- static definitions
	self.addonName = "StaticsTargeter"
	self.addonVersion = "0.0.1"
	self.varsVersion = 1
	self.author = "|CFF0000Static_Recharge|r"
	self.chatPrefix = "|cFFFFFF[ST]:|r "
	self.chatTextColor = "|cFFFFFF"
	self.chatSuffix = "|r"
	self.UnitType = {
		hostile = UNIT_REACTION_COLOR_HOSTILE,
		neutral = UNIT_REACTION_COLOR_NEUTRAL,
		friendly = UNIT_REACTION_COLOR_FRIENDLY,
		playerAlly = UNIT_REACTION_COLOR_PLAYER_ALLY,
		npcAlly = UNIT_REACTION_COLOR_NPC_ALLY,
		dead = UNIT_REACTION_COLOR_DEAD,
		interact = UNIT_REACTION_COLOR_INTERACT,
		companion = UNIT_REACTION_COLOR_COMPANION,
	}

	-- session variables
	self.currentIconIndex = 1

	self.IconPaths = {}
	self.IconFormatted = {}
	for iconIndex, iconPath in ipairs(ZO_GetPlatformTargetMarkerIconTable()) do
		self.IconPaths[iconIndex] = iconPath
		self.IconFormatted[iconIndex] = zo_strformat("|t100%:100%:<<1>>|t", iconPath)
	end
	table.insert(self.IconFormatted, "-- Disabled --")
	self.IconIndexes = {1, 2, 3, 4, 5, 6, 7, 8, 9} -- 9 is the disabled option

  -- saved variable defaults
  self.Defaults = {
		chatMsgEnabled = true,
		debugMode = false,
		settingsChanged = true,
		enabledUnitType = {
			[0] = false, -- self (no target)
			true,				-- hostile
			false,			-- neutral
			false,			-- friendly
			false,			-- player ally
			false,			-- npc ally
			false,			-- dead
			false,			-- interact
			false,			-- companion
		},
		IconOrder = {1, 2, 3, 4, 5, 6, 7, 8}, -- iconIndexes in prefered order, nil if not used
	}

	-- saved variables initialization
	self.SV = ZO_SavedVars:NewAccountWide("StaticsTargeterAccountWideVars", self.varsVersion, nil, self.Defaults, nil)

	-- child object initilization
	self.Settings = StaticsTargeterInitSettings(self)
  
  -- control bindings
  ZO_CreateStringId("SI_BINDING_NAME_STAR_CYCLE", "Next Icon")

  -- slash commands
  SLASH_COMMANDS["/startest"] = function(...) self:Test(...) end

	-- event registrations
	EM:RegisterForEvent(self.addonName, EVENT_PLAYER_ACTIVATED, function(...) self:OnPlayerActivated(...) end)

  self.initialized = true
end


--[[------------------------------------------------------------------------------------------------
function ST:CycleMarker()
Inputs:				None
Outputs:			None
Description:	Places the next marker on the target/player. Checks for the modifier key to repeat the
							last marker instead.
------------------------------------------------------------------------------------------------]]--
function ST:CycleMarker()
	-- Get target unit type and see if it's in the allowed list to mark
	local targetUnitType = GetUnitReactionColorType("reticleover")
	self:DebugMsg(zo_strformat("Unit Type: <<1>>", targetUnitType))
	if self.SV.enabledUnitType[targetUnitType] then
		if IsShiftKeyDown() then self.currentIconIndex = self.currentIconIndex - 1 end -- repeat last icon if shift is held
		if IsControlKeyDown() then self.currentIconIndex = 1 end -- start list over if ctrl is held
		local index = self.SV.IconOrder[self.currentIconIndex]
		if index == 9 or self.currentIconIndex == 9 then
			self.currentIconIndex = 1
			index = self.SV.IconOrder[self.currentIconIndex]
		end
		AssignTargetMarkerToReticleTarget(index)
		self.currentIconIndex = self.currentIconIndex + 1
	end
end


--[[------------------------------------------------------------------------------------------------
function ST:SettingsChanged()
Inputs:				None
Outputs:			None
Description:	Fired when the player first loads in after a settings reset is forced
------------------------------------------------------------------------------------------------]]--
function ST:SettingsChanged()
	if self.SV.settingsChanged then 
		self:SendToChat(zo_strformat("Static's Targeter updated to <<1>>. Settings have been reset.", self.addonVersion))
		self.SV.settingsChanged = false
	end
end


--[[------------------------------------------------------------------------------------------------
function ST:OnPlayerActivated(eventCode, initial)
Inputs:				eventCode				- Internal ZOS event code, not used here.
							initial					- Indicates if this is the first activation from log-in.
Outputs:			None
Description:	Fired when the player character is available after loading screens such as changing 
							zones, reloadui and logging in.
------------------------------------------------------------------------------------------------]]--
function ST:OnPlayerActivated(eventCode, initial)
	self:DebugMsg("OnPlayerActivated event fired.")

	if initial then
		if self.initialized then self:DebugMsg("Initialized.") end
		self:SettingsChanged()
	end
	EM:UnregisterForEvent(self.addonName, EVENT_PLAYER_ACTIVATED)
end


--[[------------------------------------------------------------------------------------------------
function ST:BoolConvert(bool)
Inputs:				bool                                - The bool to convert
Outputs:			bool                                - The converted bool or the original input
Description:	Converts a bool to text. 
------------------------------------------------------------------------------------------------]]--
function ST:BoolConvert(bool)
	if not bool then return end
	if type(bool) == boolean then
    if bool then return "true" else return "false" end
  end
  return bool
end


--[[------------------------------------------------------------------------------------------------
function ST:SendToChat(inputString, ...)
Inputs:				inputString			- The input string to be formatted and sent to chat. Can be bools.
							...							- More inputs to be placed on new lines within the same message.
Outputs:			None
Description:	Formats text to be sent to the chat box for the user. Bools will be converted to 
							"true" or "false" text formats. All inputs after the first will be placed on a new 
							line within the message. Only the first line gets the add-on prefix.
------------------------------------------------------------------------------------------------]]--
function ST:SendToChat(inputString, ...)
  -- check for chat being enabled and blank or false input end conditions
	if not self.SV.chatMsgEnabled then return end
	if inputString == false or inputString == "" then return end

  local Args = {...}
	local Output = {}

  -- build first line
  inputString = self:BoolConvert(inputString) 
	table.insert(Output, self.chatPrefix)
	table.insert(Output, self.chatTextColor)
	table.insert(Output, inputString) 
	table.insert(Output, self.chatSuffix)

  -- build any remaining lines
	if #Args > 0 then
		for i,v in ipairs(Args) do
			v = sefl:BoolConvert(v)
		  table.insert(Output, "\n")
			table.insert(Output, self.chatTextColor)
	    table.insert(Output, v) 
	    table.insert(Output, self.chatSuffix)
		end
	end

  -- add completed message to the chat system
	CS:AddMessage(table.concat(Output))
end


--[[------------------------------------------------------------------------------------------------
function ST:DebugMsg(inputString)
Inputs:				inputString			- The debug string to print to chat
Outputs:			None
Description:	Checks if debugging mode is on and if so, sends the input message to chat.
------------------------------------------------------------------------------------------------]]--
function ST:DebugMsg(inputString)
	if not self.SV.debugMode then return end
	if inputString == false then return end
	self:SendToChat("[DEBUG] " .. inputString)
end


--[[------------------------------------------------------------------------------------------------
function ST:Test(...)
Inputs:				...							- Various test inputs.
Outputs:			None
Description:	For internal add-on testing only.
------------------------------------------------------------------------------------------------]]--
function ST:Test(...)
	AssignTargetMarkerToReticleTarget(1)
end


-- Global binding redirects
function STAR_CYCLE()
	StaticsTargeter:CycleMarker()
end


--[[------------------------------------------------------------------------------------------------
Main add-on event registration. Creates the global object, StaticsTargeter, of the SST class.
------------------------------------------------------------------------------------------------]]--
EM:RegisterForEvent("StaticsTargeter", EVENT_ADD_ON_LOADED, function(eventCode, addonName)
	if addonName ~= "StaticsTargeter" then return end
	EM:UnregisterForEvent("StaticsTargeter", EVENT_ADD_ON_LOADED)
	StaticsTargeter = ST:New()
end)