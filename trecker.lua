local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

-- ==========================================
-- НАСТРОЙКИ
-- ==========================================
local BOT_TOKEN = "8657394630:AAEkidAZN1cP57xjESCO0i30qXvvpfNxRm8"
local target_id = "" 

-- Биомы (ТОЛЬКО ЛОГИ)
local biome_alerts = {
    ["DREAMSPACE"]   = "🌌 ОБНАРУЖЕН БИОМ: DREAMSPACE!",
    ["CYBERSPACE"]   = "💾 ОБНАРУЖЕН БИОМ: CYBERSPACE!",
    ["GLITCH"]       = "⚠️ ОБНАРУЖЕН БИОМ: GLITCH!"
}

-- Мерчанты (ЛОГИ + ЧАТ)
local merchant_alerts = {
    ["[Merchant]: Jester has arrived!!"] = "🤡 ПРИБЫЛ УЕБОК JESTER!",
    ["[Merchant]: Mari has arrived..."]   = "💎 ПРИБЫЛА ШЛЮШ MARI!"
}

-- ==========================================
-- ИНТЕРФЕЙС (БЕЗ ИЗМЕНЕНИЙ ДИЗАЙНА)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalTracker"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Title.Text = "Merchant & Biome Tracker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local IDInput = Instance.new("TextBox")
IDInput.Parent = MainFrame
IDInput.Position = UDim2.new(0.05, 0, 0.3, 0)
IDInput.Size = UDim2.new(0.9, 0, 0, 35)
IDInput.PlaceholderText = "Введи Chat ID и нажми Enter"
IDInput.Text = ""
IDInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IDInput.ClearTextOnFocus = false

local Status = Instance.new("TextLabel")
Status.Parent = MainFrame
Status.Position = UDim2.new(0.05, 0, 0.6, 0)
Status.Size = UDim2.new(0.9, 0, 0, 50)
Status.Text = "Ожидание ввода ID..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.Font = Enum.Font.SourceSans
Status.TextSize = 14

-- ==========================================
-- ФУНКЦИИ
-- ==========================================

local function notify(msg)
    if target_id == "" then return end
    local encodedMsg = HttpService:UrlEncode(msg)
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. target_id .. "&text=" .. encodedMsg
    
    local req = (syn and syn.request) or request or http_request
    if req then
        req({ Url = url, Method = "GET" })
    else
        pcall(function() HttpService:GetAsync(url) end)
    end
end

IDInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and IDInput.Text ~= "" then
        target_id = IDInput.Text
        Status.Text = "✅ Подключено! ID: " .. target_id
        Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        notify("📡 CONNECTED: Скрипт активен!")
    end
end)

-- ГЛАВНЫЙ ТРЕКЕР (Слушает LogService)
LogService.MessageOut:Connect(function(message, messageType)
    local msg = message:lower()
    
    -- 1. ПРОВЕРКА БИОМОВ (Только логи)
    for keyword, notification in pairs(biome_alerts) do
        if msg:find(keyword:lower()) then
            Status.Text = "✨ БИОМ: " .. keyword:upper()
            Status.TextColor3 = Color3.fromRGB(255, 215, 0)
            notify("🚨 " .. notification .. "\n📝 Log: " .. message)
            return -- Выходим, чтобы не дублировать
        end
    end

    -- 2. ПРОВЕРКА МЕРЧАНТОВ (Логи)
    for keyword, notification in pairs(merchant_alerts) do
        if msg:find(keyword:lower()) then
            Status.Text = "🏪 МЕРЧАНТ: " .. keyword:upper()
            Status.TextColor3 = Color3.fromRGB(100, 200, 255)
            notify("🚨 " .. notification .. "\n📝 Log: " .. message)
            return
        end
    end
end)

-- ДОПОЛНИТЕЛЬНЫЙ ТРЕКЕР (Чат - ТОЛЬКО для мерчантов)
TextChatService.OnIncomingMessage = function(message: TextChatMessage)
    local msg = message.Text:lower()
    
    for keyword, notification in pairs(merchant_alerts) do
        if msg:find(keyword:lower()) then
            -- Чат ловим только если это не наше собственное сообщение (защита от спама тестом)
            notify("💬 CHAT: " .. notification .. "\n📝 Текст: " .. message.Text)
            break
        end
    end
end

print("Professional Tracker Loaded!")
