--[[------------------------------------------------------------------------------------------------
Title:          Settings
Author:         Static_Recharge
Description:    Creates and controls the settings menu and related saved variables.
------------------------------------------------------------------------------------------------]]--


--[[------------------------------------------------------------------------------------------------
Libraries and Aliases
------------------------------------------------------------------------------------------------]]--
local LAM2 = LibAddonMenu2
local CM = CALLBACK_MANAGER


--[[------------------------------------------------------------------------------------------------
Settings Class Initialization
Settings    - Object containing all functions, tables, variables,and constants.
  |-  Parent    - Reference to parent object.
------------------------------------------------------------------------------------------------]]--
local Settings = ZO_InitializingObject:Subclass()


--[[------------------------------------------------------------------------------------------------
Settings:Initialize(Parent)
Inputs:				Parent 					- The parent object containing other required information.  
Outputs:			None
Description:	Initializes all of the variables and tables.
------------------------------------------------------------------------------------------------]]--
function Settings:Initialize(Parent)
  self.Parent = Parent
  self:CreateSettingsPanel()
end


--[[------------------------------------------------------------------------------------------------
Settings:CreateSettingsPanel()
Inputs:				None  
Outputs:			None
Description:	Creates and registers the settings panel with LibAddonMenu.
------------------------------------------------------------------------------------------------]]--
function Settings:CreateSettingsPanel()
	local Parent = self:GetParent()
	local panelData = {
		type = "panel",
		name = "Static's Targeter",
		displayName = "Static's Targeter",
		author = Parent.author,
		--website = "https://www.esoui.com/downloads/info3836-StaticsRecruiter.html",
		feedback = "https://www.esoui.com/portal.php?&uid=6533",
		slashCommand = "/starmenu",
		registerForRefresh = true,
		registerForDefaults = true,
		version = Parent.addonVersion,
	}

  local optionsData = {}
	local controls = {}
	local i = 1
	local k = 1

	--k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Hostile",
    getFunc = function() return Parent.SV.enabledUnitType[1] end,
    setFunc = function(value) Parent.SV.enabledUnitType[1] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[1],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Neutral",
    getFunc = function() return Parent.SV.enabledUnitType[2] end,
    setFunc = function(value) Parent.SV.enabledUnitType[2] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[2],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Self",
    getFunc = function() return Parent.SV.enabledUnitType[0] end,
    setFunc = function(value) Parent.SV.enabledUnitType[0] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[0],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Friendly",
    getFunc = function() return Parent.SV.enabledUnitType[3] end,
    setFunc = function(value) Parent.SV.enabledUnitType[3] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[3],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Player",
    getFunc = function() return Parent.SV.enabledUnitType[4] end,
    setFunc = function(value) Parent.SV.enabledUnitType[4] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[4],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "NPC Ally",
    getFunc = function() return Parent.SV.enabledUnitType[5] end,
    setFunc = function(value) Parent.SV.enabledUnitType[5] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[5],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Dead",
    getFunc = function() return Parent.SV.enabledUnitType[6] end,
    setFunc = function(value) Parent.SV.enabledUnitType[6] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[6],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Interact",
    getFunc = function() return Parent.SV.enabledUnitType[7] end,
    setFunc = function(value) Parent.SV.enabledUnitType[7] = value end,
    tooltip = "Not sure what this one does but included it for completion.",
    width = "half",
		default = Parent.Defaults.enabledUnitType[7],
	}

	k = k + 1
	controls[k] = {
		type = "checkbox",
    name = "Companion",
    getFunc = function() return Parent.SV.enabledUnitType[8] end,
    setFunc = function(value) Parent.SV.enabledUnitType[8] = value end,
    --tooltip = "",
    width = "half",
		default = Parent.Defaults.enabledUnitType[8],
	}

	--i = i + 1
  optionsData[i] = {
		type = "submenu",
		name = "Target Types",
		controls = controls,
	}

	controls = {}
	
	k = 1
	controls[k] = {
    type = "description",
    text = "This must be a continuous list, aka you can't have a disabled option between any icons you want to actually use. Putting two or more of the same icons back to back could result in accidentally removing the icon from the intended target instead.\nHolding SHIFT while using the keybind will repeat the previous icon used.\nHolding CTRL while using the keybind will restart the list from the beginning.",
    width = "full",
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "1",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[1] end,
    setFunc = function(var) Parent.SV.IconOrder[1] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[1], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "2",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[2] end,
    setFunc = function(var) Parent.SV.IconOrder[2] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[2], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "3",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[3] end,
    setFunc = function(var) Parent.SV.IconOrder[3] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[3], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "4",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[4] end,
    setFunc = function(var) Parent.SV.IconOrder[4] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[4], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "5",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[5] end,
    setFunc = function(var) Parent.SV.IconOrder[5] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[5], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "6",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[6] end,
    setFunc = function(var) Parent.SV.IconOrder[6] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[6], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "7",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[7] end,
    setFunc = function(var) Parent.SV.IconOrder[7] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[7], -- default value or function that returns the default value (optional)
	}

	k = k + 1
	controls[k] = {
    type = "dropdown",
    name = "8",
    choices = Parent.IconFormatted,
    choicesValues = Parent.IconIndexes,
    getFunc = function() return Parent.SV.IconOrder[8] end,
    setFunc = function(var) Parent.SV.IconOrder[8] = var end,
    width = "full",
    scrollable = false,
    default = Parent.Defaults.IconOrder[8], -- default value or function that returns the default value (optional)
	}

	i = i + 1
  optionsData[i] = {
		type = "submenu",
		name = "Icon Order",
		controls = controls,
	}

  i = i + 1
  optionsData[i] = {
		type = "header",
		name = "Misc.",
	}

	i = i + 1
	optionsData[i] = {
		type = "checkbox",
    name = "Chat Messages",
    getFunc = function() return Parent.SV.chatMsgEnabled end,
    setFunc = function(value) Parent.SV.chatMsgEnabled = value end,
    tooltip = "Disables ALL chat messages from this add-on.",
    width = "half",
		default = Parent.Defaults.chatMsgEnabled,
	}

	i = i + 1
	optionsData[i] = {
		type = "checkbox",
    name = "Debugging Mode",
    getFunc = function() return Parent.SV.debugMode end,
    setFunc = function(value) Parent.SV.debugMode = value end,
    tooltip = "Turns on extra messages for the purposes of debugging. Not intended for normal use. Must have chat messages enabled.",
    width = "half",
		default = Parent.Defaults.debugMode,
		disabled = not Parent.SV.chatMsgEnabled,
	}

	local function LAMPanelCreated(panel)
		if panel ~= Parent.LAMSettingsPanel then return end
		Parent.LAMReady = true
		Parent.Controls = {}
		self:Update()
	end

	local function LAMPanelOpened(panel)
		if panel ~= Parent.LAMSettingsPanel then return end
		self:Update()
	end

	Parent.LAMSettingsPanel = LAM2:RegisterAddonPanel(Parent.addonName .. "_LAM", panelData)
	CM:RegisterCallback("LAM-PanelControlsCreated", LAMPanelCreated)
	CM:RegisterCallback("LAM-PanelOpened", LAMPanelOpened)
	LAM2:RegisterOptionControls(Parent.addonName .. "_LAM", optionsData)
end


--[[------------------------------------------------------------------------------------------------
Settings:Update()
Inputs:				None
Outputs:			None
Description:	Updates the settings panel in LibAddonMenu.
------------------------------------------------------------------------------------------------]]--
function Settings:Update()
	local Parent = self:GetParent()
	if not Parent.LAMReady then return end
end


--[[------------------------------------------------------------------------------------------------
Settings:GetParent()
Inputs:				None
Outputs:			Parent          - The parent object of this object.
Description:	Returns the parent object of this object for reference to parent variables.
------------------------------------------------------------------------------------------------]]--
function Settings:GetParent()
  return self.Parent
end


--[[------------------------------------------------------------------------------------------------
StaticsTargeterInitSettings(Parent)
Inputs:				Parent          - The parent object of the object to be created.
Outputs:			ST             - The new object created.
Description:	Global function to create a new instance of this object.
------------------------------------------------------------------------------------------------]]--
function StaticsTargeterInitSettings(Parent)
	return Settings:New(Parent)
end