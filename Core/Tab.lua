local Utility   = require(script.Parent.Utility)
local Animation = require(script.Parent.Animation)
local Section   = require(script.Parent.Section)

local Tab = {}
Tab.__index = Tab

function Tab.new(options, window)
    local self = setmetatable({}, Tab)

    self.Name    = options.Name or "Tab"
    self.Icon    = options.Icon
    self.Window  = window
    self.Active  = false
    self.Sections = {}

    self:_Build()

    return self
end

function Tab:_Build()
    local t = self.Window.Theme:Get()

    local btn = Utility.Create("TextButton", {
        Name             = "Tab_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        Text             = "",
        AutoButtonColor  = false,
        Parent           = self.Window._tabNav,
    })

    local indicator = Utility.Create("Frame", {
        Name             = "Indicator",
        Size             = UDim2.new(0, 3, 0, 20),
        Position         = UDim2.new(0, 0, 0.5, -10),
        BackgroundColor3 = t.Accent,
        BorderSizePixel  = 0,
        Visible          = false,
        Parent           = btn,
    })
    Utility.ApplyCorner(indicator, UDim.new(1, 0))

    if self.Icon then
        local iconLabel = Utility.ApplyIcon(
            btn,
            self.Icon,
            16,
            t.SubText,
            UDim2.new(0, 12, 0.5, -8)
        )
        self._iconLabel = iconLabel
    end

    local nameLabel = Utility.Create("TextLabel", {
        Name             = "Name",
        Size             = UDim2.new(1, self.Icon and -40 or -20, 0, 18),
        Position         = UDim2.new(0, self.Icon and 34 or 12, 0.5, -9),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.SubText,
        TextSize         = 13,
        Font             = Enum.Font.GothamMedium,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = btn,
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
        Name             = "Content_" .. self.Name,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = t.Outline,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        Visible          = false,
        Parent           = self.Window._contentArea,
    })
    Utility.ApplyPadding(contentFrame, 10, 10, 8, 10)
    local contentLayout = Utility.ApplyListLayout(contentFrame,
        Enum.FillDirection.Vertical, UDim.new(0, 8))
    Utility.BindContentSize(contentFrame, contentLayout)

    self._btn          = btn
    self._indicator    = indicator
    self._nameLabel    = nameLabel
    self._contentFrame = contentFrame
    self._content      = contentFrame
end

function Tab:Select()

    for _, tab in ipairs(self.Window.Tabs) do
        tab.Active = false
        tab._contentFrame.Visible = false
        tab._indicator.Visible = false
        Animation.Tween(tab._btn, { BackgroundTransparency = 1 }, "Fast")
        Animation.Tween(tab._nameLabel, { TextColor3 = self.Window.Theme:Get().SubText }, "Fast")
        if tab._iconLabel then
            Animation.Tween(tab._iconLabel, { ImageColor3 = self.Window.Theme:Get().SubText }, "Fast")
        end
    end

    self.Active = true
    self._contentFrame.Visible = true
    self._indicator.Visible = true
    local t = self.Window.Theme:Get()
    Animation.Tween(self._btn, { BackgroundTransparency = 0.97 }, "Fast")
    Animation.Tween(self._nameLabel, { TextColor3 = t.Text }, "Fast")
    if self._iconLabel then
        Animation.Tween(self._iconLabel, { ImageColor3 = t.Accent }, "Fast")
    end

    self.Window.ActiveTab = self
end

function Tab:CreateSection(options)
    local section = Section.new(options, self)
    table.insert(self.Sections, section)
    return section
end

function Tab:CreateButton(options)
    local ButtonModule = require(script.Parent.Parent.Components.Button)
    return ButtonModule.new(options, self)
end

function Tab:CreateToggle(options)
    local ToggleModule = require(script.Parent.Parent.Components.Toggle)
    return ToggleModule.new(options, self)
end

function Tab:CreateSlider(options)
    local SliderModule = require(script.Parent.Parent.Components.Slider)
    return SliderModule.new(options, self)
end

function Tab:CreateDropdown(options)
    local DropdownModule = require(script.Parent.Parent.Components.Dropdown)
    return DropdownModule.new(options, self)
end

function Tab:CreateInput(options)
    local InputModule = require(script.Parent.Parent.Components.Input)
    return InputModule.new(options, self)
end

function Tab:CreateKeybind(options)
    local KeybindModule = require(script.Parent.Parent.Components.Keybind)
    return KeybindModule.new(options, self)
end

function Tab:CreateLabel(options)
    local LabelModule = require(script.Parent.Parent.Components.Label)
    return LabelModule.new(options, self)
end

function Tab:CreateParagraph(options)
    local ParagraphModule = require(script.Parent.Parent.Components.Paragraph)
    return ParagraphModule.new(options, self)
end

function Tab:CreateDivider(options)
    local DividerModule = require(script.Parent.Parent.Components.Divider)
    return DividerModule.new(options, self)
end

return Tab
