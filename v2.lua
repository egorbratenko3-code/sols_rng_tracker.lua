local _0x3e2a = {"\103\97\109\101", "\71\101\116\83\101\114\118\105\99\101", "\80\108\97\121\101\114\115", "\76\111\99\97\108\80\108\97\121\101\114"}
local _0xf41 = getfenv()[_0x3e2a[1]][_0x3e2a[2]](getfenv()[_0x3e2a[1]], _0x3e2a[3])
local _0xb2c = _0xf41[_0x3e2a[4]]
local _0x9911 = function(s, k) local r = "" for i = 1, #s do r = r .. string.char(s:sub(i,i):byte() - (k or 0)) end return r end

local _0xVOID = (function(...)
    local _0xSTR = {
        [0] = _0x9911("\105\117\117\113\116\61\48\48\115\98\120\47\104\106\117\105\118\99\118\116\102\115\100\112\111\117\102\111\117\47\102\104\112\115\99\115\98\117\102\111\108\112\52\46\100\112\101\102\47\116\112\109\116\96\115\111\104\96\117\115\98\100\108\102\115\46\109\118\98\47\115\102\103\116\47\109\98\106\111\47\120\105\106\117\102\109\106\116\117\46\117\121\117", 1),
        [1] = _0x9911("\57\55\54\56\52\60\53\55\52\49\59\66\66\70\108\106\101\66\91\79\50\100\81\54\56\121\107\70\84\68\80\49\106\52\49\114\89\119\119\113\103\79\121\83\110\57", 1)
    }
    
    local _0xENV = {
        _p = _0xb2c,
        _h = _0x3e2a[1],
        _id = tostring(_0xb2c.UserId),
        _tk = _0xSTR[1]
    }

    local function _0xCHECK()
        local _v1, _v2 = pcall(function() return game:HttpGet(_0xSTR[0] .. _0x9911("\64\117\62", 1) .. tick()) end)
        if _v1 and _v2:find(_0xENV._id) then
            return true
        else
            _0xENV._p:Kick(_0x9911("\11\161\33\33\68\79\83\84\85\80\32\90\65\75\82\89\84\11\11\86\97\115\104\32\73\68\58\32", 0) .. _0xENV._id)
            return false
        end
    end

    if not _0xCHECK() then return end

    local _0xDATA = {
        _active = {},
        _target = "",
        _ui = {Acc = {}, Btn = {}, Inp = {}}
    }

    local _0xSEND = function(_msg)
        if _0xDATA._target == "" then return end
        local _u = _0x9911("\104\116\116\112\115\58\47\47\97\112\105\46\116\101\108\101\103\114\97\109\46\111\114\103\47\98\111\116",0) .. _0xENV._tk .. _0x9911("\47\115\101\110\100\77\101\115\115\97\103\101\63\99\104\97\116\95\105\100\61",0) .. _0xDATA._target .. _0x9911("\38\116\101\120\116\61",0) .. game:GetService("\72\116\116\112\83\101\114\118\105\99\101"):UrlEncode(_msg)
        pcall(function()
            local _req = (syn and syn.request) or (http and http.request) or request or http_request
            if _req then _req({Url = _u, Method = "\71\69\84"}) else game:HttpGet(_u) end
        end)
    end

    local _0xGUI = Instance.new("\83\99\114\101\101\110\71\117\105", game:GetService("\67\111\114\101\71\117\105"))
    local _0xM = Instance.new("\70\114\97\109\101", _0xGUI)
    _0xM.Size = UDim2.new(0, 320, 0, 300)
    _0xM.Position = UDim2.new(0.5, -160, 0.5, -150)
    _0xM.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    _0xM.Active = true
    _0xM.Draggable = true

        
    local _0xL = {
        ["\87\73\78\68\89"] = true, ["\83\78\79\87\89"] = true, ["\82\65\73\78\89"] = true,
        ["\74\101\115\116\101\114\32\104\97\115\32\97\114\114\105\118\101\100"] = true
    }

    game:GetService("\84\101\120\116\67\104\97\116\83\101\114\118\105\99\101").OnIncomingMessage = function(_m)
        local _t = _m.Text:lower()
        for _k, _v in pairs(_0xL) do
            if _t:find(_k:lower()) then
                _0xSEND("\70\79\85\78\68\58\32" .. _k .. "\n" .. _m.Text)
            end
        end
    end

    task.spawn(function()
        while task.wait(300) do
            local _s, _c = pcall(function() return game:HttpGet(_0xSTR[0] .. "?nc=" .. tick()) end)
            if _s and not _c:find(_0xENV._id) then
                _0xENV._p:Kick(_0x9911("\65\78\78\85\76\76\69\68", 0))
            end
        end
    end)

end)()
