local Utility   = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(options, parent)
    local self = setmetatable({}, Toggle)

    self.Name     = options.Name or "Toggle"
    self.Default  = options.Default or false
    self.Callback = options.Callback or function() end
    self.Parent   = parent
    self.Value    = self.Default

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    if self.Default then
        self:Set(true, true)
    end

    return self
end

function Toggle:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Toggle_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 38),
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

    local nameLabel = Utility.Create("TextLabel", {
        Name             = "Name",
        Size             = UDim2.new(1, -60, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = frame,
    })

    local track = Utility.Create("Frame", {
        Name             = "Track",
        Size             = UDim2.new(0, 40, 0, 22),
        Position         = UDim2.new(1, -52, 0.5, -11),
        BackgroundColor3 = t.Outline,
        BorderSizePixel  = 0,
        Parent           = frame,
    })
    Utility.ApplyCorner(track, UDim.new(1, 0))

    local knob = Utility.Create("Frame", {
        Name             = "Knob",
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel  = 0,
        Parent           = track,
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

    self._frame = frame
    self._track = track
    self._knob  = knob
end

function Toggle:Toggle()
    self:Set(not self.Value)
end

function Toggle:Set(value, silent)
    self.Value = value
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

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

return Toggle
