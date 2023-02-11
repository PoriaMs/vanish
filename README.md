# vanish

Linux 全局代理脚本

启动脚本以后，这台虚拟机上的外网的所有流量都会走代理，而不需要其他操作

<img width="415" alt="image-20230211192057582" src="https://user-images.githubusercontent.com/66954742/218258474-c44b9654-c04e-49ab-addc-c43e472d2e8c.png">

##### 准备

需要先去<https://latest.gost.run/>下载对应平台的 GOST 二进制文件

<img width="739" alt="image-20230211181516738" src="https://user-images.githubusercontent.com/66954742/218258487-14613a32-8411-4578-9afd-ee87c2e3a432.png">


##### 操作介绍

将 shell 脚本下载到本地以后，先用 `chmod +x vanish.sh`添加权限

<img width="303" alt="image-20230211182136599" src="https://user-images.githubusercontent.com/66954742/218258503-09c44efb-2531-4050-9936-7559eb5891a1.png">

mix 选项

<img width="390" alt="image-20230211182600235" src="https://user-images.githubusercontent.com/66954742/218258536-ba3b82af-f6e5-4fba-ba11-d49400d28f80.png">

tcp 选项

<img width="366" alt="image-20230211182738383" src="https://user-images.githubusercontent.com/66954742/218258545-719263a1-b9f2-4876-ac84-81103e4ed3c5.png">

udp 选项

<img width="353" alt="image-20230211182815116" src="https://user-images.githubusercontent.com/66954742/218258557-6cafc7b6-9bed-488f-ad07-f45422be2dc8.png">

inner 选项，需要先开启前面其中一个选项，开启这个以后可以将自身流量代理进入内网

<img width="522" alt="image-20230211191210894" src="https://user-images.githubusercontent.com/66954742/218258563-277e50ba-23f1-49d9-8d7c-9bdfc6317f3c.png">

off 选项，会关闭 gost 并且清除工具添加的 iptables 规则而不影响其他规则

<img width="344" alt="image-20230211191442248" src="https://user-images.githubusercontent.com/66954742/218258569-e183b62c-3f80-48df-bbaf-72d678d4b2d9.png">

clean 选项，会删除日志，日志默认位置在`log="/tmp/vanish.log"`，可以自行修改
