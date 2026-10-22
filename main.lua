--[[
    ═══════════════════════════════════════════
              REDZ HUB  |  by 𝒍𝒂𝒏𝒔𝒉𝒆𝒓
    ═══════════════════════════════════════════
    Protected by 𝒍𝒂𝒏𝒔𝒉𝒆𝒓
    لا يمكن استخدامه إلا لأصدقاء 𝒍𝒂𝒏𝒔𝒉𝒆𝒓 و 𝒔𝒍𝒂𝒏𝒅𝒆𝒓
]]

-- ═══════════════ SERVICES ═══════════════
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")

local LP = Players.LocalPlayer

-- ═══════════════ CONFIG ═══════════════
local TOGGLE_IMG = "rbxassetid://134125667034392"
local BG_IMG     = "rbxassetid://77924857384829"

-- ⚠️ استبدل هذه الأي دي بأسكربتات الحركة الخاصة بك (البانق والمص)
local BANG_ANIM = "rbxassetid://507771019"   -- ← ضع أي دي حركة البانق
local SUCK_ANIM = "rbxassetid://507770239"   -- ← ضع أي دي حركة المص/اللعق

local OWNER_PASS = "omar"
local ADMIN_PASS = "scopa"

local USAGE_START = tick()
local RANK = "none"

-- ═══════════════ CLEANUP OLD ═══════════════
if game.CoreGui:FindFirstChild("REDZ_HUB") then
    game.CoreGui.REDZ_HUB:Destroy()
end

-- ═══════════════ MAIN GUI ═══════════════
local SG = Instance.new("ScreenGui")
SG.Name = "REDZ_HUB"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game.CoreGui

-- ─── زر التفعيل ───
local Toggle = Instance.new("ImageButton")
Toggle.Name = "Toggle"
Toggle.Size = UDim2.new(0, 60, 0, 60)
Toggle.Position = UDim2.new(0, 20, 0, 300)
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Toggle.Image = TOGGLE_IMG
Toggle.BorderSizePixel = 0
Toggle.ZIndex = 10
Toggle.Parent = SG
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", Toggle)
tStroke.Color = Color3.fromRGB(150, 50, 255)
tStroke.Thickness = 2

-- سحب زر التفعيل
local dragT, tStart, tPos
Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragT = true; tStart = input.Position; tPos = Toggle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragT = false end
        end)
    end
end)

-- ─── الواجهة الرئيسية ───
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 620, 0, 440)
Main.Position = UDim2.new(0.5, -310, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 5
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(150, 50, 255)
mainStroke.Thickness = 1.5

-- خلفية صورة
local bgImg = Instance.new("ImageLabel", Main)
bgImg.Size = UDim2.new(1, 0, 1, 0)
bgImg.BackgroundTransparency = 1
bgImg.Image = BG_IMG
bgImg.ImageTransparency = 0.55
bgImg.ScaleType = Enum.ScaleType.Crop
bgImg.ZIndex = 5
Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 12)

-- ─── الهيدر ───
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Header.BackgroundTransparency = 0.15
Header.ZIndex = 6
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "REDZ HUB  |  𝒍𝒂𝒏𝒔𝒉𝒆𝒓"
Title.TextColor3 = Color3.fromRGB(170, 80, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 6
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- سحب الواجهة
local dragM, mStart, mPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragM = true; mStart = input.Position; mPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragM = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragM and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - mStart
        Main.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + d.X, mPos.Y.Scale, mPos.Y.Offset + d.Y)
    end
    if dragT and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - tStart
        Toggle.Position = UDim2.new(tPos.X.Scale, tPos.X.Offset + d.X, tPos.Y.Scale, tPos.Y.Offset + d.Y)
    end
end)

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ─── شريط التابات ───
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0, 135, 1, -55)
TabBar.Position = UDim2.new(0, 5, 0, 50)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
TabBar.BackgroundTransparency = 0.25
TabBar.ZIndex = 6
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)
local tList = Instance.new("UIListLayout", TabBar)
tList.Padding = UDim.new(0, 4)
tList.SortOrder = Enum.SortOrder.LayoutOrder
local tPad = Instance.new("UIPadding", TabBar)
tPad.PaddingTop = UDim.new(0, 4)
tPad.PaddingLeft = UDim.new(0, 4)
tPad.PaddingRight = UDim.new(0, 4)

