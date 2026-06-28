# Clover UI Library

A modern, feature-rich UI library for Roblox with comprehensive theming support and Lucide Icons integration.

## Features

- **Modern Design System** - Clean, professional interface with smooth animations
- **6 Built-in Themes** - Dark, Light, Midnight, Emerald, Rose, and Ocean
- **Custom Theme Support** - Create and register your own themes
- **Lucide Icons Integration** - 150+ pre-mapped professional icons
- **Comprehensive Components** - Buttons, toggles, sliders, dropdowns, inputs, keybinds, and more
- **Notification System** - Toast-style notifications with auto-dismiss
- **Responsive Layouts** - Automatic content sizing and scrolling
- **Smooth Animations** - Multiple animation presets (Fast, Smooth, Bounce, Spring)
- **Section Organization** - Collapsible sections for better content structure

## Installation

### Method 1: Module Installation (Studio)

1. Download or clone this repository
2. Place the `Clover` folder in `ReplicatedStorage`
3. Require the module in your script:

```lua
local Clover = require(game.ReplicatedStorage.Clover)
```

### Method 2: Loadstring (Executors)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/sudo-dav25/Clover-UI/main/init.lua
"))()
```

## Quick Start

```lua
local Clover = require(game.ReplicatedStorage.Clover)

-- Create a window
local Window = Clover:CreateWindow({
    Title     = "My Application",
    SubTitle  = "Version 1.0.0",
    Icon      = "home",
    Theme     = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- Create a tab
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "settings",
})

-- Create a section
local Section = MainTab:CreateSection({
    Name = "Controls",
})

-- Add components
Section:CreateToggle({
    Name     = "Enable Feature",
    Default  = false,
    Callback = function(value)
        print("Toggle:", value)
    end,
})

