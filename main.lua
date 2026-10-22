-- ================================================================
-- REDZ HUB | محمي من قبل 𝒍𝒂𝒏𝒔𝒉𝒆𝒓 و 𝒔𝒍𝒂𝒏𝒅𝒆𝒓
-- لا يمكن استخدامه إلا من أصدقاء Lansher و Slander
-- ================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ============ COLORS ============
local C = {
    Bg      = Color3.fromRGB(12, 10, 18),
    Panel   = Color3.fromRGB(22, 18, 30),
    Elem    = Color3.fromRGB(38, 30, 48),
    Acc     = Color3.fromRGB(180, 40, 60),
    Acc2    = Color3.fromRGB(255, 90, 110),
    Txt     = Color3.fromRGB(240, 240, 245),
    Sub     = Color3.fromRGB(150, 150, 160),
    Green   = Color3.fromRGB(100, 220, 120),
    Yellow  = Color3.fromRGB(255, 220, 100),
}

-- ============ CLEANUP ============
if CoreGui:FindFirstChild("REDZ_HUB_UI") then
    CoreGui.REDZ_HUB_UI:Destroy()
end

-- ============ FILE SETUP ============
if not isfolder("RedzHub") then makefolder("RedzHub") end
local playtimeFile = "RedzHub/playtime.txt"
local savedPlaytime = 0
if isfile(playtimeFile) then
    local ok, v = pcall(readfile, playtimeFile)
    if ok then savedPlaytime = tonumber(v) or 0 end
end
local sessionStart = tick()
task.spawn(function()
    while true do
        task.wait(20)
        pcall(writefile, playtimeFile, tostring(savedPlaytime + (tick() - sessionStart)))
    end
end)
local function getHoursActive()
    return (savedPlaytime + (tick() - sessionStart)) / 3600
end

-- ============ ANIMATION IDS (بدلها لو تبي) ============
local ANIMS = {
    BangBehind  = "rbxassetid://12874253069",
    BangForward = "rbxassetid://12518131721",
}

-- ============ VARIABLES ============
local CurrentBangSpeed = 1
local CurrentSuckSpeed = 1
local TargetPlayer = nil
local bangTrackA, bangTrackB = nil, nil
local activeTrack = nil
local isBangActive = false

-- Timer/Tracking
local tracked = {
    userId = nil,
    name = nil,
    totalTime = 0,
    sessionStart = 0,
    active = false,
    exits = 0,
    entries = 0,
}

-- ============ UI ============
local Gui = Instance.new("ScreenGui")
Gui.Name = "REDZ_HUB_UI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 999
Gui.Parent = CoreGui

-- Toggle Button
local toggle = Instance.new("ImageButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 58, 0, 58)
toggle.Position = UDim2.new(0, 20, 0.5, -29)
toggle.BackgroundColor3 = C.Acc
toggle.Image = "rbxassetid://134125667034392"
toggle.BorderSizePixel = 0
toggle.Draggable = true
toggle.AutoButtonColor = false
toggle.Parent = Gui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local tglStroke = Instance.new("UIStroke", toggle)
tglStroke.Color = C.Acc2
tglStroke.Thickness = 2

TweenService:Create(toggle, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Size = UDim2.new(0, 62, 0, 62)
}):Play()

-- Main Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 660, 0, 490)
main.Position = UDim2.new(0.5, -330, 0.5, -245)
main.BackgroundColor3 = C.Bg
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = Gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.Acc
mainStroke.Thickness = 2

-- Background Image (as requested)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://77924857384829"
bg.ScaleType = Enum.ScaleType.Crop
bg.ImageTransparency = 0.78
bg.ZIndex = 0
bg.Parent = main
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 14)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = C.Acc
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -100, 1, 0)
titleLbl.Position = UDim2.new(0, 15, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "REDZ HUB  |  𝒍𝒂𝒏𝒔𝒉𝒆𝒓"
titleLbl.TextColor3 = C.Txt
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 17
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 2
titleLbl.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 3
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 150, 1, -54)
tabBar.Position = UDim2.new(0, 10, 0, 48)
tabBar.BackgroundColor3 = C.Panel
tabBar.BackgroundTransparency = 0.35
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 2
tabBar.Parent = main
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
local tabPad = Instance.new("UIPadding", tabBar)
tabPad.PaddingTop = UDim.new(0, 8)
tabPad.PaddingLeft = UDim.new(0, 5)
tabPad.PaddingRight = UDim.new(0, 5)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -175, 1, -54)
content.Position = UDim2.new(0, 168, 0, 48)
content.BackgroundColor3 = C.Panel
content.BackgroundTransparency = 0.35
content.BorderSizePixel = 0
content.ZIndex = 2
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)

