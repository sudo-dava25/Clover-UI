local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utility = {}

function Utility.Create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

function Utility.ApplyCorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 8)
    c.Parent = inst
    return c
end

function Utility.ApplyStroke(inst, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color     or Color3.fromRGB(50,50,70)
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

function Utility.ApplyPadding(inst, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.Parent = inst
    return p
end

function Utility.ApplyListLayout(inst, direction, spacing, halign, valign)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = direction or Enum.FillDirection.Vertical
    l.Padding             = spacing   or UDim.new(0, 6)
    l.HorizontalAlignment = halign    or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = valign    or Enum.VerticalAlignment.Top
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent = inst
    return l
end

function Utility.ApplyGridLayout(inst, cellSize, padding)
    local g = Instance.new("UIGridLayout")
    g.CellSize          = cellSize or UDim2.new(0.5, -4, 0, 36)
    g.CellPaddingSize   = padding  or UDim2.new(0, 6, 0, 6)
    g.SortOrder         = Enum.SortOrder.LayoutOrder
    g.Parent = inst
    return g
end

function Utility.ApplyIcon(parent, iconName, size, color, position)
    if not iconName then return nil end

    local Icons = require(script.Parent.Parent.Assets.Icons)
    local iconType = Icons.GetType(iconName)

    size     = size     or 16
    color    = color    or Color3.fromRGB(160, 160, 180)
    position = position or UDim2.new(0, 0, 0, 0)

    if iconType == "lucide" then
        return Utility.CreateLucideIcon(
            parent,
            Icons.GetLucideName(iconName),
            size,
            color,
            position
        )
    elseif iconType == "rbxasset" then
        return Utility.Create("ImageLabel", {
            Name               = "Icon_" .. iconName,
            Size               = UDim2.new(0, size, 0, size),
            Position           = position,
            BackgroundTransparency = 1,
            Image              = Icons.Get(iconName),
            ImageColor3        = color,
            Parent             = parent,
        })
    end

    return nil
end

local LucideAssetIds = {

    ["home"]           = "rbxassetid://0",
    ["search"]         = "rbxassetid://0",
    ["settings"]       = "rbxassetid://0",
    ["user"]           = "rbxassetid://0",
    ["users"]          = "rbxassetid://0",
    ["plus"]           = "rbxassetid://0",
    ["minus"]          = "rbxassetid://0",
    ["check"]          = "rbxassetid://0",
    ["check-circle"]   = "rbxassetid://0",
    ["x"]              = "rbxassetid://0",
    ["pencil"]         = "rbxassetid://0",
    ["trash-2"]        = "rbxassetid://0",
    ["save"]           = "rbxassetid://0",
    ["download"]       = "rbxassetid://0",
    ["upload"]         = "rbxassetid://0",
    ["refresh-cw"]     = "rbxassetid://0",
    ["copy"]           = "rbxassetid://0",
    ["bell"]           = "rbxassetid://0",
    ["mail"]           = "rbxassetid://0",
    ["message-square"] = "rbxassetid://0",
    ["info"]           = "rbxassetid://0",
    ["alert-triangle"] = "rbxassetid://0",
    ["alert-circle"]   = "rbxassetid://0",
    ["eye"]            = "rbxassetid://0",
    ["eye-off"]        = "rbxassetid://0",
    ["lock"]           = "rbxassetid://0",
    ["unlock"]         = "rbxassetid://0",
    ["star"]           = "rbxassetid://0",
    ["heart"]          = "rbxassetid://0",
    ["arrow-up"]       = "rbxassetid://0",
    ["arrow-down"]     = "rbxassetid://0",
    ["arrow-left"]     = "rbxassetid://0",
    ["arrow-right"]    = "rbxassetid://0",
    ["chevron-up"]     = "rbxassetid://0",
    ["chevron-down"]   = "rbxassetid://0",
    ["chevron-left"]   = "rbxassetid://0",
    ["chevron-right"]  = "rbxassetid://0",
    ["gamepad-2"]      = "rbxassetid://0",
    ["trophy"]         = "rbxassetid://0",
    ["target"]         = "rbxassetid://0",
    ["crosshair"]      = "rbxassetid://0",
    ["sword"]          = "rbxassetid://0",
    ["shield"]         = "rbxassetid://0",
    ["wrench"]         = "rbxassetid://0",
    ["filter"]         = "rbxassetid://0",
    ["sliders"]        = "rbxassetid://0",
    ["code"]           = "rbxassetid://0",
    ["terminal"]       = "rbxassetid://0",
    ["cpu"]            = "rbxassetid://0",
    ["database"]       = "rbxassetid://0",
    ["globe"]          = "rbxassetid://0",
    ["zap"]            = "rbxassetid://0",
    ["flame"]          = "rbxassetid://0",
    ["palette"]        = "rbxassetid://0",
    ["coins"]          = "rbxassetid://0",
    ["clock"]          = "rbxassetid://0",
    ["calendar"]       = "rbxassetid://0",
    ["map-pin"]        = "rbxassetid://0",
    ["activity"]       = "rbxassetid://0",
    ["layers"]         = "rbxassetid://0",
    ["grid"]           = "rbxassetid://0",
    ["layout"]         = "rbxassetid://0",
    ["power"]          = "rbxassetid://0",
    ["wifi"]           = "rbxassetid://0",
    ["wifi-off"]       = "rbxassetid://0",
    ["sun"]            = "rbxassetid://0",
    ["moon"]           = "rbxassetid://0",
    ["cloud"]          = "rbxassetid://0",
}

function Utility.CreateLucideIcon(parent, lucideName, size, color, position)
    local assetId = LucideAssetIds[lucideName] or "rbxassetid://0"
    return Utility.Create("ImageLabel", {
        Name               = "Lucide_" .. (lucideName or "icon"),
        Size               = UDim2.new(0, size or 16, 0, size or 16),
        Position           = position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image              = assetId,
        ImageColor3        = color or Color3.fromRGB(160, 160, 180),
        Parent             = parent,
    })
end

local TweenPresets = {
    Fast   = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.45, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Linear = TweenInfo.new(0.20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
}

function Utility.Tween(inst, props, presetName, customInfo)
    local info = customInfo or TweenPresets[presetName] or TweenPresets.Smooth
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

function Utility.ConnectHover(inst, onEnter, onLeave)
    inst.MouseEnter:Connect(onEnter)
    inst.MouseLeave:Connect(onLeave)
end

function Utility.Ripple(parent, x, y, color)
    color = color or Color3.fromRGB(255,255,255)
    local ripple = Utility.Create("Frame", {
        Name               = "Ripple",
        Size               = UDim2.new(0, 0, 0, 0),
        Position           = UDim2.new(0, x, 0, y),
        AnchorPoint        = Vector2.new(0.5, 0.5),
        BackgroundColor3   = color,
        BackgroundTransparency = 0.85,
        BorderSizePixel    = 0,
        ZIndex             = parent.ZIndex + 10,
        Parent             = parent,
    })
    Utility.ApplyCorner(ripple, UDim.new(1, 0))
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    Utility.Tween(ripple, {
        Size               = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1,
    }, "Smooth")
    game:GetService("Debris"):AddItem(ripple, 0.4)
end

function Utility.BindContentSize(scrollFrame, layoutInst)
    local function update()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0,
            layoutInst.AbsoluteContentSize.Y + 16)
    end
    layoutInst:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    update()
end

return Utility