Section:CreateSlider({
    Name      = "Speed",
    Min       = 0,
    Max       = 100,
    Default   = 50,
    Increment = 1,
    Suffix    = "%",
    Callback  = function(value)
        print("Slider:", value)
    end,
})
```

## Components

### Window

The main container for your UI.

```lua
local Window = Clover:CreateWindow({
    Title     = "Window Title",      -- Main title
    SubTitle  = "Subtitle text",     -- Optional subtitle
    Icon      = "icon-name",         -- Optional Lucide icon
    Theme     = "Dark",              -- Theme name or custom table
    ToggleKey = Enum.KeyCode.RightShift, -- Optional keybind to toggle
})
```

**Methods:**
- `Window:CreateTab(options)` - Create a new tab
- `Window:Hide()` - Toggle window visibility
- `Window:Minimize()` - Toggle minimized state
- `Window:Destroy()` - Remove window completely
- `Window:SetKeybind(keycode)` - Set toggle keybind

### Tab

Organize content into separate views.

```lua
local Tab = Window:CreateTab({
    Name = "Tab Name",
    Icon = "icon-name",  -- Optional Lucide icon
})
```

**Methods:**
- `Tab:CreateSection(options)` - Create a section container
- `Tab:Select()` - Activate this tab
- Direct component creation methods (see Components section)

### Section

Collapsible container for grouping components.

```lua
local Section = Tab:CreateSection({
    Name      = "Section Name",
    Collapsed = false,  -- Optional, defaults to false
})
```

**Methods:**
- `Section:Toggle()` - Toggle collapsed state
- All component creation methods (see below)

### Button

Clickable button with callback.

```lua
Section:CreateButton({
    Name        = "Button Text",
    Description = "Optional description",  -- Optional
    Callback    = function()
        print("Button clicked")
    end,
})
```

**Methods:**
- `Button:SetText(text)` - Update button text

### Toggle

Boolean on/off switch.

```lua
local Toggle = Section:CreateToggle({
    Name     = "Toggle Name",
    Default  = false,
    Callback = function(value)
        print("Toggled:", value)
    end,
})
```

**Methods:**
- `Toggle:Set(value, silent)` - Set value programmatically
- `Toggle:Toggle()` - Toggle current state

### Slider

Numeric value selector with draggable control.

```lua
local Slider = Section:CreateSlider({
    Name      = "Slider Name",
    Min       = 0,
    Max       = 100,
    Default   = 50,
    Increment = 1,
    Suffix    = "",  -- Optional unit suffix
    Callback  = function(value)
        print("Value:", value)
    end,
})
```

**Methods:**
- `Slider:Set(value, silent)` - Set value programmatically

### Dropdown

Single or multi-selection menu.

```lua
local Dropdown = Section:CreateDropdown({
    Name     = "Dropdown Name",
    Options  = {"Option 1", "Option 2", "Option 3"},
    Default  = "Option 1",
    Multi    = false,  -- Enable multi-select
    Callback = function(value)
        print("Selected:", value)
    end,
})
```

**Methods:**
- `Dropdown:Set(value, silent)` - Set selected value
- `Dropdown:GetValue()` - Get current value
- `Dropdown:Refresh(newOptions)` - Update options list

### Input

Text input field with validation.

```lua
local Input = Section:CreateInput({
    Name        = "Input Name",
    Placeholder = "Enter text...",
    Default     = "",
    MaxLength   = 100,
    Numeric     = false,  -- Numeric-only input
    Password    = false,  -- Hide input text
    Callback    = function(value, enterPressed)
        print("Input:", value)
    end,
})
```

**Methods:**
- `Input:Set(value, silent)` - Set value programmatically
- `Input:GetValue()` - Get current value

### Keybind

Key binding selector.

```lua
local Keybind = Section:CreateKeybind({
    Name     = "Keybind Name",
    Default  = Enum.KeyCode.E,
    Callback = function(keycode)
        print("Key pressed:", keycode.Name)
    end,
})
```

**Methods:**
- `Keybind:Set(keycode, silent)` - Set key programmatically
- `Keybind:GetValue()` - Get current keycode

### Label

Static text with optional icon.

```lua
Section:CreateLabel({
    Name = "Label text",
    Icon = "info",  -- Optional Lucide icon
})
```

**Methods:**
- `Label:Set(text)` - Update label text
- `Label:SetIcon(iconName)` - Update icon

### Paragraph

Multi-line text block with title.

```lua
Section:CreateParagraph({
    Title   = "Paragraph Title",
    Content = "Multiple lines of text content...",
    Icon    = "file-text",  -- Optional Lucide icon
})
```

**Methods:**
- `Paragraph:Set(title, content)` - Update content

### Divider

Visual separator with optional label.

```lua
Section:CreateDivider({
    Label = "Section Name",  -- Optional
    Icon  = "minus",         -- Optional Lucide icon
})
```

## Notifications

Display temporary toast notifications.

```lua
Clover:Notify({
    Title    = "Notification Title",
    Content  = "Notification message",
    Type     = "info",  -- info, success, warning, error
    Duration = 4,       -- seconds
})
```

## Theming

### Using Built-in Themes

```lua
Clover:SetTheme("Midnight")
```

Available themes: `Dark`, `Light`, `Midnight`, `Emerald`, `Rose`, `Ocean`

### Creating Custom Themes

```lua
Clover:RegisterTheme("CustomTheme", {
    Background          = Color3.fromRGB(15, 15, 20),
    SecondaryBackground = Color3.fromRGB(22, 22, 30),
    TertiaryBackground  = Color3.fromRGB(30, 30, 40),
    Accent              = Color3.fromRGB(100, 180, 255),
    AccentDark          = Color3.fromRGB(70, 128, 220),
    Text                = Color3.fromRGB(240, 240, 250),
    SubText             = Color3.fromRGB(160, 160, 180),
    Outline             = Color3.fromRGB(50, 50, 74),
    Success             = Color3.fromRGB(80, 200, 120),
    Warning             = Color3.fromRGB(255, 180, 50),
    Error               = Color3.fromRGB(255, 80, 80),
    CornerRadius        = UDim.new(0, 8),
    Transparency        = 0.04,
})

