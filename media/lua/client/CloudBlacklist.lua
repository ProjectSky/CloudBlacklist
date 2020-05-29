--
-- Created by NotePad++
-- User: ProjectSky
-- Date: 2020/05/27
-- Time: 12:25
-- CloudBlacklist.lua
--

local CloudBlacklist = {}
local sdf = SimpleDateFormat.new("yyyy-MM-dd HH:mm:ss")
local TIME = sdf:format(Calendar.getInstance():getTime())

-- 此函数将在玩家进入游戏时触发
-- @param tick 游戏刻
CloudBlacklist.OnTick = function(tick)
  if tick <= 0 then
    sendClientCommand(getPlayer(), "CheckPlayer", "OnJoinGame", { name = getOnlineUsername(), steamid = getCurrentUserSteamID() })
  end
end

-- 此函数接收服务端OnServerCommand请求
-- @param module 模块
-- @param command 命令
-- @param args 额外数据
CloudBlacklist.OnServerCommand = function(module, command, args)
  local player = getPlayer()
  if module ~= "CloudBlacklistServer" then return end
  if command == "Disconnect" then
    if args.reason ~= "" then
      BanReason = args.reason
    else
      BanReason = "Other"
    end
    CloudBlacklist_loadfail = false
    player:setBlockMovement(true)
    writeLog("CloudBlacklist", getText("Tooltip_CloudBlacklist_trigger", getOnlineUsername(), getCurrentUserSteamID(), TIME))
    Events.OnTick.Add(CloudBlacklist.ForceExit)
    Events.EveryTenMinutes.Add(CloudBlacklist.EveryTenMinutes)
  elseif command == "LoadFail" then
    CloudBlacklist_loadfail = true
    player:setBlockMovement(true)
    writeLog("CloudBlacklist", getText("Tooltip_CloudBlacklist_loadfail", getOnlineUsername(), getCurrentUserSteamID(), TIME))
    Events.OnTick.Add(CloudBlacklist.ForceExit)
    Events.EveryTenMinutes.Add(CloudBlacklist.EveryTenMinutes)
  end
end

-- 此函数执行定时操作，每游戏十五分钟执行一次
-- @info 客户端通过tick检查并不可靠，这里再添加一层检查
CloudBlacklist.EveryTenMinutes = function()
  disconnect()
end

-- 此函数执行断开操作
-- @param tick 游戏刻
CloudBlacklist.ForceExit = function(tick)
  if tick == 300 then
    disconnect()
  end
end

-- 此函数在游戏中显示一个富文本窗口
-- @param text 字符串
CloudBlacklist.showMSG = function(text)
  local msg = ISModalRichText:new(getCore():getScreenWidth() / 2 - 300, getCore():getScreenHeight() / 2 - 300, 600, 600, text, false)
  msg:initialise()
  msg.chatText:paginate()
  msg.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
  msg:setHeightToContents()
  msg:ignoreHeightChange()
  msg:setVisible(true)
  msg:addToUIManager()
end

-- 此函数调用ISServerDisconnectUI.createChildren方法
local reader = ISServerDisconnectUI.createChildren
function ISServerDisconnectUI:createChildren()
  reader(self)
  if not CloudBlacklist_loadfail then
    CloudBlacklist.showMSG(getText("UI_CloudBlacklist_BAN_MSG", getText("Tooltip_CloudBlacklist_Reason_" .. BanReason)))
  else
    CloudBlacklist.showMSG(getText("UI_CloudBlacklist_DATAFAIL_MSG"))
  end
end

Events.OnTick.Add(CloudBlacklist.OnTick)
Events.OnServerCommand.Add(CloudBlacklist.OnServerCommand)