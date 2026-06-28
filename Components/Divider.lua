local Utility = require(script.Parent.Parent.Core.Utility)

local Divider = {}
Divider.__index = Divider

function Divider.new(options, parent)
    local self = setmetatable({}, Divider)

    self.Label  = options.Label
    self.Icon   = options.Icon
    self.Parent = parent

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    return self
end

function Divider:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Divider",
        Size             = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    })

    if self.Label then
        local line1 = Utility.Create("Frame", {
            Size             = UDim2.new(0.3, 0, 0, 1),
            Position         = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = t.Outline,
            BorderSizePixel  = 0,
            Parent           = frame,
        })

        local labelFrame = Utility.Create("Frame", {
            Size             = UDim2.new(0, 0, 0, 20),
            AutomaticSize    = Enum.AutomaticSize.X,
            Position         = UDim2.new(0.5, 0, 0, 0),
            AnchorPoint      = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Parent           = frame,
        })
        Utility.ApplyListLayout(labelFrame,
            Enum.FillDirection.Horizontal, UDim.new(0, 4),
            Enum.HorizontalAlignment.Center)

        if self.Icon then
            Utility.ApplyIcon(labelFrame, self.Icon, 12,
                t.SubText, UDim2.new(0, 0, 0.5, -6))
        end

        Utility.Create("TextLabel", {
            Name             = "Text",
            Size             = UDim2.new(0, 0, 1, 0),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text             = self.Label,
            TextColor3       = t.SubText,
            TextSize         = 11,
            Font             = Enum.Font.GothamBold,
            Parent           = labelFrame,
        })

        local line2 = Utility.Create("Frame", {
            Size             = UDim2.new(0.3, 0, 0, 1),
            Position         = UDim2.new(0.7, 0, 0.5, 0),
            BackgroundColor3 = t.Outline,
            BorderSizePixel  = 0,
            Parent           = frame,
        })
    else
        Utility.Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 1),
            Position         = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = t.Outline,
            BorderSizePixel  = 0,
            Parent           = frame,
        })
    end

    self._frame = frame
end

return Divider
