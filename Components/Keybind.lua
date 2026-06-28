local UserInputService = game:GetService("UserInputService")
local Utility   = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Keybind = {}
Keybind.__index = Keybind

local KeyNames = {
    [Enum.KeyCode.LeftControl]  = "L.Ctrl",
    [Enum.KeyCode.RightControl] = "R.Ctrl",
    [Enum.KeyCode.LeftShift]    = "L.Shift",
    [Enum.KeyCode.RightShift]   = "R.Shift",
    [Enum.KeyCode.LeftAlt]      = "L.Alt",
    [Enum.KeyCode.RightAlt]     = "R.Alt",
    [Enum.KeyCode.Space]        = "Space",
    [Enum.KeyCode.Return]       = "Enter",
    [Enum.KeyCode.BackSpace]    = "Backspace",
    [Enum.KeyCode.Delete]       = "Delete",
    [Enum.KeyCode.Tab]          = "Tab",
    [Enum.KeyCode.Escape]       = "Escape",
    [Enum.KeyCode.CapsLock]     = "Caps",
    [Enum.KeyCode.Insert]       = "Insert",
    [Enum.KeyCode.Home]         = "Home",
    [Enum.KeyCode.End]          = "End",
    [Enum.KeyCode.PageUp]       = "PgUp",
    [Enum.KeyCode.PageDown]     = "PgDn",
    [Enum.KeyCode.Up]           = "Up",
    [Enum.KeyCode.Down]         = "Down",
    [Enum.KeyCode.Left]         = "Left",
    [Enum.KeyCode.Right]        = "Right",
    [Enum.KeyCode.F1]           = "F1",
    [Enum.KeyCode.F2]           = "F2",
    [Enum.KeyCode.F3]           = "F3",
    [Enum.KeyCode.F4]           = "F4",
    [Enum.KeyCode.F5]           = "F5",
    [Enum.KeyCode.F6]           = "F6",
    [Enum.KeyCode.F7]           = "F7",
    [Enum.KeyCode.F8]           = "F8",
    [Enum.KeyCode.F9]           = "F9",
    [Enum.KeyCode.F10]          = "F10",
    [Enum.KeyCode.F11]          = "F11",
    [Enum.KeyCode.F12]          = "F12",
}

local IGNORED_KEYS = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W, Enum.KeyCode.A,
    Enum.KeyCode.S, Enum.KeyCode.D,
}

function Keybind.new(options, parent)
    local self = setmetatable({}, Keybind)

    self.Name     = options.Name or "Keybind"
    self.Default  = options.Default or Enum.KeyCode.Unknown
    self.Callback = options.Callback or function() end
    self.Parent   = parent
    self.Value    = self.Default
    self.Binding  = false

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if self.Binding then
            for _, ignore in ipairs(IGNORED_KEYS) do
                if input.KeyCode == ignore then return end
            end
            self:Set(input.KeyCode)
            self:_StopBinding()
            return
        end
        if input.KeyCode == self.Value then
            self.Callback(self.Value)
        end
    end)

    return self
end

function Keybind:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Keybind_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel  = 0,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)

    local nameLabel = Utility.Create("TextLabel", {
        Name             = "Name",
        Size             = UDim2.new(1, -110, 1, 0),
        Position         = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = frame,
    })

    local badge = Utility.Create("TextButton", {
        Name             = "Badge",
        Size             = UDim2.new(0, 90, 0, 26),
        Position         = UDim2.new(1, -100, 0.5, -13),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        Text             = KeyNames[self.Default] or self.Default.Name,
        TextColor3       = t.Accent,
        TextSize         = 12,
        Font             = Enum.Font.GothamBold,
        AutoButtonColor  = false,
        Parent           = frame,
    })
    Utility.ApplyCorner(badge, UDim.new(0, 6))
    Utility.ApplyStroke(badge, t.Outline, 1)

    badge.MouseButton1Click:Connect(function()
        if self.Binding then
            self:_StopBinding()
        else
            self:_StartBinding()
        end
    end)

    Utility.ConnectHover(frame,
        function()
            Animation.Tween(frame,
                { BackgroundColor3 = t.Background }, "Fast")
        end,
        function()
            Animation.Tween(frame,
                { BackgroundColor3 = t.TertiaryBackground }, "Fast")
        end
    )

    self._frame = frame
    self._badge = badge
    self._t     = t
end

function Keybind:_StartBinding()
    self.Binding = true
    self._badge.Text = "..."
    Animation.Tween(self._badge,
        { BackgroundColor3 = self._t.Accent }, "Fast")
    Animation.Tween(self._badge,
        { TextColor3 = Color3.fromRGB(255, 255, 255) }, "Fast")
end

function Keybind:_StopBinding()
    self.Binding = false
    Animation.Tween(self._badge,
        { BackgroundColor3 = self._t.SecondaryBackground }, "Fast")
    Animation.Tween(self._badge,
        { TextColor3 = self._t.Accent }, "Fast")
end

function Keybind:Set(keyCode, silent)
    self.Value = keyCode
    self._badge.Text = KeyNames[keyCode] or keyCode.Name
    if not silent then
        self.Callback(keyCode)
    end
end

function Keybind:GetValue()
    return self.Value
end

return Keybind
