local Icons = {}
Icons.__index = Icons

local LucideMap = {

    home            = "home",
    search          = "search",
    menu            = "menu",
    settings        = "settings",

    user            = "user",
    users           = "users",
    ["user-circle"] = "user-circle",
    ["user-check"]  = "user-check",
    ["user-plus"]   = "user-plus",

    plus            = "plus",
    minus           = "minus",
    check           = "check",
    ["check-circle"]= "check-circle",
    close           = "x",
    edit            = "pencil",
    trash           = "trash-2",
    save            = "save",
    download        = "download",
    upload          = "upload",
    refresh         = "refresh-cw",
    copy            = "copy",
    link            = "link",
    share           = "share-2",
    send            = "send",

    play            = "play",
    pause           = "pause",
    stop            = "square",
    ["skip-forward"]= "skip-forward",
    ["skip-back"]   = "skip-back",
    volume          = "volume-2",
    ["volume-off"]  = "volume-x",
    mic             = "mic",
    ["mic-off"]     = "mic-off",
    video           = "video",
    ["video-off"]   = "video-off",
    camera          = "camera",
    music           = "music",

    file            = "file",
    ["file-text"]   = "file-text",
    ["file-code"]   = "file-code",
    folder          = "folder",
    ["folder-open"] = "folder-open",
    image           = "image",
    archive         = "archive",
    paperclip       = "paperclip",
    scissors        = "scissors",

    bell            = "bell",
    ["bell-off"]    = "bell-off",
    mail            = "mail",
    message         = "message-square",
    ["message-circle"] = "message-circle",
    phone           = "phone",
    ["phone-off"]   = "phone-off",
    inbox           = "inbox",

    info            = "info",
    warn            = "alert-triangle",
    error           = "alert-circle",
    success         = "check-circle",
    alert           = "alert-circle",
    help            = "help-circle",

    eye             = "eye",
    ["eye-off"]     = "eye-off",
    lock            = "lock",
    unlock          = "unlock",
    key             = "key",
    star            = "star",
    heart           = "heart",
    bookmark        = "bookmark",
    flag            = "flag",
    tag             = "tag",
    hash            = "hash",

    ["arrow-up"]    = "arrow-up",
    ["arrow-down"]  = "arrow-down",
    ["arrow-left"]  = "arrow-left",
    ["arrow-right"] = "arrow-right",
    ["chevron-up"]  = "chevron-up",
    ["chevron-down"]= "chevron-down",
    ["chevron-left"]= "chevron-left",
    ["chevron-right"]="chevron-right",
    ["move"]        = "move",
    ["external-link"]="external-link",
    ["corner-up-left"]="corner-up-left",

    gamepad         = "gamepad-2",
    trophy          = "trophy",
    target          = "target",
    crosshair       = "crosshair",
    sword           = "sword",
    shield          = "shield",
    ["shield-check"]= "shield-check",
    dice            = "dice-5",
    puzzle          = "puzzle",

    wrench          = "wrench",
    hammer          = "hammer",
    ["tool"]        = "tool",
    filter          = "filter",
    sliders         = "sliders",
    maximize        = "maximize",
    minimize        = "minimize",
    ["maximize-2"]  = "maximize-2",
    ["minimize-2"]  = "minimize-2",
    crop            = "crop",

    code            = "code",
    ["code-2"]      = "code-2",
    terminal        = "terminal",
    cpu             = "cpu",
    database        = "database",
    server          = "server",
    wifi            = "wifi",
    ["wifi-off"]    = "wifi-off",
    battery         = "battery",
    ["battery-charging"] = "battery-charging",
    power           = "power",
    monitor         = "monitor",
    smartphone      = "smartphone",
    tablet          = "tablet",
    printer         = "printer",
    hard_drive      = "hard-drive",
    cloud           = "cloud",
    ["cloud-upload"]= "cloud-upload",
    ["cloud-download"] = "cloud-download",

    grid            = "grid",
    layout          = "layout",
    layers          = "layers",
    sidebar         = "sidebar",
    columns         = "columns",
    list            = "list",
    ["align-left"]  = "align-left",
    ["align-center"]= "align-center",
    ["align-right"] = "align-right",

    clock           = "clock",
    calendar        = "calendar",
    timer           = "timer",
    hourglass       = "hourglass",
    history         = "history",

    shopping        = "shopping-cart",
    ["shopping-bag"]= "shopping-bag",
    gift            = "gift",
    package         = "package",
    truck           = "truck",
    coins           = "coins",
    ["credit-card"] = "credit-card",
    wallet          = "wallet",
    ["bar-chart"]   = "bar-chart-2",
    ["pie-chart"]   = "pie-chart",
    ["trend-up"]    = "trending-up",
    ["trend-down"]  = "trending-down",

    sun             = "sun",
    moon            = "moon",
    ["cloud-rain"]  = "cloud-rain",
    ["cloud-snow"]  = "cloud-snow",
    wind            = "wind",
    umbrella        = "umbrella",
    thermometer     = "thermometer",
    droplet         = "droplet",
    zap             = "zap",
    fire            = "flame",

    map             = "map",
    ["map-pin"]     = "map-pin",
    navigation      = "navigation",
    compass         = "compass",
    globe           = "globe",
    globe2          = "globe-2",

    paint           = "palette",
    brush           = "brush",
    pen             = "pen",
    type            = "type",
    bold            = "bold",
    italic          = "italic",
    underline       = "underline",
    smile           = "smile",
    ["meh"]         = "meh",
    frown           = "frown",
    activity        = "activity",
    aperture        = "aperture",
    award           = "award",
    box             = "box",
    briefcase       = "briefcase",
    ["bug"]         = "bug",
    command         = "command",
    feather         = "feather",
    anchor          = "anchor",
    infinity        = "infinity",
    percent         = "percent",
    ["rss"]         = "rss",
    ["toggle-left"] = "toggle-left",
    ["toggle-right"]= "toggle-right",
    zoom_in         = "zoom-in",
    zoom_out        = "zoom-out",
}

local CustomIcons   = {}
local IconTypeCache = {}

function Icons.Register(name, assetId)
    CustomIcons[name]   = assetId
    IconTypeCache[name] = "rbxasset"
end

function Icons.RegisterLucide(customName, lucideName)
    LucideMap[customName]      = lucideName
    IconTypeCache[customName]  = "lucide"
end

function Icons.Get(name)
    if not name then return nil end
    if CustomIcons[name] then return CustomIcons[name] end
    if LucideMap[name]   then return "lucide:" .. LucideMap[name] end
    return nil
end

function Icons.GetType(name)
    if not name then return nil end
    if CustomIcons[name] then return "rbxasset" end
    if LucideMap[name]   then return "lucide" end
    return nil
end

function Icons.GetLucideName(name)
    return LucideMap[name]
end

return Icons