--
-- Created by NotePad++
-- User: ProjectSky
-- Date: 2020/05/27
-- Time: 12:25
-- CloudBlacklist.lua
--

local CloudBlacklist = {}
local skyutils = skyutils

-- 此函数将在玩家进入游戏时触发
-- @param ticks 游戏刻
CloudBlacklist.OnTick = function(ticks)
    if ticks and ticks > 0 then return end
    if isClient() then
        sendClientCommand(getPlayer(), 'CheckPlayer', 'OnJoinGame', {name = getOnlineUsername(), steamid = getCurrentUserSteamID()})
    end
    Events.OnTick.Remove(CloudBlacklist.OnTick)
end

-- 此函数接收服务端OnServerCommand请求
-- @param module 模块
-- @param command 命令
-- @param args 额外数据
CloudBlacklist.OnServerCommand = function(module, command, args)
    local player = getPlayer()
    if not isClient() then return end
    if module ~= 'CloudBlacklistServer' then return end
    if command == 'Disconnect' then
        if args.reason then
            BanReason = args.reason
        else
            BanReason = 'Other'
        end
        CloudBlacklist_loadfail = false
        player:setBlockMovement(true)
        writeLog('CloudBlacklist', getText('Tooltip_CloudBlacklist_trigger', getOnlineUsername(), getCurrentUserSteamID(), skyutils.getCurrentTime()))
        Events.OnTick.Add(CloudBlacklist.forceDisconnect)
    elseif command == 'LoadFail' then
        CloudBlacklist_loadfail = true
        player:setBlockMovement(true)
        writeLog('CloudBlacklist', getText('Tooltip_CloudBlacklist_loadfail', getOnlineUsername(), getCurrentUserSteamID(), skyutils.getCurrentTime()))
        Events.OnTick.Add(CloudBlacklist.forceDisconnect)
    end
end

-- 此函数执行断开操作
-- @param ticks 游戏刻
CloudBlacklist.forceDisconnect = function(ticks)
    if ticks and ticks == 300 then
      disconnect()
      Events.OnTick.Remove(CloudBlacklist.forceDisconnect)
    end
end

-- 此函数调用ISServerDisconnectUI.createChildren方法
local reader = ISServerDisconnectUI.createChildren
function ISServerDisconnectUI:createChildren()
    reader(self)
    if not CloudBlacklist_loadfail then
        skyutils.showRichText(getText('UI_CloudBlacklist_BAN_MSG', getText('Tooltip_CloudBlacklist_Reason_' .. BanReason)))
    else
        skyutils.showRichText(getText('UI_CloudBlacklist_DATAFAIL_MSG'))
    end
end

Events.OnTick.Add(CloudBlacklist.OnTick)
Events.OnServerCommand.Add(CloudBlacklist.OnServerCommand)
