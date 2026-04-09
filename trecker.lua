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

-- ГЛАВНЫЙ ТРЕКЕР (LogService ловит всё!)
LogService.MessageOut:Connect(function(message, messageType)
    local msg = message:lower()
    
    -- Проверка на Mari
    if msg:find("mari has arrived") then
        Status.Text = "💎 НАЙДЕНА MARI!"
        notify("💎 [MERCHANT]: Mari has arrived on the island!")
        
    -- Проверка на Jester
    elseif msg:find("jester has arrived") then
        Status.Text = "🤡 НАЙДЕН JESTER!"
        notify("🤡 [MERCHANT]: Jester has arrived on the island!!")
    end
end)

Status.Text = "Скрипт готов. Введи ID."
