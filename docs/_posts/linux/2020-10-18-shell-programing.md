---
title: "Shell 编程"
subtitle: "「Linux」Shell Programming"
layout: post
author: "Hex"
header-img: "img/post-bg-coffee.jpg"
tags:
  - Linux
  - Shell 编程
---



Shell 脚本语言是实现 Linux/UNIX 系统管理及自动化运维所必备的重要工具， Linux/UNIX 系统的底层及基础应用软件的核心大都涉及 Shell 脚本的内容。

Shell 脚本是一种通过 Shell 语言编写的脚本程序，在脚本中可以编写一系列的系统指令。

通过执行编写好 Shell 脚本我们可以方便，快速，灵活的执行一些系统任务，提升我们的工作效率，减少不必要的重复工作。



## Shell 概述

什么是 Shell？

- ***Shell*** 是一个命令行解释器，它为用户提供了一个向 *Linux* 内核发送请求以便运行程序的界面系统级程序，用户可以用 *Shell* 来启动、挂起、停止甚至是编写一些程序。

- ***Shell*** 还是一个功能相当强大的编程语言，易编写，易调试，灵活性较强。*Shell* 是解释执行的脚本语言，在 *Shell* 中可以直接调用 *Linux* 系统命令。

通俗的讲，*Shell* 就是 *Linux* 系统的命令行界面。

 

***Shell*** 的分类：

- ***Bourne Shell***：从 1979 起 Unix 就开始使用 Bourne Shell，Bourne Shell 的主文件名为 ***sh***。
- ***C Shell***： C Shell 主要在 BSD 版的 Unix 系统中使用，其语法和 C 语言相类似而得名。

Shell 的两种主要语法类型有 Bourne 和 C，这两种语法彼此不兼容。Bourne家族主要包括 ***sh、ksh、bash、psh、zsh***；C 家族主要包括：***csh、tcsh***



***bash***： bash与 sh 兼容，现在使用的 Linux 就是使用 bash 作为用户的基本 Shell。



查看当前 Linux 系统支持的 Shell：

~~~shell
[root@localhost note]# cat /etc/shells
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash
~~~

切换 Shell：

~~~shell
[root@localhost note]# sh     切换到 sh Shell
sh-4.4# ls                    在 sh 下输入命令 ls
hello.sh
exit                          exit 退出当前 Shell
[root@localhost note]# 
~~~



## 脚本执行方式

输出命令：***echo*** [选项] [输出内容]

- 选项 ***-e*** ：使输出内容支持反斜线控制的字符转换

  一些常用的字符转换：

  - \\\ ：输出 \ 本身
  - \b ：输出退格键，向左删除一个字符
  - \e ：Esc 键
  - \n ：换行
  - \t ：制表符

- 输出内容：如果输出内容有空格需要使用 “” 或 ‘’ 将输出内容包含起来。

