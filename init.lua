local Clover = {}
Clover.__index = Clover

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Utility = {}

function Utility.Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utility.ApplyCorner(instance, radius)
    return Utility.Create("UICorner", {
        CornerRadius = radius or UDim.new(0, 8),
        Parent = instance,
    })
end

function Utility.ApplyStroke(instance, color, thickness)
    return Utility.Create("UIStroke", {
        Color = color or Color3.fromRGB(50, 50, 74),
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = instance,
    })
end

function Utility.ApplyPadding(instance, top, bottom, left, right)
    return Utility.Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = instance,
    })
end

function Utility.ApplyListLayout(instance, direction, padding, halign, valign, sort)
    return Utility.Create("UIListLayout", {
        FillDirection = direction or Enum.FillDirection.Vertical,
        Padding = padding or UDim.new(0, 0),
        HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
        VerticalAlignment = valign or Enum.VerticalAlignment.Top,
        SortOrder = sort or Enum.SortOrder.LayoutOrder,
        Parent = instance,
    })
end

function Utility.BindContentSize(scrollFrame, listLayout)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
end

function Utility.ConnectHover(instance, onEnter, onLeave)
    instance.MouseEnter:Connect(onEnter)
    instance.MouseLeave:Connect(onLeave)
end

function Utility.CreateLucideIcon(parent, lucideName, size, color, position)
    local iconMap = {
        ["home"] = "🏠", ["search"] = "🔍", ["settings"] = "⚙️",
        ["user"] = "👤", ["users"] = "👥", ["bell"] = "🔔",
        ["mail"] = "✉️", ["star"] = "⭐", ["heart"] = "❤️",
        ["plus"] = "➕", ["minus"] = "➖", ["check"] = "✓",
        ["close"] = "✕", ["info"] = "ℹ️", ["warning"] = "⚠️",
        ["error"] = "❌", ["success"] = "✓", ["edit"] = "✏️",
        ["trash"] = "🗑️", ["save"] = "💾", ["download"] = "⬇️",
        ["upload"] = "⬆️", ["refresh"] = "🔄", ["sync"] = "🔄",
        ["lock"] = "🔒", ["unlock"] = "🔓", ["eye"] = "👁️",
        ["eye-off"] = "👁️", ["calendar"] = "📅", ["clock"] = "🕐",
        ["map"] = "🗺️", ["compass"] = "🧭", ["target"] = "🎯",
        ["zap"] = "⚡", ["sun"] = "☀️", ["moon"] = "🌙",
        ["cloud"] = "☁️", ["shield"] = "🛡️", ["sword"] = "⚔️",
        ["gamepad"] = "🎮", ["trophy"] = "🏆", ["gift"] = "🎁",
        ["bookmark"] = "🔖", ["tag"] = "🏷️", ["flag"] = "🚩",
        ["file"] = "📄", ["folder"] = "📁", ["image"] = "🖼️",
        ["video"] = "🎥", ["music"] = "🎵", ["mic"] = "🎤",
        ["volume"] = "🔊", ["camera"] = "📷", ["phone"] = "📞",
        ["message"] = "💬", ["at"] = "@", ["hash"] = "#",
        ["dollar"] = "$", ["percent"] = "%", ["code"] = "💻",
        ["terminal"] = "⌨️", ["database"] = "💾", ["server"] = "🖥️",
        ["wifi"] = "📶", ["bluetooth"] = "📡", ["power"] = "⚡",
        ["battery"] = "🔋", ["plug"] = "🔌", ["printer"] = "🖨️",
        ["monitor"] = "🖥️", ["smartphone"] = "📱", ["tablet"] = "📱",
        ["watch"] = "⌚", ["package"] = "📦", ["inbox"] = "📥",
        ["archive"] = "📦", ["paperclip"] = "📎", ["link"] = "🔗",
        ["external-link"] = "↗️", ["maximize"] = "⤢", ["minimize"] = "⤡",
        ["menu"] = "☰", ["more-vertical"] = "⋮", ["more-horizontal"] = "⋯",
        ["chevron-up"] = "▲", ["chevron-down"] = "▼", ["chevron-left"] = "◀",
        ["chevron-right"] = "▶", ["arrow-up"] = "↑", ["arrow-down"] = "↓",
        ["arrow-left"] = "←", ["arrow-right"] = "→", ["corner-down-right"] = "↳",
        ["trending-up"] = "📈", ["trending-down"] = "📉", ["activity"] = "📊",
        ["bar-chart"] = "📊", ["pie-chart"] = "📊", ["git-branch"] = "🌿",
        ["git-commit"] = "●", ["git-merge"] = "⚡", ["layers"] = "▦",
        ["layout"] = "▦", ["grid"] = "▦", ["list"] = "☰",
        ["columns"] = "▦", ["sidebar"] = "▦", ["square"] = "□",
        ["circle"] = "○", ["triangle"] = "△", ["hexagon"] = "⬡",
        ["octagon"] = "⬢", ["crosshair"] = "⊕", ["aperture"] = "◉",
        ["disc"] = "●", ["radio"] = "◉", ["feather"] = "🪶",
        ["palette"] = "🎨", ["droplet"] = "💧", ["flame"] = "🔥",
        ["thermometer"] = "🌡️", ["umbrella"] = "☂️", ["anchor"] = "⚓",
        ["award"] = "🏅", ["briefcase"] = "💼", ["codesandbox"] = "📦",
        ["cpu"] = "🖥️", ["credit-card"] = "💳", ["filter"] = "🔍",
        ["gitlab"] = "🦊", ["github"] = "🐙", ["key"] = "🔑",
        ["life-buoy"] = "🛟", ["loader"] = "⌛", ["pocket"] = "👝",
        ["rss"] = "📡", ["scissors"] = "✂️", ["send"] = "📤",
        ["shopping-bag"] = "🛍️", ["shopping-cart"] = "🛒", ["sliders"] = "🎚️",
        ["tool"] = "🔧", ["wrench"] = "🔧", ["truck"] = "🚚",
        ["umbrella"] = "☂️", ["voicemail"] = "📞", ["watch"] = "⌚",
        ["wifi-off"] = "📵", ["x-circle"] = "⊗", ["x-octagon"] = "⊗",
        ["x-square"] = "⊗", ["zoom-in"] = "🔍", ["zoom-out"] = "🔍",
    }
    
    return Utility.Create("TextLabel", {
        Name = "Icon_" .. lucideName,
        Size = UDim2.new(0, size, 0, size),
        Position = position,
        BackgroundTransparency = 1,
        Text = iconMap[lucideName] or "•",
        TextColor3 = color,
        TextSize = size,
        Font = Enum.Font.GothamBold,
        Parent = parent,
    })
end

function Utility.ApplyIcon(parent, iconName, size, color, position)
    return Utility.CreateLucideIcon(parent, iconName, size, color, position)
end

local Animation = {}

