local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1)

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer

local isOpen = false
local targetPlayer = nil
local bangSpeed = 1
local lickSpeed = 1
local exitCount = 0
local enterCount = 0
local timerSeconds = 0
local isTimerRunning = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "REDZ_HUB"
ScreenGui.ResetOnSpawn = false

local _guiParent
local success, result = pcall(function() return gethui() end)
if success and result then
    _guiParent = result
else
    local success2, result2 = pcall(function() return game:GetService("CoreGui") end)
    if success2 and result2 then
        _guiParent = result2
    else
        _guiParent = LocalPlayer:WaitForChild("PlayerGui")
    end
end
ScreenGui.Parent = _guiParent

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://108720536583044"
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.ScaleType = Enum.ScaleType.Crop
ToggleButton.ClipsDescendants = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local WingsBackground = Instance.new("ImageLabel")
WingsBackground.Name = "WingsBackground"
WingsBackground.Size = UDim2.new(1, 0, 1, 0)
WingsBackground.BackgroundTransparency = 1
WingsBackground.Image = "rbxassetid://97350255821779"
WingsBackground.ImageTransparency = 0.3
WingsBackground.ScaleType = Enum.ScaleType.Crop
WingsBackground.ZIndex = 1
WingsBackground.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.4
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "REDZ HUB | 𝒍𝒂𝒏𝒔𝒉𝒆𝒓"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 3
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(0, 130, 1, -45)
TabList.Position = UDim2.new(0, 5, 0, 40)
TabList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabList.BackgroundTransparency = 0.5
TabList.ZIndex = 2
TabList.Parent = MainFrame
local TabListCorner = Instance.new("UICorner")
TabListCorner.CornerRadius = UDim.new(0, 5)
TabListCorner.Parent = TabList

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabList

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -145, 1, -45)
ContentFrame.Position = UDim2.new(0, 140, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContentFrame.BackgroundTransparency = 0.5
ContentFrame.ZIndex = 2
ContentFrame.Parent = MainFrame
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 5)
ContentCorner.Parent = ContentFrame

local function CreateTab(name, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.ZIndex = 3
    btn.Parent = TabList
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ZIndex = 3
    frame.Parent = ContentFrame
    frame.CanvasSize = UDim2.new(0, 0, 0, 1000)
    frame.ScrollBarThickness = 4
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(TabList:GetChildren()) do
            if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
        end
        for _, v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        frame.Visible = true
    end)
    
    return frame, btn
end

local BangTab, BangBtn = CreateTab("Bang", "بانق GG")
BangBtn.LayoutOrder = 1

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0, 10)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchBox.BackgroundTransparency = 0.2
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "اول 3 احرف من اسم الشخص..."
SearchBox.ZIndex = 4
SearchBox.Parent = BangTab

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0.9, 0, 0, 80)
InfoFrame.Position = UDim2.new(0.05, 0, 0, 50)
InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InfoFrame.BackgroundTransparency = 0.2
InfoFrame.ZIndex = 3
InfoFrame.Parent = BangTab

local PlayerImage = Instance.new("ImageLabel")
PlayerImage.Size = UDim2.new(0, 60, 0, 60)
PlayerImage.Position = UDim2.new(0, 10, 0, 10)
PlayerImage.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerImage.Image = "rbxassetid://0"
PlayerImage.ZIndex = 4
PlayerImage.Parent = InfoFrame
local PlayerImageCorner = Instance.new("UICorner")
PlayerImageCorner.CornerRadius = UDim.new(0, 8)
PlayerImageCorner.Parent = PlayerImage

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Size = UDim2.new(1, -80, 0, 20)
PlayerNameLabel.Position = UDim2.new(0, 80, 0, 10)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Text = "اسم اللاعب: لا يوجد"
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.Font = Enum.Font.Gotham
PlayerNameLabel.TextSize = 14
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerNameLabel.ZIndex = 4
PlayerNameLabel.Parent = InfoFrame

local ExitLabel = Instance.new("TextLabel")
ExitLabel.Size = UDim2.new(0.45, 0, 0, 20)
ExitLabel.Position = UDim2.new(0.05, 0, 0, 140)
ExitLabel.BackgroundTransparency = 1
ExitLabel.Text = "خروج: 0"
ExitLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ExitLabel.Font = Enum.Font.Gotham
ExitLabel.TextSize = 14
ExitLabel.TextXAlignment = Enum.TextXAlignment.Left
ExitLabel.ZIndex = 3
ExitLabel.Parent = BangTab

