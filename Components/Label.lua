local Utility = require(script.Parent.Parent.Core.Utility)

local Label = {}
Label.__index = Label

function Label.new(options, parent)
    local self = setmetatable({}, Label)

    self.Name   = options.Name or "Label"
    self.Icon   = options.Icon
    self.Parent = parent

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    return self
end

function Label:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Label_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    })

    if self.Icon then
        local iconEl = Utility.ApplyIcon(
            frame,
            self.Icon,
            14,
            t.SubText,
            UDim2.new(0, 4, 0.5, -7)
        )
        self._iconEl = iconEl
    end

    local textLabel = Utility.Create("TextLabel", {
        Name             = "Text",
        Size             = UDim2.new(1, self.Icon and -26 or -8, 1, 0),
        Position         = UDim2.new(0, self.Icon and 24 or 4, 0, 0),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.SubText,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        Parent           = frame,
    })

    self._frame      = frame
    self._textLabel  = textLabel
end

function Label:Set(text)
    self.Name = text
    self._textLabel.Text = text
end

function Label:SetIcon(iconName)
    self.Icon = iconName
    if self._iconEl then
        self._iconEl:Destroy()
    end
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()
    self._iconEl = Utility.ApplyIcon(
        self._frame, iconName, 14, t.SubText,
        UDim2.new(0, 4, 0.5, -7)
    )
end

return Label
