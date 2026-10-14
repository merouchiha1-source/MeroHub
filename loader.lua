-- Made by مـــيـــرو اوتـشـيــهـا
-- (رابط الواجهة الأساسية التي يتم جلبها لتصميم القائمة والأزرار)[span_1](start_span)[span_1](end_span)
local SLATE_URL = "https://raw.githubusercontent.com/PulseZax/Slate/refs/heads/main/.lua[span_2](start_span)"[span_2](end_span)

-- (رابط سيرفر الديسكورد الخاص بك)
local DISCORD_INVITE = "https://discord.gg/E7BTbVBsGy"

-- (محاولة نسخ رابط الديسكورد تلقائياً للحافظة إذا كان التنفيذ يدعمها)
pcall(function()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
    end
end)

-- (قائمة الألعاب المدعومة والسكربتات الخاصة بكل لعبة)[span_3](start_span)[span_3](end_span)
local CATALOG = {
    {
        Key = "mm2",
        Name = "Murder Mystery 2",
        Places = { 142823291 },
        Universe = 66654135,
        Loader = "https://api.luarmor.net/files/v4/loaders/5857a6cfae3b902eb3c2dff7cdbf173b.lua",
        Listed = true,
        Tone = Color3.fromRGB(214, 68, 88),
    },
    {
        Key = "speed",
        Name = "+1 Speed Keyboard Escape",
        Places = { 95082159892680, 118941584817777, 93411036959889 },
        Universe = 9584852943,
        Loader = "https://api.luarmor.net/files/v4/loaders/385c6d8937bfc4ef284dc8c27b50e1c5.lua",
        Listed = false,
        Tone = Color3.fromRGB(236, 176, 72),
    },
    {
        Key = "gag",
        Name = "Grow A Garden 2",
        Places = { 97598239454123 },
        Universe = 10200395747,
        Loader = "https://api.luarmor.net/files/v4/loaders/abd74919679fad90b027ed4e177cea66.lua",
        Listed = true,
        Tone = Color3.fromRGB(76, 175, 92),
    },
    {
        Key = "sandiego",
        Name = "San Diego Border Roleplay",
        Places = { 136020512003847 },
        Universe = 9855761734,
        Loader = "https://api.luarmor.net/files/v4/loaders/16e8365b42517b9a82b7e0a9f4120d3c.lua",
        Listed = true,
        Tone = Color3.fromRGB(72, 132, 220),
    },
    {
        Key = "stealegg",
        Name = "Steal An Egg",
        Places = { 107778070777162 },
        Universe = 10563114921,
        Loader = "https://api.luarmor.net/files/v4/loaders/f8f6c5e226e577900c9f873c822ac49c.lua",
        Listed = true,
        Tone = Color3.fromRGB(226, 168, 62),
    },
    {
        Key = "rivals",
        Name = "RIVALS",
        Places = { 17625359962, 71874690745115, 117398147513099, 129604661913557, 133215910299950, 18126510175 },
        Universe = 6035872082,
        Loader = "https://api.luarmor.net/files/v4/loaders/8ea20a4f7e9fb8343eec902723cf66f6.lua",
        Listed = true,
        Tone = Color3.fromRGB(90, 169, 255),
    },
    {
        Key = "bloxstrike",
        Name = "BloxStrike",
        Places = { 114234929420007, 108194354348181, 135434213652028, 101836176558619 },
        Universe = 7633926880,
        Loader = "https://api.luarmor.net/files/v4/loaders/107fbc36b735fcffe3b85e3eb7b84eb5.lua",
        Listed = true,
        Tone = Color3.fromRGB(217, 164, 65),
    },
    {
        Key = "kukirin",
        Name = "Drive A Kukirin!",
        Places = { 71704434889758 },
        Universe = 10634461028,
        Loader = "https://raw.githubusercontent.com/PulseZax/driveakukirin/refs/heads/main/.lua",
        Listed = true,
        Tone = Color3.fromRGB(242, 140, 46),
    },
}

local Players = game:GetService("Players")

-- (دالة جلب صور أيقونات المابص)[span_4](start_span)[span_4](end_span)
local function thumb(placeId)
    return string.format("rbxthumb://type=Asset&id=%d&w=150&h=150", placeId)
end

-- (دالة تشغيل السكربت الخاص باللعبة)[span_5](start_span)[span_5](end_span)
local function launch(entry)
    return pcall(function()
        return loadstring(game:HttpGet(entry.Loader), "@" .. entry.Key)()
    end)
end

-- (دالة تفعيل الأزرار واللمس عليها في الواجهة)[span_6](start_span)[span_6](end_span)
local function arm(element, action)
    if type(element) ~= "table" then
        return
    end
    local last = 0
    for _, part in ipairs({ element.button, element.card, element.hitbox }) do
        if typeof(part) == "Instance" then
            pcall(function()
                part.Active = true
                part.InputBegan:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1
                        and input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    if os.clock() - last < 0.5 then
                        return
                    end
                    last = os.clock()
                    action()
                end)
            end)
        end
    end
end

-- (دالة مطابقة رقم الماب الحالي مع القائمة)[span_7](start_span)[span_7](end_span)
local function matchPlace(placeId, universeId)
    for _, entry in ipairs(CATALOG) do
        if entry.Universe and entry.Universe == universeId then
            return entry
        end
    end
    for _, entry in ipairs(CATALOG) do
        for _, id in ipairs(entry.Places) do
            if id == placeId then
                return entry
            end
        end
    end
    return nil
end

