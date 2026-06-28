local Utility = require(script.Parent.Parent.Core.Utility)

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(options, parent)
    local self = setmetatable({}, Paragraph)

    self.Title   = options.Title or "Paragraph"
    self.Content = options.Content or ""
    self.Icon    = options.Icon
    self.Parent  = parent

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    return self
end

function Paragraph:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Para_" .. self.Title,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel  = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)
    Utility.ApplyPadding(frame, 12, 12, 14, 14)

    local inner = Utility.Create("Frame", {
        Name             = "Inner",
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent           = frame,
    })
    Utility.ApplyListLayout(inner,
        Enum.FillDirection.Vertical, UDim.new(0, 6))

    local titleRow = Utility.Create("Frame", {
        Name             = "TitleRow",
        Size             = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Parent           = inner,
    })

    if self.Icon then
        Utility.ApplyIcon(titleRow, self.Icon, 14,
            t.Accent, UDim2.new(0, 0, 0.5, -7))
    end

    Utility.Create("TextLabel", {
        Name             = "Title",
        Size             = UDim2.new(1, self.Icon and -22 or 0, 1, 0),
        Position         = UDim2.new(0, self.Icon and 20 or 0, 0, 0),
        BackgroundTransparency = 1,
        Text             = self.Title,
        TextColor3       = t.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = titleRow,
    })

    local contentLabel = Utility.Create("TextLabel", {
        Name             = "Content",
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text             = self.Content,
        TextColor3       = t.SubText,
        TextSize         = 12,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        Parent           = inner,
    })

    self._frame        = frame
    self._contentLabel = contentLabel
end

function Paragraph:Set(title, content)
    if title   then self.Title   = title;   end
    if content then self.Content = content; end
    if title   then
        self._frame:FindFirstChild("Inner")
            :FindFirstChild("TitleRow")
            :FindFirstChild("Title").Text = title
    end
    if content then
        self._contentLabel.Text = content
    end
end

return Paragraph