-- ─── منطقة المحتوى ───
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -150, 1, -60)
Content.Position = UDim2.new(0, 145, 0, 52)
Content.BackgroundTransparency = 1
Content.ZIndex = 6

-- ═══════════════ HELPERS ═══════════════
local Tabs = {}

local function MakeTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 7
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame", Content)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Visible = false
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
    scroll.ZIndex = 6
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingRight = UDim.new(0, 6)
    local ll = Instance.new("UIListLayout", scroll)
    ll.Padding = UDim.new(0, 5)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 10)
    end)

    Tabs[name] = { Button = btn, Frame = scroll }
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            t.Button.TextColor3 = Color3.fromRGB(200, 200, 220)
            t.Frame.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        scroll.Visible = true
    end)
    return scroll
end

local function MakeButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(220, 220, 240)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.ZIndex = 7
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function MakeLabel(parent, text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 26)
    l.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(200, 200, 220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.ZIndex = 7
    l.Parent = parent
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 4)
    return l
end

local function MakeTextbox(parent, placeholder)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, 0, 0, 32)
    t.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    t.Text = ""
    t.PlaceholderText = placeholder or ""
    t.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
    t.TextColor3 = Color3.fromRGB(220, 220, 240)
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.ZIndex = 7
    t.Parent = parent
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    return t
end

local function FormatTime(s)
    s = math.max(0, math.floor(s))
    return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor((s%3600)/60), s%60)
end

-- ═══════════════ تتبع إحصائيات اللاعبين ═══════════════
local PlayerStats = {}

local function InitStats(p)
    if PlayerStats[p] then return end
    PlayerStats[p] = { entries = 0, exits = 0, totalTime = 0, lastEnter = 0, inGame = false }
end

local function OnEnter(p)
    InitStats(p)
    local s = PlayerStats[p]
    if not s.inGame then
        s.entries = s.entries + 1
        s.inGame = true
        s.lastEnter = tick()
    end
end

local function OnExit(p)
    local s = PlayerStats[p]
    if s and s.inGame then
        s.exits = s.exits + 1
        s.totalTime = s.totalTime + (tick() - s.lastEnter)
        s.inGame = false
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    InitStats(p)
    if p.Character then OnEnter(p) end
    p.CharacterAdded:Connect(function() OnEnter(p) end)
    p.CharacterRemoving:Connect(function() OnExit(p) end)
end
Players.PlayerAdded:Connect(function(p)
    InitStats(p)
    p.CharacterAdded:Connect(function() OnEnter(p) end)
    p.CharacterRemoving:Connect(function() OnExit(p) end)
end)
Players.PlayerRemoving:Connect(OnExit)

-- ═══════════════════════════════════════════════════════
-- TAB 1 : بانق GG
-- ═══════════════════════════════════════════════════════
local bangTab = MakeTab("بانق GG")

local searchBox = MakeTextbox(bangTab, "اكتب أول 3 أحرف من اسم اللاعب...")

-- لوحة معلومات اللاعب
local infoFrame = Instance.new("Frame", bangTab)
infoFrame.Size = UDim2.new(1, 0, 0, 115)
infoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
infoFrame.ZIndex = 7
Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 8)

local avatarImg = Instance.new("ImageLabel", infoFrame)
avatarImg.Size = UDim2.new(0, 85, 0, 85)
avatarImg.Position = UDim2.new(0, 10, 0, 15)
avatarImg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
avatarImg.ZIndex = 8
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 8)

local nameLbl = Instance.new("TextLabel", infoFrame)
nameLbl.Size = UDim2.new(1, -110, 0, 24)
nameLbl.Position = UDim2.new(0, 105, 0, 10)
nameLbl.BackgroundTransparency = 1
nameLbl.Text = "لا يوجد لاعب محدد"
nameLbl.TextColor3 = Color3.fromRGB(170, 80, 255)
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 14
nameLbl.TextXAlignment = Enum.TextXAlignment.Left
nameLbl.ZIndex = 8