-- (فحص اللعبة الحالية، وإذا كانت مدعومة يتم تشغيل سكربتها فوراً)[span_8](start_span)[span_8](end_span)
local supported = matchPlace(game.PlaceId, game.GameId)
if supported then
    local ok, err = launch(supported)
    if not ok then
        warn("Pulse Hub: " .. supported.Name .. " failed to start - " .. tostring(err))
    end
    return
end

-- (إذا كانت اللعبة غير مدعومة، يتم تجهيز واجهة القائمة الرئيسية)[span_9](start_span)[span_9](end_span)
if type(_G.PulseHubLoader) == "table" then
    pcall(function()
        _G.PulseHubLoader.Window:Destroy()
    end)
end
_G.PulseHubLoader = {}

local Slate = loadstring(game:HttpGet(SLATE_URL), "@Slate")()

pcall(function()
    Slate.Cleanup()
end)
pcall(function()
    Slate:PreloadIcons({ "lucide" })
end)

-- (إنشاء نافذة القائمة الرئيسية Pulse Hub وإعداداتها)[span_10](start_span)[span_10](end_span)
local Window = Slate:CreateWindow({
    Name = "Pulse Hub",
    Subtitle = "script loader",
    Icon = "zap",
    Logo = true,
    Size = UDim2.fromOffset(700, 500),
    ToggleKey = Enum.KeyCode.LeftControl,
})

pcall(function()
    Slate.Theme.Preset("Ash")
end)
pcall(function()
    Slate:SetFontFamily("JosefinSans")
end)
pcall(function()
    Window:SetBackdrop("aurora")
end)
pcall(function()
    local corner = Window.root:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(0, 6)
    end
    local stroke = Window.root:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Thickness = 0
    end
end)

_G.PulseHubLoader.Window = Window

local Tab = Window:CreateTab({ Name = "Scripts", Icon = "layout-grid" })

local placeName = "this game"
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    if info and info.Name then
        placeName = info.Name
    end
end)

-- (عرض قسم التنبيه بأن اللعبة الحالية غير مدعومة مباشرة)[span_11](start_span)[span_11](end_span)
do
    local notice = Tab:CreateSection({ Name = "Unsupported game" })
    notice:Paragraph({
        Name = "No script for " .. placeName,
        Description = "Every script below reads its own game data on start and will stall here.",
    })
end

-- (عرض قائمة الألعاب المتاحة بشكل شبكة مربعات أزرار)[span_12](start_span)[span_12](end_span)
do
    local list = Tab:CreateSection({ Name = "Available scripts" })
    local grid = list:Grid({ Columns = 2, Height = 206, MinWidth = 196 })

    for _, entry in ipairs(CATALOG) do
        if entry.Listed then
            local start = function()
                Slate:Notify({
                    Title = "Pulse Hub",
                    Description = "Starting " .. entry.Name,
                    Icon = "play",
                    Duration = 5,
                })
                task.spawn(function()
                    local finished, ok, err = false, nil, nil
                    task.spawn(function()
                        ok, err = launch(entry)
                        finished = true
                    end)
                    local waited = 0
                    while not finished and waited < 6 do
                        task.wait(0.25)
                        waited += 0.25
                    end
                    if not finished then
                        Slate:Notify({
                            Title = "Pulse Hub",
                            Description = entry.Name .. " is stuck waiting for its own game data",
                            Icon = "triangle-alert",
                            Tone = "Warning",
                            Duration = 10,
                        })
                    elseif not ok then
                        Slate:Notify({
                            Title = "Pulse Hub",
                            Description = entry.Name .. " failed: " .. tostring(err),
                            Icon = "circle-alert",
                            Tone = "Danger",
                            Duration = 10,
                        })
                    else
                        Slate:Notify({
                            Title = "Pulse Hub",
                            Description = entry.Name .. " started",
                            Icon = "circle-check",
                            Tone = "Success",
                            Duration = 8,
                        })
                    end
                end)
            end
            local card = grid:Invite({
                Name = entry.Name,
                Icon = thumb(entry.Places[1]),
                Stats = {
                    { Text = "Place " .. tostring(entry.Places[1]), Dot = entry.Tone },
                },
                Game = "ROBLOX",
                GameIcon = "gamepad-2",
                Tone = entry.Tone,
                Glyph = "play",
                ButtonText = "Run",
                ButtonColor = entry.Tone,
                CopiedText = "Starting",
                Callback = start,
            })
            arm(card, start)
        end
    end
end

-- (زر إغلاق القائمة في النهاية)[span_13](start_span)[span_13](end_span)
do
    local close = Tab:CreateSection({ Name = "Menu" })
    close:Button({
        Name = "Close menu",
        Icon = "x",
        Callback = function()
            pcall(function()
                Window:Destroy()
            end)
            _G.PulseHubLoader = nil
        end,
    })
end

-- (إشعار الديسكورد والترحيب الفخم بميرو)
Slate:Notify({
    Title = "Discord Server | مـــيـــرو",
    Description = "تم نسخ رابط سيرفر الديسكورد! تعال رح تلاقي كل السكربتات هناك: " .. DISCORD_INVITE,
    Icon = "message-circle",
    Tone = "Success",
    Duration = 12,
})

-- (إشعار التنبيه الأولي عند فتح القائمة بالمقاب)[span_14](start_span)[span_14](end_span)
Slate:Notify({
    Title = "Pulse Hub",
    Description = "No script for " .. placeName .. ". Pick one below to run it anyway.",
    Icon = "triangle-alert",
    Tone = "Warning",
    Duration = 10,
})
