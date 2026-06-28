local Clover = require(game.ReplicatedStorage.Clover)

local Window = Clover:CreateWindow({
    Title     = "My Script",
    SubTitle  = "v1.0.0",
    Icon      = "sword",
    Theme     = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
})

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "crosshair",
})

local AimbotSection = CombatTab:CreateSection({
    Name = "Aimbot",
})

AimbotSection:CreateToggle({
    Name     = "Enable Aimbot",
    Default  = false,
    Callback = function(v)
        print("Aimbot:", v)
    end,
})

AimbotSection:CreateSlider({
    Name      = "FOV",
    Min       = 1,
    Max       = 360,
    Default   = 90,
    Increment = 1,
    Suffix    = "°",
    Callback  = function(v)
        print("FOV:", v)
    end,
})

local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "user",
})

local SpeedSection = PlayerTab:CreateSection({
    Name = "Movement",
})

SpeedSection:CreateSlider({
    Name      = "WalkSpeed",
    Min       = 16,
    Max       = 500,
    Default   = 16,
    Increment = 1,
    Callback  = function(v)
        game.Players.LocalPlayer.Character
            .Humanoid.WalkSpeed = v
    end,
})

SpeedSection:CreateSlider({
    Name      = "JumpPower",
    Min       = 50,
    Max       = 500,
    Default   = 50,
    Increment = 1,
    Callback  = function(v)
        game.Players.LocalPlayer.Character
            .Humanoid.JumpPower = v
    end,
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
})

SettingsTab:CreateDivider({ Label = "Appearance", Icon = "palette" })

SettingsTab:CreateDropdown({
    Name    = "Theme",
    Options = { "Dark", "Light", "Midnight", "Emerald", "Rose", "Ocean" },
    Default = "Dark",
    Callback = function(v)
        Clover:SetTheme(v)
    end,
})

SettingsTab:CreateKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightShift,
    Callback = function(key)
        print("Rebound to:", key.Name)
    end,
})

SettingsTab:CreateDivider({ Label = "Info", Icon = "info" })

SettingsTab:CreateParagraph({
    Title   = "About",
    Content = "Clover UI Library — built with Lucide Icons support.",
    Icon    = "feather",
})

Clover:RegisterLucideIcon("rocket", "rocket")
SettingsTab:CreateLabel({
    Name = "Powered by Lucide Icons",
    Icon = "rocket",
})

Clover:Notify({
    Title    = "Loaded!",
    Content  = "Script initialized successfully.",
    Type     = "success",
    Duration = 4,
})
