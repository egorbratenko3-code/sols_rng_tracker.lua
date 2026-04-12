local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local TextChatService = game:GetService("TextChatService")

-- ==========================================
-- НАСТРОЙКИ
-- ==========================================
local BOT_TOKEN = "8657394630:AAEkidAZN1cP57xjESCO0i30qXvvpfNxRm8"
local target_id = "" 

-- Ключевые слова (ищем везде)
local alerts = {
    ["jester has arrived"] = "🤡 ПРИБЫЛ JESTER!",
    ["mari has arrived"]   = "💎 ПРИБЫЛА MARI!",
    ["dreamspace"]         = "🌌 ОБНАРУЖЕН БИОМ: DREAMSPACE!",
    ["cyberspace"]         = "💾 ОБНАРУЖЕН БИОМ: CYBERSPACE!",
    ["glitch"]             = "⚠️ ОБНАРУЖЕН БИОМ: GLITCH!"
}

local last_notified_msg = "" -- Анти-спам

-- ==========================================
-- ИНТЕРФЕЙС (ДИЗАЙН СОХРАНЕН)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "тг бот: @MerchantTraker_Bot"
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
Title.Text = "Ultimate Tracker"
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
-- ЛОГИКА ОТПРАВКИ
-- ==========================================

local function notify(msg)
    if target_id == "" then return end
    -- Проверка на дубликаты, чтобы не слать одно и то же из разных чатов сразу
    if msg == last_notified_msg then return end
    last_notified_msg = msg
    
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. target_id .. "&text=" .. HttpService:UrlEncode(msg)
    
    local req = (syn and syn.request) or request or http_request
    if req then
        req({ Url = url, Method = "GET" })
    else
        pcall(function() HttpService:GetAsync(url) end)
    end
    
    -- Сброс анти-спама через 5 секунд
    task.delay(5, function() if last_notified_msg == msg then last_notified_msg = "" end end)
end

IDInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and IDInput.Text ~= "" then
        target_id = IDInput.Text
        Status.Text = "✅ Система онлайн!"
        Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        notify("📡 CONNECTED: Мониторинг всех чатов запущен!")
    end
end)

-- 1. МОНИТОРИНГ КОНСОЛИ (LogService)
LogService.MessageOut:Connect(function(message, messageType)
    local msg = message:lower()
    for keyword, response in pairs(alerts) do
        if msg:find(keyword:lower()) then
            Status.Text = "🔍 НАЙДЕНО (LOG): " .. keyword:upper()
            notify("📝 [LOG ALERT]: " .. response .. "\nСообщение: " .. message)
            break
        end
    end
end)

-- 2. МОНИТОРИНГ ТЕКСТОВОГО ЧАТА (TextChatService)
TextChatService.OnIncomingMessage = function(message: TextChatMessage)
    local msg = message.Text:lower()
    for keyword, response in pairs(alerts) do
        if msg:find(keyword:lower()) then
            Status.Text = "🔍 НАЙДЕНО (CHAT): " .. keyword:upper()
            notify("💬 [CHAT ALERT]: " .. response .. "\nТекст: " .. message.Text)
            break
        end
    end
end

-- 3. ЗАПАСНОЙ МОНИТОРИНГ СТАРОГО ЧАТА (Legacy Chat)
spawn(function()
    local success, chatEvents = pcall(function() 
        return game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 10) 
    end)
    if success and chatEvents then
        chatEvents:WaitForChild("OnMessageDoneFiltering").OnClientEvent:Connect(function(data)
            local msg = data.Message:lower()
            for keyword, response in pairs(alerts) do
                if msg:find(keyword:lower()) then
                    notify("📜 [LEGACY CHAT]: " .. response .. "\nТекст: " .. data.Message)
                    break
                end
            end
        end)
    end
end)

print("All-In-One Tracker Loaded!")