Animation.Presets = {
    Fast   = { Time = 0.15, Style = Enum.EasingStyle.Quad,   Direction = Enum.EasingDirection.Out },
    Smooth = { Time = 0.25, Style = Enum.EasingStyle.Quart,  Direction = Enum.EasingDirection.Out },
    Bounce = { Time = 0.4,  Style = Enum.EasingStyle.Back,   Direction = Enum.EasingDirection.Out },
    Spring = { Time = 0.5,  Style = Enum.EasingStyle.Elastic, Direction = Enum.EasingDirection.Out },
}

function Animation.Tween(instance, properties, preset, customInfo)
    local info
    if customInfo then
        info = customInfo
    elseif preset and Animation.Presets[preset] then
        local p = Animation.Presets[preset]
        info = TweenInfo.new(p.Time, p.Style, p.Direction)
    else
        info = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    end
    
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local Theme = {}
Theme.__index = Theme

Theme.Presets = {
    Dark = {
        Background          = Color3.fromRGB(18, 18, 24),
        SecondaryBackground = Color3.fromRGB(24, 24, 32),
        TertiaryBackground  = Color3.fromRGB(32, 32, 42),
        Accent              = Color3.fromRGB(138, 180, 248),
        AccentDark          = Color3.fromRGB(100, 140, 220),
        Text                = Color3.fromRGB(240, 240, 250),
        SubText             = Color3.fromRGB(160, 160, 180),
        Outline             = Color3.fromRGB(50, 50, 74),
        Success             = Color3.fromRGB(102, 220, 150),
        Warning             = Color3.fromRGB(255, 180, 80),
        Error               = Color3.fromRGB(255, 100, 100),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    
    Light = {
        Background          = Color3.fromRGB(250, 250, 252),
        SecondaryBackground = Color3.fromRGB(240, 240, 245),
        TertiaryBackground  = Color3.fromRGB(230, 230, 238),
        Accent              = Color3.fromRGB(70, 130, 255),
        AccentDark          = Color3.fromRGB(50, 100, 220),
        Text                = Color3.fromRGB(30, 30, 40),
        SubText             = Color3.fromRGB(100, 100, 120),
        Outline             = Color3.fromRGB(200, 200, 215),
        Success             = Color3.fromRGB(60, 180, 100),
        Warning             = Color3.fromRGB(220, 140, 40),
        Error               = Color3.fromRGB(220, 60, 60),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    
    Midnight = {
        Background          = Color3.fromRGB(10, 12, 20),
        SecondaryBackground = Color3.fromRGB(16, 18, 28),
        TertiaryBackground  = Color3.fromRGB(22, 24, 36),
        Accent              = Color3.fromRGB(120, 140, 255),
        AccentDark          = Color3.fromRGB(80, 100, 220),
        Text                = Color3.fromRGB(230, 235, 255),
        SubText             = Color3.fromRGB(140, 145, 180),
        Outline             = Color3.fromRGB(40, 42, 64),
        Success             = Color3.fromRGB(90, 200, 140),
        Warning             = Color3.fromRGB(240, 170, 70),
        Error               = Color3.fromRGB(240, 90, 90),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    
    Emerald = {
        Background          = Color3.fromRGB(16, 22, 20),
        SecondaryBackground = Color3.fromRGB(22, 30, 26),
        TertiaryBackground  = Color3.fromRGB(28, 38, 34),
        Accent              = Color3.fromRGB(80, 200, 140),
        AccentDark          = Color3.fromRGB(60, 160, 110),
        Text                = Color3.fromRGB(230, 250, 240),
        SubText             = Color3.fromRGB(150, 180, 165),
        Outline             = Color3.fromRGB(45, 60, 52),
        Success             = Color3.fromRGB(70, 220, 150),
        Warning             = Color3.fromRGB(250, 180, 70),
        Error               = Color3.fromRGB(255, 100, 100),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    
    Rose = {
        Background          = Color3.fromRGB(24, 18, 20),
        SecondaryBackground = Color3.fromRGB(32, 24, 28),
        TertiaryBackground  = Color3.fromRGB(40, 32, 36),
        Accent              = Color3.fromRGB(255, 120, 160),
        AccentDark          = Color3.fromRGB(220, 90, 130),
        Text                = Color3.fromRGB(250, 240, 245),
        SubText             = Color3.fromRGB(180, 160, 170),
        Outline             = Color3.fromRGB(60, 50, 55),
        Success             = Color3.fromRGB(100, 210, 140),
        Warning             = Color3.fromRGB(255, 170, 80),
        Error               = Color3.fromRGB(255, 90, 120),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    
    Ocean = {
        Background          = Color3.fromRGB(14, 20, 26),
        SecondaryBackground = Color3.fromRGB(20, 28, 36),
        TertiaryBackground  = Color3.fromRGB(26, 36, 46),
        Accent              = Color3.fromRGB(80, 180, 240),
        AccentDark          = Color3.fromRGB(60, 140, 200),
        Text                = Color3.fromRGB(230, 240, 250),
        SubText             = Color3.fromRGB(150, 170, 190),
        Outline             = Color3.fromRGB(40, 56, 70),
        Success             = Color3.fromRGB(80, 200, 180),
        Warning             = Color3.fromRGB(240, 180, 90),
        Error               = Color3.fromRGB(240, 100, 120),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
}

function Theme.new(themeName)
    local self = setmetatable({}, Theme)
    self.Current = themeName or "Dark"
    self.CustomThemes = {}
    return self
end

function Theme:Get()
    if self.CustomThemes[self.Current] then
        return self.CustomThemes[self.Current]
    end
    return Theme.Presets[self.Current] or Theme.Presets.Dark
end

function Theme:Set(themeName, customData)
    if customData then
        self.CustomThemes[themeName] = customData
    end
    self.Current = themeName
end

function Theme:Register(name, data)
    self.CustomThemes[name] = data
end

local Window = {}
Window.__index = Window

function Window.new(options, theme)
    local self = setmetatable({}, Window)
    
    self.Title = options.Title or "Clover"
    self.SubTitle = options.SubTitle or ""
    self.Icon = options.Icon
    self.Theme = theme
    self.Tabs = {}
    self.ActiveTab = nil
    self._visible = true
    self._minimized = false
    
    self:_Build()
    
    if options.ToggleKey then
        self:SetKeybind(options.ToggleKey)
    end
    
    return self
end

function Window:_Build()
    local t = self.Theme:Get()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local gui = Utility.Create("ScreenGui", {
        Name = "CloverUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = playerGui,
    })
    
    local success, blur = pcall(function()
        local b = Instance.new("BlurEffect")
        b.Size = 0
        b.Parent = game:GetService("Lighting")
        return b
    end)
    
    if success then
        self._blur = blur
        Animation.Tween(blur, { Size = 14 }, "Smooth")
    end
    
    local main = Utility.Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = t.Background,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = gui,
    })
    Utility.ApplyCorner(main, UDim.new(0, 12))
    
    Animation.Tween(main, {
        Size = UDim2.new(0, 600, 0, 420),
        BackgroundTransparency = t.Transparency,
    }, "Bounce")
    
    local titleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = main,
    })
    Utility.ApplyCorner(titleBar, UDim.new(0, 12))
    Utility.Create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = titleBar,
    })
    
    if self.Icon then
        Utility.ApplyIcon(titleBar, self.Icon, 20, t.Accent, UDim2.new(0, 16, 0.5, -10))
    end
    
    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 0, 18),
        Position = UDim2.new(0, self.Icon and 44 or 16, 0, 10),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = t.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })
    
    if self.SubTitle ~= "" then
        Utility.Create("TextLabel", {
            Name = "SubTitle",
            Size = UDim2.new(0, 200, 0, 14),
            Position = UDim2.new(0, self.Icon and 44 or 16, 0, 28),
            BackgroundTransparency = 1,
            Text = self.SubTitle,
            TextColor3 = t.SubText,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleBar,
        })
    end
    
    local minimizeBtn = Utility.Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0.5, -15),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
        Text = "−",
        TextColor3 = t.SubText,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = titleBar,
    })
    Utility.ApplyCorner(minimizeBtn, UDim.new(0, 6))
    
    local closeBtn = Utility.Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -34, 0.5, -15),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = t.SubText,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = titleBar,
    })
    Utility.ApplyCorner(closeBtn, UDim.new(0, 6))
    
    minimizeBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    Utility.ConnectHover(minimizeBtn,
        function()
            Animation.Tween(minimizeBtn, { BackgroundColor3 = t.Background }, "Fast")
        end,
        function()
            Animation.Tween(minimizeBtn, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end
    )
    
    Utility.ConnectHover(closeBtn,
        function()
            Animation.Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(255, 80, 80) }, "Fast")
        end,
        function()
            Animation.Tween(closeBtn, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end
    )
    
    local divider = Utility.Create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = t.Outline,
        BorderSizePixel = 0,
        Parent = main,
    })
    
    local container = Utility.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = main,
    })
    
    local tabNav = Utility.Create("Frame", {
        Name = "TabNav",
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = container,
    })
    Utility.ApplyCorner(tabNav, UDim.new(0, 12))
    
    local tabNavList = Utility.Create("ScrollingFrame", {
        Name = "List",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = t.Outline,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = tabNav,
    })
    Utility.ApplyPadding(tabNavList, 8, 8, 0, 0)
    local navLayout = Utility.ApplyListLayout(tabNavList, Enum.FillDirection.Vertical, UDim.new(0, 4))
    Utility.BindContentSize(tabNavList, navLayout)
    
    local contentArea = Utility.Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -186, 1, 0),
        Position = UDim2.new(0, 186, 0, 0),
        BackgroundTransparency = 1,
        Parent = container,
    })
    
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Animation.Tween(main, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, "Fast")
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    self._gui = gui
    self._main = main
    self._titleBar = titleBar
    self._tabNav = tabNavList
    self._contentArea = contentArea
