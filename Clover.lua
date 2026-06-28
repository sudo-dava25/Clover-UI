local Clover = {}
Clover.__index = Clover

local ScriptRoot      = script
local ThemeModule     = require(ScriptRoot.Core.Theme)
local WindowModule    = require(ScriptRoot.Core.Window)
local NotifModule     = require(ScriptRoot.Components.Notification)
local IconsModule     = require(ScriptRoot.Assets.Icons)

local themeManager = ThemeModule.new()

function Clover:CreateWindow(options)
    options = options or {}
    if options.Theme then
        if type(options.Theme) == "string" then
            themeManager:Set(options.Theme)
        elseif type(options.Theme) == "table" then
            themeManager:Set("Dark", options.Theme)
        end
    end
    local window = WindowModule.new(options, themeManager)
    if options.ToggleKey then
        window:SetKeybind(options.ToggleKey)
    end
    return window
end

function Clover:Notify(options)
    return NotifModule.new(options, themeManager)
end

function Clover:SetTheme(name, customData)
    themeManager:Set(name, customData)
end

function Clover:RegisterTheme(name, data)
    themeManager:Register(name, data)
end

function Clover:GetTheme()
    return themeManager:Get()
end

function Clover:RegisterIcon(name, assetId)
    IconsModule.Register(name, assetId)
end

function Clover:RegisterLucideIcon(customName, lucideName)
    IconsModule.RegisterLucide(customName, lucideName)
end

return Clover