local EnterLabel = Instance.new("TextLabel")
EnterLabel.Size = UDim2.new(0.45, 0, 0, 20)
EnterLabel.Position = UDim2.new(0.05, 0, 0, 170)
EnterLabel.BackgroundTransparency = 1
EnterLabel.Text = "دخول: 0"
EnterLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
EnterLabel.Font = Enum.Font.Gotham
EnterLabel.TextSize = 14
EnterLabel.TextXAlignment = Enum.TextXAlignment.Left
EnterLabel.ZIndex = 3
EnterLabel.Parent = BangTab

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.45, 0, 0, 20)
TimerLabel.Position = UDim2.new(0.5, 0, 0, 140)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextSize = 14
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.ZIndex = 3
TimerLabel.Parent = BangTab

local BangActionBtn = Instance.new("TextButton")
BangActionBtn.Size = UDim2.new(0.4, 0, 0, 35)
BangActionBtn.Position = UDim2.new(0.05, 0, 0, 210)
BangActionBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
BangActionBtn.Text = "BANG"
BangActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BangActionBtn.Font = Enum.Font.GothamBold
BangActionBtn.ZIndex = 4
BangActionBtn.Parent = BangTab

local BangForwardBtn = Instance.new("TextButton")
BangForwardBtn.Size = UDim2.new(0.4, 0, 0, 35)
BangForwardBtn.Position = UDim2.new(0.55, 0, 0, 210)
BangForwardBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
BangForwardBtn.Text = "BANG FORWARD"
BangForwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BangForwardBtn.Font = Enum.Font.GothamBold
BangForwardBtn.ZIndex = 4
BangForwardBtn.Parent = BangTab

local BangSpeedBox = Instance.new("TextBox")
BangSpeedBox.Size = UDim2.new(0.3, 0, 0, 30)
BangSpeedBox.Position = UDim2.new(0.05, 0, 0, 270)
BangSpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BangSpeedBox.BackgroundTransparency = 0.2
BangSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BangSpeedBox.PlaceholderText = "1 - 300"
BangSpeedBox.Text = "1"
BangSpeedBox.ZIndex = 4
BangSpeedBox.Parent = BangTab

local BangSpeedBtn = Instance.new("TextButton")
BangSpeedBtn.Size = UDim2.new(0.4, 0, 0, 30)
BangSpeedBtn.Position = UDim2.new(0.35, 0, 0, 270)
BangSpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
BangSpeedBtn.BackgroundTransparency = 0.3
BangSpeedBtn.Text = "START / ابدأ"
BangSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BangSpeedBtn.Font = Enum.Font.Gotham
BangSpeedBtn.ZIndex = 4
BangSpeedBtn.Parent = BangTab

local LickSpeedBox = Instance.new("TextBox")
LickSpeedBox.Size = UDim2.new(0.3, 0, 0, 30)
LickSpeedBox.Position = UDim2.new(0.05, 0, 0, 320)
LickSpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LickSpeedBox.BackgroundTransparency = 0.2
LickSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
LickSpeedBox.PlaceholderText = "1 - 300"
LickSpeedBox.Text = "1"
LickSpeedBox.ZIndex = 4
LickSpeedBox.Parent = BangTab

local LickSpeedBtn = Instance.new("TextButton")
LickSpeedBtn.Size = UDim2.new(0.4, 0, 0, 30)
LickSpeedBtn.Position = UDim2.new(0.35, 0, 0, 320)
LickSpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
LickSpeedBtn.BackgroundTransparency = 0.3
LickSpeedBtn.Text = "START / ابدأ"
LickSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LickSpeedBtn.Font = Enum.Font.Gotham
LickSpeedBtn.ZIndex = 4
LickSpeedBtn.Parent = BangTab

SearchBox.FocusLost:Connect(function()
    local search = string.lower(SearchBox.Text)
    if #search >= 3 then
        for _, p in pairs(Players:GetPlayers()) do
            if string.sub(string.lower(p.Name), 1, 3) == search or string.sub(string.lower(p.DisplayName), 1, 3) == search then
                targetPlayer = p
                PlayerNameLabel.Text = "اللاعب: " .. p.Name
                local thumb = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                PlayerImage.Image = thumb
                break
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if isTimerRunning and targetPlayer then
            timerSeconds = timerSeconds + 1
            local h = math.floor(timerSeconds / 3600)
            local m = math.floor((timerSeconds % 3600) / 60)
            local s = timerSeconds % 60
            TimerLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == targetPlayer then
        exitCount = exitCount + 1
        ExitLabel.Text = "خروج: " .. exitCount
        isTimerRunning = false
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if targetPlayer and plr.UserId == targetPlayer.UserId then
        enterCount = enterCount + 1
        EnterLabel.Text = "دخول: " .. enterCount
        isTimerRunning = true
        targetPlayer = plr
    end
end)

