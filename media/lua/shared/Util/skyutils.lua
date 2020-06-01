--
-- Created by NotePad++
-- User: ProjectSky
-- Date: 2020/05/31
-- Time: 11:51
-- CloudBlacklist utils
--

skyutils = {}

local getUrlStream = getUrlInputStream
local stringStarts = luautils.stringStarts
local pairs = pairs
local tostring = tostring
local sub = string.sub
local rep = string.rep
local len = string.len
local split = string.split
local banID = Keys.banSteamID

-- 此函数在游戏中显示一个富文本窗口
-- @param text 字符串
skyutils.showRichText = function(text)
    local msg = ISModalRichText:new(getCore():getScreenWidth() / 2 - 300, getCore():getScreenHeight() / 2 - 300, 600, 600, text, false)
    msg:initialise()
    msg.chatText:paginate()
    msg.backgroundColor = {r = 0, g = 0, b = 0, a = 0.9}
    msg:setHeightToContents()
    msg:ignoreHeightChange()
    msg:setVisible(true)
    msg:addToUIManager()
end

-- 此函数按照yyyy-MM-dd HH:mm:ss格式化时间
-- @param time 当前时间
skyutils.getCurrentTime = function()
    local sdf = SimpleDateFormat.new('yyyy-MM-dd HH:mm:ss')
    local time = sdf:format(Calendar.getInstance():getTime())
    return time
end

-- 此函数用来封禁指定的steamid
-- @param steamid 玩家的steamid
-- @param reason 封禁的原因
-- @info 此函数通过反编译添加，不保证稳定性
skyutils.banSteamID = function(steamid, reason)
    if not banID then return end
    banID(steamid, reason)
end

-- 此函数读取远程服务器的http数据流并将其解析成ini格式
-- @param url 服务器地址
-- @return table
skyutils.readHttpini = function(url)
    local settingsFile = getUrlStream(url)
    local inidata = {}
    local line = nil
    local section = 'empty'
    while true do
        line = settingsFile:readLine()
        if line == nil then
            settingsFile:close()
            break
        end

        if stringStarts(line, '[') then
            section = sub(line, 2, -2)
            inidata[section] = {}
        end
        if not stringStarts(line, '[') and not stringStarts(line, ';') and not stringStarts(line, '#') and line ~= '' then
            local splitedLine = split(line, '=')
            local key = splitedLine[1]
            local value = splitedLine[2]
            inidata[section][key] = value
        end
    end
    return inidata
end