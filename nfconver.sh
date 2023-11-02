purple(){
    echo -e "\033[30m $1 \033[0m" 
}
red(){
    echo -e "\033[31m $1 \033[0m"  
}
green(){
    echo -e "\033[32m $1 \033[0m"  
}
yellow(){
    echo -e "\033[33m $1 \033[0m" 
}
blue(){
    echo -e "\033[34m $1 \033[0m" 
}
#========================================================
function nftabless(){

if [ -f "/usr/local/bin/nat" ] && [ -f "/etc/nat.conf" ];then
	red "转发服务已安装！"
	
	red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	start_menu "first"
	
else
	bash <(curl -s -L https://raw.githubusercontent.com/qswlsky/HelloWorld/main/nftables.sh)
	
	red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	start_menu "first"
fi
}

function nftablereset(){
	bash <(curl -s -L https://raw.githubusercontent.com/qswlsky/HelloWorld/main/nftables.sh)
	
	red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	start_menu "first"
}

function checks(){
	systemctl status nat.service
	
	red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	start_menu "first"
}
function reboots(){
	systemctl restart nat.service 
	red "转发服务已重启！"
	
	red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	start_menu "first"
}
function views(){
	yellow "[ 转发模式，本机转发端口,远程接收端口,远程IP ]"  
	cat /etc/nat.conf
	
	red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	start_menu "first"
}
function edits(){
	nano /etc/nat.conf
}
#获取互联网时间，这里请求的是苏宁提供的API
result=$(curl -s http://quan.suning.com/getSysTime.do)
datetime=${result:13:19}
#echo $datetime

#添加端口
function menu(){
    clear
    yellow "================================= 中转，服务器流量中转 =============================== "
    green "转发格式为【本机转发端口,远程接收端口,远程IP】"   
    echo
    stty erase '^H'
    read -p "请输入转发信息:" menuNumberInput


if [ "$menuNumberInput" = "" ]; then
	menu
else
	valA=$(echo $menuNumberInput | awk -F',' '{print NF-1}')
	valB=$(echo $menuNumberInput | awk -F'.' '{print NF-1}')
	if (($valA==2)) && (($valB==3));then
		nums=(${menuNumberInput//,/ })
		#yellow " echo 'SINGLE,${nums[0]},${nums[1]},${nums[2]}' >> /etc/nat.conf"
		echo SINGLE,${nums[0]},${nums[1]},${nums[2]} >> /etc/nat.conf
		red "端口转发已添加！"
		
		red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
		start_menu "first"
	else
		menu
	fi
fi
}
#========================================================
#主菜单
function start_menu(){
    #apt update -y && apt install -y curl && apt install -y socat && apt install wget -y
    #clear
	echo
    yellow "================================= 中转，服务器流量中转 ================================ "
    green " 1.【Nftables一键安装脚本】		||	2.【检测Nftables服务状态】"   
    green " 3.【添加转发端口】			||	4.【编辑转发端口】"
    green " 5.【查看转发端口】			||	6.【重启Nftables服务】"
	green " 7.【Nftables重新安装】			"
		
    yellow "====================================================================================== "   
    yellow "     ****** 0. 退出脚本 北京时间: $datetime ******" #$(date) 
    yellow "====================================================================================== "
    echo
    stty erase '^H'
    read -p "请输入数字:" menuNumberInput


	if [[ $menuNumberInput != 0 ]]; then
		red "※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
	else
		clear
	fi 
	
    case "$menuNumberInput" in
 #==================================    
		1 )
            nftabless
	;;
		2 )
            checks
	;;
		3 )
            menu
	;;
		4 )
            edits
	;;
	        5 )
            views
	;;
		6 )
            reboots
	;;
		7 )
            nftablereset
	;;
 #==================================
        0 )
            exit 1
        ;;
        * )
            clear
            red "请输入正确数字 !"
            start_menu
        ;;
    esac
}
start_menu "first"