local exitLbl = Instance.new("TextLabel", infoFrame)
exitLbl.Size = UDim2.new(0, 110, 0, 20)
exitLbl.Position = UDim2.new(0, 105, 0, 38)
exitLbl.BackgroundTransparency = 1
exitLbl.Text = "خروج: 0"
exitLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
exitLbl.Font = Enum.Font.Gotham
exitLbl.TextSize = 12
exitLbl.TextXAlignment = Enum.TextXAlignment.Left
exitLbl.ZIndex = 8

local entryLbl = Instance.new("TextLabel", infoFrame)
entryLbl.Size = UDim2.new(0, 110, 0, 20)
entryLbl.Position = UDim2.new(0, 220, 0, 38)
entryLbl.BackgroundTransparency = 1
entryLbl.Text = "دخول: 0"
entryLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
entryLbl.Font = Enum.Font.Gotham
entryLbl.TextSize = 12
entryLbl.TextXAlignment = Enum.TextXAlignment.Left
entryLbl.ZIndex = 8

local timerLbl = Instance.new("TextLabel", infoFrame)
timerLbl.Size = UDim2.new(1, -115, 0, 22)
timerLbl.Position = UDim2.new(0, 105, 0, 62)
timerLbl.BackgroundTransparency = 1
timerLbl.Text = "الوقت: 00:00:00"
timerLbl.TextColor3 = Color3.fromRGB(200, 200, 255)
timerLbl.Font = Enum.Font.GothamBold
timerLbl.TextSize = 13
timerLbl.TextXAlignment = Enum.TextXAlignment.Left
timerLbl.ZIndex = 8

local function UpdateInfo()
    if not selectedPlayer or not PlayerStats[selectedPlayer] then return end
    local s = PlayerStats[selectedPlayer]
    local t = s.totalTime
    if s.inGame then t = t + (tick() - s.lastEnter) end
    nameLbl.Text = selectedPlayer.Name .. "  (@" .. selectedPlayer.DisplayName .. ")"
    exitLbl.Text = "خروج: " .. s.exits
    entryLbl.Text = "دخول: " .. s.entries
    timerLbl.Text = "الوقت: " .. FormatTime(t)
end

task.spawn(function()
    while true do
        task.wait(1)
        UpdateInfo()
    end
end)

-- أزرار الحركة (تظهر بعد اختيار لاعب)
local bangBtn = MakeButton(bangTab, "BANG (من الخلف)", function() end)
bangBtn.Visible = false

local bangFwdBtn = MakeButton(bangTab, "BANG Forward (مص / لعق)", function() end)
bangFwdBtn.Visible = false

local bangSpeedBox = MakeTextbox(bangTab, "سرعة البانق (1 - 300)")
bangSpeedBox.Visible = false
local bangSpeedStart = MakeButton(bangTab, "▶ Start / ابدأ (سرعة البانق)", function()
    local n = tonumber(bangSpeedBox.Text)
    if n and n >= 1 and n <= 300 then
        bangSpeed = n
        if bangTrack then pcall(function() bangTrack:AdjustSpeed(n) end) end
    end
end)
bangSpeedStart.Visible = false

local suckSpeedBox = MakeTextbox(bangTab, "سرعة المص/اللعق (1 - 300)")
suckSpeedBox.Visible = false
local suckSpeedStart = MakeButton(bangTab, "▶ Start / ابدأ (سرعة المص)", function()
    local n = tonumber(suckSpeedBox.Text)
    if n and n >= 1 and n <= 300 then
        suckSpeed = n
        if suckTrack then pcall(function() suckTrack:AdjustSpeed(n) end) end
    end
end)
suckSpeedStart.Visible = false

local function ShowActionButtons(v)
    bangBtn.Visible = v
    bangFwdBtn.Visible = v
    bangSpeedBox.Visible = v
    bangSpeedStart.Visible = v
    suckSpeedBox.Visible = v
    suckSpeedStart.Visible = v
end