Clover:SetTheme("CustomTheme")
```

### Inline Theme Customization

```lua
local Window = Clover:CreateWindow({
    Title = "Custom Theme",
    Theme = {
        Background = Color3.fromRGB(10, 10, 15),
        Accent     = Color3.fromRGB(255, 100, 150),
        -- Override specific colors
    }
})
```

## Lucide Icons

Clover includes 150+ pre-mapped Lucide icons. Icons can be used in windows, tabs, labels, paragraphs, and dividers.

### Available Icon Categories

- **Navigation**: home, search, menu, settings
- **User**: user, users, user-circle, user-check
- **Actions**: plus, minus, check, close, edit, trash, save
- **Media**: play, pause, stop, volume, mic, camera
- **Files**: file, folder, image, archive
- **Communication**: bell, mail, message, phone
- **Indicators**: info, warn, error, success, alert
- **Interface**: eye, lock, star, heart, bookmark
- **Arrows**: arrow-up, chevron-down, external-link
- **Gaming**: gamepad, trophy, target, sword, shield
- **Tools**: wrench, filter, sliders, maximize
- **Data & Tech**: code, terminal, cpu, database, wifi
- **And many more...**

### Using Icons

```lua
-- In window
local Window = Clover:CreateWindow({
    Icon = "sword",
})

-- In tab
local Tab = Window:CreateTab({
    Icon = "settings",
})

-- In components
Section:CreateLabel({
    Name = "Label with icon",
    Icon = "info",
})

Section:CreateDivider({
    Label = "Section",
    Icon  = "minus",
})
```

### Custom Icon Registration

```lua
-- Register custom Roblox asset
Clover:RegisterIcon("my-icon", "rbxassetid://123456789")

-- Register custom Lucide icon mapping
Clover:RegisterLucideIcon("rocket", "rocket")
```

### Icon Implementation Notes

The library uses a lookup table for Lucide icons in `Assets/Icons.lua`. By default, placeholder asset IDs are used. For production:

1. Download Lucide icons as PNG files
2. Upload to Roblox as image assets
3. Replace placeholder IDs in `LucideAssetIds` table
4. Or use emoji fallbacks for executor compatibility

## Executor Compatibility

Clover is designed to work with popular script executors. For optimal compatibility:

### Single-File Bundle

For executors that don't support multi-file requires, use a bundled version or loadstring from a remote source.

### Icon Fallbacks

If Lucide icon assets are unavailable:

```lua
-- Use emoji fallbacks
local emojiIcons = {
    ["home"] = "🏠",
    ["search"] = "🔍",
    ["settings"] = "⚙️",
}
```

### Blur Effect

Some executors may not support Lighting effects. The library handles this gracefully with error catching.

## Project Structure

```
ReplicatedStorage/
└── Clover/
    ├── Clover.lua              # Main entry point
    ├── Core/
    │   ├── Animation.lua       # Animation system
    │   ├── Theme.lua           # Theme manager
    │   ├── Utility.lua         # Helper functions
    │   ├── Window.lua          # Window container
    │   ├── Tab.lua             # Tab system
    │   └── Section.lua         # Section container
    ├── Components/
    │   ├── Button.lua
    │   ├── Toggle.lua
    │   ├── Slider.lua
    │   ├── Dropdown.lua
    │   ├── Input.lua
    │   ├── Keybind.lua
    │   ├── Label.lua
    │   ├── Paragraph.lua
    │   ├── Divider.lua
    │   └── Notification.lua
    └── Assets/
        └── Icons.lua           # Icon registry
```

## Best Practices

### Component Organization

```lua
-- Group related components in sections
local PlayerSection = Tab:CreateSection({ Name = "Player" })
PlayerSection:CreateSlider({ Name = "WalkSpeed", ... })
PlayerSection:CreateSlider({ Name = "JumpPower", ... })

local CombatSection = Tab:CreateSection({ Name = "Combat" })
CombatSection:CreateToggle({ Name = "Aimbot", ... })
```

### Value Management

```lua
-- Store component references for programmatic updates
local SpeedSlider = Section:CreateSlider({ Name = "Speed", ... })