-- ============ HELPER FUNCTIONS ============
local tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = C.Elem
    btn.BackgroundTransparency = 0.3
    btn.Text = "  " .. name
    btn.TextColor3 = C.Sub
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.ZIndex = 3
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -12, 1, -12)
    page.Position = UDim2.new(0, 6, 0, 6)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = C.Acc
    page.ZIndex = 3
    page.Visible = false
    page.Parent = content
    local pl = Instance.new("UIListLayout", page)
    pl.Padding = UDim.new(0, 6)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pl.AbsoluteContentSize.Y + 10)
    end)

    tabs[name] = { btn = btn, page = page }
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.btn.BackgroundColor3 = C.Elem
            t.btn.TextColor3 = C.Sub
            t.page.Visible = false
        end
        btn.BackgroundColor3 = C.Acc
        btn.TextColor3 = C.Txt
        page.Visible = true
    end)
    return page
end

local function makeBtn(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 34)
    b.BackgroundColor3 = C.Elem
    b.BackgroundTransparency = 0.15
    b.Text = text
    b.TextColor3 = C.Txt
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.ZIndex = 4
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Acc}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Elem}):Play()
    end)
    if cb then b.MouseButton1Click:Connect(cb) end
    return b
end

local function makeTxt(parent, placeholder, cb)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, -8, 0, 32)
    t.BackgroundColor3 = C.Elem
    t.BackgroundTransparency = 0.15
    t.Text = ""
    t.PlaceholderText = placeholder
    t.PlaceholderColor3 = C.Sub
    t.TextColor3 = C.Txt
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 13
    t.BorderSizePixel = 0
    t.ZIndex = 4
    t.Parent = parent
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    if cb then t.FocusLost:Connect(function() cb(t.Text) end) end
    return t
end

local function makeLbl(parent, text, h, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, h or 24)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or C.Txt
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 4
    l.Parent = parent
    return l
end

-- ============ TOGGLE LOGIC ============
local isOpen = false
local function setOpen(state)
    isOpen = state
    if state then
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 660, 0, 490)
        }):Play()
    else
        local tw = TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() main.Visible = false end)
    end
end
toggle.MouseButton1Click:Connect(function() setOpen(not isOpen) end)
closeBtn.MouseButton1Click:Connect(function() setOpen(false) end)

-- ============ TAB 1: بانق GG ============
local t1 = createTab("بانق GG")

makeLbl(t1, "اكتب اول 3 احرف من اسم الشخص:")
local searchBox = makeTxt(t1, "مثال: abc")

-- Info panel
local infoPanel = Instance.new("Frame")
infoPanel.Size = UDim2.new(1, -8, 0, 95)
infoPanel.BackgroundColor3 = C.Elem
infoPanel.BackgroundTransparency = 0.3
infoPanel.BorderSizePixel = 0
infoPanel.ZIndex = 4
infoPanel.Parent = t1
Instance.new("UICorner", infoPanel).CornerRadius = UDim.new(0, 8)

local profPic = Instance.new("ImageLabel")
profPic.Size = UDim2.new(0, 75, 0, 75)
profPic.Position = UDim2.new(0, 10, 0, 10)
profPic.BackgroundColor3 = C.Bg
profPic.BorderSizePixel = 0
profPic.Image = ""
profPic.ZIndex = 5
profPic.Parent = infoPanel
Instance.new("UICorner", profPic).CornerRadius = UDim.new(1, 0)

local nameLbl = Instance.new("TextLabel")
nameLbl.Size = UDim2.new(1, -100, 0, 24)
nameLbl.Position = UDim2.new(0, 95, 0, 10)
nameLbl.BackgroundTransparency = 1
nameLbl.Text = "لا يوجد لاعب"
nameLbl.TextColor3 = C.Txt
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 15
nameLbl.TextXAlignment = Enum.TextXAlignment.Left
nameLbl.ZIndex = 5
nameLbl.Parent = infoPanel