local function SelectPlayer(p)
    selectedPlayer = p
    pcall(function()
        avatarImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    UpdateInfo()
    ShowActionButtons(true)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = string.lower(searchBox.Text)
    if #txt < 1 then
        selectedPlayer = nil
        nameLbl.Text = "لا يوجد لاعب محدد"
        ShowActionButtons(false)
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and string.sub(string.lower(p.Name), 1, #txt) == txt then
            SelectPlayer(p)
            return
        end
    end
end)

-- تشغيل الحركات
local bangSpeed = 1
local suckSpeed = 1
local bangTrack, suckTrack

local function PlayAnim(animId, speed, which)
    if not selectedPlayer or not selectedPlayer.Character then return end
    local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if which == "bang" then
        if bangTrack then pcall(function() bangTrack:Stop() end) end
        local a = Instance.new("Animation")
        a.AnimationId = animId
        local ok, track = pcall(function() return hum:LoadAnimation(a) end)
        if ok then
            bangTrack = track
            bangTrack:Play()
            bangTrack:AdjustSpeed(speed)
        end
    else
        if suckTrack then pcall(function() suckTrack:Stop() end) end
        local a = Instance.new("Animation")
        a.AnimationId = animId
        local ok, track = pcall(function() return hum:LoadAnimation(a) end)
        if ok then
            suckTrack = track
            suckTrack:Play()
            suckTrack:AdjustSpeed(speed)
        end
    end
end

bangBtn.MouseButton1Click:Connect(function() PlayAnim(BANG_ANIM, bangSpeed, "bang") end)
bangFwdBtn.MouseButton1Click:Connect(function() PlayAnim(SUCK_ANIM, suckSpeed, "suck") end)

-- ═══════════════════════════════════════════════════════
-- TAB 2 : أوامر انفنتي
-- ═══════════════════════════════════════════════════════
local cmdsTab = MakeTab("أوامر انفنتي")
local commands = {
    "2022materials", "clearerror", "antilag", "xray",
    "antiafk", "antikick", "backtrack nan", "backtrack 999",
    "datalimit 660", "autokeypress nan", "autokeypress",
    "Replicationlag 999", "nofog"
}
for _, cmd in ipairs(commands) do
    MakeButton(cmdsTab, "📋  " .. cmd, function()
        pcall(function()
            if setclipboard then setclipboard(cmd) end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB 3 : سكربتات تحسين (بدون مكرر)
-- ═══════════════════════════════════════════════════════
local optTab = MakeTab("سكربتات تحسين")
local optScripts = {
    { name = "Optimizer v1",  url = "https://pastebin.com/raw/trEyCGm1" },
    { name = "3skr Hub",      url = "https://scriptblox.com/raw/Universal-Script-3skr-hub-240428" },
    { name = "Optimizer v2",  url = "https://pastebin.com/raw/HMEBL5Y7" },
    { name = "Optimizer v3",  url = "https://pastebin.com/raw/SVBWBNMN" },
    { name = "Optimizer v4",  url = "https://pastebin.com/raw/jNBy9uhB" },
}
for _, s in ipairs(optScripts) do
    MakeButton(optTab, "▶  " .. s.name, function()
        pcall(function()
            loadstring(game:HttpGet(s.url))()
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB 4 : سكربتات خاصه
-- ═══════════════════════════════════════════════════════
local privTab = MakeTab("سكربتات خاصه")
local privScripts = {
    { name = "Private 1",      url = "https://pastefy.app/mXMaE9fC/raw" },
    { name = "MADARA x CATAY", url = "https://raw.githubusercontent.com/MADARA9223/AL7FRAA-MADARAxCATAY/refs/heads/main/AL7FRAA%20%7C%20MADARAxCATAYxROBERTO" },
    { name = "Private 2",      url = "https://pastebin.com/raw/JEUtzDyu" },
    { name = "AL-QYADAH F7LK", url = "https://raw.githubusercontent.com/professor-f7lk/AL-QYADAHF7LK-/refs/heads/main/README.md" },
    { name = "Private 3",      url = "https://pastebin.com/raw/mAtRSqbu" },
    { name = "Private 4",      url = "https://pastefy.app/WhGd80IZ/raw" },
    { name = "GAROU XR7",      url = "https://scriptblox.com/raw/Universal-Script-GAROU-XR7-230829" },
    { name = "Kaize25KP",      url = "https://encrypt-x.pages.dev/Scripts?Id=Kaize25KP", param = "Kaize25KP" },
}
for _, s in ipairs(privScripts) do
    MakeButton(privTab, "▶  " .. s.name, function()
        pcall(function()
            if s.param then
                loadstring(game:HttpGet(s.url))(s.param)
            else
                loadstring(game:HttpGet(s.url))()
            end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- TAB 5 : رتب
-- ═══════════════════════════════════════════════════════
local rankTab = MakeTab("رتب")

MakeLabel(rankTab, "👑 رتبة (مالك السكربت)", Color3.fromRGB(255, 200, 50))
local ownerBox = MakeTextbox(rankTab, "كلمة السر...")
local ownerStatus = MakeLabel(rankTab, "الحالة: غير مفعّلة", Color3.fromRGB(200, 100, 100))
MakeButton(rankTab, "تفعيل رتبة المالك", function()
    if ownerBox.Text == OWNER_PASS then
        RANK = "owner"
        ownerStatus.Text = "الحالة: ✅ مفعّلة (مالك)"
        ownerStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    ownerBox.Text = ""
end)

MakeLabel(rankTab, "🛡️ رتبة (ادمن)", Color3.fromRGB(100, 200, 255))
local adminBox = MakeTextbox(rankTab, "كلمة السر...")
local adminStatus = MakeLabel(rankTab, "الحالة: غير مفعّلة", Color3.fromRGB(200, 100, 100))
MakeButton(rankTab, "تفعيل رتبة ادمن", function()
    if adminBox.Text == ADMIN_PASS then
        RANK = "admin"
        adminStatus.Text = "الحالة: ✅ مفعّلة (ادمن)"
        adminStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    adminBox.Text = ""
end)

MakeLabel(rankTab, "⭐ رتبة (صملاوي) — تتطلب 50 ساعة متواصلة", Color3.fromRGB(255, 100, 200))
local samlawiStatus = MakeLabel(rankTab, "الوقت: 00:00:00 / 50:00:00", Color3.fromRGB(200, 200, 220))
task.spawn(function()
    while true do
        task.wait(1)
        local t = tick() - USAGE_START
        samlawiStatus.Text = "الوقت: " .. FormatTime(t) .. " / 50:00:00"
        if t >= 50 * 3600 and RANK == "none" then
            RANK = "samlawi"
            samlawiStatus.Text = "✅ رتبة صملاوي مفعّلة!"
            samlawiStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
end)

-- ═══════════════════════════════════════════════════════
-- TAB 6 : حقوق
-- ═══════════════════════════════════════════════════════
local creditsTab = MakeTab("حقوق")
MakeLabel(creditsTab, "📱 تيك توك: w_.0.10",     Color3.fromRGB(200, 200, 255))
MakeLabel(creditsTab, "💬 دسكورد: 9z_e.1",       Color3.fromRGB(150, 200, 255))
MakeLabel(creditsTab, "")
MakeLabel(creditsTab, "🛡️ محمي من قبل 𝒍𝒂𝒏𝒔𝒉𝒆𝒓", Color3.fromRGB(255, 100, 150))
MakeLabel(creditsTab, "فقط لأصدقاء 𝒍𝒂𝒏𝒔𝒉𝒆𝒓 و 𝒔𝒍𝒂𝒏𝒅𝒆𝒓", Color3.fromRGB(255, 150, 150))
MakeLabel(creditsTab, "ولا ننسى كسم AS وأصدقائهم ❤️", Color3.fromRGB(200, 150, 255))

-- ═══════════════════════════════════════════════════════
-- تفعيل التاب الأول تلقائياً
-- ═══════════════════════════════════════════════════════
local first = Tabs["بانق GG"]
if first then
    first.Button.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    first.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    first.Frame.Visible = true
end
