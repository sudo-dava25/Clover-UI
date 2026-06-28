local Theme = {}
Theme.__index = Theme

local Themes = {
    Dark = {
        Background          = Color3.fromRGB(15,  15,  20),
        SecondaryBackground = Color3.fromRGB(22,  22,  30),
        TertiaryBackground  = Color3.fromRGB(30,  30,  40),
        Accent              = Color3.fromRGB(100, 180, 255),
        AccentDark          = Color3.fromRGB(70,  128, 220),
        Text                = Color3.fromRGB(240, 240, 250),
        SubText             = Color3.fromRGB(160, 160, 180),
        Outline             = Color3.fromRGB(50,  50,  74),
        Success             = Color3.fromRGB(80,  200, 120),
        Warning             = Color3.fromRGB(255, 180, 50),
        Error               = Color3.fromRGB(255, 80,  80),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    Light = {
        Background          = Color3.fromRGB(244, 244, 248),
        SecondaryBackground = Color3.fromRGB(255, 255, 255),
        TertiaryBackground  = Color3.fromRGB(234, 234, 240),
        Accent              = Color3.fromRGB(59,  130, 246),
        AccentDark          = Color3.fromRGB(37,  99,  235),
        Text                = Color3.fromRGB(26,  26,  46),
        SubText             = Color3.fromRGB(107, 107, 128),
        Outline             = Color3.fromRGB(212, 212, 224),
        Success             = Color3.fromRGB(34,  197, 94),
        Warning             = Color3.fromRGB(245, 158, 11),
        Error               = Color3.fromRGB(239, 68,  68),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.0,
    },
    Midnight = {
        Background          = Color3.fromRGB(12,  12,  26),
        SecondaryBackground = Color3.fromRGB(17,  17,  42),
        TertiaryBackground  = Color3.fromRGB(24,  24,  53),
        Accent              = Color3.fromRGB(167, 139, 250),
        AccentDark          = Color3.fromRGB(124, 58,  237),
        Text                = Color3.fromRGB(237, 233, 254),
        SubText             = Color3.fromRGB(139, 133, 168),
        Outline             = Color3.fromRGB(45,  43,  78),
        Success             = Color3.fromRGB(52,  211, 153),
        Warning             = Color3.fromRGB(251, 191, 36),
        Error               = Color3.fromRGB(248, 113, 113),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.06,
    },
    Emerald = {
        Background          = Color3.fromRGB(10,  18,  16),
        SecondaryBackground = Color3.fromRGB(17,  31,  26),
        TertiaryBackground  = Color3.fromRGB(24,  40,  32),
        Accent              = Color3.fromRGB(52,  211, 153),
        AccentDark          = Color3.fromRGB(16,  185, 129),
        Text                = Color3.fromRGB(236, 253, 245),
        SubText             = Color3.fromRGB(107, 144, 128),
        Outline             = Color3.fromRGB(31,  53,  40),
        Success             = Color3.fromRGB(52,  211, 153),
        Warning             = Color3.fromRGB(251, 191, 36),
        Error               = Color3.fromRGB(248, 113, 113),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    Rose = {
        Background          = Color3.fromRGB(20,  10,  15),
        SecondaryBackground = Color3.fromRGB(30,  15,  22),
        TertiaryBackground  = Color3.fromRGB(40,  20,  30),
        Accent              = Color3.fromRGB(251, 113, 133),
        AccentDark          = Color3.fromRGB(225, 29,  72),
        Text                = Color3.fromRGB(255, 241, 242),
        SubText             = Color3.fromRGB(180, 130, 140),
        Outline             = Color3.fromRGB(60,  30,  42),
        Success             = Color3.fromRGB(52,  211, 153),
        Warning             = Color3.fromRGB(251, 191, 36),
        Error               = Color3.fromRGB(248, 113, 113),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
    Ocean = {
        Background          = Color3.fromRGB(10,  20,  40),
        SecondaryBackground = Color3.fromRGB(15,  30,  55),
        TertiaryBackground  = Color3.fromRGB(20,  40,  70),
        Accent              = Color3.fromRGB(50,  180, 220),
        AccentDark          = Color3.fromRGB(30,  140, 180),
        Text                = Color3.fromRGB(230, 240, 255),
        SubText             = Color3.fromRGB(130, 160, 200),
        Outline             = Color3.fromRGB(30,  55,  90),
        Success             = Color3.fromRGB(80,  200, 120),
        Warning             = Color3.fromRGB(255, 180, 50),
        Error               = Color3.fromRGB(255, 80,  80),
        CornerRadius        = UDim.new(0, 8),
        Transparency        = 0.04,
    },
}

function Theme.new()
    local self = setmetatable({}, Theme)
    self._current = Themes.Dark
    return self
end

function Theme:Set(name, overrides)
    local base = Themes[name] or Themes.Dark
    if overrides then
        local merged = {}
        for k, v in pairs(base)      do merged[k] = v end
        for k, v in pairs(overrides) do merged[k] = v end
        self._current = merged
    else
        self._current = base
    end
end

function Theme:Get()
    return self._current
end

function Theme:Register(name, data)
    Themes[name] = data
end

function Theme:GetAll()
    local names = {}
    for k in pairs(Themes) do table.insert(names, k) end
    table.sort(names)
    return names
end

return Theme
