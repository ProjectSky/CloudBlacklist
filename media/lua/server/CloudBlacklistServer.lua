--
-- Created by NotePad++
-- User: ProjectSky
-- Date: 2020/05/27
-- Time: 12:25
-- CloudBlacklistServer.lua
--

local CloudBlacklistServer = {}
local sub = string.sub
local split = string.split
local getUrlStream = getUrlInputStream
local stringStarts = luautils.stringStarts

-- 此函数读取远程服务器的http数据流并将其解析成ini格式
-- @param Url 服务器url
-- @return table
function CloudBlacklistServer.readHttpini(Url)
	local settingsFile = getUrlStream(Url)
	local inidata = {}
	local line = nil
	local section = "empty"
	while true do
		line = settingsFile:readLine()
		if line == nil then
			settingsFile:close()
			break
		end

		if (stringStarts(line, "[")) then
			section = sub(line, 2, -2)
			inidata[section] = {}
		end
		if (not stringStarts(line, "[") and not stringStarts(line, "") and line ~= "") then
			local splitedLine = split(line, "=")
			local key = splitedLine[1]
			local value = splitedLine[2]
			inidata[section][key] = value
		end
	end
	return inidata
end

-- 此函数接收客户端sendClientCommand请求
-- @param module 模块
-- @param command 命令
-- @param player 发送请求的玩家
-- @param args 额外数据
CloudBlacklistServer.OnClientCommand = function(module, command, player, args)
  if not isServer() then return end
  if module ~= "CheckPlayer" then return end
  if command == "OnJoinGame" then
    local LIST = CloudBlacklistServer.readHttpini("http://hfs.imsky.cc:777/test.ini")
      for k,v in pairs (LIST["BLACKLIST"]) do
        if k == args.steamid then
          print("Kick User: ", args.name)
          sendServerCommand('CloudBlacklistServer', 'Disconnect', {msg = v})
          --executeQuery("UPDATE bannedip SET reason = ? WHERE ip = ? AND username = ?", {"12", "114.114.114.115", "test1"})
        end
    end
  end
end

Events.OnClientCommand.Add(CloudBlacklistServer.OnClientCommand)