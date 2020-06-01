#### ProjectZomboid Cloud BlackList Mod

* author: ProjectSky
* Date: May 27, 2020

#### 说明
* 此MOD主要的功能是使多个服务器共享黑名单，毕竟如果一个恶意玩家在一个服务器被封禁，这个玩家换个服务器还可以继续游戏
* 原理很简单，当客户端连接服务器时，客户端会将自己的steamid和用户名发送给服务器，服务器收到steamid后会拉取远程服务器的黑名单列表进行对比，如果steamid匹配则强制断开该玩家连接
* ~~由于PZ没有低权限封禁玩家/操作数据库的API，所以目前只能将黑名单中的玩家强制断开连接~~（已实现，移至扩展内容）
* 黑名单列表托管在[CloudBlackList-Config](https://github.com/ProjectSky/CloudBlackList-Config)
* 有任何添加新黑名单需求的发起pr即可，请务必带上合理的理由和证据

#### 更新说明
* 经过几次更新，可用性已经很强了
* 如果玩家无法处理来自服务器的检查，则强制断开连接，并显示提示信息
* 被封禁的玩家将会在断开连接后显示一个窗口，消息内容为一些额外的信息和封禁原因

#### 扩展内容
* 因API的限制，无法自动封禁玩家，为了解决这个问题，反编译添加了一个用来封禁玩家steamid的函数，使用该函数需要替换服务端的class文件
* 添加的代码
```
public static void banSteamID(String steamID, String reason) throws SQLException {
		if (GameServer.bServer) {
			ServerWorldDatabase.instance.banSteamID(steamID, reason, true);
		}
	}
```
* 该函数仅对服务端生效，客户端无法调用，没有安全风险
* 该扩展是可选功能，不替换也不会影响该MOD的使用（推荐使用，省去手动封禁）
* 下载地址 [java.zip](https://dl.imsky.cc:666/s/XLAyo6aZ2BsCerW) 下载替换至服务器根目录即可，客户端不需要该文件

#### 外部链接
* [WORKSHOP](https://steamcommunity.com/sharedfiles/filedetails/?id=2111507850)