local function PlayAnimation()
    if targetPlayer and targetPlayer.Character then
        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771019"
            local track
            local success, err = pcall(function()
                track = humanoid:LoadAnimation(anim)
            end)
            if success and track then
                track:Play()
            end
        end
    end
end

BangActionBtn.MouseButton1Click:Connect(PlayAnimation)
BangForwardBtn.MouseButton1Click:Connect(PlayAnimation)

BangSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(BangSpeedBox.Text)
    if val and val >= 1 and val <= 300 then
        bangSpeed = val
        BangSpeedBtn.Text = "تم التثبيت: " .. val
        task.wait(1)
        BangSpeedBtn.Text = "START / ابدأ"
    end
end)

LickSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(LickSpeedBox.Text)
    if val and val >= 1 and val <= 300 then
        lickSpeed = val
        LickSpeedBtn.Text = "تم التثبيت: " .. val
        task.wait(1)
        LickSpeedBtn.Text = "START / ابدأ"
    end
end)

local InfiniteTab, InfBtn = CreateTab("Infinite", "أوامر انفنتي")
InfBtn.LayoutOrder = 2

local commands = {
    "2022materials", "clearerror", "antilag", "xray", "antiafk", 
    "antikick", "backtrack nan", "backtrack 999", "datalimit 660", 
    "autokeypress nan", "autokeypress", "Replicationlag 999", "nofog"
}

for i, cmd in ipairs(commands) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, 0, (i-1)*30 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.2
    btn.Text = cmd
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.ZIndex = 4
    btn.Parent = InfiniteTab
    
    btn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(cmd)
            btn.Text = "تم النسخ!"
            task.wait(1)
            btn.Text = cmd
        end
    end)
end

local ImproveTab, ImpBtn = CreateTab("Improve", "سكربتات تحسين")
ImpBtn.LayoutOrder = 3

local improveScripts = {
    "https://pastebin.com/raw/trEyCGm1",
    "https://scriptblox.com/raw/Universal-Script-3skr-hub-240428",
    "https://pastebin.com/raw/HMEBL5Y7",
    "https://pastebin.com/raw/SVBWBNMN",
    "https://pastebin.com/raw/jNBy9uhB"
}

