local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local Utility   = require(script.Parent.Utility)
local Animation = require(script.Parent.Animation)
local Tab       = require(script.Parent.Tab)

local Window = {}
Window.__index = Window

function Window.new(options, theme)
    local self = setmetatable({}, Window)

    self.Title     = options.Title     or "Clover"
    self.SubTitle  = options.SubTitle  or ""
    self.Icon      = options.Icon
    self.Theme     = theme
    self.Tabs      = {}
    self.ActiveTab = nil
    self._visible  = true
    self._minimized = false

    self:_Build()

    return self
end

function Window:_Build()
    local t = self.Theme:Get()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gui = Utility.Create("ScreenGui", {
        Name            = "CloverUI",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        DisplayOrder    = 100,
        Parent          = playerGui,
    })

    local blur = Instance.new("BlurEffect")
    blur.Size   = 0
    blur.Parent = game:GetService("Lighting")
    self._blur  = blur

    local main = Utility.Create("Frame", {
        Name             = "Window",
        Size             = UDim2.new(0, 600, 0, 460),
        Position         = UDim2.new(0.5, -300, 0.5, -230),
        BackgroundColor3 = t.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        Parent           = gui,
    })
    Utility.ApplyCorner(main, UDim.new(0, 12))
    Utility.ApplyStroke(main, t.Outline, 1)

    local shadow = Utility.Create("ImageLabel", {
        Name             = "Shadow",
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Size             = UDim2.new(1, 40, 1, 40),
        Position         = UDim2.new(0.5, 0, 0.5, 6),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://6014261993",
        ImageColor3      = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(49, 49, 450, 450),
        ZIndex           = 0,
        Parent           = main,
    })

    local titleBar = Utility.Create("Frame", {
        Name             = "TitleBar",
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        Parent           = main,
    })
    Utility.ApplyCorner(titleBar, UDim.new(0, 12))

    Utility.Create("Frame", {
        Name             = "BottomCover",
        Size             = UDim2.new(1, 0, 0, 12),
        Position         = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        Parent           = titleBar,
    })

    Utility.ApplyStroke(titleBar, t.Outline, 1)

    local logoFrame = Utility.Create("Frame", {
        Name             = "Logo",
        Size             = UDim2.new(0, 30, 0, 30),
        Position         = UDim2.new(0, 14, 0.5, -15),
        BackgroundColor3 = t.Accent,
        BorderSizePixel  = 0,
        Parent           = titleBar,
    })
    Utility.ApplyCorner(logoFrame, UDim.new(0, 7))

    if self.Icon then
        Utility.ApplyIcon(logoFrame, self.Icon, 16, Color3.fromRGB(255,255,255),
            UDim2.new(0.5, -8, 0.5, -8))
    else
        Utility.Create("TextLabel", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text             = string.sub(self.Title, 1, 1),
            TextColor3       = Color3.fromRGB(255, 255, 255),
            TextSize         = 16,
            Font             = Enum.Font.GothamBold,
            Parent           = logoFrame,
        })
    end

    local titleLabel = Utility.Create("TextLabel", {
        Name             = "Title",
        Size             = UDim2.new(0, 200, 0, 18),
        Position         = UDim2.new(0, 52, 0, 10),
        BackgroundTransparency = 1,
        Text             = self.Title,
        TextColor3       = t.Text,
        TextSize         = 15,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = titleBar,
    })

    local subLabel = Utility.Create("TextLabel", {
        Name             = "SubTitle",
        Size             = UDim2.new(0, 200, 0, 14),
        Position         = UDim2.new(0, 52, 0, 28),
        BackgroundTransparency = 1,
        Text             = self.SubTitle,
        TextColor3       = t.SubText,
        TextSize         = 11,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = titleBar,
    })

    Utility.Create("Frame", {
        Name             = "AccentLine",
        Size             = UDim2.new(0, 36, 0, 3),
        Position         = UDim2.new(0, 14, 1, -3),
        BackgroundColor3 = t.Accent,
        BorderSizePixel  = 0,
        Parent           = titleBar,
    })

    local controls = Utility.Create("Frame", {
        Name             = "Controls",
        Size             = UDim2.new(0, 80, 0, 26),
        Position         = UDim2.new(1, -94, 0.5, -13),
        BackgroundTransparency = 1,
        Parent           = titleBar,
    })
    Utility.ApplyListLayout(controls, Enum.FillDirection.Horizontal, UDim.new(0, 4))

    local function makeCtrl(icon, iconFallback, onClick, hoverColor)
        local btn = Utility.Create("TextButton", {
            Size             = UDim2.new(0, 24, 0, 24),
            BackgroundColor3 = t.TertiaryBackground,
            BorderSizePixel  = 0,
            Text             = "",
            AutoButtonColor  = false,
            Parent           = controls,
        })
        Utility.ApplyCorner(btn, UDim.new(0, 6))

        local iconEl = Utility.ApplyIcon(btn, icon, 12,
            t.SubText, UDim2.new(0.5, -6, 0.5, -6))
        if not iconEl then
            Utility.Create("TextLabel", {
                Size             = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text             = iconFallback,
                TextColor3       = t.SubText,
                TextSize         = 14,
                Font             = Enum.Font.GothamBold,
                Parent           = btn,
            })
        end

        Utility.ConnectHover(btn,
            function()
                Animation.Tween(btn,
                    { BackgroundColor3 = hoverColor or t.Outline }, "Fast")
            end,
            function()
                Animation.Tween(btn,
                    { BackgroundColor3 = t.TertiaryBackground }, "Fast")
            end
        )
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    makeCtrl("minimize", "−", function() self:Minimize() end)
    makeCtrl("maximize", "□", function() self:Minimize() end)
    makeCtrl("close",    "×", function() self:Hide() end,
        Color3.fromRGB(255, 80, 80))

    local body = Utility.Create("Frame", {
        Name             = "Body",
        Size             = UDim2.new(1, 0, 1, -52),
        Position         = UDim2.new(0, 0, 0, 52),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent           = main,
    })

    local tabNav = Utility.Create("ScrollingFrame", {
        Name             = "TabNav",
        Size             = UDim2.new(0, 158, 1, 0),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        Parent           = body,
    })
    Utility.ApplyStroke(tabNav, t.Outline, 1)
    Utility.ApplyPadding(tabNav, 8, 8, 6, 6)
    local tabNavLayout = Utility.ApplyListLayout(tabNav,
        Enum.FillDirection.Vertical, UDim.new(0, 4))
    Utility.BindContentSize(tabNav, tabNavLayout)

    local contentArea = Utility.Create("Frame", {
        Name             = "ContentArea",
        Size             = UDim2.new(1, -158, 1, 0),
        Position         = UDim2.new(0, 158, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent           = body,
    })

    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    self._gui         = gui
    self._main        = main
    self._titleBar    = titleBar
    self._body        = body
    self._tabNav      = tabNav
    self._contentArea = contentArea

    main.Size = UDim2.new(0, 600, 0, 0)
    main.BackgroundTransparency = 1
    Animation.Tween(main, {
        Size                = UDim2.new(0, 600, 0, 460),
        BackgroundTransparency = t.Transparency,
    }, "Bounce")
    task.delay(0.1, function()
        Animation.Tween(self._blur, { Size = 12 }, "Smooth")
    end)
end

function Window:CreateTab(options)
    local tab = Tab.new(options, self)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        tab:Select()
    end
    return tab
end

function Window:Minimize()
    self._minimized = not self._minimized
    if self._minimized then
        Animation.Tween(self._body,  { Size = UDim2.new(1, 0, 0, 0) }, "Smooth")
        Animation.Tween(self._main,  { Size = UDim2.new(0, 600, 0, 52) }, "Smooth")
    else
        Animation.Tween(self._main,  { Size = UDim2.new(0, 600, 0, 460) }, "Bounce")
        Animation.Tween(self._body,  { Size = UDim2.new(1, 0, 1, -52) }, "Bounce")
    end
end

function Window:Hide()
    self._visible = not self._visible
    if self._visible then
        self._main.Visible = true
        Animation.Tween(self._main, {
            Size = UDim2.new(0, 600, 0, 460),
            BackgroundTransparency = self.Theme:Get().Transparency,
        }, "Bounce")
        Animation.Tween(self._blur, { Size = 12 }, "Smooth")
    else
        Animation.Tween(self._main, {
            Size = UDim2.new(0, 600, 0, 0),
            BackgroundTransparency = 1,
        }, "Smooth")
        Animation.Tween(self._blur, { Size = 0 }, "Smooth")
        task.delay(0.3, function()
            if not self._visible then
                self._main.Visible = false
            end
        end)
    end
end

function Window:Destroy()
    Animation.Tween(self._main, {
        Size = UDim2.new(0, 600, 0, 0),
        BackgroundTransparency = 1,
    }, "Smooth")
    Animation.Tween(self._blur, { Size = 0 }, "Smooth")
    task.delay(0.4, function()
        self._gui:Destroy()
        if self._blur then self._blur:Destroy() end
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

return Window