end

function Window:CreateTab(options)
    local Tab = {}
    Tab.__index = Tab
    
    function Tab.new(opts, window)
        local tab = setmetatable({}, Tab)
        tab.Name = opts.Name or "Tab"
        tab.Icon = opts.Icon
        tab.Window = window
        tab.Active = false
        tab.Sections = {}
        tab:_Build()
        return tab
    end
    
    function Tab:_Build()
        local t = self.Window.Theme:Get()
        
        local btn = Utility.Create("TextButton", {
            Name = "Tab_" .. self.Name,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = self.Window._tabNav,
        })
        
        local indicator = Utility.Create("Frame", {
            Name = "Indicator",
            Size = UDim2.new(0, 3, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            BackgroundColor3 = t.Accent,
            BorderSizePixel = 0,
            Visible = false,
            Parent = btn,
        })
        Utility.ApplyCorner(indicator, UDim.new(1, 0))
        
        if self.Icon then
            local iconLabel = Utility.ApplyIcon(btn, self.Icon, 16, t.SubText, UDim2.new(0, 12, 0.5, -8))
            self._iconLabel = iconLabel
        end
        
        local nameLabel = Utility.Create("TextLabel", {
            Name = "Name",
            Size = UDim2.new(1, self.Icon and -40 or -20, 0, 18),
            Position = UDim2.new(0, self.Icon and 34 or 12, 0.5, -9),
            BackgroundTransparency = 1,
            Text = self.Name,
            TextColor3 = t.SubText,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn,
        })
        
        btn.MouseButton1Click:Connect(function()
            self:Select()
        end)
        
        Utility.ConnectHover(btn,
            function()
                if not self.Active then
                    Animation.Tween(btn, { BackgroundTransparency = 0.97 }, "Fast")
                end
            end,
            function()
                if not self.Active then
                    Animation.Tween(btn, { BackgroundTransparency = 1 }, "Fast")
                end
            end
        )
        
                local contentFrame = Utility.Create("ScrollingFrame", {
            Name = "Content_" .. self.Name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = t.Outline,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = self.Window._contentArea,
        })
        Utility.ApplyPadding(contentFrame, 10, 10, 8, 10)
        local contentLayout = Utility.ApplyListLayout(contentFrame, Enum.FillDirection.Vertical, UDim.new(0, 8))
        Utility.BindContentSize(contentFrame, contentLayout)
        
        self._btn = btn
        self._indicator = indicator
        self._nameLabel = nameLabel
        self._iconLabel = self._iconLabel
        self._contentFrame = contentFrame
        self._content = contentFrame
    end
    
    function Tab:Select()
        for _, tab in ipairs(self.Window.Tabs) do
            tab.Active = false
            tab._contentFrame.Visible = false
            tab._indicator.Visible = false
            Animation.Tween(tab._btn, { BackgroundTransparency = 1 }, "Fast")
            Animation.Tween(tab._nameLabel, { TextColor3 = self.Window.Theme:Get().SubText }, "Fast")
            if tab._iconLabel then
                Animation.Tween(tab._iconLabel, { TextColor3 = self.Window.Theme:Get().SubText }, "Fast")
            end
        end
        
        self.Active = true
        self._contentFrame.Visible = true
        self._indicator.Visible = true
        local t = self.Window.Theme:Get()
        Animation.Tween(self._btn, { BackgroundTransparency = 0.97 }, "Fast")
        Animation.Tween(self._nameLabel, { TextColor3 = t.Text }, "Fast")
        if self._iconLabel then
            Animation.Tween(self._iconLabel, { TextColor3 = t.Accent }, "Fast")
        end
        
        self.Window.ActiveTab = self
    end
    
    function Tab:CreateSection(opts)
        local Section = {}
        Section.__index = Section
        
        function Section.new(options, parent)
            local section = setmetatable({}, Section)
            section.Name = options.Name or "Section"
            section.Collapsed = options.Collapsed or false
            section.Parent = parent
            section.Tab = parent
            section:_Build()
            return section
        end
        
        function Section:_Build()
            local t = self.Tab.Window.Theme:Get()
            
            local frame = Utility.Create("Frame", {
                Name = "Section_" .. self.Name,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = t.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = self.Parent._contentFrame,
            })
            Utility.ApplyCorner(frame, UDim.new(0, 9))
            Utility.ApplyStroke(frame, t.Outline, 1)
            
            local header = Utility.Create("TextButton", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = frame,
            })
            
            local headerLabel = Utility.Create("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = string.upper(self.Name),
                TextColor3 = t.SubText,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = header,
            })
            
            local chevron = Utility.Create("TextLabel", {
                Name = "Chevron",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -28, 0.5, -8),
                BackgroundTransparency = 1,
                Text = "▾",
                TextColor3 = t.SubText,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = header,
            })
            
            local divider = Utility.Create("Frame", {
                Name = "Divider",
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = t.Outline,
                BorderSizePixel = 0,
                Parent = header,
            })
            
            local content = Utility.Create("Frame", {
                Name = "Content",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 36),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ClipsDescendants = false,
                Parent = frame,
            })
            Utility.ApplyPadding(content, 8, 10, 10, 10)
            Utility.ApplyListLayout(content, Enum.FillDirection.Vertical, UDim.new(0, 6))
            
            header.MouseButton1Click:Connect(function()
                self:Toggle()
            end)
            
            Utility.ConnectHover(header,
                function()
                    Animation.Tween(header, { BackgroundTransparency = 0.98 }, "Fast")
                end,
                function()
                    Animation.Tween(header, { BackgroundTransparency = 1 }, "Fast")
                end
            )
            
            if self.Collapsed then
                content.Visible = false
                chevron.Rotation = -90
            end
            
            self._frame = frame
            self._header = header
            self._chevron = chevron
            self._content = content
        end
        
        function Section:Toggle()
            self.Collapsed = not self.Collapsed
            if self.Collapsed then
                Animation.Tween(self._chevron, { Rotation = -90 }, "Smooth")
                self._content.Visible = false
            else
                Animation.Tween(self._chevron, { Rotation = 0 }, "Smooth")
                self._content.Visible = true
            end
        end
        
        function Section:CreateButton(options)
            return CreateButton(options, self)
        end
        
        function Section:CreateToggle(options)
            return CreateToggle(options, self)
        end
        
        function Section:CreateSlider(options)
            return CreateSlider(options, self)
        end
        
        function Section:CreateDropdown(options)
            return CreateDropdown(options, self)
        end
        
        function Section:CreateInput(options)
            return CreateInput(options, self)
        end
        
        function Section:CreateKeybind(options)
            return CreateKeybind(options, self)
        end
        
        function Section:CreateLabel(options)
            return CreateLabel(options, self)
        end
        
        function Section:CreateParagraph(options)
            return CreateParagraph(options, self)
        end
        
        function Section:CreateDivider(options)
            return CreateDivider(options, self)
        end
        
        local section = Section.new(opts, self)
        table.insert(self.Sections, section)
        return section
    end
    
    function Tab:CreateButton(options)
        return CreateButton(options, self)
    end
    
    function Tab:CreateToggle(options)
        return CreateToggle(options, self)
    end
    
    function Tab:CreateSlider(options)
        return CreateSlider(options, self)
    end
    
    function Tab:CreateDropdown(options)
        return CreateDropdown(options, self)
    end
    
    function Tab:CreateInput(options)
        return CreateInput(options, self)
    end
    
    function Tab:CreateKeybind(options)
        return CreateKeybind(options, self)
    end
    
    function Tab:CreateLabel(options)
        return CreateLabel(options, self)
    end
    
    function Tab:CreateParagraph(options)
        return CreateParagraph(options, self)
    end
    
    function Tab:CreateDivider(options)
        return CreateDivider(options, self)
    end
    
    local tab = Tab.new(options, self)
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        tab:Select()
    end
    
    return tab
