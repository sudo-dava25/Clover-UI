local UserInputService = game:GetService("UserInputService")
local Utility   = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Slider = {}
Slider.__index = Slider

function Slider.new(options, parent)
    local self = setmetatable({}, Slider)

    self.Name      = options.Name or "Slider"
    self.Min       = options.Min or 0
    self.Max       = options.Max or 100
    self.Default   = options.Default or self.Min
    self.Increment = options.Increment or 1
    self.Suffix    = options.Suffix or ""
    self.Callback  = options.Callback or function() end
    self.Parent    = parent
    self.Value     = self.Default

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    self:Set(self.Default, true)

    return self
end

function Slider:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Slider_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel  = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)

    local nameLabel = Utility.Create("TextLabel", {
        Name             = "Name",
        Size             = UDim2.new(0, 200, 0, 16),
        Position         = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = frame,
    })

    local valueLabel = Utility.Create("TextLabel", {
        Name             = "Value",
        Size             = UDim2.new(0, 80, 0, 16),
        Position         = UDim2.new(1, -94, 0, 10),
        BackgroundTransparency = 1,
        Text             = tostring(self.Default) .. self.Suffix,
        TextColor3       = t.Accent,
        TextSize         = 12,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Right,
        Parent           = frame,
    })

    local trackBg = Utility.Create("Frame", {
        Name             = "TrackBg",
        Size             = UDim2.new(1, -28, 0, 6),
        Position         = UDim2.new(0, 14, 1, -18),
        BackgroundColor3 = t.Outline,
        BorderSizePixel  = 0,
        Parent           = frame,
    })
    Utility.ApplyCorner(trackBg, UDim.new(1, 0))

    local trackFill = Utility.Create("Frame", {
        Name             = "TrackFill",
        Size             = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = t.Accent,
        BorderSizePixel  = 0,
        Parent           = trackBg,
    })
    Utility.ApplyCorner(trackFill, UDim.new(1, 0))

    local knob = Utility.Create("Frame", {
        Name             = "Knob",
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new(0, -7, 0.5, -7),
        AnchorPoint      = Vector2.new(0, 0.5),
        BackgroundColor3 = t.Accent,
        BorderSizePixel  = 0,
        Parent           = trackFill,
    })
    Utility.ApplyCorner(knob, UDim.new(1, 0))

    local dragging = false

    local function updateValue(input)
        local relX = math.clamp((input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        local raw  = self.Min + (self.Max - self.Min) * relX
        local val  = math.floor(raw / self.Increment + 0.5) * self.Increment
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

    self._frame      = frame
    self._valueLabel = valueLabel
    self._trackBg    = trackBg
    self._trackFill  = trackFill
    self._knob       = knob
end

function Slider:Set(value, silent)
    self.Value = math.clamp(value, self.Min, self.Max)
    local pct = (self.Value - self.Min) / (self.Max - self.Min)

    self._valueLabel.Text = tostring(self.Value) .. self.Suffix
    Animation.Tween(self._trackFill,
        { Size = UDim2.new(pct, 0, 1, 0) },
        "Fast"
    )

    if not silent then
        self.Callback(self.Value)
    end
end

return Slider
