-- ============================================================
-- REDZ HUB - by lansher
-- ============================================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local UI_ICON = 77924857384829
local TOGGLE_ICON = 134125667034392

-- غيّر الـ Animation IDs من هنا اذا تبي
local BANG_ANIM = "rbxassetid://507771019"
local LICK_ANIM = "rbxassetid://507770553"

local ray = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local win = ray:CreateWindow({
    Name = "REDZ HUB",
    Icon = UI_ICON,
    LoadingTitle = "REDZ HUB",
    LoadingSubtitle = "by lansher",
    Theme = "Default",
    ToggleUIKeybind = "RightShift",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- ============================================================
-- زر التفعيل (صورة مخصصة)
-- ============================================================
do
    local gui = Instance.new("ScreenGui")
    gui.Name = "RedzToggle"
    gui.ResetOnSpawn = false
    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok then gui.Parent = LP:WaitForChild("PlayerGui") end

    local btn = Instance.new("ImageButton")
    btn.Image = "rbxassetid://" .. TOGGLE_ICON
    btn.Size = UDim2.new(0, 55, 0, 55)
    btn.Position = UDim2.new(0, 15, 0.5, -27)
    btn.BackgroundTransparency = 1
    btn.Parent = gui

    local dragging, dragStart, startPos, moved
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    btn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then moved = true end
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and not moved then
                pcall(function()
                    VIM:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
                end)
            end
            dragging = false
        end
    end)
end

-- ============================================================
-- تتبع اللاعب
-- ============================================================
local tracked = { player = nil, userId = nil, name = "", joins = 0, leaves = 0, time = 0, active = false }

local function fmtTime(s)
    s = math.floor(s)
    return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor((s%3600)/60), s%60)
end

RunService.Heartbeat:Connect(function(dt)
    if tracked.active and tracked.player and tracked.player.Parent then
        tracked.time += dt
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if tracked.active and p.UserId == tracked.userId then tracked.leaves += 1 end
end)

Players.PlayerAdded:Connect(function(p)
    if tracked.active and p.UserId == tracked.userId then
        tracked.joins += 1
        tracked.player = p
    end
end)

-- ============================================================
-- لوحة البروفايل (صورة + عدادات)
-- ============================================================
local profileGui = Instance.new("ScreenGui")
profileGui.Name = "RedzProfile"
profileGui.ResetOnSpawn = false
local ok = pcall(function() profileGui.Parent = game:GetService("CoreGui") end)
if not ok then profileGui.Parent = LP:WaitForChild("PlayerGui") end

local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0, 180, 0, 260)
profileFrame.Position = UDim2.new(0, 80, 0.5, -130)
profileFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
profileFrame.BorderSizePixel = 0
profileFrame.Visible = false
profileFrame.Active = true
profileFrame.Parent = profileGui
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 8)

local img = Instance.new("ImageLabel")
img.Size = UDim2.new(0, 100, 0, 100)
img.Position = UDim2.new(0.5, -50, 0, 10)
img.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
img.Parent = profileFrame
Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

local nameLbl = Instance.new("TextLabel")
nameLbl.Size = UDim2.new(1, 0, 0, 22)
nameLbl.Position = UDim2.new(0, 0, 0, 115)
nameLbl.BackgroundTransparency = 1
nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLbl.Text = "---"
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 14
nameLbl.Parent = profileFrame

local leaveLbl = Instance.new("TextLabel")
leaveLbl.Size = UDim2.new(1, 0, 0, 22)
leaveLbl.Position = UDim2.new(0, 0, 0, 140)
leaveLbl.BackgroundTransparency = 1
leaveLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
leaveLbl.Text = "خروج: 0"
leaveLbl.Font = Enum.Font.Gotham
leaveLbl.TextSize = 13
leaveLbl.Parent = profileFrame

local joinLbl = Instance.new("TextLabel")
joinLbl.Size = UDim2.new(1, 0, 0, 22)
joinLbl.Position = UDim2.new(0, 0, 0, 163)
joinLbl.BackgroundTransparency = 1
joinLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
joinLbl.Text = "دخول: 0"
joinLbl.Font = Enum.Font.Gotham
joinLbl.TextSize = 13
joinLbl.Parent = profileFrame