end

function Window:Hide()
    self._visible = not self._visible
    if self._visible then
        self._main.Visible = true
        Animation.Tween(self._main, { Size = UDim2.new(0, 600, 0, 420) }, "Bounce")
        if self._blur then
            Animation.Tween(self._blur, { Size = 14 }, "Smooth")
        end
    else
        Animation.Tween(self._main, { Size = UDim2.new(0, 600, 0, 0) }, "Smooth")
        if self._blur then
            Animation.Tween(self._blur, { Size = 0 }, "Smooth")
        end
        task.delay(0.3, function()
            if not self._visible then
                self._main.Visible = false
            end
        end)
    end
end

function Window:Minimize()
    self._minimized = not self._minimized
    if self._minimized then
        Animation.Tween(self._main, { Size = UDim2.new(0, 600, 0, 50) }, "Smooth")
    else
        Animation.Tween(self._main, { Size = UDim2.new(0, 600, 0, 420) }, "Smooth")
    end
end

function Window:Destroy()
    Animation.Tween(self._main, {
        Size = UDim2.new(0, 600, 0, 0),
        BackgroundTransparency = 1,
    }, "Smooth")
    if self._blur then
        Animation.Tween(self._blur, { Size = 0 }, "Smooth")
    end
    task.delay(0.4, function()
        self._gui:Destroy()
        if self._blur then
            self._blur:Destroy()
        end
    end)
end

function Window:SetKeybind(key)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == key then
            self:Hide()
        end
    end)
end

