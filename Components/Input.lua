local Utility   = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Input = {}
Input.__index = Input

function Input.new(options, parent)
    local self = setmetatable({}, Input)

    self.Name        = options.Name or "Input"
    self.Placeholder = options.Placeholder or "Enter text..."
    self.Default     = options.Default or ""
    self.MaxLength   = options.MaxLength or 100
    self.Numeric     = options.Numeric or false
    self.Password    = options.Password or false
    self.Callback    = options.Callback or function() end
    self.Parent      = parent
    self.Value       = self.Default

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    return self
end

function Input:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Input_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel  = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)

    local nameLabel = Utility.Create("TextLabel", {
        Name             = "Name",
        Size             = UDim2.new(1, -20, 0, 16),
        Position         = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.SubText,
        TextSize         = 11,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = frame,
    })

    local inputBox = Utility.Create("TextBox", {
        Name             = "InputBox",
        Size             = UDim2.new(1, -28, 0, 22),
        Position         = UDim2.new(0, 14, 0, 26),
        BackgroundTransparency = 1,
        Text             = self.Default,
        PlaceholderText  = self.Placeholder,
        TextColor3       = t.Text,
        PlaceholderColor3 = t.SubText,
        TextSize         = 13,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent           = frame,
    })

    if self.Password then
        inputBox.TextTransparency = 1
        local dots = Utility.Create("TextLabel", {
            Name             = "Dots",
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text             = "",
            TextColor3       = t.Text,
            TextSize         = 13,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            Parent           = inputBox,
        })
        self._dots = dots
    end

    inputBox.Focused:Connect(function()
        Animation.Tween(frame, {
            BackgroundColor3 = t.Background,
        }, "Fast")
        local stroke = frame:FindFirstChildWhichIsA("UIStroke")
        if stroke then
            Animation.Tween(stroke, { Color = t.Accent }, "Fast")
        end
    end)

    inputBox.FocusLost:Connect(function(enter)
        Animation.Tween(frame, {
            BackgroundColor3 = t.TertiaryBackground,
        }, "Fast")
        local stroke = frame:FindFirstChildWhichIsA("UIStroke")
        if stroke then
            Animation.Tween(stroke, { Color = t.Outline }, "Fast")
        end

        local val = inputBox.Text
        if self.Numeric then
            val = tonumber(val) or self.Value
            inputBox.Text = tostring(val)
        end
        if #val > self.MaxLength then
            val = string.sub(val, 1, self.MaxLength)
            inputBox.Text = val
        end
        self.Value = val
        self.Callback(val, enter)

        if self.Password and self._dots then
            self._dots.Text = string.rep("•", #tostring(val))
        end
    end)

    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        if self.Password and self._dots then
            self._dots.Text = string.rep("•", #inputBox.Text)
        end
    end)

    self._frame    = frame
    self._inputBox = inputBox
end

function Input:Set(value, silent)
    self.Value = value
    self._inputBox.Text = tostring(value)
    if not silent then
        self.Callback(value)
    end
end

function Input:GetValue()
    return self.Value
end

return Input
