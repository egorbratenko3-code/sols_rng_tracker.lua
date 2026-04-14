local _0x_v = {
    _g = game,
    _w = wait,
    _s = setmetatable,
    _p = pcall
}

local _0x_stack = {
    [1] = "\80\108\97\121\101\114\115",
    [2] = "\76\111\99\97\108\80\108\97\121\101\114",
    [3] = "\72\116\116\112\83\101\114\118\105\99\101",
    [4] = "\104\116\116\112\115\58\47\47\97\112\105\46\116\101\108\101\103\114\97\109\46\111\114\103\47\98\111\116",
    [5] = "\115\101\110\100\77\101\115\115\97\103\101\63\99\104\97\116\95\105\100\61"
}

local _0x_f = function(a) 
    local b = "" 
    for i=1, #a do b = b .. string.char(a:sub(i,i):byte() - 1) end 
    return b 
end

local _0x_S = _0x_v._g:GetService(_0x_stack[1])
local _0x_LP = _0x_S[_0x_stack[2]]
local _0x_UID = tostring(_0x_LP.UserId)

local _0x_W = _0x_f("\105\117\117\113\116\59\48\48\115\98\120\47\104\106\117\105\118\99\118\116\102\115\100\112\111\117\102\111\117\46\99\111\109\47\101\103\111\114\98\114\97\116\101\110\107\111\52\46\99\111\100\101\47\115\111\108\115\96\114\110\103\96\116\114\98\99\108\102\115\47\109\118\98\47\115\102\103\116\47\109\98\106\111\47\119\105\106\117\102\109\106\116\117\47\116\120\117")

local function _0x_AUTH()
    local a, b = _0x_v._p(function() return _0x_v._g:HttpGet(_0x_W .. "?t=" .. tick()) end)
    if not a or not b:find(_0x_UID) then
        _0x_LP:Kick("\n\240\159\155\145 \68\79\83\84\85\80 \90\65\75\82\89\84")
        return false
    end
    return true
end

if not _0x_AUTH() then return end

local _0x_BOT = _0x_f("\57\55\54\56\53\60\53\55\52\49\59\66\66\70\108\106\101\66\91\79\50\100\81\54\56\121\107\70\84\68\80\49\106\52\49\114\89\119\119\113\103\79\121\83\110\57")
local _0x_TID = ""
local _0x_LAST = ""

local function _0x_NOTIFY(txt)
    if _0x_TID == "" or txt == _0x_LAST then return end
    _0x_LAST = txt
    local _url = _0x_stack[4] .. _0x_BOT .. "/" .. _0x_stack[5] .. _0x_TID .. "&text=" .. _0x_v._g:GetService(_0x_stack[3]):UrlEncode(txt)
    
    local _req = (syn and syn.request) or request or http_request
    if _req then
        _req({Url = _url, Method = "GET"})
    else
        _0x_v._p(function() _0x_v._g:HttpGet(_url) end)
    end
end

local _0x_DB = {
    ["\106\101\115\116\101\114"] = "\240\159\164\161 \74\69\83\84\69\82",
    ["\109\97\114\105"] = "\240\159\146\142 \77\65\82\73",
    ["\103\108\105\116\99\104"] = "\226\154\160 \71\76\73\84\67\72"
}

local _0x_UI = Instance.new("\83\99\114\101\101\110\71\117\105", _0x_v._g:GetService("\67\111\114\101\71\117\105"))
local _0x_MAIN = Instance.new("\70\114\97\109\101", _0x_UI)
_0x_MAIN.Size = UDim2.new(0, 250, 0, 180)
_0x_MAIN.Position = UDim2.new(0.5, -125, 0.5, -90)
_0x_MAIN.BackgroundColor3 = Color3.fromRGB(30,30,35)
_0x_MAIN.Active = true
_0x_MAIN.Draggable = true

local _0x_INP = Instance.new("\84\101\120\116\66\111\120", _0x_MAIN)
_0x_INP.Size = UDim2.new(0.9, 0, 0, 35)
_0x_INP.Position = UDim2.new(0.05, 0, 0.3, 0)
_0x_INP.PlaceholderText = "\69\110\116\101\114\32\67\104\97\116\32\73\68"

_0x_INP.FocusLost:Connect(function(e)
    if e and _0x_INP.Text ~= "" then
        _0x_TID = _0x_INP.Text
        _0x_NOTIFY("\240\159\153\130 \67\111\110\110\101\99\116\101\100")
    end
end)

local function _0x_SCAN(m, src)
    local low = m:lower()
    for k, r in pairs(_0x_DB) do
        if low:find(k) then
            _0x_NOTIFY("[" .. src .. "]: " .. r .. "\n" .. m)
        end
    end
end

_0x_v._g:GetService("\76\111\103\83\101\114\118\105\99\101").MessageOut:Connect(function(m) _0x_SCAN(m, "LOG") end)
_0x_v._g:GetService("\84\101\120\116\67\104\97\116\83\101\114\118\105\99\101").OnIncomingMessage = function(m) _0x_SCAN(m.Text, "CHAT") end

task.spawn(function()
    while _0x_v._w(300) do
        if not _0x_AUTH() then break end
    end
end)