function CreateButton(options, parent)
    local Button = {}
    Button.__index = Button
    
    local self = setmetatable({}, Button)
    self.Name = options.Name or "Button"
    self.Description = options.Description
    self.Callback = options.Callback or function() end
    self.Parent = parent
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    local h = self.Description and 54 or 38
    
    local frame = Utility.Create("Frame", {
        Name = "Button_" .. self.Name,
        Size = UDim2.new(1, 0, 0, h),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    
    local btn = Utility.Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = frame,
    })
    
    if self.Description then
        Utility.Create("TextLabel", {
            Name = "Name",
            Size = UDim2.new(1, -40, 0, 18),
            Position = UDim2.new(0, 14, 0, 10),
            BackgroundTransparency = 1,
            Text = self.Name,
            TextColor3 = t.Text,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame,
        })
        
        Utility.Create("TextLabel", {
            Name = "Desc",
            Size = UDim2.new(1, -40, 0, 14),
            Position = UDim2.new(0, 14, 0, 28),
            BackgroundTransparency = 1,
            Text = self.Description,
            TextColor3 = t.SubText,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame,
        })
    else
        Utility.Create("TextLabel", {
            Name = "Name",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text = self.Name,
            TextColor3 = t.Text,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame,
        })
    end
    
    local arrow = Utility.Create("TextLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Text = "→",
        TextColor3 = t.Accent,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        Parent = frame,
    })
    
    btn.MouseButton1Click:Connect(function()
        Animation.Tween(frame, { Size = UDim2.new(1, 0, 0, h - 2) }, "Fast")
        task.delay(0.08, function()
            Animation.Tween(frame, { Size = UDim2.new(1, 0, 0, h) }, "Bounce")
        end)
        Animation.Tween(arrow, { Position = UDim2.new(1, -24, 0.5, -8) }, "Fast")
        task.delay(0.15, function()
            Animation.Tween(arrow, { Position = UDim2.new(1, -28, 0.5, -8) }, "Smooth")
        end)
        self.Callback()
    end)
    
    Utility.ConnectHover(btn,
        function()
            Animation.Tween(frame, { BackgroundColor3 = t.Background }, "Fast")
        end,
        function()
            Animation.Tween(frame, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end
    )
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._btn = btn
    
    function self:SetText(text)
        self.Name = text
        self._frame:FindFirstChild("Name").Text = text
    end
    
    return self
end

function CreateToggle(options, parent)
    local Toggle = {}
    Toggle.__index = Toggle
    
    local self = setmetatable({}, Toggle)
    self.Name = options.Name or "Toggle"
    self.Default = options.Default or false
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Value = self.Default
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Toggle_" .. self.Name,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    
    local btn = Utility.Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = frame,
    })
    
    Utility.Create("TextLabel", {
        Name = "Name",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = t.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
    
    local track = Utility.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -52, 0.5, -11),
        BackgroundColor3 = t.Outline,
        BorderSizePixel = 0,
        Parent = frame,
    })
    Utility.ApplyCorner(track, UDim.new(1, 0))
    
    local knob = Utility.Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = track,
    })
    Utility.ApplyCorner(knob, UDim.new(1, 0))
    
    btn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    Utility.ConnectHover(btn,
        function()
            Animation.Tween(frame, { BackgroundColor3 = t.Background }, "Fast")
        end,
        function()
            Animation.Tween(frame, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end
    )
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._track = track
    self._knob = knob
    
    function self:Toggle()
        self:Set(not self.Value)
    end
    
    function self:Set(value, silent)
        self.Value = value
        local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
        
        if value then
            Animation.Tween(self._track, { BackgroundColor3 = t.Accent }, "Smooth")
            Animation.Tween(self._knob, { Position = UDim2.new(0, 21, 0.5, -8) }, "Bounce")
        else
            Animation.Tween(self._track, { BackgroundColor3 = t.Outline }, "Smooth")
            Animation.Tween(self._knob, { Position = UDim2.new(0, 3, 0.5, -8) }, "Bounce")
        end
        
        if not silent then
            self.Callback(value)
        end
    end
    
    if self.Default then
        self:Set(true, true)
    end
    
    return self
end

function CreateSlider(options, parent)
    local Slider = {}
    Slider.__index = Slider
    
    local self = setmetatable({}, Slider)
    self.Name = options.Name or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Increment = options.Increment or 1
    self.Suffix = options.Suffix or ""
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Value = self.Default
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Slider_" .. self.Name,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    
    Utility.Create("TextLabel", {
        Name = "Name",
        Size = UDim2.new(0, 200, 0, 16),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = t.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
    
    local valueLabel = Utility.Create("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0, 80, 0, 16),
        Position = UDim2.new(1, -94, 0, 10),
        BackgroundTransparency = 1,
        Text = tostring(self.Default) .. self.Suffix,
        TextColor3 = t.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame,
    })
    
    local trackBg = Utility.Create("Frame", {
        Name = "TrackBg",
        Size = UDim2.new(1, -28, 0, 6),
        Position = UDim2.new(0, 14, 1, -18),
        BackgroundColor3 = t.Outline,
        BorderSizePixel = 0,
        Parent = frame,
    })
    Utility.ApplyCorner(trackBg, UDim.new(1, 0))
    
    local trackFill = Utility.Create("Frame", {
        Name = "TrackFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = t.Accent,
        BorderSizePixel = 0,
        Parent = trackBg,
    })
    Utility.ApplyCorner(trackFill, UDim.new(1, 0))
    
    local knob = Utility.Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, -7, 0.5, -7),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = t.Accent,
        BorderSizePixel = 0,
        Parent = trackFill,
    })
    Utility.ApplyCorner(knob, UDim.new(1, 0))
    
    local dragging = false
    
    local function updateValue(input)
        local relX = math.clamp((input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        local raw = self.Min + (self.Max - self.Min) * relX
        local val = math.floor(raw / self.Increment + 0.5) * self.Increment
        val = math.clamp(val, self.Min, self.Max)
        self:Set(val)
    end
    
    trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Utility.ConnectHover(frame,
        function()
            Animation.Tween(knob, {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, -9, 0.5, -9),
            }, "Fast")
        end,
        function()
            Animation.Tween(knob, {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, -7, 0.5, -7),
            }, "Fast")
        end
    )
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._valueLabel = valueLabel
    self._trackBg = trackBg
    self._trackFill = trackFill
    self._knob = knob
    
    function self:Set(value, silent)
        self.Value = math.clamp(value, self.Min, self.Max)
        local pct = (self.Value - self.Min) / (self.Max - self.Min)
        
        self._valueLabel.Text = tostring(self.Value) .. self.Suffix
        Animation.Tween(self._trackFill, { Size = UDim2.new(pct, 0, 1, 0) }, "Fast")
        
        if not silent then
            self.Callback(self.Value)
        end
    end
    
    self:Set(self.Default, true)
    
    return self
end

