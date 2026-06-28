local UserInputService = game:GetService("UserInputService")
local Utility   = require(script.Parent.Parent.Core.Utility)
local Animation = require(script.Parent.Parent.Core.Animation)

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(options, parent)
    local self = setmetatable({}, Dropdown)

    self.Name        = options.Name or "Dropdown"
    self.Options     = options.Options or {}
    self.Default     = options.Default
    self.Multi       = options.Multi or false
    self.Callback    = options.Callback or function() end
    self.Parent      = parent
    self.Value       = self.Multi and {} or nil
    self.Open        = false

    self:_Build()

    local container = parent._content or parent._contentFrame
    self._frame.Parent = container

    if self.Default then
        self:Set(self.Default, true)
    end

    return self
end

function Dropdown:_Build()
    local t = self.Parent.Tab and self.Parent.Tab.Window.Theme:Get()
        or self.Parent.Window.Theme:Get()

    local frame = Utility.Create("Frame", {
        Name             = "Dropdown_" .. self.Name,
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.TertiaryBackground,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        ZIndex           = 2,
    })
    Utility.ApplyCorner(frame, UDim.new(0, 8))
    Utility.ApplyStroke(frame, t.Outline, 1)

    local nameLabel = Utility.Create("TextLabel", {
        Name             = "Name",
        Size             = UDim2.new(1, -20, 0, 16),
        Position         = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text             = self.Name,
        TextColor3       = t.SubText,
        TextSize         = 11,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = frame,
    })

    local selected = Utility.Create("TextLabel", {
        Name             = "Selected",
        Size             = UDim2.new(1, -44, 0, 16),
        Position         = UDim2.new(0, 14, 0, 28),
        BackgroundTransparency = 1,
        Text             = "Select...",
        TextColor3       = t.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextTruncate     = Enum.TextTruncate.AtEnd,
        Parent           = frame,
    })

    local chevronIcon = Utility.ApplyIcon(frame, "chevron-down", 14,
        t.SubText, UDim2.new(1, -28, 0.5, -7))

    local hitbox = Utility.Create("TextButton", {
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        Text             = "",
        AutoButtonColor  = false,
        ZIndex           = 3,
        Parent           = frame,
    })

    local list = Utility.Create("Frame", {
        Name             = "List",
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 1, 6),
        BackgroundColor3 = t.SecondaryBackground,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        Visible          = false,
        ZIndex           = 10,
        Parent           = frame,
    })
    Utility.ApplyCorner(list, UDim.new(0, 8))
    Utility.ApplyStroke(list, t.Outline, 1)

    local listScroll = Utility.Create("ScrollingFrame", {
        Name             = "Scroll",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = t.Outline,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        Parent           = list,
    })
    Utility.ApplyPadding(listScroll, 6, 6, 6, 6)
    local listLayout = Utility.ApplyListLayout(listScroll,
        Enum.FillDirection.Vertical, UDim.new(0, 3))
    Utility.BindContentSize(listScroll, listLayout)

    for _, optName in ipairs(self.Options) do
        local optBtn = Utility.Create("TextButton", {
            Name             = "Opt_" .. optName,
            Size             = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = t.TertiaryBackground,
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            Text             = "",
            AutoButtonColor  = false,
            ZIndex           = 11,
            Parent           = listScroll,
        })
        Utility.ApplyCorner(optBtn, UDim.new(0, 6))

        local optLabel = Utility.Create("TextLabel", {
            Size             = UDim2.new(1, -36, 1, 0),
            Position         = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text             = optName,
            TextColor3       = t.Text,
            TextSize         = 13,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 11,
            Parent           = optBtn,
        })

        local checkIcon = Utility.Create("Frame", {
            Name             = "Check",
            Size             = UDim2.new(0, 16, 0, 16),
            Position         = UDim2.new(1, -26, 0.5, -8),
            BackgroundColor3 = t.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ZIndex           = 11,
            Parent           = optBtn,
        })
        Utility.ApplyCorner(checkIcon, UDim.new(1, 0))

        local checkLabel = Utility.Create("TextLabel", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text             = "✓",
            TextColor3       = Color3.fromRGB(255, 255, 255),
            TextSize         = 11,
            Font             = Enum.Font.GothamBold,
            ZIndex           = 12,
            Parent           = checkIcon,
        })

        optBtn.MouseButton1Click:Connect(function()
            if self.Multi then
                self:_ToggleMulti(optName)
            else
                self:Set(optName)
                self:_Close()
            end
        end)

        Utility.ConnectHover(optBtn,
            function()
                Animation.Tween(optBtn,
                    { BackgroundTransparency = 0.94 }, "Fast")
            end,
            function()
                local isSelected = self.Multi
                    and table.find(self.Value, optName)
                    or  self.Value == optName
                Animation.Tween(optBtn,
                    { BackgroundTransparency = isSelected and 0.90 or 1 }, "Fast")
            end
        )
    end

    hitbox.MouseButton1Click:Connect(function()
        if self.Open then
            self:_Close()
        else
            self:_Open()
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.Open then
                local mPos = UserInputService:GetMouseLocation()
                local abs  = list.AbsolutePosition
                local size = list.AbsoluteSize
                if mPos.X < abs.X or mPos.X > abs.X + size.X
                or mPos.Y < abs.Y or mPos.Y > abs.Y + size.Y then
                    self:_Close()
                end
            end
        end
    end)

    self._frame       = frame
    self._selected    = selected
    self._list        = list
    self._listScroll  = listScroll
    self._chevronIcon = chevronIcon
    self._t           = t
