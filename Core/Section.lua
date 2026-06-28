local Utility   = require(script.Parent.Utility)
local Animation = require(script.Parent.Animation)

local Section = {}
Section.__index = Section

function Section.new(options, parent)
    local self = setmetatable({}, Section)

    self.Name      = options.Name or "Section"
    self.Collapsed = options.Collapsed or false
    self.Parent    = parent
    self.Tab       = parent

    self:_Build()

    return self
end

function Section:_Build()
    local t = self.Tab.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Section_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        Parent           = self.Parent._contentFrame,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 9))
    Utility.ApplyStroke(frame, t.Outline, 1)

    local header = Utility.Create("TextButton", {
        Name             = "Header",
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text             = "",
        AutoButtonColor  = false,
        Parent           = frame,
    })

    local headerLabel = Utility.Create("TextLabel", {
        Name             = "Label",
        Size             = UDim2.new(1, -40, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = string.upper(self.Name),
        TextColor3       = t.SubText,
        TextSize         = 10,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = header,
    })

    local chevron = Utility.Create("TextLabel", {
        Name             = "Chevron",
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Text             = "▾",
        TextColor3       = t.SubText,
        TextSize         = 12,
        Font             = Enum.Font.GothamBold,
        Parent           = header,
    })

    local divider = Utility.Create("Frame", {
        Name             = "Divider",
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = t.Outline,
        BorderSizePixel  = 0,
        Parent           = header,
    })

    local content = Utility.Create("Frame", {
        Name             = "Content",
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 0, 36),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent           = frame,
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

    self._frame   = frame
    self._header  = header
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
    local ButtonModule = require(script.Parent.Parent.Components.Button)
    return ButtonModule.new(options, self)
end

function Section:CreateToggle(options)
    local ToggleModule = require(script.Parent.Parent.Components.Toggle)
    return ToggleModule.new(options, self)
end

function Section:CreateSlider(options)
    local SliderModule = require(script.Parent.Parent.Components.Slider)
    return SliderModule.new(options, self)
end

function Section:CreateDropdown(options)
    local DropdownModule = require(script.Parent.Parent.Components.Dropdown)
    return DropdownModule.new(options, self)
end

function Section:CreateInput(options)
    local InputModule = require(script.Parent.Parent.Components.Input)
    return InputModule.new(options, self)
end

function Section:CreateKeybind(options)
    local KeybindModule = require(script.Parent.Parent.Components.Keybind)
    return KeybindModule.new(options, self)
end

function Section:CreateLabel(options)
    local LabelModule = require(script.Parent.Parent.Components.Label)
    return LabelModule.new(options, self)
end

function Section:CreateParagraph(options)
    local ParagraphModule = require(script.Parent.Parent.Components.Paragraph)
    return ParagraphModule.new(options, self)
end

function Section:CreateDivider(options)
    local DividerModule = require(script.Parent.Parent.Components.Divider)
    return DividerModule.new(options, self)
end

return Section