local exitLbl = Instance.new("TextLabel")
exitLbl.Size = UDim2.new(0, 110, 0, 20)
exitLbl.Position = UDim2.new(0, 95, 0, 38)
exitLbl.BackgroundTransparency = 1
exitLbl.Text = "خروج: 0"
exitLbl.TextColor3 = C.Acc2
exitLbl.Font = Enum.Font.GothamMedium
exitLbl.TextSize = 12
exitLbl.TextXAlignment = Enum.TextXAlignment.Left
exitLbl.ZIndex = 5
exitLbl.Parent = infoPanel

local entryLbl = Instance.new("TextLabel")
entryLbl.Size = UDim2.new(0, 110, 0, 20)
entryLbl.Position = UDim2.new(0, 210, 0, 38)
entryLbl.BackgroundTransparency = 1
entryLbl.Text = "دخول: 0"
entryLbl.TextColor3 = C.Green
entryLbl.Font = Enum.Font.GothamMedium
entryLbl.TextSize = 12
entryLbl.TextXAlignment = Enum.TextXAlignment.Left
entryLbl.ZIndex = 5
entryLbl.Parent = infoPanel

local timerLbl = Instance.new("TextLabel")
timerLbl.Size = UDim2.new(0, 160, 0, 22)
timerLbl.Position = UDim2.new(0, 95, 0, 62)
timerLbl.BackgroundTransparency = 1
timerLbl.Text = "⏱ 00:00:00"
timerLbl.TextColor3 = C.Yellow
timerLbl.Font = Enum.Font.GothamBold
timerLbl.TextSize = 14
timerLbl.TextXAlignment = Enum.TextXAlignment.Left
timerLbl.ZIndex = 5
timerLbl.Parent = infoPanel

-- Bang buttons
local bangBtn = makeBtn(t1, "BANG (من الخلف)", function() triggerBang(false) end)
local bangFwdBtn = makeBtn(t1, "BANG FORWARD (مص/لعق)", function() triggerBang(true) end)

makeLbl(t1, "سرعة البانق (1-300):")
local spd1Box = makeTxt(t1, "1-300", function(txt)
    local n = tonumber(txt)
    if n and n >= 1 and n <= 300 then
        CurrentBangSpeed = n
    end
end)
makeBtn(t1, "START - تثبيت سرعة البانق", function()
    local n = tonumber(spd1Box.Text)
    if n and n >= 1 and n <= 300 then
        CurrentBangSpeed = n
        if activeTrack then activeTrack:AdjustSpeed(CurrentBangSpeed) end
    end
end)

makeLbl(t1, "سرعة المص/اللعق (1-300):")
local spd2Box = makeTxt(t1, "1-300", function(txt)
    local n = tonumber(txt)
    if n and n >= 1 and n <= 300 then
        CurrentSuckSpeed = n
    end
end)
makeBtn(t1, "START - تثبيت سرعة المص/اللعق", function()
    local n = tonumber(spd2Box.Text)
    if n and n >= 1 and n <= 300 then
        CurrentSuckSpeed = n
    end
end)

-- ============ TAB 2: أوامر انفنتي ============
local t2 = createTab("أوامر انفنتي")
local cmds = {
    "2022materials", "clearerror", "antilag", "xray",
    "antiafk", "antikick", "backtrack nan", "backtrack 999",
    "datalimit 660", "autokeypress nan", "autokeypress",
    "Replicationlag 999", "nofog"
}
for _, cmd in ipairs(cmds) do
    makeBtn(t2, cmd, function()
        pcall(setclipboard, cmd)
        local old = t2.Parent
    end)
end

-- ============ TAB 3: سكربتات تحسين ============
local t3 = createTab("سكربتات تحسين")
local improvements = {
    { name = "Script 1 - Pastebin trEyCGm1", url = "https://pastebin.com/raw/trEyCGm1" },
    { name = "Universal 3skr Hub",            url = "https://scriptblox.com/raw/Universal-Script-3skr-hub-240428" },
    { name = "Script 2 - Pastebin HMEBL5Y7",  url = "https://pastebin.com/raw/HMEBL5Y7" },
    { name = "Script 3 - Pastebin SVBWBNMN",  url = "https://pastebin.com/raw/SVBWBNMN" },
    { name = "Script 4 - Pastebin jNBy9uhB",  url = "https://pastebin.com/raw/jNBy9uhB" },
}
for _, s in ipairs(improvements) do
    makeBtn(t3, s.name, function()
        task.spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(s.url))()
            end)
            if not ok then warn("REDZ HUB | Script error: " .. tostring(err)) end
        end)
    end)
end