- 输出颜色：`echo -e "\e[1;31m abcd \e[0m"`

  ***\e[1;*** ：表示颜色输出开始

  ***\e[0m*** ：表示颜色输出结束

  30m=黑色，31m=红色，32m=绿色，33m=黄色，34m=蓝色，35m=洋红，36m=青色，37m=白色



脚本格式：建议将脚本文件以 sh 作为后缀名，方便区分

```shell
#!/bin/bash
#The first program
# Author: Niko
echo -e "Hello World"
```

***#!/bin/bash***：第一行的此部分标志下面的内容为 Shell 脚本，不写此语句一般不会对脚本执行造成影响，但是可能会引发某些更为复杂的报错。

在 Shell 脚本的其他位置， # 后面的内容均为注释。



执行方式：

- 赋予脚本执行权限，以相对路径或绝对路径的方式调用脚本文件。

  ~~~shell
  [root@localhost note]# chmod 700 hello.sh 
  [root@localhost note]# ./hello.sh 
  ~~~

- 使用 bash 调用执行脚本：

  ~~~shell
  [root@localhost note]# bash hello.sh 
  ~~~

  

当脚本在 Windows 系统和 Linux 系统中交换执行时，需要转变脚本中的某些特殊字符：

- dos2unix：将脚本从 Windows 系统格式转为 Unix 系统格式
- unix2dos：将脚本从 Unix 系统格式转为 Windows 系统格式



## Bash 基本功能

#### 历史命令功能

Linux 会将我们输过的命令保存缓存中，我们可以通过命令查看，在用户正常退出时，再将缓存中的命令信息刷新到当前用户的家目录下的 ***.bash_history*** 文件中。

history [选项]

选项：

- ***-c*** ：`history -c`，清空缓存及文件中的历史命令。
- ***-w***：`history -w`，将缓存中的历史命令记录强制刷新到文件中。
- 数字 n：`history 3`，列出最近 3 条历史记录，不加数字时为列出全部历史命令

历史命令默认保存 ***1000*** 条，可以在 ***/etc/profile*** 文件中进行修改（***HISTSIZE=1000***）。

历史命令的调用：

- 使用上、下箭头调用以前的历史命令

- 使用 “!n” 重复执行第 n 条历史命令，使用 history 可以查看每条命令对于的数字

- 使用 “!!” 重复执行上一条命令

- 使用 “!xxx” 重复执行最后一条以 xxx 开头的命令



#### 命令别名

Linux 支持为命令起一个别名，通过调用别名去调用原始命令。

- ***alias***：查看别名。

- alias 别名='原命令'：为命令起一个别名，只会临时生效，重新登陆后失效。

  ~~~shell
  alias mv='mv -i'
  ~~~

  如果想让别名永久生效，需要将别名写入用户目录下的 ***.bashrc*** 文件中。

- ***unalias xxx***：删除别名 xxx

命令的执行顺序：

1.  执行用绝对路径或相对路径执行的命令。
2.  执行别名。
3.  执行 ***bash*** 的内部命令（由 Shell 本身自带的，没有执行文件的命令，如：cd）。
4.  第四顺位执行按照 ***$PATH*** 环境变量定义的目录查找顺序找到的第一个命令

> 注意：在起别名时，不要覆盖已经存在的命令。
>
> 如果原命令已经被覆盖，可以在命令前加转义符来执行原命令。



#### Bash 常用快捷键

- bash 常用快捷键：
  - ***ctrl+A***：把光标移动到命令行开头。如果我们输入的命令过长，想要把光标移动到命令行开头时使用。
  - ***ctrl+E***：把光标移动到命令行结尾。
  - ***ctrl+C***：强制终止当前的命令。
  - ***ctrl+L***：清屏，相当于clear命令。
  - ***ctrl+U***：删除或剪切光标之前的命令。我输入了一行很长的命令，不用使用退格键一个一个字符的删除，使用这个快捷键会更加方便
  - ***ctrl+K***：删除或剪切光标之后的内容。
  - ***ctrl+Y***：粘贴 ctrl+U 或 ctrl+K 剪切的内容。
  - ***ctrl+R***：在历史命令中搜索，按下 ctrl+R 之后，就会出现搜索界面，只要输入搜索内容，就会从历史命令中搜索。
  - ***ctrl+D***：退出当前终端。
  - ***ctrl+Z***：将命令暂停，并放入后台。
  - ***ctrl+S***：暂停屏幕输出。
  - ***ctrl+Q***：恢复屏幕输出。



#### 输入输出重定向

标准输入输出：

| 设备   | 设备文件名  | 文件描述符 | 类 型        |
| ------ | ----------- | ---------- | ------------ |
| 键盘   | /dev/stdin  | 0          | 标准输入     |
| 显示器 | /dev/sdtout | 1          | 标准输出     |
| 显示器 | /dev/sdterr | 2          | 标准错误输出 |

标准输出重定向：

- 命令 > 文件：将命令的正确输出以覆盖的方式输出到文件中
- 命令 >> 文件：将命令的正确输出以追加的方式输出到文件中

标准错误输出重定向：

- 错误命令 2> 文件：将命令的错误输出以覆盖的方式输出到文件中
- 错误命令 2>> 文件：将命令的错误输出以追加的方式输出到文件中

~~~shell
[root@localhost ~]# ls > out.txt       将 ls 的结果保存在 out.txt 中
[root@localhost ~]# lst 2>> out.txt    将 lst 的错误结果保存在 out.txt 中
[root@localhost ~]# vim out.txt 
~~~

> 上面两种方式都必须事先知道命令的输出结果是正确还是错误，一般来说用处不大，我们一般将两种输出都同时保存。

正确输出和错误输出同时保存：

- 命令 > 文件 2>&1：以覆盖的方式，把正确输出和错误输出都保存到同一个文件当中。
- 命令 >> 文件 2>&1：以追加的方式，把正确输出和错误输出都保存到同一个文件当中。
- 命令 &>文件：以覆盖的方式，把正确输出和错误输出都保存到同一个文件当中。
- 命令 &>>文件：以追加的方式，把正确输出和错误输出都保存到同一个文件当中。
- 命令>>文件1 2>>文件2：把正确的输出追加到文件1中，把错误的输出追加到文件2中。

> 命令 > /dev/null：将命令的输出结果抛弃。

输入重定向：输入重定向的用处不大。



#### 命令特殊符号

命令分隔符：

- ***;***：命令1;命令2，多个命令顺序执行。
- ***&&***：命令1&&命令2，当命令1正确执行，则命令2才会执行。
- ***||***：命令1||命令2，当命令1 执行不正确，则命令2才会执行。

管道符：***|***，命令1|命令2，将命令1的正确输出作为命令2的操作对象

```shell
[root@localhost note]# ll -a /etc |more      将 etc 下的文件以 more 命令的形式显示
[root@localhost note]# ps -ef|grep java      
```

通配符：匹配文件名时使用

- ?：匹配一个字符
- *：匹配 0 个或多个字符
- []：匹配括号中的一个字符，如：[abc]，[a-z]，[\^abc]（非 abc）

~~~shell
[root@localhost ~]# ls
anaconda-ks.cfg  note  out.txt  test.txt
[root@localhost ~]# ls *txt
out.txt  test.txt
[root@localhost ~]# ls *tx
ls: 无法访问'*tx': 没有那个文件或目录
[root@localhost ~]# ls *tx*
out.txt  test.txt
[root@localhost ~]# ls ou?.txt
out.txt
[root@localhost ~]# ls out.[a-z]xt
out.txt
[root@localhost ~]# ls out.[^a-z]xt
ls: 无法访问'out.[^a-z]xt': 没有那个文件或目录
~~~

其他特殊符号：

- ***''***：单引号，在单引号中的所有特殊符号都没有特殊含义。
- ***""***：双引号，在双引号中的所有特殊符号都没有特殊含义（$，\ 和 ``[反引号] 除外）。
- ***``***：反引号，反引号括起来的内容为系统命令（***Esc*** 键下的那个键）。
- ***$()***：用来引用系统命令，获取命令执行结果。
- ***#***：在 shell 脚本中，# 开头的行代表注释。
- ***$***：用来调用变量的值。
- ***\\***：转义符，\ 后面的特殊符号会失去其特殊意义变为普通字符。

~~~shell
[root@localhost ~]# name=niko             给 name 变量赋值 niko
[root@localhost ~]# echo $name            调用变量的值
niko
[root@localhost ~]# echo '$name'
$name
[root@localhost ~]# echo "$name"
niko
[root@localhost ~]# echo date
date
[root@localhost ~]# echo `date`           反引号调用命令
2020年 08月 04日 星期二 23:24:39 CST
[root@localhost ~]# echo $(date)          $() 调用命令
2020年 08月 04日 星期二 23:25:04 CST
[root@localhost ~]# echo "$(date)"
2020年 08月 04日 星期二 23:27:19 CST
[root@localhost ~]# echo '$(date)'
$(date)
~~~



## Bash 变量

什么是变量？

变量是计算机内存的单元，其中存放的值可以改变。当Shell脚本需要保存一些信息时，如一个文件名或是一个数字，就把它存放在一个变量中。每个变量有一个名字，所以很容易引用它。使用变量可以保存有用信息，使系统获知用户相关设置，变量也可以用于保存暂时信息。

变量设置规则：

- 变量名称可以由字母、数字和下划线组成，但是不能以数字开头。

- 在Bash中，变量的默认类型都是字符串型，如果要进行数值运算，则必须使用特殊的数值运算方法（详情见 "5.数值运算" 章节）。

- 变量用等号连接值，等号左右两侧不能有空格。

- 变量的值如果有空格，需要使用单引号 '' 或双引号 "" 包括。

- 在变量的值中，可以使用 “\” 转义符。

- 如果需要增加变量的值，那么可以进行变量值的叠加。不过变量需要用双引号包含 “$变量名” 或用 ${变量名} 包含。

  ~~~shell
  [root@localhost note]# name=niko
  [root@localhost note]# name1="$name"o
  [root@localhost note]# echo $name1
  nikoo
  [root@localhost note]# name2=${name}k
  [root@localhost note]# echo $name2
  nikok
  ~~~

- 如果是把命令的结果作为变量值赋予变量，则需要使用反引号 `` 或 $() 包含命令。

  ~~~shell
  [root@localhost note]# name=`date`
  [root@localhost note]# echo $name
  2020年 08月 05日 星期三 00:25:01 CST
  [root@localhost note]# name=$(date)
  [root@localhost note]# echo $name
  2020年 08月 05日 星期三 00:25:19 CST
  ~~~

- 环境变量名建议大写，便于区分。

变量分类：

- 用户自定义变量：用户自己定义的变量。

- 环境变量：主要保存的是和系统操作环境相关的数据，可以新增变量和修改变量值。

- 位置参数变量：主要是用来向脚本当中传递参数或数据的，变量名不能自定义，变量作用是固定的，只可以修改变量值。

- 预定义变量：Bash中已经定义好的变量，变量名不能自定义，变量作用也是固定的，只可以修改变量值。

  > 位置参数变量是预定义变量的一种！



用户自定义变量：

变量定义：变量名=变量值

变量调用：使用 $变量名 或 ${变量名} 进行调用

变量查看：set - 查看系统所有变量

~~~shell
[root@localhost note]# set | grep niko
name=niko
name1=nikoo
name2=nikok
~~~

变量定义（不赋值）：set xxx

变量删除：unset xxx - 删除系统变量 xxx

~~~shell
[root@localhost note]# unset name
~~~



环境变量：

用户自定义变量只在当前的 Shell 中生效，而环境变量会在当前 Shell 和这个 Shell 的所有子 Shell 当中生效。如果把环境变量写入相应的配置文件，那么每当建立一个新的 Shell 时都会去读取配置文件，此环境变量就会在所有的 Shell 中生效。

父子 Shell：在一个 Shell 中可以打开新的 Shell，当前 Shell 与新建立的 Shell 即为父子关系。

~~~shell
[root@localhost ~]# pstree    展示进程树
systemd─┬─NetworkManager───2*[{NetworkManager}]
        ├─VGAuthService
        ......
        ├─smartd
        ├─sshd───sshd───sshd───bash───pstree        # 通过远程工具 ssh 建立的 bash 上的 pstree 命令
        ├─sssd─┬─sssd_be
        │      └─sssd_nss
        ......
        └─vmtoolsd───{vmtoolsd}
[root@localhost ~]# sh         建立一个 sh 子 shell
sh-4.4# pstree
systemd─┬─NetworkManager───2*[{NetworkManager}]
        ├─VGAuthService
        ......
        ├─smartd
        ├─sshd───sshd───sshd───bash───bash───sh───pstree  # 通过远程工具 ssh 建立的 bash 的子 shell sh 的 pstree 命令
        ├─sssd─┬─sssd_be
        │      └─sssd_nss
        ......
        └─vmtoolsd───{vmtoolsd}
sh-4.4# exit      退出当前 shell (回到父 shell)
exit
[root@localhost ~]#
~~~

变量定义：export 变量名=变量值，也可以先定义再执行 export

变量调用：使用 $变量名 或 ${变量名} 进行调用

变量查看：env ，查看所有环境变量（也可以使用 set 命令）

变量删除：unset xxx - 删除环境变量 xxx

~~~shell
[root@localhost ~]# export age=18
[root@localhost ~]# sex=male
[root@localhost ~]# email=tiny.star@qq.com
[root@localhost ~]# export email             先定义变量再执行 export
[root@localhost ~]# sh
sh-4.4# echo $age
18
sh-4.4# echo $sex

sh-4.4# echo $email
tiny.star@qq.com
sh-4.4# exit
exit
[root@localhost ~]# 
~~~

系统常见环境变量：

- ***PATH***：系统用来查找命令位置的路径。

  ~~~shell
  [root@localhost note]# ls
  els.sh  hello.sh
  [root@localhost note]# pwd
  /root/note
  [root@localhost note]# PATH="$PATH":$(pwd)     向 PATH 环境变量中加入当前路径
  [root@localhost note]# echo $PATH
  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/root/note
  [root@localhost note]# cd ../
  [root@localhost ~]# ls
  anaconda-ks.cfg  note  out.txt  test.txt
  [root@localhost ~]# hello.sh     在任意目录下都可以执行此命令
  Hello World!
  ~~~



位置参数变量：

- ***$n***：n为数字，$0代表命令本身，$1-$9代表第一到第九个参数，十以上的参数需要用大括号包含，如${10}。

  ~~~shell
  #!/bin/bash
  echo $0
  echo $1
  echo $2
  -------------------------------- # 以上为脚本内容
  [root@localhost note]# ./param.sh 11 22
  ./param.sh
  11
  22
  ~~~

- ***$\****：代表命令行中所有的参数，且把所有的参数看成一个整体。

- ***$@***：代表命令行中所有的参数，且把每个参数区分对待。

- ***$#***：代表命令行中所有参数的个数。

~~~shell
#!/bin/bash
echo '共输入参数'$#'个!'
echo '参数列表$*:'$*
echo '参数列表$@:'$@
#两者之间的区别
echo '-------循环"$*"--------'
for i in "$*"
do
        echo "参数:"$i
done
echo '-------循环$*--------'
for i in $*
do
        echo "参数:"$i
done
echo '-------循环$@--------'
for i in "$@"
do
        echo "参数:"$i
done
-------------------------------- # 以上为脚本内容
[root@localhost note]# ./print.sh niko jack lucky
共输入参数3个!
参数列表$*:niko jack lucky
参数列表$@:niko jack lucky
-------循环"$*"------
参数:niko jack lucky
-------循环$*--------
参数:niko
参数:jack
参数:lucky
-------循环$@--------
参数:niko
参数:jack
参数:lucky
~~~



预定义变量：

- ***$?***：最后一次执行的命令的返回状态，如果这个变量的值为 0，证明上一个命令正确执行；如果这个变量的值为非 0 则证明上一个命令执行不正确（报错时返回的值由脚本编写者定义）。01

  ~~~shell
  [root@localhost note]# ls
  els.sh  hello.sh  param.sh  print.sh
  [root@localhost note]# echo $?
  0
  [root@localhost note]# dadaf
  -bash: dadaf: 未找到命令
  [root@localhost note]# echo $?
  127
  ~~~

- ***$$***：当前进程的进程号（PID）。

- ***$!***：后台运行的最后一个进程的进程号（PID）。

~~~shell
[root@localhost note]# find /root -name hello.sh &      # 后台根据名称查找文件
[1] 2228
[root@localhost note]# /root/note/hello.sh

[1]+  已完成               find /root -name hello.sh
[root@localhost note]# echo $!
2228
[root@localhost note]# echo $$
2179
~~~



> 接收键盘输入：从键盘接收用户输入信息。
>
> ***read*** [选项] [变量名]
>
> - -p：在等待用户输入时，输出提示信息
> - -t：指定此命令的等待时间
> - -n：只接收指定的字符数（接收到指定字符数后自动执行）
> - -s：隐藏输入的数据，适用于密码输入
>
> ~~~shell
> #!/bin/bash
> echo "-----加法计算器-----"
> read -p "请输入第一个数:" a
> read -p "请输入第二个数:" b
> echo "两数相加结果为:"$((a+b))
> -------------------------------- # 以上为脚本内容
> [root@localhost note]# ./add.sh 
> -----加法计算器-----
> 请输入第一个数:789
> 请输入第二个数:12348
> 两数相加结果为:13137
> ~~~



## 数值运算

声明变量类型：declare [+/-] [选项] 变量名

- ***-/+***： 给变量 设定/取消（与常规的加减相反）类型属性

- ***-i/+i***： 将变量 声明/取消声明 整数型（integer） 

- ***-x/+x***： 将变量 声明/取消声明 环境变量

- ***-p***： 显示指定变量的被声明的类型

~~~shell
[root@localhost note]# a=4
[root@localhost note]# b=3
[root@localhost note]# declare -i c=$a+$b
[root@localhost note]# echo $c
7
~~~



***expr*** / ***let*** 数值运算工具：

使用 expr 进行数值运算：

~~~shell
[root@localhost note]# a=12
[root@localhost note]# b=71
[root@localhost note]# c=$(expr $a + $b)
[root@localhost note]# echo $c
83
~~~

- ***$()***：获取表达式的执行结果。

注意：expr 表达式的运算符号两边必须有空格，否则不能正确进行计算。

使用 let 进行数值运算：

~~~shell
[root@localhost note]# a=15
[root@localhost note]# b=20
[root@localhost note]# let c=a-b
[root@localhost note]# echo $c
-5
~~~

注意：使用 let 时，变量前不需要添加 $ 符号。 



使用 ***$(())*** 或 ***$[]*** 运算式进行数值运算：

~~~shell
[root@localhost note]# a=84
[root@localhost note]# b=53
[root@localhost note]# c=$(($a+$b))
[root@localhost note]# d=$[$a-$b]
[root@localhost note]# echo $c
137
[root@localhost note]# echo $d
31
~~~



Linux 中支持的运算符（优先级从大到小排列）：

- ***+,-***：单目正负符号
- ***!,~***：逻辑非，按位取反或补码
- ***\*,/,%***：乘，除，取模
- ***+,-***：加号，减号
- ***<<,>>***：向左位移，向右位移
- ***<=,>=,<,>***：小于等于，大于等于，小于，大于
- ***==,!=***：等于，不等于
- ***&***：按位与
- ***^***：按位异或
- ***|***：按位或
- ***&&***：逻辑与
- ***||***：逻辑或
- ***=,+=,-=,*=,/=,%=,&=,^=,|=,<<=,>>=***：赋值，运算且赋值

表达式的优先级可以通过小括号进行调节。

~~~shell
[root@localhost note]# a=$((1+(2-3)*8))
[root@localhost note]# echo $a
-7
~~~



变量置换与内容替换：

| 置换方式     | 无变量y                        | 变量y为空                      | 变量y有值     |
| ------------ | ------------------------------ | ------------------------------ | ------------- |
| x=${y-新值}  | x=新值                         | x为空                          | x=$y          |
| x=${y:-新值} | x=新值                         | x=新值                         | x=$y          |
| x=${y+新值}  | x为空                          | x=新值                         | x=新值        |
| x=${y:+新值} | x为空                          | x为空                          | x=新值        |
| x=${y=新值}  | x=新值，y=新值                 | x为空，y值不变                 | x=$y，y值不变 |
| x=${y:=新值} | x=新值，y=新值                 | x=新值，y=新值                 | x=$y，y值不变 |
| x=${y?新值}  | 新值输出到标准错误输出（屏幕） | x为空                          | x=$y          |
| x=${y:?新值} | 新值输出到标准错误输出（屏幕） | 新值输出到标准错误输出（屏幕） | x=$y          |

~~~shell
[root@localhost note]# unset a
[root@localhost note]# b=${a-5}
[root@localhost note]# echo $b
5
[root@localhost note]# y=""
[root@localhost note]# x=${y-new}
[root@localhost note]# echo $x

[root@localhost note]# i=star
[root@localhost note]# j=${i-niko}
[root@localhost note]# echo $j
star
~~~



## 环境配置文件

环境变量配置文件：环境变量配置文件中主要是定义对系统的操作环境生效的系统默认环境变量，比如 ***PATH***、***HISTSIZE***、***PS1***、***HOSTNAME*** 等默认环境变量。

在 Linux 中，修改环境变量配置文件后一般需要重新登录后才生效，可以使用命令使配置文件立刻生效：

- source 配置文件
- . 配置文件（有空格）

系统中的环境变量配置文件：/etc/profile，/etc/profile.d/*.sh，\~/.bash_profile，~/.bashrc，/etc/bashrc

在 etc 目录下的环境变量配置文件对所有用户生效，~ 指用户的家目录。



系统各种环境变量配置文件的作用：

- ***/etc/profile***：将登录用户的相关信息加载到环境变量中，然后调用所有的 /etc/profile.d/*.sh 文件、\~/.bash_profile 文件。
- ***/etc/profile.d/\*.sh***：加载语言环境等。
- ***\~/.bash_profile***：调用 ~/.bashrc 文件，追加家目录下的 bin 目录到 PATH 变量中。
- ***~/.bashrc***：加载该用户的系统别名，读取 /etc/bashrc 文件。
- ***/etc/bashrc***：加载所有用户的系统别名。



其他配置文件：

- ***~/.bash_logout***：用户注销登录时执行此文件的内容。
- ***~/bash_history***：保存用户所有执行过的历史命令。
- ***/etc/motd***：登录后的欢迎信息。



## 正则表达式

正则表达式和通配符：

- 正则表达式：用来在文件中匹配符合条件的字符串，grep、awk、sed 等命令可以支持正则表达式。
- 通配符（*，?，[]）：用来匹配符合条件的「文件名」，ls、find、cp 这些命令不支持正则表达式，所以只能使用 shell 自己的通配符来进行匹配。（3 种符号的功能说明在第 3 节：[命令特殊符号](#命令特殊符号)）

基础正则表达式：

- \*：前一个字符匹配 0 次或任意多次；`a*` 表示 a 重复 0 次或多次。
- . ：匹配除换行符外的任意一个字母。
- \^：匹配行首；^hello 会匹配以 hello 开头的行。
- $：匹配行尾；hello& 会匹配以 hello 结尾的行。
- []：匹配中括号中指定的任意一个字符，只匹配一个字符；如 [aoeiu] 匹配任意一个元音字母，[0-9] 匹配任意一位数字， [a-z]匹配一个小写字母。
- [\^]：匹配除中括号的字符以外的任意一个字符；\[^0-9] 匹配任意一位非数字字符，\[^a-z] 表示任意一位非小写字母。
- \ ：转义符。用于取消讲特殊符号的含义取消。 
- \\{n\\}：表示其前面的字符恰好出现n次；[0-9]\\{4\\} 匹配4位数字，\[1]\[3-8][0-9]\\{9\\} 匹配手机号码。 
- \\{n,\\}：表示其前面的字符出现不小于 n 次；[0-9]\\{2,\\} 表示两位及以上的数字。 
- \\{n,m\\}：表示其前面的字符至少出现 n 次，最多出现 m 次； [a-z]\\{6,8\\} 匹配 6 到 8 位小写字母。

> 注意：正则表达式中使用大括号时需要使用转义符 \\ 。



## 字符截取命令

grep 命令：

命令格式：***grep*** [选项] 搜索内容 文件名，按照指定字符串提取文件中的相关行。

常用选项：

- -n：显示行号。
- -i：不区分关键词的大小写。
- -v：反向查找，`grep -v “xxx” test.txt` 显示文件中所有不包含 xxx 字符串的行。
- -w：严格匹配关键字（默认只要包含关键字即为匹配）。
- -d：查询对象是目录时，使用此选项，切其后应该跟一个 action（read/skip/recurse）
  - `grep -d read “oo” /root/*`：遍历 /root 目录下的所有文件和文件夹，并作出读取操作，然后提取文件中的包含 oo 的行，此时当读取到 /root 目录下的目录时，会抛出相应提示。
  - `grep -d skip “oo” /root/*`：遍历 /root 目录下的所有文件和文件夹，如果是文件夹进行跳过，如果是文件则进行读取操作，然后提取文件中包含 oo 的行。
  - `grep -d recurse “oo” /root/*`：遍历 /root 目录下的所有文件和文件夹，如果是文件则进行读取操作，提取文件中包含 oo 的行，如果是文件夹则进行递归处理。
- -r：与 `-d recurse` 的作用一致，递归查找目录下的所有文件，此时文件名应该为目录。
- --color=auto：高亮关键字

使用示例：

~~~shell
[root@localhost ~]# grep "ooo" test.txt 
                                   -- edit by Nikooooo
[root@localhost ~]# grep -n "ooo" test.txt 
10:                                   -- edit by Nikooooo
[root@localhost ~]# grep -w "ooo" test.txt 
[root@localhost ~]# grep -w "Nikooooo" test.txt 
                                   -- edit by Nikooooo
[root@localhost ~]# grep -i "nikooooo" test.txt 
                                   -- edit by Nikooooo
[root@localhost ~]# grep -d skip "ooo" ./*
./test.txt:                                   -- edit by Nikooooo
[root@localhost ~]# grep -r "ooo" ./
./test.txt:                                   -- edit by Nikooooo
~~~



cut 命令：

命令格式：***cut*** [选项] 文件名，按列提取文件中的内容，默认使用制表符进行分列。

常用选项：

- -f 列号：指定提取第几列，此时默认的分隔符为制表符。
- -d 分隔符：按照指定分隔符分格列。

使用示例：

~~~shell
[root@localhost ~]# cat student.txt 
ID	GENDER	NAME	SUBJECT:GRADE
1	Male	Niko	English:86
2	Female	Jacy	Math:92
3	Male	Ray	Language:78
4	Male	Niko	Math:88
[root@localhost ~]# cut -f 2,3 student.txt               提取文件第2,3列
GENDER	NAME
Male	Niko
Female	Jacy
Male	Ray
Male	Niko
[root@localhost ~]# cut -d ":" -f 2 student.txt          提取文件按:分割的第二列
GRADE
86
92
78
88
[root@localhost ~]# cat student.txt | grep "Female" | cut -f 3       按照规律提取文件中性别为Female的名字
Jacy
~~~

> cut 命令的局限性：不能很好的分割连续空格的文件内容。



printf 命令：

命令格式：***printf*** 格式 内容，按照格式输出内容。

常用格式：

- %s：输出字符串。

- %ns：输出字符串，n 为数字，表示输出的字符个数，不足的在前面补空格。
- %ni：输出整数，不足字符个数的在前面补空格，将 n 写为 0n 可以在前面补 0。
- %m.nf：输出浮点数。
- \n：输出换行符。
- \t：输出制表符。

使用示例：

~~~shell
[root@localhost ~]# printf %s a b c d e f                         将内容直接拼接输出
abcdef[root@localhost ~]# printf '%s%s%s\n' a b c d e f           将内容每3个拼接为一行输出
abc
def
[root@localhost ~]# printf '%s%2s%s\n' a b c d e f                将内容每3个拼接为一行输出，每第二个参数输出2个字符
a bc
d ef
[root@localhost ~]# printf '%4i' 123                              以整数形式输出 123，使用空格补齐
 123[root@localhost ~]# printf '%04i' 123                         以整数形式输出 123，使用 0 补齐
0123[root@localhost ~]# 
~~~



awk 命令：

命令格式：***awk*** ‘条件1{动作1}条件2{动作2}条件3{动作3}’ 文件名，根据规则条件提取文件中的列（列默认以制表符或空格分割）。

条件：一般使用关系表达式作为条件，如：x>10 等，也有一些

动作：

- 格式化输出：在动作中输出内容。

- 流程控制语句：在动作中可以写入流程执行语句进行输出。

使用示例：

~~~shell
[root@localhost ~]# cat student.txt 
ID	GENDER	NAME	SUBJECT:GRADE
1	Male	Niko	English:86
2	Female	Jacy	Math:92
3	Male	Ray	Language:78
4	Male	Niko	Math:88
[root@localhost ~]# awk '{printf $3"\t"$4"\n"}' student.txt   不带条件，直接格式化输出文件的第3,4列
NAME	SUBJECT:GRADE
Niko	English:86
Jacy	Math:92
Ray		Language:78
Niko	Math:88
[root@localhost ~]# df -h
文件系统             容量  已用  可用 已用% 挂载点
devtmpfs             3.8G     0  3.8G    0% /dev
tmpfs                3.9G     0  3.9G    0% /dev/shm
/dev/sda1            976M  139M  771M   16% /boot
[root@localhost ~]# df -h | awk '{print $1"\t"$5}'   识别空格进行分列输出 “df -h” 命令的第1,5列
文件系统	已用%
devtmpfs	0%
tmpfs	0%
/dev/sda1	16%
[root@localhost ~]# cat grade.txt 
Id	Name	Java	Python	Scala
1	James	76	80	68
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# awk '$3>$4{print $2}' grade.txt  输出 Java 成绩大于 Python 成绩的人的姓名
Lane
~~~

> Linux 中没有 print 命令，而在 awk 中可使用 print 命令（每一次输出都会自动加上换行符）

特殊条件关键字：

- BEGIN{动作}：在读取数据之前执行动作。

  > awk 内置变量 FS：分隔符，可以自己指定 FS 进行分割

  ~~~shell
  [root@localhost ~]# cat student.txt 
  ID	GENDER	NAME	SUBJECT:GRADE
  1	Male	Niko	English:86
  2	Female	Jacy	Math:92
  3	Male	Ray	Language:78
  4	Male	Niko	Math:88
  [root@localhost ~]# awk 'BEGIN{FS=":"}{print $2}' student.txt   在读取数据前，指定分隔符，然后再提取列
  GRADE
  86
  92
  78
  88
  ~~~

- END{动作}：在所有数据读取完成后执行动作。

  ~~~shell
  [root@localhost ~]# cat student.txt 
  ID	GENDER	NAME	SUBJECT:GRADE
  1	Male	Niko	English:86
  2	Female	Jacy	Math:92
  3	Male	Ray	Language:78
  4	Male	Niko	Math:88
  [root@localhost ~]# awk 'END{print "The End!"}{print $3}' student.txt 
  NAME
  Niko
  Jacy
  Ray
  Niko
  ~~~


> 应用实例：获取正在运行的Java程序的进行ID
> ~~~shell
> [root@localhost ~]# ps -ef |grep java
> root      58316      1  0 Sep14 ?        00:08:57 java -jar ymes-analysis-0.0.1-SNAPSHOT.jar
> root      92422  92306  0 15:27 pts/0    00:00:00 grep --color=auto java
> [root@localhost ~]# ps -ef | grep java | grep -v grep | awk '{print $2}'
> 58316
> ~~~
> 此命令可直接获取到应用程序进程号，然后可以根据进程号作相应操作。



sed 命令：

命令格式：***sed*** [选项] [动作] 文件名，主要用来将数据进行选取、替换、删除、新增等**行操作**，可以直接对命令结果进行操作，支持管道符操作。

选项：

- -n：一般sed命令会把所有数据都输出到屏幕 ，如果加入此选择，则只会把经过sed命令处理的行输出到屏幕。
- -e：允许对输入数据应用多个 sed 动作进行编辑，多个动作之间使用 ; 进行分割。
- -i：直接修改读取数据的文件，而不是输出到屏幕。

动作：

- a： 追加，在当前行后添加一行或多行。
- c： 行替换，用 c 后面的字符串替换原数据行。
- i： 插入，在当期行前插入一行或多行。
- d： 删除，删除指定的行。
- p： 打印，输出指定的行。
- s： 字串替换，用一个字符串替换另外一个字符串。格式为 “行范围s/旧字串/新字串/g ”（和vim中的替换格式类似）。

> 在 Linux 中输入命令时，如果命令太长，可以输入 \ 然后回车，此时系统不会执行命令而是另起一行等待输出，此处可以使用 \ 符号一次 追加/替换/插入 多行。

使用示例：

~~~shell
[root@localhost ~]# cat grade.txt 
Id	Name	Java	Python	Scala
1	James	76	80	68
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed '2p' grade.txt    打印第2行
Id	Name	Java	Python	Scala
1	James	76	80	68                    #未加 -n 选项，整个文件也会输出，第2行打印2次。
1	James	76	80	68
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed -n '2p' grade.txt  #只打印第2行
1	James	76	80	68
[root@localhost ~]# df -h | sed -n '2p'    打印 df -h 命令的第2行
devtmpfs             3.8G     0  3.8G    0% /dev
[root@localhost ~]# sed '2,4d' grade.txt   删除文件2-4行后输出，未加"-i"选项，原文件未更改。
Id	Name	Java	Python	Scala
[root@localhost ~]# sed '2a append' grade.txt  在第2行后追加行
Id	Name	Java	Python	Scala
1	James	76	80	68
append
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed '2a append\
test' grade.txt  在第2行后追加2行
Id	Name	Java	Python	Scala
1	James	76	80	68
append
test
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed '2i insert' grade.txt  插入行
Id	Name	Java	Python	Scala
insert
1	James	76	80	68
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed '2c 无效成绩' grade.txt  替换第2行的内容
Id	Name	Java	Python	Scala
无效成绩
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed '2s/80/0/g' grade.txt  将第2行的 89 改为 0
Id	Name	Java	Python	Scala
1	James	76	0	68
2	Jerry	82	89	97
3	Lane	80	67	62
[root@localhost ~]# sed 's/J//g;s/a/e/g' grade.txt  同时替换所有行的'J'字母和'a'字母
Id	Neme	eve	Python	Scele
1	emes	76	80	68
2	erry	82	89	97
3	Lene	80	67	62
~~~



## 字符处理命令

命令：***sort*** [选项] 文件名，对文件的行进行排序，支持管道符。

选项：

- -f：忽略大小写。
- -n：以数值型进行排序（默认以字符串型排序）。
- -r：反向排序。
- -t：指定分隔符（默认以制表符为分隔符）。
- -k m(,n)：排序第 m 个字段到第 n 个字段（ n 可以不填表示一直到行尾）。

使用示例：

~~~shell
[root@localhost ~]# cat student.txt 
ID	GENDER	NAME	SUBJECT:GRADE
1	Male	Niko	English:86
2	Female	Jacy	Math:92
3	Male	Ray	Language:78
4	Male	Niko	Math:88
[root@localhost ~]# sort student.txt  排序文件
1	Male	Niko	English:86
2	Female	Jacy	Math:92
3	Male	Ray	Language:78
4	Male	Niko	Math:88
ID	GENDER	NAME	SUBJECT:GRADE
[root@localhost ~]# sort -t ":" -k 2 student.txt   按照:分割后的第二个字段进行排序
3	Male	Ray	Language:78
1	Male	Niko	English:86
4	Male	Niko	Math:88
2	Female	Jacy	Math:92
ID	GENDER	NAME	SUBJECT:GRADE
~~~



命令：***wc*** [选项] 文件名，统计文件的内容，支持管道符。

选项：

- -l：统计行数。
- -w：只统计单词数。
- -m：只统计字符数。

使用示例：

~~~shell
[root@localhost ~]# wc student.txt 
  5  20 117 student.txt              #表示文件共有 5 行，20 个单词，117 个字符。
~~~



## 条件判断语句

按照文件类型进行判断：

- -b 文件：判断该文件是否存在，并且是否为块设备文件（是块设备文件为真） 
- -c 文件：判断该文件是否存在，并且是否为字符设备文件（是字符设备文件为真） 
- ***-d*** 文件：判断该文件是否存在，并且是否为目录文件（是目录为真） 
- ***-e*** 文件：判断该文件是否存在（存在为真） 
- ***-f*** 文件 判断该文件是否存在，并且是否为普通文件（是普通文件为真） 
- -L 文件：判断该文件是否存在，并且是否为符号链接文件（是符号链接文件为真） 
- -p 文件：判断该文件是否存在，并且是否为管道文件（是管道文件为真） 
- -s 文件：判断该文件是否存在，并且是否为非空（非空为真） 
- -S 文件：判断该文件是否存在，并且是否为套接字文件（是套接字文件为真） 

使用方法：使用 test 命令或 [] 进行条件判断

~~~shell
[root@localhost ~]# test -e student.txt 
[root@localhost ~]# echo $?                   由于命令没有输出，可以使用 $? 来查看上一条命令的执行结果
0
[root@localhost ~]# [ -e student.tx ]         中括号两边必须有空格
[root@localhost ~]# echo $?
1
[root@localhost ~]# [ -f student.txt ] && echo "yes" || echo "no"
yes
~~~



按照文件权限进行判断：

- ***-r*** 文件：判断该文件是否存在，并且是否该文件拥有读权限（有读权限为真） 
- ***-w*** 文件：判断该文件是否存在，并且是否该文件拥有写权限（有写权限为真）
- ***-x*** 文件：判断该文件是否存在，并且是否该文件拥有执行权限（有执行权限为真） 
- -u 文件：判断该文件是否存在，并且是否该文件拥有SUID权限（有SUID权限为真） 
- -g 文件：判断该文件是否存在，并且是否该文件拥有SGID权限（有SGID权限为真） 
- -k 文件：判断该文件是否存在，并且是否该文件拥有SBit权限（有SBit权限为真）

使用示例：

~~~shell
[root@localhost ~]# [ -w student.txt ] && echo "有写权限" || echo "无写权限"
有写权限
~~~



两个文件之间进行比较：

- 文件1 -nt 文件2：判断文件1的修改时间是否比文件2的新（如果新则为真）
- 文件1 -ot 文件2：判断文件1的修改时间是否比文件2的旧（如果旧则为真）。
- 文件1 -ef 文件2：判断 文件1 是否和 文件2 的 Inode（相当于文件ID） 号一致，可以理解为两个文件是否为同一个文件。这个判断用于判断硬链接是很好的方法（两个硬链接返回真）。

使用方法：

~~~shell
[root@localhost ~]# [ grade.txt -nt student.txt ] && echo "grade.txt新" || echo "grade.txt旧"
grade.txt新
~~~



两个整数进行比较：

- 整数1 -eq 整数2：判断整数1是否和整数2相等（相等为真）
- 整数1 -ne 整数2：判断整数1是否和整数2不相等（不相等位置）
- 整数1 -gt 整数2：判断整数1是否大于整数2（大于为真）
- 整数1 -lt 整数2：判断整数1是否小于整数2（小于位置）
- 整数1 -ge 整数2：判断整数1是否大于等于整数2（大于等于为真）
- 整数1 -le 整数2：判断整数1是否小于等于整数2（小于等于为真）

使用示例：

~~~shell
[root@localhost ~]# [ 10 -gt 5 ] && echo "10>5" || echo "10<5"
10>5
~~~



字符串的判断：

- -z 字符串：判断字符串是否为空（为空返回真）
-  -n 字符串：判断字符串是否为非空（非空返回真） 
- 字串1 == 字串2：判断字符串1是否和字符串2相等（相等返回真）
- 字串1 != 字串2判断字符串1是否和字符串2不相等（不相等返回真）

使用示例：

~~~shell
[root@localhost ~]# [ -z "$name" ] && echo "无值" || echo “有值”
“有值”
~~~



多重条件判断：

- 判断1 -a 判断2：逻辑与，判断1和判断2都成立，最终的结果才为真。
- 判断1 -o 判断2：逻辑或，判断1和判断2有一个成立，最终的结果就为真。
- ！判断：逻辑非，使原始的判断式取反。

使用示例：

~~~shell
[root@localhost ~]# [ -n "$name" -a $name==niko ] && echo "yes" || echo "no"
yes               # $name 有值且为 niko
~~~



## 流程控制

if 流程控制：

- 单分支 if 条件语句：

  第一种写法：

  ~~~shell
  if [ 条件判断语句 ];then
  	程序
  fi
  ~~~

  第二种写法：

  ~~~shell
  if [ 条件判断语句 ]
  	then
  		程序
  fi
  ~~~

  > 注意：[] 的首位空格不能省略。

- 双分支 id 条件语句：

  ~~~shell
  if [ 条件判断式 ]
  	then
  		条件成立时，执行的程序
  	else
  		条件不成立时，执行的另一个程序
  fi
  ~~~

- 多分支 if 语句：

  ~~~shell
  if [ 条件判断式1 ]
  	then
  		当条件判断式1成立时，执行程序1
  elif [ 条件判断式2 ]
  	then
  		当条件判断式2成立时，执行程序2
  ......
  	else
  		当所有条件都不成立时，最后执行此程序
  fi
  ~~~

使用示例：

~~~shell
#!/bin/bash
#判断Redis服务是否启动
#Author Star
pid=$(ps -ef | grep redis | grep -v grep | awk '{print $2}')
if [ -z "$pid" ]
	then
		echo “未启动Redis服务!”
	else
		echo "Redis服务已启动，进程ID:$pid"
fi
~~~



case 语句：

~~~shell
case $变量名 in
	“值1”)
		执行程序1
    	;;
    “值2”)
        执行程序2
        ;;
   	......
   	*)
   		执行程序xxx(所有条件均不满足时)
