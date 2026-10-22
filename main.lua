--[[
    OMAR HUB | REDZ STYLE
    Safe Luau UI
    Place in StarterPlayer > StarterPlayerScripts

    Images:
    Open button: 134125667034392
    Header image: 77924857384829

    External scripts are displayed for inspection/copying.
    They are NOT executed automatically.
]]

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local OPEN_IMAGE = "rbxassetid://134125667034392"
local HEADER_IMAGE = "rbxassetid://77924857384829"

local COLORS = {
    Background = Color3.fromRGB(16, 17, 25),
    Panel = Color3.fromRGB(27, 29, 41),
    Button = Color3.fromRGB(43, 46, 64),
    Accent = Color3.fromRGB(125, 83, 255),
    Text = Color3.fromRGB(245, 245, 255),
    Muted = Color3.fromRGB(175, 179, 199),
    Red = Color3.fromRGB(180, 55, 70),
    Green = Color3.fromRGB(55, 155, 105),
}

local old = playerGui:FindFirstChild("OmarRedzHub")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "OmarRedzHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 20
gui.Parent = playerGui

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = object
    return c
end

local function make(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function label(parent, text, height)
    local obj = make("TextLabel", {
        Size = UDim2.new(1, -8, 0, height or 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 15,
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, parent)
    return obj
end

local function button(parent, text, callback)
    local obj = make("TextButton", {
        Size = UDim2.new(1, -8, 0, 42),
        BackgroundColor3 = COLORS.Button,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        TextWrapped = true,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = true,
    }, parent)

    corner(obj, 8)
    obj.Activated:Connect(callback or function() end)
    return obj
end

local function textbox(parent, placeholder, defaultText)
    local obj = make("TextBox", {
        Size = UDim2.new(1, -8, 0, 42),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Text = defaultText or "",
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = COLORS.Muted,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
    }, parent)
    corner(obj, 8)
    return obj
end

-- Main panel
local panel = make("Frame", {
    Name = "MainPanel",
    Size = UDim2.new(0.9, 0, 0.76, 0),
    Position = UDim2.new(0.05, 0, 0.12, 0),
    BackgroundColor3 = COLORS.Background,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
}, gui)
corner(panel, 14)

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MaxSize = Vector2.new(620, 650)
sizeLimit.MinSize = Vector2.new(280, 300)
sizeLimit.Parent = panel

-- Header
local header = make("ImageLabel", {
    Name = "HeaderImage",
    Size = UDim2.new(1, 0, 0, 92),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
    Image = HEADER_IMAGE,
    ScaleType = Enum.ScaleType.Fit,
}, panel)

local title = make("TextLabel", {
    Size = UDim2.new(1, -58, 0, 34),
    Position = UDim2.new(0, 10, 0, 91),
    BackgroundTransparency = 1,
    Text = "REDZ HUB | OMAR",
    TextColor3 = COLORS.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local close = make("TextButton", {
    Size = UDim2.fromOffset(38, 34),
    Position = UDim2.new(1, -46, 0, 94),
    BackgroundColor3 = COLORS.Red,
    Text = "X",
    TextColor3 = COLORS.Text,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
}, panel)
corner(close, 8)

-- Open/close image button
local openButton = make("ImageButton", {
    Name = "OpenCloseButton",
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 14, 0.42, 0),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
    Image = OPEN_IMAGE,
    ScaleType = Enum.ScaleType.Fit,
}, gui)
corner(openButton, 14)

openButton.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

close.Activated:Connect(function()
    panel.Visible = false
end)

-- Tab bar
local tabBar = make("ScrollingFrame", {
    Name = "Tabs",
    Size = UDim2.new(1, -16, 0, 44),
    Position = UDim2.new(0, 8, 0, 132),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollingDirection = Enum.ScrollingDirection.X,
    AutomaticCanvasSize = Enum.AutomaticSize.X,
    CanvasSize = UDim2.new(),
}, panel)

local tabLayout = make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, tabBar)

-- Content area
local content = make("ScrollingFrame", {
    Name = "TabContent",
    Size = UDim2.new(1, -16, 1, -190),
    Position = UDim2.new(0, 8, 0, 181),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
}, panel)
corner(content, 10)

make("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 4),
}, content)

local contentLayout = make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local currentTab = nil
local tabButtons = {}

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= contentLayout
            and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

-- Clipboard fallback:
-- Standard Roblox LocalScripts do not provide setclipboard.
local function copyText(value)
    if typeof(setclipboard) == "function" then
        local ok = pcall(setclipboard, value)
        if ok then
            return true
        end
    end

    clearContent()
    label(content, "النسخ التلقائي غير متاح هنا. انسخ النص من المربع:", 42)

    local box = textbox(content, "النص المراد نسخه", value)
    box.Text = value
    box.TextEditable = true
    box.MultiLine = true
    box.TextWrapped = true
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Size = UDim2.new(1, -8, 0, 120)

    button(content, "تحديد النص", function()
        box:CaptureFocus()
        box.CursorPosition = #box.Text + 1
    end)

    button(content, "رجوع للقائمة", function()
        if currentTab then
            currentTab()
        end
    end)

    return false
end

-- Infinity command list: buttons copy text, not execute it.
local commands = {
    "2022materials",
    "clearerror",
    "antilag",
    "xray",
    "antiafk",
    "antikick",
    "backtrack nan",
    "backtrack 999",
    "datalimit 660",
    "autokeypress nan",
    "autokeypress",
    "Replicationlag 999",
    "nofog",
}

-- External script links: deduplicated.
-- These are displayed as text and are NOT executed.
local improvementScripts = {
    "https://pastebin.com/raw/trEyCGm1",
    "https://scriptblox.com/raw/Universal-Script-3skr-hub-240428",
    "https://pastebin.com/raw/HMEBL5Y7",
    "https://pastebin.com/raw/SVBWBNMN",
    "https://pastebin.com/raw/jNBy9uhB",
}

local privateScripts = {
    "https://pastefy.app/mXMaE9fC/raw",
    "https://raw.githubusercontent.com/MADARA9223/AL7FRAA-MADARAxCATAY/refs/heads/main/AL7FRAA%20%7C%20MADARAxCATAYxROBERTO",
    "https://pastebin.com/raw/JEUtzDyu",
    "https://raw.githubusercontent.com/professor-f7lk/AL-QYADAHF7LK-/refs/heads/main/README.md",
    "https://pastebin.com/raw/mAtRSqbu",
    "https://pastefy.app/WhGd80IZ/raw",
    "https://scriptblox.com/raw/Universal-Script-GAROU-XR7-230829",
    "https://encrypt-x.pages.dev/Scripts?Id=Kaize25KP",
}

-- Session-only demonstration timer.
-- This does not persist after the script/game session ends.
local sessionStart = os.clock()
local sessionRoleUnlocked = false

local function formatTime(seconds)
    seconds = math.max(0, math.floor(seconds))
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function addScriptList(items, titleText)
    label(content, titleText, 36)
    label(content,
        "هذه روابط خارجية غير مفحوصة. لن يتم تشغيلها تلقائيًا.",
        46)

    for index, url in ipairs(items) do
        button(content, "نسخ الرابط " .. index, function()
            copyText(url)
        end)
    end
end

local function buildTab(name)
    clearContent()

    if name == "أوامر انفنتي" then
        label(content, "أوامر انفنتي", 34)
        label(content, "اضغط على الأمر لنسخ اسمه فقط.", 30)

        for _, command in ipairs(commands) do
            button(content, command, function()
                copyText(command)
            end)
        end

    elseif name == "سكربتات تحسين" then
        addScriptList(
            improvementScripts,
            "سكربتات تحسين (روابط منفصلة)"
        )

    elseif name == "سكربتات خاصة" then
        addScriptList(
            privateScripts,
            "سكربتات خاصة (روابط منفصلة)"
        )

    elseif name == "رتب" then
        label(content, "نظام الرتب التجريبي", 36)
        label(content,
            "كلمات المرور داخل LocalScript ليست حماية حقيقية.",
            42)

        local rankPassword = textbox(
            content,
            "اكتب كلمة المرور"
        )
        rankPassword.ClearTextOnFocus = false

        local rankStatus = label(content, "الرتبة: بدون رتبة", 36)

        button(content, "Start | تفعيل الرتبة", function()
            if rankPassword.Text == "omar" then
                rankStatus.Text = "الرتبة: مالك السكربت (عرض تجريبي)"
                rankStatus.TextColor3 = COLORS.Green
            elseif rankPassword.Text == "scopa" then
                rankStatus.Text = "الرتبة: أدمن (عرض تجريبي)"
                rankStatus.TextColor3 = COLORS.Green
            else
                rankStatus.Text = "كلمة المرور غير صحيحة"
                rankStatus.TextColor3 = Color3.fromRGB(255, 110, 110)
            end
        end)

        local timerLabel = label(content, "", 36)

        local function updateTimer()
            local elapsed = os.clock() - sessionStart
            timerLabel.Text = "مدة الجلسة الحالية: "
                .. formatTime(elapsed)

            if elapsed >= 50 * 60 * 60 then
                sessionRoleUnlocked = true
            end
        end

        updateTimer()

        button(content, "تحديث مؤقت الجلسة", updateTimer)

        local roleLabel = label(content, "", 42)
        local function updateRole()
            if sessionRoleUnlocked then
                roleLabel.Text = "الرتبة: صملاوي (50 ساعة في الجلسة الحالية)"
                roleLabel.TextColor3 = COLORS.Green
            else
                local remaining = (50 * 60 * 60)
                    - (os.clock() - sessionStart)

                roleLabel.Text = "صملاوي: متبقي "
                    .. formatTime(remaining)
            end
        end

        updateRole()

        task.spawn(function()
            while gui.Parent and panel.Parent do
                task.wait(1)
                if name == "رتب" and currentTab then
                    -- The label may have been destroyed on tab switch.
                    if timerLabel.Parent then
                        updateTimer()
                    end
                    if roleLabel.Parent then
                        updateRole()
                    end
                end
            end
        end)

    elseif name == "حقوق" then
        label(content, "حقوق صاحب الواجهة", 38)
        button(content, "TikTok: w_.0.10", function()
            copyText("w_.0.10")
        end)
        button(content, "Discord: 9z_e.1", function()
            copyText("9z_e.1")
        end)
        label(content, "هذا السكربت محمي من قبل 𝒍𝒂𝒏𝒔𝒉𝒆𝒓", 48)
        label(content, "مخصص للأصدقاء المذكورين من صاحب السكربت.", 48)
        label(content, "Credits: OMAR HUB", 32)
    end
end

local tabNames = {
    "أوامر انفنتي",
    "سكربتات تحسين",
    "سكربتات خاصة",
    "رتب",
    "حقوق",
}

for index, name in ipairs(tabNames) do
    local tabButton = make("TextButton", {
        Name = "Tab_" .. index,
        Size = UDim2.fromOffset(116, 40),
        BackgroundColor3 = COLORS.Button,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = COLORS.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        LayoutOrder = index,
    }, tabBar)

    corner(tabButton, 8)
    tabButtons[name] = tabButton

    tabButton.Activated:Connect(function()
        currentTab = function()
            buildTab(name)
        end

        for tabName, obj in pairs(tabButtons) do
            obj.BackgroundColor3 =
                tabName == name and COLORS.Accent or COLORS.Button
        end

        buildTab(name)
    end)
end

-- Open on the first tab without opening the panel.
currentTab = function()
    buildTab("أوامر انفنتي")
end

for tabName, obj in pairs(tabButtons) do
    obj.BackgroundColor3 =
        tabName == "أوامر انفنتي" and COLORS.Accent or COLORS.Button
end

buildTab("أوامر انفنتي")

print("OMAR HUB loaded successfully")