-- ============ TAB 4: سكربتات خاصه ============
local t4 = createTab("سكربتات خاصه")
local specials = {
    { name = "Script 1 - Pastefy mXMaE9fC",       url = "https://pastefy.app/mXMaE9fC/raw" },
    { name = "AL7FRAA MADARA Hub",                 url = "https://raw.githubusercontent.com/MADARA9223/AL7FRAA-MADARAxCATAY/refs/heads/main/AL7FRAA%20%7C%20MADARAxCATAYxROBERTO" },
    { name = "Script 2 - Pastebin JEUtzDyu",       url = "https://pastebin.com/raw/JEUtzDyu" },
    { name = "AL-QYADAH F7LK",                     url = "https://raw.githubusercontent.com/professor-f7lk/AL-QYADAHF7LK-/refs/heads/main/README.md" },
    { name = "Script 3 - Pastebin mAtRSqbu",       url = "https://pastebin.com/raw/mAtRSqbu" },
    { name = "Script 4 - Pastefy WhGd80IZ",        url = "https://pastefy.app/WhGd80IZ/raw" },
    { name = "GAROU XR7",                          url = "https://scriptblox.com/raw/Universal-Script-GAROU-XR7-230829" },
    { name = "Kaize25 KP Hub",                     url = "https://encrypt-x.pages.dev/Scripts?Id=Kaize25KP" },
}
for _, s in ipairs(specials) do
    makeBtn(t4, s.name, function()
        task.spawn(function()
            local ok, err = pcall(function()
                if s.url:find("encrypt%-x") then
                    loadstring(game:HttpGet(s.url))("Kaize25KP")
                else
                    loadstring(game:HttpGet(s.url))()
                end
            end)
            if not ok then warn("REDZ HUB | Script error: " .. tostring(err)) end
        end)
    end)
end

-- ============ TAB 5: رتب ============
local t5 = createTab("رتب")

local ranks = {
    { name = "👑 مالك السكربت", password = "omar",   key = "owner" },
    { name = "⭐ ادمن",         password = "scopa",  key = "admin" },
    { name = "🔰 صملاوي (تلقائي بعد 50 ساعة)", password = nil, key = "free" },
}

local function activateRank(rankKey)
    if rankKey == "free" then
        if getHoursActive() >= 50 then
            return true
        end
        return false
    end
    pcall(writefile, "RedzHub/rank_" .. rankKey .. ".txt", "1")
    return true
end

local function checkRank(rankKey)
    if rankKey == "free" then return getHoursActive() >= 50 end
    return isfile("RedzHub/rank_" .. rankKey .. ".txt")
end

for _, r in ipairs(ranks) do
    makeLbl(t5, r.name, 26, C.Acc2)
    if r.password then
        local pwBox = makeTxt(t5, "كلمة السر")
        makeBtn(t5, "START - تفعيل", function()
            if pwBox.Text == r.password then
                activateRank(r.key)
                pwBox.Text = "✅ تم التفعيل"
                pwBox.TextColor3 = C.Green
            else
                pwBox.Text = "❌ كلمة سر خاطئة"
                pwBox.TextColor3 = C.Acc2
            end
        end)
    else
        makeBtn(t5, "التحقق من الحالة", function()
            if checkRank(r.key) then
                makeLbl(t5, "✅ الرتبة مفعلة - " .. math.floor(getHoursActive()) .. "h", 22, C.Green)
            else
                local remain = 50 - getHoursActive()
                makeLbl(t5, "⏳ باقي " .. string.format("%.1f", remain) .. " ساعة", 22, C.Yellow)
            end
        end)
    end
end

-- ============ TAB 6: حقوق ============
local t6 = createTab("حقوق")
makeLbl(t6, "📱 تيك توك: w_.0.10", 30, C.Acc2)
makeLbl(t6, "💬 ديسكورد: 9z_e.1", 30, C.Acc2)
makeLbl(t6, "─────────────────", 20)
makeLbl(t6, "🔒 السكربت محمي من قبل 𝒍𝒂𝒏𝒔𝒉𝒆𝒓", 22, C.Yellow)
makeLbl(t6, "لا يمكن استخدامه إلا أصدقاء 𝒍𝒂𝒏𝒔𝒉𝒆𝒓", 22, C.Txt)
makeLbl(t6, "أو أصدقاء 𝒔𝒍𝒂𝒏𝒅𝒆𝒓", 22, C.Txt)
makeLbl(t6, "و 𝐴𝑆 وأصدقائهم ❌", 22, C.Acc2)

