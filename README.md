#### ProjectZomboid Cloud BlackList Mod

* author: ProjectSky
* Date: May 27, 2020

#### 说明
* 此MOD主要的功能是使多个服务器共享黑名单，毕竟如果一个恶意玩家在一个服务器被封禁，这个玩家换个服务器还可以继续
* 原理很简单，当客户端连接服务器时，客户端会将自己的steamid和用户名发送给服务器，服务器收到steamid后会拉取远程服务器的黑名单列表进行对比，如果steamid匹配则强制断开该玩家连接。
* 由于PZ没有低权限封禁玩家/操作数据库的API，所以目前只能将黑名单中的玩家强制断开连接
* 黑名单文件托管在[CloudBlackList-Config](https://github.com/ProjectSky/CloudBlackList-Config)中，有任何更新需求的服主发起pr即可，请务必带上合理的理由和证据

#### 更新说明
* 经过几次更新，可用性已经很强了
* 如果玩家无法处理来自服务器的检查，则强制断开连接，并显示提示信息
* 被封禁的玩家将会在断开连接后显示一个窗口，消息内容为一些额外的信息和封禁原因

#### 外部链接
* [WORKSHOP](https://steamcommunity.com/sharedfiles/filedetails/?id=2111507850)