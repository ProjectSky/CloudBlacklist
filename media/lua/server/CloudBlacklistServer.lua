--
-- Created by NotePad++
-- User: ProjectSky
-- Date: 2020/05/27
-- Time: 12:25
-- CloudBlacklistServer.lua
--

local CONFIG_URL = 'https://cdn.jsdelivr.net/gh/ProjectSky/CloudBlackList-Config@latest/BlackListConfig.ini'

local CloudBlacklistServer = {}
local pairs = pairs
local skyutils = skyutils

-- 此函数接收客户端sendClientCommand请求
-- @param module 模块
-- @param command 命令
-- @param player 发送请求的玩家
-- @param args 额外数据
CloudBlacklistServer.OnClientCommand = function(module, command, player, args)
    if not isServer() then return end
    if module ~= 'CheckPlayer' then return end
    if command == 'OnJoinGame' then
        local status, ini = pcall(skyutils.readHttpini, CONFIG_URL)
        if status and type(ini['BLACKLIST']) == 'table' then
            for k, v in pairs(ini['BLACKLIST']) do
                if k == args.steamid then
                    print("[CloudBlacklist] Player: " .. args.name, "steamid: " .. args.steamid, "Trigger ban rule!")
                    sendServerCommand('CloudBlacklistServer', 'Disconnect', {reason = v})
                end
            end
        else
            print("[CloudBlacklist] Player: " .. args.name, "steamid: " .. args.steamid, "Failed to process rule!")
            sendServerCommand('CloudBlacklistServer', 'LoadFail', {})
        end
    end
end

Events.OnClientCommand.Add(CloudBlacklistServer.OnClientCommand)