esac
~~~

使用示例：

~~~shell
#!/bin/bash
#目的地选择
echo “1\)上海  2\)北京  3\)成都  4\)深圳”
read -p "请选择你的目的地:" destination
case $destination in
        "1")
                echo "你选择了飞往上海的航班!"
                ;;
        "2")
                echo "你选择了飞往北京的航班!"
                ;;
        "3")
                echo "你选择了飞往成都的航班!"
                ;;
        "4")
                echo "你选择了飞往深圳的航班!"
                ;;
        *)
                echo "输入错误!"
esac
~~~



for 循环：

- 语法一：

  ~~~shell
  for 变量 in值1值2值3...
  do
  	程序
  done
  ~~~

  使用示例：

  ~~~shell
  #!/bin/bash
  #打印当前目录下每个文件大小
  files=$(ls)
  for file in $files
  do
          echo "文件名:$file，文件大小:$(du -h $file|awk '{print $1}')"
  done
  ~~~

- 语法二：

  ~~~shell
  for((初始值;循环控制条件;变量变化))
  do
  	程序
  done
  ~~~

  使用示例：

  ~~~shell
  #!/bin/bash
  #计算累加和
  read -p "请输入起始值:" start
  read -p "请输入结束值:" end
  sum=0
  for((i=$start;i<=$end;i++))
  do
          sum=$(($sum+$i))
  done
  echo "$start至$end的累加和为$sum"
  ~~~

  

