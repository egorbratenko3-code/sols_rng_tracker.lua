local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

-- ==========================================
-- НАСТРОЙКИ (ВСТАВЬ СВОЙ ТОКЕН)
-- ==========================================
local BOT_TOKEN = "8657394630:AAEkidAZN1cP57xjESCO0i30qXvvpfNxRm8"
local target_id = "" -- Установится через GUI

-- Список целей для отслеживания (Биомы и Торговцы)
local alerts = {
    ["merchant npc"] = "🏪 Торговец появился на сервере!",
    ["dreamspace"]   = "🌌 ОБНАРУЖЕН БИОМ: DREAMSPACE!",
    ["cyberspace"]   = "💾 ОБНАРУЖЕН БИОМ: CYBERSPACE!",
    ["glitch"]       = "⚠️ ОБНАРУЖЕН БИОМ: GLITCH!"
}

-- ==========================================
-- СОЗДАНИЕ ИНТЕРФЕЙСА (GUI)
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
MainFrame.Draggable = true -- Можно двигать мышкой за всё окно

-- Скругление углов
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
    
    -- Кодируем сообщение для URL
    local encodedMsg = HttpService:UrlEncode(msg)
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. target_id .. "&text=" .. encodedMsg
    
    local req = (syn and syn.request) or request or http_request
    if req then
        req({
            Url = url,
            Method = "GET"
        })
    else
        -- Запасной метод, если инжектор старый
        pcall(function()
            HttpService:GetAsync(url)
        end)
    end
end

-- Обработка ввода ID
IDInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and IDInput.Text ~= "" then
        target_id = IDInput.Text
        Status.Text = "✅ Подключено! ID: " .. target_id
        Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Сразу отправляем тестовое уведомление
        notify("📡 CONNECTED: Скрипт в Roblox запущен и слушает логи!")
    end
end)

-- ГЛАВНЫЙ ТРЕКЕР (Слушает LogService)
LogService.MessageOut:Connect(function(message, messageType)
    local msg = message:lower()
    
    for keyword, notification in pairs(alerts) do
        if msg:find(keyword:lower()) then
            Status.Text = "✨ НАЙДЕНО: " .. keyword:upper()
            Status.TextColor3 = Color3.fromRGB(255, 215, 0)
            
            -- Отправка в ТГ
            notify("🚨 " .. notification .. "\n\n📝 Полный лог: " .. message)
            
            task.wait(2) -- Защита от спама (если лог дублируется)
            break
        end
    end
end)

-- Дополнительный трекер через чат (на всякий случай)
TextChatService.OnIncomingMessage = function(message: TextChatMessage)
    local msg = message.Text:lower()
    for keyword, notification in pairs(alerts) do
        if msg:find(keyword:lower()) then
            notify("💬 ЧАТ АЛЕРТ: " .. notification .. "\n📝 Сообщение: " .. message.Text)
            break
        end
    end
end

print("Tracker Script Loaded!")