function CreateDropdown(options, parent)
    local Dropdown = {}
    Dropdown.__index = Dropdown
    
    local self = setmetatable({}, Dropdown)
    self.Name = options.Name or "Dropdown"
    self.Options = options.Options or {}
    self.Default = options.Default
    self.Multi = options.Multi or false
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Value = self.Multi and {} or nil
    self.Open = false
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Dropdown_" .. self.Name,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 2,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    
    Utility.Create("TextLabel", {
        Name = "Name",
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = t.SubText,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
    
    local selected = Utility.Create("TextLabel", {
        Name = "Selected",
        Size = UDim2.new(1, -44, 0, 16),
        Position = UDim2.new(0, 14, 0, 28),
        BackgroundTransparency = 1,
        Text = "Select...",
        TextColor3 = t.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    })
    
    local chevronIcon = Utility.ApplyIcon(frame, "chevron-down", 14, t.SubText, UDim2.new(1, -28, 0.5, -7))
    
    local hitbox = Utility.Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 3,
        Parent = frame,
    })
    
    local list = Utility.Create("Frame", {
        Name = "List",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 6),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = frame,
    })
    Utility.ApplyCorner(list, UDim.new(0, 8))
    Utility.ApplyStroke(list, t.Outline, 1)
    
    local listScroll = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = t.Outline,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = list,
    })
    Utility.ApplyPadding(listScroll, 6, 6, 6, 6)
    local listLayout = Utility.ApplyListLayout(listScroll, Enum.FillDirection.Vertical, UDim.new(0, 3))
        Utility.BindContentSize(listScroll, listLayout)
    
    for _, optName in ipairs(self.Options) do
        local optBtn = Utility.Create("TextButton", {
            Name = "Opt_" .. optName,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = t.TertiaryBackground,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 11,
            Parent = listScroll,
        })
        Utility.ApplyCorner(optBtn, UDim.new(0, 6))
        
        Utility.Create("TextLabel", {
            Size = UDim2.new(1, -36, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = optName,
            TextColor3 = t.Text,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 11,
            Parent = optBtn,
        })
        
        local checkIcon = Utility.Create("Frame", {
            Name = "Check",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -26, 0.5, -8),
            BackgroundColor3 = t.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 11,
            Parent = optBtn,
        })
        Utility.ApplyCorner(checkIcon, UDim.new(1, 0))
        
        Utility.Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "✓",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            ZIndex = 12,
            Parent = checkIcon,
        })
        
        optBtn.MouseButton1Click:Connect(function()
            if self.Multi then
                self:_ToggleMulti(optName)
            else
                self:Set(optName)
                self:_Close()
            end
        end)
        
        Utility.ConnectHover(optBtn,
            function()
                Animation.Tween(optBtn, { BackgroundTransparency = 0.94 }, "Fast")
            end,
            function()
                local isSelected = self.Multi
                    and table.find(self.Value, optName)
                    or self.Value == optName
                Animation.Tween(optBtn, { BackgroundTransparency = isSelected and 0.90 or 1 }, "Fast")
            end
        )
    end
    
    hitbox.MouseButton1Click:Connect(function()
        if self.Open then
            self:_Close()
        else
            self:_Open()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.Open then
                local mPos = UserInputService:GetMouseLocation()
                local abs = list.AbsolutePosition
                local size = list.AbsoluteSize
                if mPos.X < abs.X or mPos.X > abs.X + size.X
                or mPos.Y < abs.Y or mPos.Y > abs.Y + size.Y then
                    self:_Close()
                end
            end
        end
    end)
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._selected = selected
    self._list = list
    self._listScroll = listScroll
    self._chevronIcon = chevronIcon
    self._t = t
    
    function self:_Open()
        self.Open = true
        local itemCount = math.min(#self.Options, 5)
        local listH = itemCount * 38 + 12
        self._list.Visible = true
        self._list.Size = UDim2.new(1, 0, 0, 0)
        Animation.Tween(self._list, { Size = UDim2.new(1, 0, 0, listH) }, "Bounce")
        if self._chevronIcon then
            Animation.Tween(self._chevronIcon, { Rotation = 180 }, "Smooth")
        end
    end
    
    function self:_Close()
        self.Open = false
        Animation.Tween(self._list, { Size = UDim2.new(1, 0, 0, 0) }, "Smooth")
        task.delay(0.25, function()
            if not self.Open then
                self._list.Visible = false
            end
        end)
        if self._chevronIcon then
            Animation.Tween(self._chevronIcon, { Rotation = 0 }, "Smooth")
        end
    end
    
    function self:Set(value, silent)
        self.Value = value
        self._selected.Text = tostring(value)
        for _, optBtn in ipairs(self._listScroll:GetChildren()) do
            if optBtn:IsA("TextButton") then
                local checkIcon = optBtn:FindFirstChild("Check")
                if checkIcon then
                    local isSelected = optBtn.Name == "Opt_" .. tostring(value)
                    Animation.Tween(checkIcon, { BackgroundTransparency = isSelected and 0 or 1 }, "Fast")
                    Animation.Tween(optBtn, { BackgroundTransparency = isSelected and 0.90 or 1 }, "Fast")
                end
            end
        end
        if not silent then
            self.Callback(value)
        end
    end
    
    function self:_ToggleMulti(optName)
        local idx = table.find(self.Value, optName)
        if idx then
            table.remove(self.Value, idx)
        else
            table.insert(self.Value, optName)
        end
        for _, optBtn in ipairs(self._listScroll:GetChildren()) do
            if optBtn:IsA("TextButton") then
                local checkIcon = optBtn:FindFirstChild("Check")
                if checkIcon then
                    local name = optBtn.Name:sub(5)
                    local isSelected = table.find(self.Value, name) ~= nil
                    Animation.Tween(checkIcon, { BackgroundTransparency = isSelected and 0 or 1 }, "Fast")
                    Animation.Tween(optBtn, { BackgroundTransparency = isSelected and 0.90 or 1 }, "Fast")
                end
            end
        end
        if #self.Value == 0 then
            self._selected.Text = "Select..."
        elseif #self.Value == 1 then
            self._selected.Text = self.Value[1]
        else
            self._selected.Text = self.Value[1] .. " (+" .. (#self.Value - 1) .. ")"
        end
        self.Callback(self.Value)
    end
    
    function self:GetValue()
        return self.Value
    end
    
    function self:Refresh(newOptions)
        self.Options = newOptions
        for _, child in ipairs(self._listScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        self.Value = self.Multi and {} or nil
        self._selected.Text = "Select..."
    end
    
    if self.Default then
        self:Set(self.Default, true)
    end
    
    return self
end

function CreateInput(options, parent)
    local Input = {}
    Input.__index = Input
    
    local self = setmetatable({}, Input)
    self.Name = options.Name or "Input"
    self.Placeholder = options.Placeholder or "Enter text..."
    self.Default = options.Default or ""
    self.MaxLength = options.MaxLength or 100
    self.Numeric = options.Numeric or false
    self.Password = options.Password or false
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Value = self.Default
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Input_" .. self.Name,
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    
    Utility.Create("TextLabel", {
        Name = "Name",
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = t.SubText,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
    
    local inputBox = Utility.Create("TextBox", {
        Name = "InputBox",
        Size = UDim2.new(1, -28, 0, 22),
        Position = UDim2.new(0, 14, 0, 26),
        BackgroundTransparency = 1,
        Text = self.Default,
        PlaceholderText = self.Placeholder,
        TextColor3 = t.Text,
        PlaceholderColor3 = t.SubText,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = frame,
    })
    
    local dots
    if self.Password then
        inputBox.TextTransparency = 1
        dots = Utility.Create("TextLabel", {
            Name = "Dots",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = t.Text,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = inputBox,
        })
    end
    
    inputBox.Focused:Connect(function()
        Animation.Tween(frame, { BackgroundColor3 = t.Background }, "Fast")
        local stroke = frame:FindFirstChildWhichIsA("UIStroke")
        if stroke then
            Animation.Tween(stroke, { Color = t.Accent }, "Fast")
        end
    end)
    
    inputBox.FocusLost:Connect(function(enter)
        Animation.Tween(frame, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        local stroke = frame:FindFirstChildWhichIsA("UIStroke")
        if stroke then
            Animation.Tween(stroke, { Color = t.Outline }, "Fast")
        end
        local val = inputBox.Text
        if self.Numeric then
            val = tonumber(val) or self.Value
            inputBox.Text = tostring(val)
        end
        if #tostring(val) > self.MaxLength then
            val = string.sub(tostring(val), 1, self.MaxLength)
            inputBox.Text = val
        end
        self.Value = val
        if dots then
            dots.Text = string.rep("•", #tostring(val))
        end
        self.Callback(val, enter)
    end)
    
    if self.Password then
        inputBox:GetPropertyChangedSignal("Text"):Connect(function()
            if dots then
                dots.Text = string.rep("•", #inputBox.Text)
            end
        end)
    end
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._inputBox = inputBox
    
    function self:Set(value, silent)
        self.Value = value
        self._inputBox.Text = tostring(value)
        if not silent then
            self.Callback(value)
        end
    end
    
    function self:GetValue()
        return self.Value
    end
    
    return self
end

function CreateKeybind(options, parent)
    local Keybind = {}
    Keybind.__index = Keybind
    
    local self = setmetatable({}, Keybind)
    self.Name = options.Name or "Keybind"
    self.Default = options.Default or Enum.KeyCode.Unknown
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Value = self.Default
    self.Binding = false
    
    local KeyNames = {
        [Enum.KeyCode.LeftControl]  = "L.Ctrl",
        [Enum.KeyCode.RightControl] = "R.Ctrl",
        [Enum.KeyCode.LeftShift]    = "L.Shift",
        [Enum.KeyCode.RightShift]   = "R.Shift",
        [Enum.KeyCode.LeftAlt]      = "L.Alt",
        [Enum.KeyCode.RightAlt]     = "R.Alt",
        [Enum.KeyCode.Space]        = "Space",
        [Enum.KeyCode.Return]       = "Enter",
        [Enum.KeyCode.BackSpace]    = "Backspace",
        [Enum.KeyCode.Tab]          = "Tab",
        [Enum.KeyCode.Escape]       = "Escape",
        [Enum.KeyCode.CapsLock]     = "Caps",
        [Enum.KeyCode.Delete]       = "Delete",
        [Enum.KeyCode.Insert]       = "Insert",
        [Enum.KeyCode.Home]         = "Home",
        [Enum.KeyCode.End]          = "End",
        [Enum.KeyCode.PageUp]       = "PgUp",
        [Enum.KeyCode.PageDown]     = "PgDn",
        [Enum.KeyCode.Up]           = "Up",
        [Enum.KeyCode.Down]         = "Down",
        [Enum.KeyCode.Left]         = "Left",
        [Enum.KeyCode.Right]        = "Right",
        [Enum.KeyCode.F1]           = "F1",
        [Enum.KeyCode.F2]           = "F2",
        [Enum.KeyCode.F3]           = "F3",
        [Enum.KeyCode.F4]           = "F4",
        [Enum.KeyCode.F5]           = "F5",
        [Enum.KeyCode.F6]           = "F6",
        [Enum.KeyCode.F7]           = "F7",
        [Enum.KeyCode.F8]           = "F8",
        [Enum.KeyCode.F9]           = "F9",
        [Enum.KeyCode.F10]          = "F10",
        [Enum.KeyCode.F11]          = "F11",
        [Enum.KeyCode.F12]          = "F12",
    }
    
    local IGNORED_KEYS = {
        Enum.KeyCode.Unknown,
        Enum.KeyCode.W, Enum.KeyCode.A,
        Enum.KeyCode.S, Enum.KeyCode.D,
    }
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Keybind_" .. self.Name,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    
    Utility.Create("TextLabel", {
        Name = "Name",
        Size = UDim2.new(1, -110, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = t.Text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })
    
    local badge = Utility.Create("TextButton", {
        Name = "Badge",
        Size = UDim2.new(0, 90, 0, 26),
        Position = UDim2.new(1, -100, 0.5, -13),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel = 0,
        Text = KeyNames[self.Default] or self.Default.Name,
        TextColor3 = t.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = frame,
    })
    Utility.ApplyCorner(badge, UDim.new(0, 6))
    Utility.ApplyStroke(badge, t.Outline, 1)
    
    badge.MouseButton1Click:Connect(function()
        if self.Binding then
            self:_StopBinding()
        else
            self:_StartBinding()
        end
    end)
    
    Utility.ConnectHover(frame,
        function()
            Animation.Tween(frame, { BackgroundColor3 = t.Background }, "Fast")
        end,
        function()
            Animation.Tween(frame, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end
    )
    
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if self.Binding then
            for _, ignore in ipairs(IGNORED_KEYS) do
                if input.KeyCode == ignore then return end
            end
            self:Set(input.KeyCode)
            self:_StopBinding()
            return
        end
        if input.KeyCode == self.Value then
            self.Callback(self.Value)
        end
    end)
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._badge = badge
    self._t = t
    self._KeyNames = KeyNames
    
    function self:_StartBinding()
        self.Binding = true
        self._badge.Text = "..."
        Animation.Tween(self._badge, { BackgroundColor3 = self._t.Accent }, "Fast")
        Animation.Tween(self._badge, { TextColor3 = Color3.fromRGB(255, 255, 255) }, "Fast")
    end
    
    function self:_StopBinding()
        self.Binding = false
        Animation.Tween(self._badge, { BackgroundColor3 = self._t.SecondaryBackground }, "Fast")
        Animation.Tween(self._badge, { TextColor3 = self._t.Accent }, "Fast")
    end
    
    function self:Set(keyCode, silent)
        self.Value = keyCode
        self._badge.Text = self._KeyNames[keyCode] or keyCode.Name
        if not silent then
            self.Callback(keyCode)
        end
    end
    
    function self:GetValue()
        return self.Value
    end
    
    return self
end

function CreateLabel(options, parent)
    local Label = {}
    Label.__index = Label
    
    local self = setmetatable({}, Label)
    self.Name = options.Name or "Label"
    self.Icon = options.Icon
    self.Parent = parent
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Label_" .. self.Name,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })
    
    local iconEl
    if self.Icon then
        iconEl = Utility.ApplyIcon(frame, self.Icon, 14, t.SubText, UDim2.new(0, 4, 0.5, -7))
    end
    
    local textLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, self.Icon and -26 or -8, 1, 0),
        Position = UDim2.new(0, self.Icon and 24 or 4, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = t.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = frame,
    })
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._textLabel = textLabel
    self._iconEl = iconEl
    
    function self:Set(text)
        self.Name = text
        self._textLabel.Text = text
    end
    
    function self:SetIcon(iconName)
        self.Icon = iconName
        if self._iconEl then
            self._iconEl:Destroy()
        end
        local theme = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
        self._iconEl = Utility.ApplyIcon(self._frame, iconName, 14, theme.SubText, UDim2.new(0, 4, 0.5, -7))
    end
    
    return self
end

function CreateParagraph(options, parent)
    local Paragraph = {}
    Paragraph.__index = Paragraph
    
    local self = setmetatable({}, Paragraph)
    self.Title = options.Title or "Paragraph"
    self.Content = options.Content or ""
    self.Icon = options.Icon
    self.Parent = parent
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Para_" .. self.Title,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    Utility.ApplyPadding(frame, 12, 12, 14, 14)
    
    local inner = Utility.Create("Frame", {
        Name = "Inner",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = frame,
    })
    Utility.ApplyListLayout(inner, Enum.FillDirection.Vertical, UDim.new(0, 6))
    
    local titleRow = Utility.Create("Frame", {
        Name = "TitleRow",
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Parent = inner,
    })
    
    if self.Icon then
        Utility.ApplyIcon(titleRow, self.Icon, 14, t.Accent, UDim2.new(0, 0, 0.5, -7))
    end
    
    Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, self.Icon and -22 or 0, 1, 0),
        Position = UDim2.new(0, self.Icon and 20 or 0, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = t.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleRow,
    })
    
    local contentLabel = Utility.Create("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = self.Content,
        TextColor3 = t.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = inner,
    })
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    self._contentLabel = contentLabel
    
    function self:Set(title, content)
        if title then
            self.Title = title
            local titleLabel = self._frame:FindFirstChild("Inner")
                and self._frame.Inner:FindFirstChild("TitleRow")
                and self._frame.Inner.TitleRow:FindFirstChild("Title")
            if titleLabel then
                titleLabel.Text = title
            end
        end
        if content then
            self.Content = content
            self._contentLabel.Text = content
        end
    end
    
    return self
end

function CreateDivider(options, parent)
    local Divider = {}
    Divider.__index = Divider
    
    local self = setmetatable({}, Divider)
    self.Label = options.Label
    self.Icon = options.Icon
    self.Parent = parent
    
    local t = parent.Tab and parent.Tab.Window.Theme:Get() or parent.Window.Theme:Get()
    
    local frame = Utility.Create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })
    
    if self.Label then
        Utility.Create("Frame", {
            Size = UDim2.new(0.3, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = t.Outline,
            BorderSizePixel = 0,
            Parent = frame,
        })
        
        local labelFrame = Utility.Create("Frame", {
            Size = UDim2.new(0, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            Position = UDim2.new(0.5, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Parent = frame,
        })
        Utility.ApplyListLayout(labelFrame, Enum.FillDirection.Horizontal,
            UDim.new(0, 4), Enum.HorizontalAlignment.Center)
        
        if self.Icon then
            Utility.ApplyIcon(labelFrame, self.Icon, 12, t.SubText, UDim2.new(0, 0, 0.5, -6))
        end
        
        Utility.Create("TextLabel", {
            Name = "Text",
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text = self.Label,
            TextColor3 = t.SubText,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            Parent = labelFrame,
        })
        
        Utility.Create("Frame", {
            Size = UDim2.new(0.3, 0, 0, 1),
            Position = UDim2.new(0.7, 0, 0.5, 0),
            BackgroundColor3 = t.Outline,
            BorderSizePixel = 0,
            Parent = frame,
        })
    else
        Utility.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = t.Outline,
            BorderSizePixel = 0,
            Parent = frame,
        })
    end
    
    local container = parent._content or parent._contentFrame
    frame.Parent = container
    
    self._frame = frame
    return self
end

local NotifGui = nil
local NotifStack = nil
local NotifCount = 0

local NotifTypes = {
    success = { icon = "check",   color = "Success" },
    error   = { icon = "close",   color = "Error"   },
    warning = { icon = "warning", color = "Warning" },
    info    = { icon = "info",    color = "Accent"  },
}

local function getNotifStack(t)
    if NotifGui and NotifGui.Parent then
        return NotifStack
    end
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    NotifGui = Utility.Create("ScreenGui", {
        Name = "CloverNotifs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 200,
        Parent = playerGui,
    })
    
    NotifStack = Utility.Create("Frame", {
        Name = "Stack",
        Size = UDim2.new(0, 320, 1, -20),
        Position = UDim2.new(1, -336, 0, 10),
        BackgroundTransparency = 1,
        Parent = NotifGui,
    })
    Utility.ApplyPadding(NotifStack, 0, 0, 0, 0)
    Utility.ApplyListLayout(NotifStack,
        Enum.FillDirection.Vertical,
        UDim.new(0, 8),
        Enum.HorizontalAlignment.Right,
        Enum.VerticalAlignment.Bottom
    )
    
    return NotifStack
end

local function CreateNotification(options, theme)
    local t = theme:Get()
    local nType = NotifTypes[options.Type] or NotifTypes.info
    local accentColor = t[nType.color] or t.Accent
    local stack = getNotifStack(t)
    local duration = options.Duration or 4
    
    NotifCount = NotifCount + 1
    
    local card = Utility.Create("Frame", {
        Name = "Notif_" .. NotifCount,
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 20, 0, 0),
        Parent = stack,
    })
    Utility.ApplyCorner(card, UDim.new(0, 10))
    Utility.ApplyStroke(card, t.Outline, 1)
    
    local accentBar = Utility.Create("Frame", {
        Name = "Accent",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = card,
    })
    Utility.ApplyCorner(accentBar, UDim.new(0, 10))
    Utility.Create("Frame", {
        Size = UDim2.new(0, 6, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = accentBar,
    })
    
    Utility.ApplyIcon(card, nType.icon, 18, accentColor, UDim2.new(0, 16, 0, 14))
    
    Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -70, 0, 18),
        Position = UDim2.new(0, 42, 0, 12),
        BackgroundTransparency = 1,
        Text = options.Title or "Notification",
        TextColor3 = t.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })
    
    Utility.Create("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, -52, 0, 22),
        Position = UDim2.new(0, 42, 0, 30),
        BackgroundTransparency = 1,
        Text = options.Content or "",
        TextColor3 = t.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = card,
    })
    
    local closeBtn = Utility.Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -28, 0, 10),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = t.SubText,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = card,
    })
    
    local progressBg = Utility.Create("Frame", {
        Name = "ProgressBg",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = t.Outline,
        BorderSizePixel = 0,
        Parent = card,
    })
    Utility.ApplyCorner(progressBg, UDim.new(0, 10))
    
    local progressFill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = progressBg,
    })
    Utility.ApplyCorner(progressFill, UDim.new(0, 10))
    
    Animation.Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, "Bounce")
    Animation.Tween(progressFill,
        { Size = UDim2.new(0, 0, 1, 0) },
        nil,
        TweenInfo.new(duration, Enum.EasingStyle.Linear)
    )
    
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        Animation.Tween(card, {
            Position = UDim2.new(1, 20, 0, 0),
            BackgroundTransparency = 1,
        }, "Smooth")
        task.delay(0.3, function()
            if card and card.Parent then
                card:Destroy()
            end
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(dismiss)
    task.delay(duration, dismiss)
    
    Utility.ConnectHover(card,
        function()
            Animation.Tween(card, { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end,
        function()
            Animation.Tween(card, { BackgroundColor3 = t.SecondaryBackground }, "Fast")
        end
    )
end

local _theme = Theme.new("Dark")
local _windows = {}
local _customIcons = {}

function Clover:CreateWindow(options)
    if type(options.Theme) == "table" then
        _theme:Register("__custom__", options.Theme)
        _theme:Set("__custom__")
    elseif options.Theme then
        _theme:Set(options.Theme)
    end
    
    local window = Window.new(options, _theme)
    table.insert(_windows, window)
    return window
end

function Clover:Notify(options)
    CreateNotification(options, _theme)
end

function Clover:SetTheme(name, customData)
    _theme:Set(name, customData)
end

function Clover:RegisterTheme(name, data)
    _theme:Register(name, data)
end

function Clover:GetTheme()
    return _theme:Get()
end

function Clover:RegisterIcon(name, assetId)
    _customIcons[name] = assetId
end

function Clover:RegisterLucideIcon(customName, lucideName)
    _customIcons[customName] = lucideName
end

return Clover