while 循环：

~~~shell
while [ 条件判断式 ]
do
	程序
done
~~~



***until*** 循环语句：

~~~shell
while [ 条件判断式 ]
do
	程序
done
~~~

> 注意：与 while 相反，until 的条件判断式不成立时才会执行循环体当中的程序。



## 函数调用

shell 中函数定义方式：

~~~shell
function 函数名()     
{
	命令序列
	return xxx;
}
~~~

其中 function 关键字可以不写，return 语句可以不写。



> 在 shell 脚本中，函数必须先定义，后调用。



函数的基本用法：

- 函数不带参数调用：

  ~~~shell
  function f()
  {
          echo "This is a function"
  }
  f
  ~~~

- 函数带参调用：

  ~~~shell
  function f()
  {
          echo "Function input is $1 and $2"
  }
  f hello sorry
  ~~~

  > 除 $n 外，函数中还可以使用其他位置参数变量和预定义变量。

- 获取函数返回的整型值：

  ~~~shell
  function f()
  {
          echo "Function input is $1 and $2"
          return 7;
  }
  f a b
  echo "$?"
  ~~~

  > 函数的返回结果不能直接获取，只能放在 $? 中，所以 shell 的函数不能返回字符串。
  >
  > 如果返回字符串，运行时会抛出提示：`./function.sh: 第 6 行:xxxx: 需要数字参数`

- 获取函数的字符串：

  ~~~shell
  function f()
  {
          echo "success"
  }
  result=$(f)
  echo "$result"
  ~~~

  > 通过 $() 获取函数当中的输出，变相的获取到函数的输出。

  ~~~shell
  set result
  function f()
  {
          result="success"
  }
  f
  echo "$result"
  ~~~

  > 使用全局变量接收函数想要返回的值。