local timerLbl = Instance.new("TextLabel")
timerLbl.Size = UDim2.new(1, 0, 0, 30)
timerLbl.Position = UDim2.new(0, 0, 0, 188)
timerLbl.BackgroundTransparency = 1
timerLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
timerLbl.Text = "00:00:00"
timerLbl.Font = Enum.Font.GothamBold
timerLbl.TextSize = 16
timerLbl.Parent = profileFrame

-- سحب اللوحة
do
    local dr, ds, sp
    profileFrame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = true; ds = i.Position; sp = profileFrame.Position
        end
    end)
    profileFrame.InputChanged:Connect(function(i)
        if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            profileFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
    profileFrame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false end
    end)
end

task.spawn(function()
    while task.wait(0.3) do
        if tracked.active then
            pcall(function()
                nameLbl.Text = tracked.name
                leaveLbl.Text = "خروج: " .. tracked.leaves
                joinLbl.Text = "دخول: " .. tracked.joins
                timerLbl.Text = fmtTime(tracked.time)
            end)
        end
    end
end)

-- ============================================================
-- تاب 1: بانق GG
-- ============================================================
local bangTab = win:CreateTab("بانق GG")
local currentTarget = nil
local bangSpeed = 1
local lickSpeed = 1

bangTab:CreateInput({
    Name = "اكتب اول 3 احرف من اسم اللاعب",
    PlaceholderText = "اكتب هنا...",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        txt = txt:gsub("%s+", "")
        if #txt >= 3 then
            currentTarget = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Name:lower():sub(1, #txt) == txt:lower() then
                    currentTarget = p
                    break
                end
            end
            if currentTarget then
                tracked.player = currentTarget
                tracked.userId = currentTarget.UserId
                tracked.name = currentTarget.Name
                tracked.joins = 1
                tracked.leaves = 0
                tracked.time = 0
                tracked.active = true
                profileFrame.Visible = true
                pcall(function()
                    img.Image = Players:GetUserThumbnailAsync(currentTarget.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                end)
                ray:Notify({Title = "تم تحديد اللاعب", Content = currentTarget.Name, Duration = 3})
            else
                ray:Notify({Title = "لم يتم العثور", Content = "لا يوجد لاعب بهذا الاسم", Duration = 3})
            end
        else
            tracked.active = false
            profileFrame.Visible = false
            currentTarget = nil
        end
    end,
})

local function playAnim(targetPlayer, animId, speed)
    if not targetPlayer or not targetPlayer.Character then return end
    local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = hum:LoadAnimation(anim)
    track:Play()
    if speed and speed ~= 1 then track:AdjustSpeed(speed) end
end

bangTab:CreateButton({
    Name = "BANG",
    Callback = function()
        if not currentTarget then
            ray:Notify({Title = "خطأ", Content = "اكتب اول 3 احرف من اسم لاعب", Duration = 3})
            return
        end
        playAnim(currentTarget, BANG_ANIM, bangSpeed)
    end,
})

bangTab:CreateButton({
    Name = "BANG forward",
    Callback = function()
        if not currentTarget then
            ray:Notify({Title = "خطأ", Content = "اكتب اول 3 احرف من اسم لاعب", Duration = 3})
            return
        end
        playAnim(currentTarget, LICK_ANIM, lickSpeed)
    end,
})

bangTab:CreateSection("سرعة البانق")
bangTab:CreateSlider({
    Name = "سرعة البانق (1-300)",
    Range = {1, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Callback = function(v) bangSpeed = v end,
})
bangTab:CreateButton({
    Name = "start (البانق)",
    Callback = function()
        ray:Notify({Title = "تم التثبيت", Content = "سرعة البانق: " .. bangSpeed, Duration = 2})
    end,
})

bangTab:CreateSection("سرعة اللعق")
bangTab:CreateSlider({
    Name = "سرعة اللعق (1-300)",
    Range = {1, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Callback = function(v) lickSpeed = v end,
})
bangTab:CreateButton({
    Name = "start (اللعق)",
    Callback = function()
        ray:Notify({Title = "تم التثبيت", Content = "سرعة اللعق: " .. lickSpeed, Duration = 2})
    end,
})

-- ============================================================
-- تاب 2: أوامر انفنتي
-- ============================================================
local cmdTab = win:CreateTab("أوامر انفنتي")
local cmds = {
    "2022materials","clearerror","antilag","xray","antiafk","antikick",
    "backtrack nan","backtrack 999","datalimit 660",
    "autokeypress nan","autokeypress","Replicationlag 999","nofog"
}
for _, c in ipairs(cmds) do
    cmdTab:CreateButton({
        Name = c,
        Callback = function()
            pcall(function() setclipboard(c) end)
            ray:Notify({Title = "تم النسخ", Content = c, Duration = 2})
        end,
    })
end

-- ============================================================
-- تاب 3: سكربتات تحسين
-- ============================================================
local improveTab = win:CreateTab("سكربتات تحسين")
local improveScripts = {
    {"تحسين 1", "https://pastebin.com/raw/trEyCGm1"},
    {"3skr hub", "https://scriptblox.com/raw/Universal-Script-3skr-hub-240428"},
    {"تحسين 2", "https://pastebin.com/raw/HMEBL5Y7"},
    {"تحسين 3", "https://pastebin.com/raw/SVBWBNMN"},
    {"تحسين 4", "https://pastebin.com/raw/jNBy9uhB"},
}
for _, s in ipairs(improveScripts) do
    improveTab:CreateButton({
        Name = s[1],
        Callback = function()
            local ok, err = pcall(function() loadstring(game:HttpGet(s[2]))() end)
            if ok then ray:Notify({Title = "تم التشغيل", Content = s[1], Duration = 2})
            else ray:Notify({Title = "خطأ", Content = tostring(err):sub(1, 50), Duration = 3}) end
        end,
    })
end

-- ============================================================
-- تاب 4: سكربتات خاصه
-- ============================================================
local specialTab = win:CreateTab("سكربتات خاصه")
local specialScripts = {
    {"خاص 1", "https://pastefy.app/mXMaE9fC/raw"},
    {"مدارا", "https://raw.githubusercontent.com/MADARA9223/AL7FRAA-MADARAxCATAY/refs/heads/main/AL7FRAA%20%7C%20MADARAxCATAYxROBERTO"},
    {"خاص 2", "https://pastebin.com/raw/JEUtzDyu"},
    {"AL-QYADAH", "https://raw.githubusercontent.com/professor-f7lk/AL-QYADAHF7LK-/refs/heads/main/README.md"},
    {"خاص 3", "https://pastebin.com/raw/mAtRSqbu"},
    {"خاص 4", "https://pastefy.app/WhGd80IZ/raw"},
    {"GAROU XR7", "https://scriptblox.com/raw/Universal-Script-GAROU-XR7-230829"},
    {"Kaize", "https://encrypt-x.pages.dev/Scripts?Id=Kaize25KP", true},
}
for _, s in ipairs(specialScripts) do
    specialTab:CreateButton({
        Name = s[1],
        Callback = function()
            local ok, err = pcall(function()
                if s[3] then loadstring(game:HttpGet(s[2]))("Kaize25KP")
                else loadstring(game:HttpGet(s[2]))() end
            end)
            if ok then ray:Notify({Title = "تم التشغيل", Content = s[1], Duration = 2})
            else ray:Notify({Title = "خطأ", Content = tostring(err):sub(1, 50), Duration = 3}) end
        end,
    })
end

-- ============================================================
-- تاب 5: رتب
-- ============================================================
local rankTab = win:CreateTab("رتب")

-- ملف تخزين ساعات الاستخدام
local function getStored()
    local ok, d = pcall(function() return readfile("redz_hours.txt") end)
    if ok and d then return tonumber(d) or 0 end
    return 0
end
local function saveStored(t) pcall(function() writefile("redz_hours.txt", tostring(t)) end) end

local storedSeconds = getStored()
task.spawn(function()
    while task.wait(60) do
        storedSeconds += 60
        saveStored(storedSeconds)
    end
end)

-- عرض الرتبة فوق الرأس
local rankGui = Instance.new("BillboardGui")
rankGui.Name = "RedzRank"
rankGui.Size = UDim2.new(0, 200, 0, 40)
rankGui.StudsOffset = Vector3.new(0, 3, 0)
rankGui.AlwaysOnTop = true
rankGui.Enabled = false

local rankLbl = Instance.new("TextLabel")
rankLbl.Size = UDim2.new(1, 0, 1, 0)
rankLbl.BackgroundTransparency = 1
rankLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
rankLbl.Font = Enum.Font.GothamBold
rankLbl.TextSize = 18
rankLbl.TextStrokeTransparency = 0
rankLbl.Text = ""
rankLbl.Parent = rankGui

if LP.Character then rankGui.Parent = LP.Character end
LP.CharacterAdded:Connect(function(c) rankGui.Parent = c end)

local currentRank = nil
local function setRank(name, color)
    currentRank = name
    rankLbl.Text = name
    rankLbl.TextColor3 = color
    rankGui.Enabled = true
end

rankTab:CreateSection("رتبة مالك السكربت")
local ownerPass = ""
rankTab:CreateInput({
    Name = "كلمة سر المالك",
    PlaceholderText = "أدخل كلمة السر...",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt) ownerPass = txt end,
})
rankTab:CreateButton({
    Name = "start (مالك)",
    Callback = function()
        if ownerPass == "omar" then
            setRank("مالك السكربت", Color3.fromRGB(255, 50, 50))
            ray:Notify({Title = "تم", Content = "تم تفعيل رتبة مالك السكربت", Duration = 3})
        else
            ray:Notify({Title = "خطأ", Content = "كلمة السر غير صحيحة", Duration = 3})
        end
    end,
})

rankTab:CreateSection("رتبة ادمن")
local adminPass = ""
rankTab:CreateInput({
    Name = "كلمة سر الادمن",
    PlaceholderText = "أدخل كلمة السر...",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt) adminPass = txt end,
})
rankTab:CreateButton({
    Name = "start (ادمن)",
    Callback = function()
        if adminPass == "scopa" then
            setRank("ادمن", Color3.fromRGB(255, 100, 0))
            ray:Notify({Title = "تم", Content = "تم تفعيل رتبة ادمن", Duration = 3})
        else
            ray:Notify({Title = "خطأ", Content = "كلمة السر غير صحيحة", Duration = 3})
        end
    end,
})

rankTab:CreateSection("رتبة صملاوي (تفعيل تلقائي بعد 50 ساعة)")
rankTab:CreateButton({
    Name = "فحص رتبة صملاوي",
    Callback = function()
        local hours = storedSeconds / 3600
        if hours >= 50 and currentRank == nil then
            setRank("صملاوي", Color3.fromRGB(0, 200, 255))
            ray:Notify({Title = "تم", Content = "تم تفعيل رتبة صملاوي", Duration = 4})
        elseif currentRank == "صملاوي" then
            ray:Notify({Title = "مفعّلة", Content = "رتبة صملاوي مفعلة عندك", Duration = 3})
        else
            ray:Notify({Title = "غير مؤهل", Content = string.format("استخدمت %.1f ساعة من أصل 50", hours), Duration = 4})
        end
    end,
})

task.spawn(function()
    while task.wait(60) do
        if storedSeconds >= 50 * 3600 and currentRank == nil then
            setRank("صملاوي", Color3.fromRGB(0, 200, 255))
        end
    end
end)

-- ============================================================
-- تاب 6: حقوق
-- ============================================================
local rightsTab = win:CreateTab("حقوق")

rightsTab:CreateParagraph({Title = "تيك توك صاحب السكربت", Content = "w_.0.10"})
rightsTab:CreateParagraph({Title = "دسكورد صاحب السكربت", Content = "9z_e.1"})
rightsTab:CreateSection("_____________________________________")
rightsTab:CreateParagraph({Title = "حماية", Content = "هذا السكربت محمي من قبل lansher"})
rightsTab:CreateParagraph({Title = "", Content = "لا يمكن اي احد استخدامه الا اصدقاء lansher"})
rightsTab:CreateParagraph({Title = "", Content = "او اصدقاء slander"})
rightsTab:CreateParagraph({Title = "", Content = "ولا ننسى كسم AS وا اصدقائهم"})
