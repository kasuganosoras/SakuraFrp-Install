#!/bin/sh
checkos() {
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        OS=CentOS
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        OS=Debian
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        OS=Ubuntu
    else
        echo -e "${COLOR_RED}不支持的操作系统！${COLOR_END}"
        exit 1
    fi
}
color() {
    COLOR_RED='\E[1;31m'
    COLOR_GREEN='\E[1;32m'
    COLOR_YELOW='\E[1;33m'
    COLOR_BLUE='\E[1;34m'
    COLOR_PINK='\E[1;35m'
    COLOR_PINKBACK_WHITEFONT='\033[45;37m'
    COLOR_GREEN_LIGHTNING='\033[32m \033[05m'
    COLOR_END='\E[0m'
}
main() {
	color
	checkos
	echo -e "+--------------------------------------+"
	echo -e "|   Sakura Frp Server Install Script   |"
	echo -e "+--------------------------------------+"
	echo -e "|        https://www.natfrp.org/       |"
	echo -e "+--------------------------------------+"
	echo -e ""
	read -p "请输入服务器节点名称 > " server_name
	echo -e "Server name: ${COLOR_GREEN}${server_name}${COLOR_END}"
	read -p "请输入运行端口 (推荐 2333) > " bind_port
	echo -e "Bind port: ${COLOR_GREEN}${bind_port}${COLOR_END}"
	read -p "请输入 http 服务端口 (推荐 80) > " http_port
	echo -e "Http port: ${COLOR_GREEN}${http_port}${COLOR_END}"
	read -p "请输入 https 服务端口 (推荐 443) > " https_port
	echo -e "Https port: ${COLOR_GREEN}${https_port}${COLOR_END}"
	read -p "请输入管理用户名 (推荐 admin) > " admin_user
	echo -e "Admin username: ${COLOR_GREEN}${admin_user}${COLOR_END}"
	read -p "请输入管理密码 (推荐自己设置) > " admin_pass
	echo -e "Admin password: ${COLOR_GREEN}${admin_pass}${COLOR_END}"
	read -p "请输入 Token 特权密码 (自己设置) > " token
	echo -e "Token set to: ${COLOR_GREEN}${token}${COLOR_END}"
	echo -e ""
	echo -e "${COLOR_BLUE}正在下载配置文件...${COLOR_END}"
	[ ! -d /usr/local/frps/ ] && mkdir -p /usr/local/frps/
	cd /usr/local/frps/
	wget --no-check-certificate "https://frp.tcotp.cn:4443/api/build.php?action=install&port=${bind_port}&user=${admin_user}&pass=${admin_pass}&http=${http_port}&https=${https_port}&token=${token}" -qO frps.ini
	echo -e "${COLOR_GREEN}配置文件下载完成！${COLOR_END}"
	echo -e ""
	echo -e "${COLOR_BLUE}正在下载服务端主体...${COLOR_END}"
	wget --no-check-certificate "https://frp.tcotp.cn:4443/api/build.php?name=${server_name}" -qO frps
	echo -e "${COLOR_GREEN}服务端主体下载完成！${COLOR_END}"
	echo -e ""
	echo -e "${COLOR_BLUE}正在下载管理脚本...${COLOR_END}"
	wget --no-check-certificate "https://frp.tcotp.cn:4443/api/build.php?action=init" -qO /etc/init.d/frps
	echo -e "${COLOR_GREEN}管理脚本下载完成！${COLOR_END}"
	echo -e ""
	echo -e "${COLOR_BLUE}正在设置可执行权限...${COLOR_END}"
	chmod +x frps
	chmod +x /etc/init.d/frps
	if [ "${OS}" = "CentOS" ]; then
		chkconfig --add frps
	else
		update-rc.d -f frps defaults
	fi
	echo -e "${COLOR_GREEN}可执行权限设置完成！${COLOR_END}"
	echo -e ""
	echo -e "${COLOR_BLUE}正在启动服务端...${COLOR_END}"
	/etc/init.d/frps start
	echo -e "${COLOR_GREEN}服务端启动完成！${COLOR_END}"
	echo -e ""
	echo -e "${COLOR_PINK}Sakura Frp${COLOR_END} 服务端安装完成！"
	echo -e "现在您可以通过以下命令管理服务端："
	echo -e ""
	echo -e "    启动：${COLOR_GREEN}/etc/init.d/frps start${COLOR_END}"
	echo -e "    停止：${COLOR_RED}/etc/init.d/frps stop${COLOR_END}"
	echo -e "    重启：${COLOR_YELOW}/etc/init.d/frps restart${COLOR_END}"
	echo -e ""
	echo -e "Sakura Frp: https://www.natfrp.org/"
	echo -e ""
}
main
