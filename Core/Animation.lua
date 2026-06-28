local TweenService = game:GetService("TweenService")

local Animation = {}

local Presets = {
    Fast   = TweenInfo.new(0.12, Enum.EasingStyle.Quart,   Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quart,   Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.45, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Linear = TweenInfo.new(0.20, Enum.EasingStyle.Linear,  Enum.EasingDirection.InOut),
    Slow   = TweenInfo.new(0.60, Enum.EasingStyle.Quart,   Enum.EasingDirection.Out),
}

function Animation.Tween(inst, props, presetName, customInfo)
    local info = customInfo or Presets[presetName] or Presets.Smooth
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

function Animation.Shake(inst, intensity, duration)
    intensity = intensity or 4
    duration  = duration  or 0.3
    local origin = inst.Position
    local steps  = 6
    local delay  = duration / steps
    for i = 1, steps do
        task.delay(delay * (i - 1), function()
            local ox = math.random(-intensity, intensity)
            local oy = math.random(-intensity, intensity)
            Animation.Tween(inst, {
                Position = UDim2.new(
                    origin.X.Scale, origin.X.Offset + ox,
                    origin.Y.Scale, origin.Y.Offset + oy
                )
            }, "Fast")
        end)
    end
    task.delay(duration, function()
        Animation.Tween(inst, { Position = origin }, "Smooth")
    end)
end

function Animation.FadeIn(inst, duration)
    inst.BackgroundTransparency = 1
    Animation.Tween(inst,
        { BackgroundTransparency = 0 },
        nil,
        TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    )
end

function Animation.FadeOut(inst, duration, callback)
    Animation.Tween(inst,
        { BackgroundTransparency = 1 },
        nil,
        TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    ):Completed:Connect(function()
        if callback then callback() end
    end)
end

function Animation.ScalePop(inst)
    inst.Size = UDim2.new(
        inst.Size.X.Scale * 0.92, inst.Size.X.Offset,
        inst.Size.Y.Scale * 0.92, inst.Size.Y.Offset
    )
    Animation.Tween(inst, {
        Size = UDim2.new(
            inst.Size.X.Scale / 0.92, inst.Size.X.Offset,
            inst.Size.Y.Scale / 0.92, inst.Size.Y.Offset
        )
    }, "Bounce")
end

return Animation