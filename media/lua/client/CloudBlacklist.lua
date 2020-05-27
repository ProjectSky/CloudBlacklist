--
-- Created by NotePad++
-- User: ProjectSky
-- Date: 2020/05/27
-- Time: 12:25
-- CloudBlacklist.lua
--

local CloudBlacklist = {}

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
    player:setBlockMovement(true)
    --player:getInventory():clear()
    --removeInventoryUI(getPlayer():getPlayerNum())
    disconnect()
  end
end

-- 此函数在游戏中显示一个富文本窗口
-- @param text 字符串
CloudBlacklist.showMSG = function(text)
  local msg = ISModalRichText:new(getCore():getScreenWidth() / 2 - 300,getCore():getScreenHeight() / 2 - 300,600,600, getText(text), false)
  msg:initialise()
  msg.chatText:paginate()
  msg.backgroundColor = {r=0, g=0, b=0, a=0.9}
  msg:setHeightToContents()
  msg:ignoreHeightChange()
  msg:setVisible(true)
  msg:addToUIManager()
end

-- 此函数调用ISServerDisconnectUI.createChildren方法
local reader = ISServerDisconnectUI.createChildren
function ISServerDisconnectUI:createChildren()
  reader(self)
  CloudBlacklist.showMSG("UI_CloudBlacklist_msg")
end

Events.OnTick.Add(CloudBlacklist.OnTick)
Events.OnServerCommand.Add(CloudBlacklist.OnServerCommand)