-- ============ OPEN DEFAULT TAB ============
tabs["بانق GG"].btn:Fire("MouseButton1Click")
-- fix: manually set visible
for _, t in pairs(tabs) do t.page.Visible = false end
tabs["بانق GG"].btn.BackgroundColor3 = C.Acc
tabs["بانق GG"].btn.TextColor3 = C.Txt
tabs["بانق GG"].page.Visible = true

-- ============ PLAYER SEARCH ============
local function findPlayer(prefix)
    if #prefix < 3 then return nil end
    prefix = string.lower(prefix)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and string.sub(string.lower(p.Name), 1, #prefix) == prefix then
            return p
        end
    end
    return nil
end

local function fmtTime(sec)
    sec = math.floor(sec)
    return string.format("%02d:%02d:%02d", math.floor(sec/3600), math.floor(sec%3600/60), sec%60)
end

local function updateTimerDisplay()
    if tracked.active then
        timerLbl.Text = "⏱ " .. fmtTime(tracked.totalTime + (tick() - tracked.sessionStart))
    else
        timerLbl.Text = "⏱ " .. fmtTime(tracked.totalTime)
    end
    exitLbl.Text = "خروج: " .. tracked.exits
    entryLbl.Text = "دخول: " .. tracked.entries
end

RunService.Heartbeat:Connect(updateTimerDisplay)

local function selectTarget(player)
    TargetPlayer = player
    tracked.userId = player.UserId
    tracked.name = player.Name
    tracked.totalTime = 0
    tracked.sessionStart = tick()
    tracked.active = true
    tracked.exits = 0
    tracked.entries = 1
    nameLbl.Text = player.Name
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if ok and img then profPic.Image = img end
    end)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = searchBox.Text
    if #txt < 3 then return end
    local found = findPlayer(txt)
    if found then
        if TargetPlayer ~= found then selectTarget(found) end
    else
        nameLbl.Text = "لا يوجد لاعب مطابق"
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if tracked.userId == p.UserId then
        if tracked.active then
            tracked.totalTime = tracked.totalTime + (tick() - tracked.sessionStart)
            tracked.active = false
        end
        tracked.exits = tracked.exits + 1
    end
end)

Players.PlayerAdded:Connect(function(p)
    if tracked.userId == p.UserId then
        tracked.sessionStart = tick()
        tracked.active = true
        tracked.entries = tracked.entries + 1
    end
end)

-- ============ BANG LOGIC ============
function triggerBang(forward)
    if not TargetPlayer or not TargetPlayer.Character then return end
    if not LocalPlayer.Character then return end

    local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local tgtHum = TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tgtHrp = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (myHum and tgtHum and myHrp and tgtHrp) then return end

    -- Stop previous
    if bangTrackA then pcall(function() bangTrackA:Stop() end) end
    if bangTrackB then pcall(function() bangTrackB:Stop() end) end

    local animId = forward and ANIMS.BangForward or ANIMS.BangBehind
    local speed = forward and CurrentSuckSpeed or CurrentBangSpeed

    local anim = Instance.new("Animation")
    anim.AnimationId = animId

    local okA = pcall(function()
        bangTrackA = myHum:LoadAnimation(anim)
        bangTrackA:Play()
        bangTrackA:AdjustSpeed(speed)
    end)
    local okB = pcall(function()
        bangTrackB = tgtHum:LoadAnimation(anim)
        bangTrackB:Play()
        bangTrackB:AdjustSpeed(speed)
    end)

    activeTrack = bangTrackA
    isBangActive = true

    -- Position (behind vs forward)
    local offset = forward and CFrame.new(0, 0, -1.5) or CFrame.new(0, 0, 1.5)
    pcall(function()
        myHrp.CFrame = tgtHrp.CFrame * offset
    end)

    -- Face each other
    task.spawn(function()
        for _ = 1, 30 do
            if not (myHrp and myHrp.Parent and tgtHrp and tgtHrp.Parent) then break end
            local look = forward and tgtHrp.CFrame.LookVector or -tgtHrp.CFrame.LookVector
            pcall(function()
                myHrp.CFrame = CFrame.new(tgtHrp.Position + (forward and -look*1.5 or look*1.5), tgtHrp.Position)
            end)
            task.wait(0.1)
        end
    end)
end

-- ============ SCRIPT END ============
print("[REDZ HUB] Loaded successfully | Protected by 𝒍𝒂𝒏𝒔𝒉𝒆𝒓")
