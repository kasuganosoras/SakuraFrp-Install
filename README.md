# SakuraFrp-Install
Sakura Frp 定制版服务端安装程序

支持的操作系统：CentOS 6/7、Ubuntu 14/16/18、Debian 8/9
### 一键安装
```bash
wget --no-check-certificate "https://github.com/kasuganosoras/SakuraFrp-Install/raw/master/install-sakurafrp.sh"
chmod +x install-sakurafrp.sh
./install-sakurafrp.sh
```
安装过程只需要输入一些信息即可自动完成下载安装启动。

### 管理命令
启动 Sakura Frp 服务端
```bash
frps start
```
停止 Sakura Frp 服务端
```bash
frps stop
```
重启 Sakura Frp 服务端
```bash
frps restart
```
查询 Sakura Frp 服务端状态
```bash
frps status
```
管理脚本修改自：https://github.com/clangcn/onekey-install-shell/blob/master/frps/frps.init
