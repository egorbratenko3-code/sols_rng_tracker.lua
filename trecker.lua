local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

-- ПЕРЕМЕННЫЕ
local BOT_TOKEN = "ТВОЙ_ТОКЕН_БОТА" -- Вставь свой токен
local BOT_URL = "https://t.me/MerchantTraker_Bot"
local target_id = "" 

-- Таблица целей для отслеживания
local targets = {
    ["Jester"] = "Jester has arrived",
    ["Mari"] = "Mari has arrived"
}

-- СОЗДАНИЕ GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Content = Instance.new("Frame")
local IDInput = Instance.new("TextBox")
local CopyBotBtn = Instance.new("TextButton")
local LogBox = Instance.new("ScrollingFrame")
local LogList = Instance.new("UIListLayout")

ScreenGui.Name = "EventTracker"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.BorderSizePixel = 0

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TopBar.Size = UDim2.new(1, 0, 0, 30)

Title.Parent = TopBar
Title.Text = "Merchant & Jester Tracker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

IDInput.Parent = MainFrame
IDInput.Position = UDim2.new(0.05, 0, 0.2, 0)
IDInput.Size = UDim2.new(0.9, 0, 0, 30)
IDInput.PlaceholderText = "Введите Chat ID..."
IDInput.Text = ""
IDInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)

CopyBotBtn.Parent = MainFrame
CopyBotBtn.Position = UDim2.new(0.05, 0, 0.37, 0)
CopyBotBtn.Size = UDim2.new(0.9, 0, 0, 25)
CopyBotBtn.Text = "Скопировать ссылку на бота"
CopyBotBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 136) -- Цвет поменял для стиля
CopyBotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

LogBox.Parent = MainFrame
LogBox.Position = UDim2.new(0.05, 0, 0.53, 0)
LogBox.Size = UDim2.new(0.9, 0, 0, 90)
LogBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
LogBox.CanvasSize = UDim2.new(0, 0, 5, 0)
LogList.Parent = LogBox

-- ФУНКЦИИ
local function addLog(text)
    local l = Instance.new("TextLabel")
    l.Parent = LogBox
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.TextSize = 12
    l.Text = "[" .. os.date("%X") .. "] " .. text
    l.TextXAlignment = Enum.TextXAlignment.Left
    LogBox.CanvasPosition = Vector2.new(0, LogBox.AbsoluteWindowSize.Y)
end

-- ЛОГИКА ПЕРЕМЕЩЕНИЯ
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ОТПРАВКА В ТГ
local function sendToTelegram(msg)
    if target_id == "" then 
        addLog("Ошибка: Нет ID!")
        return 
    end
    
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage"
    local data = {chat_id = target_id, text = "🛒 " .. msg}
    
    local req = request or http_request or (syn and syn.request)
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
        addLog("Уведомление отправлено!")
    else
        addLog("Ошибка: HTTP не поддерживается")
    end
end

-- ТРЕКИНГ ЧАТА (Две цели)
TextChatService.OnIncomingMessage = function(message: TextChatMessage)
    local msg = message.Text:lower()
    
    for name, phrase in pairs(targets) do
        if msg:find(phrase:lower()) then
            addLog("ОБНАРУЖЕН: " .. name)
            sendToTelegram(message.Text)
            break
        end
    end
end

IDInput.FocusLost:Connect(function()
    target_id = IDInput.Text
    addLog("ID сохранен: " .. target_id)
end)

CopyBotBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(BOT_URL) addLog("Ссылка в буфере!") end
end)

addLog("Скрипт запущен. Жду Mari/Jester...")