-- Update later
SpeedSlider:Set(75)
```

### Callbacks

```lua
-- Use callbacks for reactive behavior
Section:CreateToggle({
    Name = "Auto Farm",
    Callback = function(enabled)
        if enabled then
            startAutoFarm()
        else
            stopAutoFarm()
        end
    end,
})
```

### Theme Switching

```lua
-- Create theme selector
local SettingsTab = Window:CreateTab({ Name = "Settings" })
SettingsTab:CreateDropdown({
    Name     = "Theme",
    Options  = {"Dark", "Light", "Midnight", "Emerald", "Rose", "Ocean"},
    Default  = "Dark",
    Callback = function(theme)
        Clover:SetTheme(theme)
    end,
})
```

## API Reference

### Global Methods

| Method | Description |
|--------|-------------|
| `Clover:CreateWindow(options)` | Create a new window instance |
| `Clover:Notify(options)` | Display a notification |
| `Clover:SetTheme(name, customData)` | Change active theme |
| `Clover:RegisterTheme(name, data)` | Register new theme |
| `Clover:GetTheme()` | Get current theme data |
| `Clover:RegisterIcon(name, assetId)` | Register custom icon |
| `Clover:RegisterLucideIcon(customName, lucideName)` | Map custom name to Lucide icon |

### Component Methods

All components support these common patterns:

- `Set(value, silent)` - Update value programmatically (silent skips callback)
- `GetValue()` - Retrieve current value (where applicable)
- Callback functions receive the new value as first parameter

## Examples

### Complete Script Example

```lua
local Clover = require(game.ReplicatedStorage.Clover)

-- Initialize window
local Window = Clover:CreateWindow({
    Title     = "Script Hub",
    SubTitle  = "Premium Edition",
    Icon      = "zap",
    Theme     = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- Player tab
local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "user",
})

local MovementSection = PlayerTab:CreateSection({ Name = "Movement" })

MovementSection:CreateSlider({
    Name      = "Walk Speed",
    Min       = 16,
    Max       = 500,
    Default   = 16,
    Increment = 1,
    Callback  = function(speed)
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = speed
    end,
})

MovementSection:CreateSlider({
    Name      = "Jump Power",
    Min       = 50,
    Max       = 500,
    Default   = 50,
    Increment = 1,
    Callback  = function(power)
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.JumpPower = power
    end,
})

-- Combat tab
local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "crosshair",
})

local AimbotSection = CombatTab:CreateSection({ Name = "Aimbot" })

local aimbotEnabled = false
AimbotSection:CreateToggle({
    Name     = "Enable Aimbot",
    Default  = false,
    Callback = function(enabled)
        aimbotEnabled = enabled
    end,
})

AimbotSection:CreateSlider({
    Name      = "FOV",
    Min       = 10,
    Max       = 360,
    Default   = 90,
    Increment = 1,
    Suffix    = "°",
    Callback  = function(fov)
        -- Update FOV circle
    end,
})

-- Settings tab
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
})

SettingsTab:CreateDivider({ Label = "Appearance" })

SettingsTab:CreateDropdown({
    Name     = "Theme",
    Options  = {"Dark", "Light", "Midnight", "Emerald", "Rose", "Ocean"},
    Default  = "Dark",
    Callback = function(theme)
        Clover:SetTheme(theme)
    end,
})

SettingsTab:CreateKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightShift,
    Callback = function(key)
        Window:SetKeybind(key)
    end,
})

SettingsTab:CreateDivider({ Label = "About" })

SettingsTab:CreateParagraph({
    Title   = "Information",
    Content = "Clover UI Library - A modern interface solution for Roblox scripts.",
    Icon    = "info",
})

-- Success notification
Clover:Notify({
    Title    = "Script Loaded",
    Content  = "All systems initialized successfully.",
    Type     = "success",
    Duration = 4,
})
```

## License

This project is provided as-is for educational and development purposes.

## Contributing

Contributions, issues, and feature requests are welcome.

## Support

For bug reports, feature requests, or questions, please open an issue on the repository.

**Warm regards** - Dava25
