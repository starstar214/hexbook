## 目录

1. [shell概述](#1shell概述)
2. [脚本执行方式](#2脚本执行方式)
3. [bash的基本功能](#3bash的基本功能)
4. [bash变量](#4bash变量)
5. [数值运算](5数值运算)
6. [环境配置文件](6环境配置文件)
7. [正则表达式](#7正则表达式)

---

#### 1.shell概述

什么是 Shell？

- ***Shell*** 是一个命令行解释器，它为用户提供了一个向 *Linux* 内核发送请求以便运行程序的界面系统级程序，用户可以用 *Shell* 来启动、挂起、停止甚至是编写一些程序。

- ***Shell*** 还是一个功能相当强大的编程语言，易编写，易调试，灵活性较强。*Shell* 是解释执行的脚本语言，在 *Shell* 中可以直接调用 *Linux* 系统命令。

通俗的讲，*Shell* 就是 *Linux* 系统的命令行界面。

 

***Shell*** 的分类：

- ***Bourne Shell***：从 1979 起 Unix 就开始使用 Bourne Shell，Bourne Shell 的主文件名为 ***sh***。
- ***C Shell***： C Shell 主要在 BSD 版的 Unix 系统中使用，其语法和 C 语言相类似而得名。

Shell 的两种主要语法类型有 Bourne 和 C，这两种语法彼此不兼容。Bourne家族主要包括 ***sh、ksh、bash、psh、zsh***；C 家族主要包括：***csh、tcsh***



==***bash***： bash与 sh 兼容，现在使用的 Linux 就是使用 bash 作为用户的基本 Shell。==



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



---

#### 2.脚本执行方式

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



---

#### 3.Bash的基本功能

**历史命令功能**：Linux 会将我们输过的命令保存缓存中，我们可以通过命令查看，在用户正常退出时，再将缓存中的命令信息刷新到当前用户的家目录下的 ***.bash_history*** 文件中。

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



**命令别名**：

- Linux 支持为命令起一个别名，通过调用别名去调用原始命令。

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



**常用快捷键**：

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



**输入输出重定向**：

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



**命令特殊符号**：

命令分隔符：

- ***;***：命令1;命令2，多个命令顺序执行。
- ***&&***：命令1&&命令2，当命令1正确执行，则命令2才会执行。
- ***||***：命令1||命令2，当命令1 执行不正确，则命令2才会执行。

管道符：***|***，命令1|命令2，将命令1的正确输出作为命令2的操作对象

```shell
[root@localhost note]# ll -a /etc |more      将 etc 下的文件以 more 命令的形式显示
[root@localhost note]# ps -ef|grep java      
```

> ***grep*** 搜索命令：grep [选项] 搜索内容 文件名
>
> - -i：忽略大小写
> - -n：输出行号
> - -v：反向查找
> - --color=auto：高亮关键字

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
- ***""***：双引号，在双引号中的所有特殊符号都没有特殊含义（$，\ 和 `[^反引号] 除外）。
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



---

#### 4.bash变量

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



**用户自定义变量**：

变量定义：变量名=变量值

变量调用：使用 $变量名 或 ${变量名} 进行调用

变量查看：set - 查看系统所有变量

~~~shell
[root@localhost note]# set | grep niko
name=niko
name1=nikoo
name2=nikok
~~~

变量删除：unset xxx - 删除系统变量 xxx

~~~shell
[root@localhost note]# unset name
~~~

**环境变量**：用户自定义变量只在当前的 Shell 中生效，而环境变量会在当前 Shell 和这个 Shell 的所有子 Shell 当中生效。如果把环境变量写入相应的配置文件，那么每当建立一个新的 Shell 时都会去读取配置文件，此环境变量就会在所有的 Shell 中生效。

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

**位置参数变量**：

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

**预定义变量**：

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



---

#### 5.数值运算

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
- ****,/,%***：乘，除，取模
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



---

#### 6.环境配置文件

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



---

#### 7.正则表达式

正则表达式和通配符：

- 正则表达式：用来在文件中匹配符合条件的字符串，grep、awk、sed 等命令可以支持正则表达式。
- 通配符（*，?，[]）：用来匹配符合条件的文件名，ls、find、cp 这些命令不支持正则表达式，所以只能使用 shell 自己的通配符来进行匹配。



示例文件：

~~~

~~~

基础正则表达式：

- \*：前一个字符匹配0次或任意多次。
- .：匹配除换行符外的任意一个字母。
