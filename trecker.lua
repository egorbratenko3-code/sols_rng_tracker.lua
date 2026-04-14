local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local userId = tostring(lplr.UserId)

local whitelistUrl = ("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\101\103\111\114\98\114\97\116\101\110\107\111\51\45\99\111\100\101\47\115\111\108\115\95\114\110\103\95\116\114\97\99\107\101\114\46\108\117\97\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\119\104\105\116\101\108\105\115\116\46\116\120\116")

local function checkWhitelist()
    local success, content = pcall(function()
        return game:HttpGet(whitelistUrl .. "?t=" .. tick())
    end)
    
    if success and content:find(userId) then
        print("✅ Доступ разрешен! Привет, " .. lplr.Name)
        return true
    else
        lplr:Kick("\n🛑 ДОСТУП ЗАКРЫТ\n\nВаш ID: " .. userId .. "\nКупите доступ у автора скрипта.")
        return false
    end
end

if not checkWhitelist() then return end

local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local TextChatService = game:GetService("TextChatService")

local BOT_TOKEN = ("\56\54\53\55\51\57\52\54\51\48\58\65\65\69\107\105\100\65\90\78\49\99\80\53\55\120\106\69\83\67\79\48\105\51\48\113\88\118\118\112\102\78\120\82\109\56")
local target_id = "" 

local alerts = {
    ["jester has arrived"] = "🤡 ПРИБЫЛ JESTER!",
    ["mari has arrived"]   = "💎 ПРИБЫЛА MARI!",
    ["dreamspace"]         = "🌌 ОБНАРУЖЕН БИОМ: DREAMSPACE!",
    ["cyberspace"]         = "💾 ОБНАРУЖЕН БИОМ: CYBERSPACE!",
    ["glitch"]             = "⚠️ ОБНАРУЖЕН БИОМ: GLITCH!"
}

local last_notified_msg = ""

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


local function notify(msg)
    if target_id == "" then return end
    if msg == last_notified_msg then return end
    last_notified_msg = msg
    
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. target_id .. "&text=" .. HttpService:UrlEncode(msg)
    
    local req = (syn and syn.request) or request or http_request
    if req then
        req({ Url = url, Method = "GET" })
    else
        pcall(function() HttpService:GetAsync(url) end)
    end
    
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

task.spawn(function()
    while task.wait(300) do
        local success, content = pcall(function()
            return game:HttpGet(whitelistUrl .. "?nocache=" .. tick())
        end)
        
        if success then
            if not content:find(userId) then
                lplr:Kick("\n🛑 ДОСТУП АННУЛИРОВАН\n\nВаша подписка была приостановлена или удалена администратором.")
            end
        end
    end
end)
