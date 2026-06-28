local Players  = game:GetService("Players")
local Utility  = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Notification = {}
Notification.__index = Notification

local NotifTypes = {
    success = { icon = "check-circle", color = "Success" },
    error   = { icon = "alert-circle", color = "Error"   },
    warning = { icon = "alert-triangle", color = "Warning" },
    info    = { icon = "info",           color = "Accent"  },
}

local _gui    = nil
local _stack  = nil
local _count  = 0

local function getStack(t)
    if _gui and _gui.Parent then return _stack end

    local player    = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    _gui = Utility.Create("ScreenGui", {
        Name           = "CloverNotifs",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 200,
        Parent         = playerGui,
    })

    _stack = Utility.Create("Frame", {
        Name             = "Stack",
        Size             = UDim2.new(0, 320, 1, 0),
        Position         = UDim2.new(1, -336, 0, 0),
        BackgroundTransparency = 1,
        Parent           = _gui,
    })
    Utility.ApplyPadding(_stack, 16, 16, 0, 0)
    Utility.ApplyListLayout(_stack,
        Enum.FillDirection.Vertical,
        UDim.new(0, 8),
        Enum.HorizontalAlignment.Right,
        Enum.VerticalAlignment.Bottom
    )

    return _stack
end

function Notification.new(options, theme)
    local self = setmetatable({}, Notification)

    self.Title    = options.Title    or "Notification"
    self.Content  = options.Content  or ""
    self.Type     = options.Type     or "info"
    self.Duration = options.Duration or 4

    local t    = theme:Get()
    local nType = NotifTypes[self.Type] or NotifTypes.info
    local accentColor = t[nType.color] or t.Accent
    local stack = getStack(t)

    _count += 1

    local card = Utility.Create("Frame", {
        Name             = "Notif_" .. _count,
        Size             = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        Position         = UDim2.new(1, 20, 0, 0),
        Parent           = stack,
    })
    Utility.ApplyCorner(card, UDim.new(0, 10))
    Utility.ApplyStroke(card, t.Outline, 1)

    local accentBar = Utility.Create("Frame", {
        Name             = "Accent",
        Size             = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Parent           = card,
    })
    Utility.ApplyCorner(accentBar, UDim.new(0, 10))

    Utility.Create("Frame", {
        Size             = UDim2.new(0, 6, 1, 0),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Parent           = accentBar,
    })

    local iconEl = Utility.ApplyIcon(
        card,
        nType.icon,
        18,
        accentColor,
        UDim2.new(0, 16, 0, 14)
    )

    Utility.Create("TextLabel", {
        Name             = "Title",
        Size             = UDim2.new(1, -70, 0, 18),
        Position         = UDim2.new(0, 42, 0, 12),
        BackgroundTransparency = 1,
        Text             = self.Title,
        TextColor3       = t.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = card,
    })

    local closeBtn = Utility.Create("TextButton", {
        Name             = "Close",
        Size             = UDim2.new(0, 20, 0, 20),
        Position         = UDim2.new(1, -28, 0, 10),
        BackgroundTransparency = 1,
        Text             = "×",
        TextColor3       = t.SubText,
        TextSize         = 18,
        Font             = Enum.Font.GothamBold,
        AutoButtonColor  = false,
        Parent           = card,
    })

    Utility.Create("TextLabel", {
        Name             = "Content",
        Size             = UDim2.new(1, -52, 0, 22),
        Position         = UDim2.new(0, 42, 0, 30),
        BackgroundTransparency = 1,
        Text             = self.Content,
        TextColor3       = t.SubText,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        Parent           = card,
    })

    local progressBg = Utility.Create("Frame", {
        Name             = "ProgressBg",
        Size             = UDim2.new(1, 0, 0, 3),
        Position         = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = t.Outline,
        BorderSizePixel  = 0,
        Parent           = card,
    })
    Utility.ApplyCorner(progressBg, UDim.new(0, 10))

    local progressFill = Utility.Create("Frame", {
        Name             = "Fill",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Parent           = progressBg,
    })
    Utility.ApplyCorner(progressFill, UDim.new(0, 10))

    Animation.Tween(card,
        { Position = UDim2.new(0, 0, 0, 0) }, "Bounce")

    Animation.Tween(progressFill,
        { Size = UDim2.new(0, 0, 1, 0) },
        nil,
        TweenInfo.new(self.Duration, Enum.EasingStyle.Linear)
    )

    local function dismiss()
        Animation.Tween(card,
            { Position = UDim2.new(1, 20, 0, 0),
              BackgroundTransparency = 1 },
            "Smooth"
        )
        task.delay(0.3, function()
            if card and card.Parent then
                card:Destroy()
            end
        end)
    end

    closeBtn.MouseButton1Click:Connect(dismiss)
    task.delay(self.Duration, dismiss)

    Utility.ConnectHover(card,
        function()
            Animation.Tween(card,
                { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end,
        function()
            Animation.Tween(card,
                { BackgroundColor3 = t.SecondaryBackground }, "Fast")
        end
    )

    self._card = card
    return self
end

return Notification