for i, url in ipairs(improveScripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, (i-1)*35 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    btn.BackgroundTransparency = 0.2
    btn.Text = "تشغيل سكربت " .. i
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.ZIndex = 4
    btn.Parent = ImproveTab
    
    btn.MouseButton1Click:Connect(function()
        btn.Text = "جاري التشغيل..."
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        btn.Text = "تم التشغيل"
    end)
end

local SpecialTab, SpecBtn = CreateTab("Special", "سكربتات خاصة")
SpecBtn.LayoutOrder = 4

local specialScripts = {
    "https://pastefy.app/mXMaE9fC/raw",
    "https://raw.githubusercontent.com/MADARA9223/AL7FRAA-MADARAxCATAY/refs/heads/main/AL7FRAA%20%7C%20MADARAxCATAYxROBERTO",
    "https://pastebin.com/raw/JEUtzDyu",
    "https://raw.githubusercontent.com/professor-f7lk/AL-QYADAHF7LK-/refs/heads/main/README.md",
    "https://pastebin.com/raw/mAtRSqbu",
    "https://pastefy.app/WhGd80IZ/raw",
    "https://scriptblox.com/raw/Universal-Script-GAROU-XR7-230829",
    "https://encrypt-x.pages.dev/Scripts?Id=Kaize25KP"
}

for i, url in ipairs(specialScripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, (i-1)*35 + 5)
    btn.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    btn.BackgroundTransparency = 0.2
    btn.Text = "تشغيل سكربت " .. i
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.ZIndex = 4
    btn.Parent = SpecialTab
    
    btn.MouseButton1Click:Connect(function()
        btn.Text = "جاري التشغيل..."
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        btn.Text = "تم التشغيل"
    end)
end

local RankTab, RankBtn = CreateTab("Rank", "رتب")
RankBtn.LayoutOrder = 5

local OwnerPass = Instance.new("TextBox")
OwnerPass.Size = UDim2.new(0.9, 0, 0, 30)
OwnerPass.Position = UDim2.new(0.05, 0, 0, 10)
OwnerPass.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OwnerPass.BackgroundTransparency = 0.2
OwnerPass.TextColor3 = Color3.fromRGB(255, 255, 255)
OwnerPass.PlaceholderText = "كلمة سر مالك السكربت (omar)"
OwnerPass.ZIndex = 4
OwnerPass.Parent = RankTab

local AdminPass = Instance.new("TextBox")
AdminPass.Size = UDim2.new(0.9, 0, 0, 30)
AdminPass.Position = UDim2.new(0.05, 0, 0, 50)
AdminPass.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AdminPass.BackgroundTransparency = 0.2
AdminPass.TextColor3 = Color3.fromRGB(255, 255, 255)
AdminPass.PlaceholderText = "كلمة سر الادمن (scopa)"
AdminPass.ZIndex = 4
AdminPass.Parent = RankTab

local SamlawiLabel = Instance.new("TextLabel")
SamlawiLabel.Size = UDim2.new(0.9, 0, 0, 30)
SamlawiLabel.Position = UDim2.new(0.05, 0, 0, 90)
SamlawiLabel.BackgroundTransparency = 1
SamlawiLabel.Text = "رتبة صملاوي: تتطلب 50 ساعة تشغيل متواصل"
SamlawiLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
SamlawiLabel.Font = Enum.Font.Gotham
SamlawiLabel.ZIndex = 3
SamlawiLabel.Parent = RankTab

OwnerPass.FocusLost:Connect(function()
    if OwnerPass.Text == "omar" then
        OwnerPass.Text = "تم تفعيل رتبة المالك!"
        OwnerPass.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        OwnerPass.Text = "كلمة سر خاطئة"
        OwnerPass.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

AdminPass.FocusLost:Connect(function()
    if AdminPass.Text == "scopa" then
        AdminPass.Text = "تم تفعيل رتبة الأدمن!"
        AdminPass.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        AdminPass.Text = "كلمة سر خاطئة"
        AdminPass.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

local RightsTab, RightBtn = CreateTab("Rights", "حقوق")
RightBtn.LayoutOrder = 6

local TikTok = Instance.new("TextLabel")
TikTok.Size = UDim2.new(0.9, 0, 0, 30)
TikTok.Position = UDim2.new(0.05, 0, 0, 10)
TikTok.BackgroundTransparency = 1
TikTok.Text = "تيك توك المالك: w_.0.10"
TikTok.TextColor3 = Color3.fromRGB(255, 255, 255)
TikTok.Font = Enum.Font.GothamBold
TikTok.ZIndex = 3
TikTok.Parent = RightsTab

local Discord = Instance.new("TextLabel")
Discord.Size = UDim2.new(0.9, 0, 0, 30)
Discord.Position = UDim2.new(0.05, 0, 0, 40)
Discord.BackgroundTransparency = 1
Discord.Text = "دسكورد المالك: 9z_e.1"
Discord.TextColor3 = Color3.fromRGB(100, 150, 255)
Discord.Font = Enum.Font.GothamBold
Discord.ZIndex = 3
Discord.Parent = RightsTab

local Protection = Instance.new("TextLabel")
Protection.Size = UDim2.new(0.9, 0, 0, 100)
Protection.Position = UDim2.new(0.05, 0, 0, 80)
Protection.BackgroundTransparency = 1
Protection.Text = "هذا السكربت محمي من قبل 𝒍𝒂𝒏𝒔𝒉𝒆𝒓\nلا يمكن اي احد استخدامه الا اصدقاء 𝒍𝒂𝒏𝒔𝒉𝒆𝒓\nاو اصدقاء 𝒔𝒍𝒂𝒏𝒅𝒆𝒓\nولا ننسى كسم 𝑨𝑺 وا اصدقائهم"
Protection.TextColor3 = Color3.fromRGB(200, 200, 200)
Protection.Font = Enum.Font.Gotham
Protection.TextSize = 12
Protection.TextWrapped = true
Protection.ZIndex = 3
Protection.Parent = RightsTab

local draggingTitle, dragInputTitle, dragStartTitle, startPosTitle
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingTitle = true
        dragStartTitle = input.Position
        startPosTitle = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingTitle = false
            end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputTitle = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputTitle and draggingTitle then
        local delta = input.Position - dragStartTitle
        MainFrame.Position = UDim2.new(startPosTitle.X.Scale, startPosTitle.X.Offset + delta.X, startPosTitle.Y.Scale, startPosTitle.Y.Offset + delta.Y)
    end
end)

local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        dragStartBtn = input.Position
        startPosBtn = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingBtn = false
            end
        end)
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputBtn = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        local delta = input.Position - dragStartBtn
        ToggleButton.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    isOpen = false
end)
