local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

-- ==========================================
-- КОНФИГУРАЦИЯ
-- ==========================================
local BOT_TOKEN = "8657394630:AAEkidAZN1cP57xjESCO0i30qXvvpfNxRm8"
local target_id = ""

local biomes = {"WINDY", "SNOWY", "RAINY", "SANDSTORM", "HELL", "STARFALL", "HEAVEN", "CORRUPTION", "NULL", "GLITCH", "DREAMSPACE", "CYBERSPACE"}
local merchants = {"Jester", "Rin", "Mari"}
local active = {}
local ui_elements = {Main = nil, Accords = {}, Buttons = {}, Inputs = {}}

-- ==========================================
-- ФУНКЦИЯ ОТПРАВКИ (БРОНЕБОЙНАЯ)
-- ==========================================
local function sendToTelegram(message)
    if target_id == "" or target_id == nil then return end
    
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. target_id .. "&text=" .. HttpService:UrlEncode(message)
    
    local success, err = pcall(function()
        -- Пробуем сначала через спец-функции читов, если их нет - через стандарт
        local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
        if httpRequest then
            httpRequest({Url = url, Method = "GET"})
        else
            HttpService:GetAsync(url)
        end
    end)
    
    if not success then
        warn("Tracker: Ошибка отправки -> " .. tostring(err))
    end
end

-- ==========================================
-- СИСТЕМА ТЕМ (ПОЛНАЯ ПЕРЕКРАСКА)
-- ==========================================
local isRGB = false

local function ApplyTheme(bg, accent, text)
    isRGB = false
    ui_elements.Main.BackgroundColor3 = bg
    for _, obj in pairs(ui_elements.Accords) do
        obj.Frame.BackgroundColor3 = accent
        obj.Header.TextColor3 = text
    end
    for _, btn in pairs(ui_elements.Buttons) do
        if not btn:GetAttribute("IsToggle") then
            btn.BackgroundColor3 = accent
        end
        btn.TextColor3 = text
    end
    for _, input in pairs(ui_elements.Inputs) do
        input.BackgroundColor3 = accent
        input.TextColor3 = text
    end
end

-- ==========================================
-- ИНТЕРФЕЙС
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sol's RNG Tracker_V1.6"
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Main.Position = UDim2.new(0.5, -160, 0.5, -150)
Main.Size = UDim2.new(0, 320, 0, 300)
Main.Active = true
Main.Draggable = true
ui_elements.Main = Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "SOL'S RNG TRACKER V1.6"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Position = UDim2.new(0, 10, 0, 40)
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 0

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

-- ЭЛЕМЕНТЫ
local IDInput = Instance.new("TextBox")
IDInput.Parent = Scroll
IDInput.Size = UDim2.new(1, 0, 0, 35)
IDInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
IDInput.TextColor3 = Color3.new(1, 1, 1)
IDInput.PlaceholderText = "CHAT ID"
IDInput.Font = Enum.Font.Gotham
IDInput.TextSize = 14
Instance.new("UICorner", IDInput)
table.insert(ui_elements.Inputs, IDInput)

local function CreateAccordion(title)
    local AccordionFrame = Instance.new("Frame")
    AccordionFrame.Size = UDim2.new(1, 0, 0, 35)
    AccordionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    AccordionFrame.ClipsDescendants = true
    AccordionFrame.Parent = Scroll
    Instance.new("UICorner", AccordionFrame)

    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundTransparency = 1
    Header.Text = "  [+]  " .. title
    Header.TextColor3 = Color3.new(1, 1, 1)
    Header.Font = Enum.Font.GothamSemibold
    Header.TextSize = 13
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = AccordionFrame

    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, 5, 0, 40)
    Content.Size = UDim2.new(1, -10, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1
    Content.Parent = AccordionFrame
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 4)

    Header.MouseButton1Click:Connect(function()
        local open = AccordionFrame.Size.Y.Offset == 35
        AccordionFrame.Size = open and UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 45) or UDim2.new(1, 0, 0, 35)
        Header.Text = (open and "  [-]  " or "  [+]  ") .. title
    end)
    
    table.insert(ui_elements.Accords, {Frame = AccordionFrame, Header = Header})
    return Content
end

local ThemeSec = CreateAccordion("THEMES")
local MerchSec = CreateAccordion("MERCHANTS")
local BiomeSec = CreateAccordion("BIOMES")

-- ТЕМЫ
local function AddThemeBtn(name, bg, acc, txt)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = acc
    b.Text = name
    b.TextColor3 = txt
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.Parent = ThemeSec
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() ApplyTheme(bg, acc, txt) end)
    table.insert(ui_elements.Buttons, b)
end

AddThemeBtn("Midnight Dark", Color3.fromRGB(15,15,17), Color3.fromRGB(25,25,30), Color3.new(1,1,1))
AddThemeBtn("Pure Light", Color3.fromRGB(240,240,240), Color3.fromRGB(215,215,215), Color3.fromRGB(30,30,30))
AddThemeBtn("Oceanic", Color3.fromRGB(20,30,45), Color3.fromRGB(35,50,75), Color3.new(1,1,1))

-- RGB ЦИКЛ
local rgbBtn = Instance.new("TextButton")
rgbBtn.Size = UDim2.new(1, 0, 0, 30); rgbBtn.Text = "RGB MODE [TOGGLE]"; rgbBtn.Parent = ThemeSec; rgbBtn.Font = Enum.Font.Gotham; rgbBtn.TextSize = 12
Instance.new("UICorner", rgbBtn)
rgbBtn.MouseButton1Click:Connect(function() isRGB = not isRGB end)

task.spawn(function()
    while task.wait() do
        if isRGB then
            local c = Color3.fromHSV(tick()%5/5, 0.5, 0.7)
            Main.BackgroundColor3 = c
            for _, v in pairs(ui_elements.Accords) do v.Frame.BackgroundColor3 = c:Lerp(Color3.new(0,0,0), 0.15) end
            for _, i in pairs(ui_elements.Inputs) do i.BackgroundColor3 = c:Lerp(Color3.new(0,0,0), 0.15) end
        end
    end
end)

-- ПЕРЕКЛЮЧАТЕЛИ
local function AddToggle(name, parent)
    active[name] = true
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(40, 110, 40)
    b.Text = name .. " [ON]"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b:SetAttribute("IsToggle", true)
    b.Parent = parent
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        active[name] = not active[name]
        b.BackgroundColor3 = active[name] and Color3.fromRGB(40, 110, 40) or Color3.fromRGB(110, 40, 40)
        b.Text = name .. (active[name] and " [ON]" or " [OFF]")
    end)
end

for _, m in pairs(merchants) do AddToggle(m, MerchSec) end
for _, b in pairs(biomes) do AddToggle(b, BiomeSec) end

-- ==========================================
-- ЛОГИКА
-- ==========================================
IDInput.FocusLost:Connect(function(ep)
    if ep then 
        target_id = IDInput.Text
        sendToTelegram("✅ Tracker Connected! ID: " .. target_id)
    end
end)

TextChatService.OnIncomingMessage = function(message: TextChatMessage)
    local raw = message.Text
    for name, state in pairs(active) do
        if state and raw:lower():find(name:lower()) then
            sendToTelegram("🔔 TARGET FOUND: " .. name .. "\n\n" .. raw)
            break
        end
    end
end
