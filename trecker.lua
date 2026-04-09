local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local UserInputService = game:GetService("UserInputService")

-- НАСТРОЙКИ
local BOT_TOKEN = "8657394630:AAEkidAZN1cP57xjESCO0i30qXvvpfNxRm8"
local target_id = "" -- Впишешь в самом GUI

-- ГРАФИКА
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true -- Включаем встроенную перетаскиваемость

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Merchant Tracker v2.0"
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.new(1, 1, 1)

local IDInput = Instance.new("TextBox", Frame)
IDInput.Size = UDim2.new(0.9, 0, 0, 30)
IDInput.Position = UDim2.new(0.05, 0, 0.25, 0)
IDInput.PlaceholderText = "Введи Chat ID и жми Enter"
IDInput.Text = ""

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(0.9, 0, 0, 60)
Status.Position = UDim2.new(0.05, 0, 0.55, 0)
Status.Text = "Ожидание ввода ID..."
Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Status.TextWrapped = true

-- ФУНКЦИЯ ОТПРАВКИ
local function notify(msg)
    if target_id == "" then return end
    
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage"
    local data = {chat_id = target_id, text = msg}
    
    local req = (syn and syn.request) or request or http_request
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- ОБРАБОТКА ВВОДА ID
IDInput.FocusLost:Connect(function(enter)
    if enter then
        target_id = IDInput.Text
        Status.Text = "✅ Подключено! ID: " .. target_id
        notify("📡 CONNECTED: Скрипт запущен в игре!")
    end
end)

-- ГЛАВНЫЙ ТРЕКЕР (Проверяет 3 источника)

-- 1. ЛОГИ СИСТЕМЫ (Самый надежный метод для инжектора)
-- Почти все системные алерты о торговцах дублируются в консоль (F9)
game:GetService("LogService").MessageOut:Connect(function(message, messageType)
    local msg = message:lower()
    if msg:find("mari has arrived") or msg:find("jester has arrived") then
        Status.Text = "🚨 НАЙДЕН В ЛОГАХ!"
        notify("LOG ALERT: " .. message)
    end
end)

-- 2. НОВЫЙ ЧАТ (TextChatService)
-- Проверяем OnIncomingMessage (срабатывает даже на скрытые сообщения)
TextChatService.OnIncomingMessage = function(message: TextChatMessage)
    local content = message.Text:lower()
    if content:find("mari has arrived") or content:find("jester has arrived") then
        Status.Text = "📢 НАЙДЕН В ЧАТЕ (NEW)!"
        notify("CHAT ALERT: " .. message.Text)
    end
end

-- На случай, если игра использует классический движок чата
spawn(function()
    local success, chatEvents = pcall(function() 
        return game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 10) 
    end)
    
    if success and chatEvents then
        local onMsg = chatEvents:WaitForChild("OnMessageDoneFiltering", 10)
        if onMsg then
            onMsg.OnClientEvent:Connect(function(data)
                local msg = data.Message:lower()
                if msg:find("mari has arrived") or msg:find("jester has arrived") then
                    Status.Text = "💬 НАЙДЕН В ЧАТЕ (OLD)!"
                    notify("LEGACY ALERT: " .. data.Message)
                end
            end)
        end
    end
end)

Status.Text = "Скрипт готов. Введи ID."