end

function Dropdown:_Open()
    self.Open = true
    local itemCount = math.min(#self.Options, 5)
    local listH = itemCount * 38 + 12

    self._list.Visible = true
    self._list.Size = UDim2.new(1, 0, 0, 0)
    Animation.Tween(self._list,
        { Size = UDim2.new(1, 0, 0, listH) }, "Bounce")

    if self._chevronIcon then
        Animation.Tween(self._chevronIcon, { Rotation = 180 }, "Smooth")
    end
end

function Dropdown:_Close()
    self.Open = false
    Animation.Tween(self._list,
        { Size = UDim2.new(1, 0, 0, 0) }, "Smooth")

    task.delay(0.25, function()
        if not self.Open then
            self._list.Visible = false
        end
    end)

    if self._chevronIcon then
        Animation.Tween(self._chevronIcon, { Rotation = 0 }, "Smooth")
    end
end

function Dropdown:Set(value, silent)
    self.Value = value
    self._selected.Text = tostring(value)

    for _, optBtn in ipairs(self._listScroll:GetChildren()) do
        if optBtn:IsA("TextButton") then
            local checkIcon = optBtn:FindFirstChild("Check")
            if checkIcon then
                local isSelected = optBtn.Name == "Opt_" .. tostring(value)
                Animation.Tween(checkIcon,
                    { BackgroundTransparency = isSelected and 0 or 1 }, "Fast")
                Animation.Tween(optBtn,
                    { BackgroundTransparency = isSelected and 0.90 or 1 }, "Fast")
            end
        end
    end

    if not silent then
        self.Callback(value)
    end
end

function Dropdown:_ToggleMulti(optName)
    local idx = table.find(self.Value, optName)
    if idx then
        table.remove(self.Value, idx)
    else
        table.insert(self.Value, optName)
    end

    for _, optBtn in ipairs(self._listScroll:GetChildren()) do
        if optBtn:IsA("TextButton") then
            local checkIcon = optBtn:FindFirstChild("Check")
            if checkIcon then
                local name = optBtn.Name:sub(5)
                local isSelected = table.find(self.Value, name) ~= nil
                Animation.Tween(checkIcon,
                    { BackgroundTransparency = isSelected and 0 or 1 }, "Fast")
                Animation.Tween(optBtn,
                    { BackgroundTransparency = isSelected and 0.90 or 1 }, "Fast")
            end
        end
    end

    if #self.Value == 0 then
        self._selected.Text = "Select..."
    elseif #self.Value == 1 then
        self._selected.Text = self.Value[1]
    else
        self._selected.Text = self.Value[1] .. " (+" .. (#self.Value - 1) .. ")"
    end

    self.Callback(self.Value)
end

function Dropdown:GetValue()
    return self.Value
end

function Dropdown:Refresh(newOptions)
    self.Options = newOptions
    for _, child in ipairs(self._listScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    self.Value = self.Multi and {} or nil
    self._selected.Text = "Select..."

    self:_Build()
end

return Dropdown
