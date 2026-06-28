local Utility   = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Button = {}
Button.__index = Button

function Button.new(options, parent)
    local self = setmetatable({}, Button)

    self.Name        = options.Name or "Button"
    self.Description = options.Description
    self.Callback    = options.Callback or function() end
    self.Parent      = parent

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    return self
end

function Button:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local h = self.Description and 54 or 38

    local frame = Utility.Create("Frame", {
        Name             = "Button_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, h),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel  = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)

    local btn = Utility.Create("TextButton", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = "",
        AutoButtonColor  = false,
        Parent           = frame,
    })

    if self.Description then
        local nameLabel = Utility.Create("TextLabel", {
            Name             = "Name",
            Size             = UDim2.new(1, -40, 0, 18),
            Position         = UDim2.new(0, 14, 0, 10),
            BackgroundTransparency = 1,
            Text             = self.Name,
            TextColor3       = t.Text,
            TextSize         = 13,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            Parent           = frame,
        })

        local descLabel = Utility.Create("TextLabel", {
            Name             = "Desc",
            Size             = UDim2.new(1, -40, 0, 14),
            Position         = UDim2.new(0, 14, 0, 28),
            BackgroundTransparency = 1,
            Text             = self.Description,
            TextColor3       = t.SubText,
            TextSize         = 11,
            Font             = Enum.Font.Gotham,
            TextXAlignment   = Enum.TextXAlignment.Left,
            Parent           = frame,
        })
    else
        local nameLabel = Utility.Create("TextLabel", {
            Name             = "Name",
            Size             = UDim2.new(1, -40, 1, 0),
            Position         = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text             = self.Name,
            TextColor3       = t.Text,
            TextSize         = 13,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            Parent           = frame,
        })
    end

    local arrow = Utility.Create("TextLabel", {
        Name             = "Arrow",
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Text             = "→",
        TextColor3       = t.Accent,
        TextSize         = 15,
        Font             = Enum.Font.GothamBold,
        Parent           = frame,
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

    self._frame = frame
    self._btn   = btn
end

function Button:SetText(text)
    self.Name = text
    self._frame:FindFirstChild("Name").Text = text
end

return Button
