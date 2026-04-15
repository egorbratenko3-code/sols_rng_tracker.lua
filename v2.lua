-- [[ ELITE TRACKER V1.6 - FULL SECURE VERSION ]]

local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local userId = tostring(lplr.UserId)

-- Твоя зашифрованная ссылка на вайтлист
local whitelistUrl = ("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\101\103\111\114\98\114\97\116\101\110\107\111\51\45\99\111\100\101\47\115\111\108\115\95\114\110\103\95\116\114\97\99\107\101\114\46\108\117\97\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\119\104\105\116\101\108\105\115\116\46\116\120\116")

local function checkWhitelist()
    local success, content = pcall(function()
        return game:HttpGet(whitelistUrl .. "?nocache=" .. math.random(1, 999999))
    end)
    
    if success and content:find(userId) then
        print("✅ Доступ разрешен! Привет, " .. lplr.Name)
        return true
    else
        lplr:Kick("\n🛑 ДОСТУП ЗАКРЫТ\n\nВаш ID: " .. userId .. "\nКупите доступ у автора скрипта.")
        return false
    end
end

-- Запускаем всё дерево скрипта только при успешной проверке
if checkWhitelist() then
    
    local HttpService = game:GetService("HttpService")
    local TextChatService = game:GetService("TextChatService")
    
    -- Твой зашифрованный токен бота
    local BOT_TOKEN = ("\56\54\53\55\51\57\52\54\51\48\58\65\65\69\107\105\100\65\90\78\49\99\80\53\55\120\106\69\83\67\79\48\105\51\48\113\88\118\118\112\102\78\120\82\109\56")
    local target_id = ""

    local biomes = {"WINDY", "SNOWY", "RAINY", "SANDSTORM", "HELL", "STARFALL", "HEAVEN", "CORRUPTION", "NULL", "GLITCH", "DREAMSPACE", "CYBERSPACE"}
    local merchants = {"Jester", "Rin", "Mari"}
    local active = {}
    local ui_elements = {Main = nil, Accords = {}, Buttons = {}, Inputs = {}}

    local function sendToTelegram(message)
        if target_id == "" or target_id == nil then return end
        local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. target_id .. "&text=" .. HttpService:UrlEncode(message)
        
        pcall(function()
            local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
            if httpRequest then
                httpRequest({Url = url, Method = "GET"})
            else
                HttpService:GetAsync(url)
            end
        end)
    end

    -- Настройка Live Kick (раз в 5 минут)
    task.spawn(function()
        while task.wait(300) do
            local s, res = pcall(function()
                return game:HttpGet(whitelistUrl .. "?nocache=" .. math.random(1, 999999))
            end)
            if s and not res:find(userId) then
                lplr:Kick("\n🛑 ДОСТУП АННУЛИРОВАН")
            end
        end
    end)

    -- [[ ИНТЕРФЕЙС ]]
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Sol's RNG Tracker V1.6"
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
    Title.Text = "Sol's RNG Tracker V1.6"
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

    local function ApplyTheme(bg, accent, text)
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

    IDInput.FocusLost:Connect(function(ep)
        if ep then 
            target_id = IDInput.Text
            sendToTelegram("✅ Connected! ID: " .. target_id)
        end
    end)

    TextChatService.OnIncomingMessage = function(message: TextChatMessage)
        local raw = message.Text
        for name, state in pairs(active) do
            if state and raw:lower():find(name:lower()) then
                sendToTelegram("FOUND: " .. name .. "\n\n" .. raw)
                break
            end
        end
    end

    print("Elite Tracker V16: Fully Loaded and Secure!")
end
