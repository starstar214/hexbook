Python 官网：https://www.python.org/



**目录**

1. [计算机基础知识](#1计算机基础知识)
2. [Python 简介](#2Python 简介)
3. [Python 基本语法](#3Python 基本语法)
4. [Python 数据类型](#4Python 数据类型)
5. [Python 运算符](#5Python 运算符)
6. [流程控制](#6流程控制)
7. [序列与列表](#7序列与列表)
8. [字典](#8字典)
9. [集合](#9集合)
10. [函数](#10函数)



---

### 1.计算机基础知识

什么是计算机？

计算机俗称电脑，是能够按照程序运行，自动、高速处理海量数据的现代化智能电子设备。既可以进行数值计算，又可以进行逻辑计算，还具有存储记忆功能。

计算机的组成？

计算机由 **硬件** 和 **软件** 两部分组成

- 硬件：键盘、鼠标、显示器、CPU、主板、内存、硬盘等......
- 软件：软件由系统软件（windows、macOS、Linux）和应用软件（office 、QQ、绝地求生）组成，用户通过软件与计算机进行交流。

计算机的使用：

我们通过软件来对计算机完成各种操作，但是软件中并不是所有的功能都会对用户开放，用户需要调用软件提供的接口（Interface 交互界面）来操作计算机。

用户交互界面分成两种：TUI（文本交互界面）和 GUI（图形化交互界面）。

文本交互界面有多个不同的名字：

​	命令行、命令行窗口、DOS窗口、命令提示符、CMD窗口、Shell、终端、Terminal

通过命令行可以使用一个一个的指令来操作计算机，任何的计算机的操作系统中都包含有TUI（文本交互界面）。



**Windows 命令行的基本使用**

如何进入命令行

​	win键 + R 出现运行窗口，输入 cmd，然后回车

命令行的结构

- 版本及版权声明：

  Microsoft Windows [版本 10.0.18363.1256]
  (c) 2019 Microsoft Corporation。保留所有权利。

- 命令提示符

  C:\Users\star>

  命令提示符标明了当前所处的目录位置，在命令提示符后输入命令点击回车键即可执行。

  输入 x: 点击回车可以切换盘符，如：`C:\Users\star>D:` 切换到 D 盘。

常用 DOS 命令

- dir：列出当前目录下的文件和目录。

- cd：进入到指定目录

  ​	`.` 指当前目录。

  ​	`..` 指上一级目录。

- md：创建目录。

- rd：删除目录。

- del：删除文件。

- cls：清空屏幕。

操作技巧

- 使用「上」方向键可以快速调出历史命令。
- 使用 Tab 键可以进行命令补全。



**环境变量（environment variable）**

环境变量是指在操作系统中用来指定操作系统运行环境的一些参数，如：临时文件夹位置和系统文件夹位置等，我们可以通过修改环境变量，来对计算机进行配置。

查看环境变量

​	右键 计算机（此电脑） --> 选择属性 --> 选择高级系统设置 --> 选择环境变量
​	环境变量界面分成了两个部分，上边是用户环境变量，下边是系统环境变量，用户环境变量只对当前用户生效，系统环境变量对所有使用此台电脑的用户都生效，一般来说，我们配置用户环境变量即可。

修改环境变量

​	在环境变量界面，我们可以通过 新建、编辑、删除 按钮来修改环境变量。

​	一个环境变量可以由多个值组成，值与值之间使用 ;（英文）隔开。

​	环境变量之间可以相互引用，使用 `%变量名%` 即可对变量值进行引用。

Path 环境变量

​	Path 环境变量中保存的是一个一个的路径。

​	当我们在命令行中输入一个命令（或访问一个文件时）：

​		系统会首先在当前目录下寻找，如果找到了则直接执行或打开；

​		如果没有找到，则会依次去path环境变量的路径中去寻找，直到找到为止；

​		如果 Path 环境变量中所有的路径都没有找到，则报错 'xxx' 不是内部或外部命令，也不是可运行的程序或批处理文件。

​	我们可以将一些经常需要访问到的文件或程序的路径添加到 Path 环境变量中，这样我们就可以在任意的位置访问这些文件或程序。

​	注意事项：

​	1.如果环境变量中没有 Path，可以手动添加。

​	2.Path 环境变量不区分大小写 PATH Path path。 

​	3.修改完环境变量必须重新启动命令行窗口才会生效。

​	4.多个路径之间使用 ;（英文） 隔开。



**进制**

十进制（最常用的进制）：满十进一

​	十进制共有十个数字：0 1 2 3 4 5 6 7 8 9

二进制（计算机底层使用的进制）：满二进一

​    二进制中一共有两个数字：0 1	

​	所有的数据在计算机底层都是以二进制的形式保存的，计算机只认二进制。

计算机内存

​	我们可以将计算机内存想象为一个一个的小格子，每一个小格子中可以存储一个 0 或者一个 1，每一个小格子我们称为 1bit（位），bit 是计算机中的最小的单位。

​	每 8 个 bit 组成一个 byte（字节），byte 是我们最小的可操作的内存单位。

常用内存单位换算

​	8 bit = 1 byte（字节）

​	1024 byte = 1 kb（千字节）

​	1024 kb = 1 mb（兆字节）

​	1024 mb = 1 gb（吉字节）

​	1024 gb = 1 tb（太字节）

​	......	

八进制（一般不用）：满八进一

​	八进制中一共有八个数字：0 1 2 3 4 5 6 7	

十六进制：满十六进一

​	十六进制中一共有十六个数字：0 1 2 3 4 5 6 7 8 9 a b c d e f 

​	十六进制中引入了 a b c d e f 来表示 10 11 12 13 14 15

​	我们在查看二进制数据时，一般会以十六进制的形式显示。



**文本和字符集**

文本

​	文本分成两种，一种叫做纯文本，还有一种叫做富文本。

​	纯文本：中只能保存单一的文本内容，无法保存内与容无关的东西（字体、颜色、图片......）。

​	富文本：富文本中可以保存文本以外的内容（word文档）。

​	在开发时，我们编写程序使用的全都是纯文本！

编解码和字符集

​	纯文本在计算机底层会转换为二进制进行保存，将字符转换为二进制码的过程，我们称为编码；将二进制码转换为字符的过程，我们称为解码；编码和解码时所采用的规则，我们称为字符集。

常见的字符集
    ASCII：美国人编码，使用 7 位来对美国常用的字符进行编码，包含 128 个字符。

​    ISO-8859-1：欧洲的编码，使用 8 位，包含256个字符。

​    GB2312、GBK：国标码，中国的编码。

​    GBK：国标码，中国的编码。

​    Unicode：万国码，包含世界上所有的语言和符号，编写程序时一般都会使用 Unicode 编码。

​		Unicode 编码有多种实现如：UTF-8 UTF-16 UTF-32 等，最常用的就是 `UTF-8`

乱码

​	编写程序时，如果发现程序代码出现乱码的情况，就要马上去检查字符集是否正确。



---

### 2.Python 简介

什么是计算机语言？

计算机语言（Computer Language）指用于人与计算机之间通讯的语言，我们需要通过计算机语言（编程语言）来控制计算机。

计算机语言的发展历程：

1. 机器语言：直接通过二进制编码来编写程序，执行效率好，编写起来太麻烦。

2. 符号语言（汇编）：使用符号来代替机器码，编写程序时，不需要使用二进制，而是直接编写符号，编写完成后，需要将符号转换为机器码，再由计算机进行执行。

   将符号转换为机器码的过程称为汇编。

   将机器码转换为符号的过程，称为反汇编。

   汇编语言一般只适用于某些硬件，兼容性比较差。

3. 高级语言：高级语言的语法基本和现在英语语法类似，与硬件的关系没有那么紧密了，我们通过高级语言开发程序可以在不同的硬件系统中执行，并且高级语言学习起来也更加的容易。

   现在我们所知道的语言基本都是高级语言：C、C++、C#、Java、JavaScript、Python......

编译型语言和解释型语言

计算机只能识别二进制编码（机器码），所以任何的语言在交由计算机执行时必须要先转换为机器码。

根据转换时机的不同，语言分成了两大类：编译型语言和解释型语言

- 编译型语言：会在代码执行前将代码编译为机器码，然后将机器码交由计算机执行。如：C、C++ ......

  ​	编译型语言的执行速度特别快，但是跨平台性比较差。

- 解释型语言：不会在执行前对代码进行编译，而是一边执行一边编译。如：Python、JavaScrip、Java ......

  ​	解释型语言的执行速度比较慢，但是跨平台性比较好。



> Tiobe：Tiobe 根据互联网上有经验的程序员、课程和第三方厂商的数量，并使用搜索引擎（如：Google、Bing、Yahoo）以及 Wikipedia、Amazon、YouTube 统计出排名数据，反映了各个编程语言的热门程度，排行榜每月更新一次。
>
> 查看地址：https://www.tiobe.com/tiobe-index/



**Python 简介**

Python 是一种广泛使用的高级编程语言，属于通用型编程语言，由 [吉多·范罗苏姆](https://baike.baidu.com/item/%E5%90%89%E5%A4%9A%C2%B7%E8%8C%83%E7%BD%97%E8%8B%8F%E5%A7%86/328361?fr=aladdin) 创造，第一版发布于 1991 年。可以视之为一种改良（加入了一些其他编程语言的优点，如面向对象）的 LISP。作为一种解释型语言，Python 的设计哲学强调代码的可读性和简洁的语法（尤其是使用空格缩进划分代码块，而非使用大括号或者关键词）。相比于 C++ 和 Java，Python 让开发者能够用更少的代码表达想法。 

Python 的用途

​	WEB应用、爬虫程序、科学计算、自动化运维、大数据（数据清洗）、云计算、桌面软件/游戏、人工智能......



**Python 环境搭建**

Python 开发环境搭建就是安装 Python 的解释器。

Python 的解释器有很多种：

- CPython（官方）：用 C 语言编写的 Python 解释器。
- PyPy：用 Python 语言编写的 Python 解释器。
- IronPython：用 .net 编写的 Python 解释器。
- Jython：用 Java 编写的 Python 解释器。

通过使用不同的 Python 解释器，Python 程序可以在不同的语言环境中进行执行（如：使用 Jython 解释器编译出字节码文件提供给 Jvm 进行执行）。

目前我们使用最广泛的是 CPython 解释器，如果要和 Java 或 .Net 平台进行交互，最好的办法不是用 Jython 或 IronPython，而是通过网络调用来交互，确保各程序之间的独立性。

Python 安装步骤：

1. 安装包下载：https://www.python.org/ --> 选择 Downloads --> 选择 Windows --> 点击 Python 3.x.x 进行下载。

2. 双击下载的文件 `python-3.x.x-amd64.exe`，进入安装步骤。

3. 选择 `Customize installation`，大部分设置都不需要我们进行改动，我们主要需要修改 Python 的安装路径。

4. 点击 Next 进入 `Optional Features`，此部分选项无需改动。

5. 点击 Next 进入 `Advanced Options`，勾选将 Python 加入到环境变量中并修改 Python 的安装路径。

6. 点击 Install 完成安装。

7. 验证安装：打开 cmd 命令行窗口，输入 python 出现如下内

   ~~~powershell
   Microsoft Windows [版本 10.0.18363.1256]
   (c) 2019 Microsoft Corporation。保留所有权利。
   
   C:\Users\star>python
   Python 3.9.1 (tags/v3.9.1:1e5d33e, Dec  7 2020, 17:08:21) [MSC v.1927 64 bit (AMD64)] on win32
   Type "help", "copyright", "credits" or "license" for more information.
   >>>
   ~~~

   安装成功！此时进入到了 Python 的命令行当中。



**Python 交互界面**

Windows 下进入 Python 交互界面（命令行）

​	win键 + R 出现运行窗口，输入 cmd，然后回车进入到 Windows 命令行，输入 `python` 命令即可进入 Python 交互界面。

Python 交互界面结构

- 版本和版权声明：

  Python 3.9.1 (tags/v3.9.1:1e5d33e, Dec  7 2020, 17:08:21) [MSC v.1927 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.

- 命令提示符：
  \>\>\>

  在命令提示符后可以直接输入 Python 的指令，点击回车后指令将会被 Python 解释器立即执行。

Python 开发工具 IDLE

​	在安装 Python 的同时，会自动安装一个 Python 的开发工具 IDLE，通过 IDLE 也可以进入到交互模式。

​	在 IDLE 中可以通过 TAB 键来查看语句的提示，并且可以将代码进行保存（保存的是界面的所有信息，不仅仅包含 Python 代码）。

其他 Python 开发工具

​	在交互模式中输入一行代码，它就执行一行，所以他并不适用于我们日常的开发，仅可以用来做一些日常的简单的测试。

​	我们一般会将 Python 代码编写到一个 .py 文件中，然后通过 python 指令来执行文件中的代码，如：`python xxx.py`

​	PyCharm 是一款功能强大的 Python 编辑器，由 [JetBrains](https://www.jetbrains.com/) 公司出品，是最受欢迎的 Python 编辑器之一。

​	

**PyCharm 的安装及使用**

1. 在官网下载 PyCharm 并安装：https://www.jetbrains.com/pycharm/download/other.html

2. 双击 PyCharm 运行，点击 `Create New Project` 创建新项目。

3. 选择 `Pure Python` 创建一个简单的纯 Python 项目，在 Location 处输入项目存放位置。

4. 展开 `Project Interpreter`，为项目指定一个独立的 Python 解释器（也可直接使用默认值）。

5. 点击 `create` 创建项目。

6. 右键左侧窗口的项目名 --> 选择 New --> 选择 Python File --> 输入文件名创建 Python 文件。

7. 编写 Python 文件内容，点击顶部工具栏上的 Run 运行编写的 Python 文件。

   ~~~python
   # Python 的输出语句
   print("Hello Python!")
   # Python 的 print 方法可以输出多个参数，输出时将会自动在每一个参数之间添加空格
   print("Python is", 26, "years old.")
   ~~~

8. 控制台输出正常，PyCharm 的安装完成。



---

### 3.Python 基本语法

**几个基础概念**

表达式

​	变量或常量与符号的组合，表达式不会对程序产生实质性的影响，比如：10 + 5，8 - 4

语句

​	在程序中语句一般需要完成某种功能，语句的执行一般会对程序产生一定的影响，比如打印信息、获取信息、为变量赋值......

程序（program）

​	程序就是由一条一条的语句和一条一条的表达式构成的。

函数（function）

​    函数就是一种语句，用来完成特定的功能，如：xxx()

​	函数的分类：

​		内置函数：由Python解释器提供的函数，可以在 Python 中直接使用。

​		自定义函数：由程序员自主的创建的函数。

​	函数的两个要素：

​		参数：() 中的内容就是函数的参数，函数中可以没有参数，也可以有多个参数，多个参数之间使用 , 隔开。

​		返回值：返回值是函数的返回结果，不是所有的函数都有返回值。

方法（method）

​	方法与函数基本一样，Python 中方法必须由对象调用，而函数不需要。



**Python 基本语法**

1. 在 Python 中严格区分大小写。

2. Python 中的每一行就是一条语句，每条语句以换行结束。

3. Python 一条语句可以分多行编写，多行编写时语句后边以 `\` 结尾（规范中建议每行不要超过 80 个字符）。

4. Python 是缩进严格的语言，在Python中不可以随便缩进。

5. 在 Python 中使用 `#` 来表示单行注释，# 后的内容都属于注释，注释的内容将会被解释器所忽略（习惯上 # 后边跟一个空格）。

   

**Python 变量**

字面量

​	字面量就是一个值，比如：1，2，3，4，5，6，"HELLO"，字面量所表示的意思就是它的字面的值，在程序中可以直接使用。

变量（variable）

​	变量可以用来保存字面量，变量中保存的字面量是不定的，变量本身没有任何意思，根据不同的字面量表示不同的意思。

​	在 Python 中使用变量不需要定义，直接为变量赋值即可，如：`a = "123"`

​	不能使用没有进行过赋值的变量。

​	Python 是一个动态类型的语言，可以为变量赋任意类型的值，也可以任意修改变量的值。

标识符：在 Python 中可以自主命名的内容都属于标识符，如：变量名，函数名，类名......

标识符命名规范：

1. 标识符可以由数字，字母，下划线组成，不能以数字开头。

2. 标识符不能是 Python 中的关键字和保留字。

   查看所有的关键字和保留字：

   ~~~python
   import keyword
   
   # 打印关键字和保留字
   print(keyword.kwlist)
   ~~~

   ['False', 'None', 'True', '\_\_peg_parser\_\_', 'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']

3. 不建议使用 Python 中的函数名作为标识符（函数名会被覆盖，导致无法调用）。

4. 命名规范

   下划线命名法：所有字母小写，单词之间使用下划线连接，一般用作变量名。

   帕斯卡命名法（大驼峰）：所有单词首字母大写，其余字母小写，一般用作类名。

   ​	使用场景：类名

   命名使用场景：

   - 项目名称：使用帕斯卡命名法，如：ProjectName

   - 文件名、模块名和包名：使用下划线命名法，如：file_name，module_name，package_name

   - 类名：使用帕斯卡命名法，内部类使用额外的下划线开头，如：MyClass，_InnerClass

   - 函数&方法：使用下划线命名法，如：example_function

     ​	类内部函数命名，使用单下划线开头（该函数可被继承访问）。

     ​	类内部私有函数命名，使用双下划线开头（该函数不可被继承访问）。

   - 函数&方法的参数：使用下划线命名法，同时总使用 `self` 作为实例方法的第一个参数，总使用 `cls` 作为类方法的第一个参数，如：function_param，self，cls

   - 变量：使用下划线命名法，同时因为 Python 是动态类型语言，所以变量名不应带有类型信息，如 iValue，names_list 等都是不好的命名。

     ​	类内部变量命名，使用单下划线开头（该变量可被继承访问）。

     ​	类内部私有变量命名，使用双下划线开头（该变量不可被继承访问）。

   - 异常：使用帕斯卡命名法，同时以 `Error` 结尾，如：NameError

   - 常量：使用下划线命名法，但是常量名所有的字母均大写，如：MAX_OVERFLOW

> Python 中下划线的含义
>
> 1. 单前导下划线：\_var、\_function，它有一个约定俗成的含义：以单个下划线开头的变量或方法仅供内部使用；它只是对程序员的一个提示， 程序的行为不会受其影响。
>
> ​	注：在使用通配符导入模块时，以单下划线开头的变量或方法不会导入，常规导入不受影响（我们应该尽量避免通配符导入）。
>
> 2. 单末尾下划线：var\_、function\_，当一个变量的最合适的名称已经被一个关键字所占用，此时可以附加一个下划线来解决命名冲突，如：class\_
>
> 3. 双前导下划线：\_\_var、\_\_function，双下划线前缀会导致 Python 解释器重写属性名称，在类被扩展的时候不容易与子类中的命名产生冲突。
>
> ​	注：使用此种方式命名时，如果你创建了一个子类，那么你将不能轻易地覆写父类中的方法或变量。
>
> 4. 双前导和双末尾下划线：\_\_var\_\_，使用这种用法表示 Python 中特殊的方法或变量，如：\_\_init\_\_，\_\_all\_\_ 等。
>
> 5. 单下划线：\_，使用独立下划线是用作一个名字，表示某个变量是临时的或无关紧要的，如使用 for _ in range(10): 用来循环。



---

### 4.Python 数据类型

**数值**

在 Python 中，数值分为了三种：整数，浮点数，复数

整数：在 Python 中所有的整数都是 int 类型，如：10，-5 等，整数的大小没有限制，可以是任意大小。

​	在书写时，如果整数长度过大，可以使用下划线做分隔符，如：10\_000

​	其他进制的整数写法：

​	1.二进制（Binary）：以 0b 开头，如：0b101101

​	2.八进制（Octal）：以 0o 开头，如：0o1574

​	3.十六进制（Hexadecimal）：以 0x 开头，如：ox51ac8

​	注意：为了避免混淆，Python 总会以十进制输出数字（所有语言都如此）。

浮点数：在 Python 中所有的小数都是 float 类型，如：0.78，1.22

​	对浮点数进行运算时，可能会得到一个不精确的结果，可以通过模块 decimal 进行计算。

复数：数学概念，见：https://baike.baidu.com/item/%E5%A4%8D%E6%95%B0/254365
$$
方程：x^2 - 2x + 2 = 0；解得：x^2 - 2x + 1 = -1；解得：(x - 1)^2 = -1；解得：x - 1 = \sqrt{-1}；解得：x = 1 + \sqrt{-1}；即：x = 1 - 1i
$$
​	其中 1 - 1i 就是一个复数，由实部 1 和虚部 -1 组成，虚部后加字母 i 表示。

在 Python 中，使用 a + bj 来表示复数：

~~~python
# 复数
num = 1 + 2j
# 打印 num 的实部
print(num.real)
# 打印 num 的虚部
print(num.imag)
~~~



**字符串**

字符串用来表示一段文本信息，在 Python 中，字符串需要使用单引号或双引号引起来，单引号和双引号可以同时使用，但相同的引号之间不能嵌套。

长字符串：使用三重引号来包含文字内容，内容之间可以随意换行

```python
a = '''abc
efg
'''
print(a)
```

字符串支持转义符，如：`\n` 表示换行，`\u1234` 表示 Unicode 编码 1234 表示的字符。

> 在 Python 中，字符串之间可以使用加号进行拼接，但是字符串也只能与字符串进行拼接，与其他类型的数据（如：int）拼接时会报错：TypeError

字符串格式化：

1. 字符串占位符 %s：%s 表示任意字符串

   使用方法：字符串外加一个 %，然后紧跟需要填充的内容

   ~~~python
   # 单占位符
   msg = 'Hello,%s' % 'Niko'
   print(msg)
   # 将数字作为字符串填充进去
   msg = 'I\'m %s years old.' % 25
   print(msg)
   # 多占位符，括号内的内容按顺序填充
   msg = 'Hello,%s,I %s you so much!' % ('Niko', 'miss')
   print(msg)
   ~~~

   输出结果：

   ~~~markdown
   Hello,Niko
   I'm 25 years old.
   Hello,Niko,I miss you so much!
   ~~~

   我们还可以在 % 后面加上数字来限制填充内容的最小（最大）长度，如果少于（超出）该长度，将会对字符串前方添加空格（截除多余内容），如：%3s，%3.5s

   ~~~python
   # 限制填充内容长度至少为 5
   msg = 'Nice to meet you,%5s' % 'Niko'
   print(msg)
   # 限制填充内容长度至少为 3，最多为 5
   msg = 'Nice to meet you,%3.5s' % 'Charles'
   print(msg)
   ~~~

   输出结果：

   ~~~markdown
   Nice to meet you, Niko
   Nice to meet you,Charl
   ~~~

2. 整数占位符 %d：对整数内容进行格式化填充

   限制整数的长度，如：%4d，填充长度至少是 4，不够时在前面加空格；%.4d，填充长度至少是 4，不够时在前面加 0

   ~~~python
   msg = 'There are %.4d eggs in the basket' % 123.5700
   print(msg)
   msg = 'There are %4d eggs in the basket' % 123.5700
   print(msg)
   ~~~

   输出结果：

   ~~~markdown
   There are 0123 eggs in the basket
   There are  123 eggs in the basket
   ~~~

3. 浮点数占位符 %f：对浮点数内容进行格式化填充

   限制小数位数，如：%.3f，保留 3 位小数，多于 3 位的会被截除，少于 3 位的则在末尾添加 0

   ~~~python
   # 限制小数位数
   msg = 'There are %.2f eggs in the basket' % 123.5700
   print(msg)
   ~~~

   输出结果：

   ~~~markdown
   There are 123.57 eggs in the basket
   ~~~

格式化字符串：在字符串前加 f 或 F 表示该字符串是一个格式化字符串，格式化字符串中可以直接引用变量

~~~python
age = 25
name = "James"
introduction = f"{name} is {age} years old."
print(introduction)
~~~

输出结果：

~~~markdown
James is 25 years old.
~~~

字符串复制：在 Python 中，如果使用字符串与整数相乘，相当于把字符串重复指定次数并拼接

~~~python
# 字符串复制
a = "Hello "
a *= 5
print(a)
~~~

输出结果：

~~~markdown
Hello Hello Hello Hello Hello 
~~~



**布尔值**

在 Python 使用 bool 表示布尔值，用来表示真（True）或假（False）两个值（在 Python 中布尔值的首字母大写）。

~~~python
# 布尔值
a = True
b = False
~~~

在 Python 中 True 相当于整数 1，False 相当于整数 0

~~~python
print(1 + True)
print(1 + False)
~~~

输出的结果是：2、1



**空值（None）**

在 Python 中，使用 None 来表示空值，不存在。



**类型检查**

在 Python 中，使用 type() 函数检查变量的值的数据类型

~~~python
# 类型检查
print(type("str"))
print(type(1))
print(type(1.2))
print(type(1 + 2j))
print(type(False))
print(type(None))
~~~

输出结果：

~~~markdown
<class 'str'>
<class 'int'>
<class 'float'>
<class 'complex'>
<class 'bool'>
<class 'NoneType'>
~~~



**对象（Object）**

Python 是一门面向对象的语言，在 Python 中任何东西都可看作对象，例如：数值、字符串、布尔值、None 都是对象

每个对象都保存了 3 中属性：

- id：用来标识对象的唯一性，使用 id() 函数进行查看。

  ~~~python
  print(id("Hello"))
  ~~~

  输出：1985004694768，由解释器生成，在 CPython 中，此值就是该对象的内存地址。

  对象一旦创建，其 id 永远不能改变。

- type：用来标识对象的类型，使用 type() 函数进行查看。

  Python 是一门强类型的语言，对象一旦创建，其 type 也永远不能改变。

- value：用来标识对象当中存储的具体数据，当我们使用 print() 打印时，就是打印的对象的值。

  在 Python 中，对象的值可以改变，可以改变值的对象叫可变对象（如：list，set），不可以改变值的对象叫不可变对象（如：int，float）。



**变量和对象**

在 Python 中，变量更像是对象的一个别名，变量当中存储的是对象的内存地址。



**类型转换**

在 Python 中，可以对变量的值进行类型转换（不是改变对象的类型，而是创建一个新的类型的对象重新赋值给变量）。

类型转换的 4 个函数：int()、float()、str()、bool()

类型转换不会改变变量的值，而是返回转换后的结果，需要重新赋值才可转换变量类型。

注意事项：

1. float 转 int 是省略小数点后的结果。
2. 小数字符串不能直接转换为 int，如 int('12.5') 会抛出异常：ValueError
3. 类型转换函数不能转换 None 值。
4. 使用 bool() 可以将 空数值（0、0.0）、空字符串（''、""）、空（None）、空集合（[]、()、{}）转为 False，其他情况下都是 True。



---

### 5.Python 运算符

运算符可以对一个值或多个值进行运算操作，如：+、-、*、/ 等。



**运算符分类**

1. 算术运算符：

   1. +（加）：整数与整数相加，整数与浮点数相加（得到浮点数），字符串与字符串相加（拼接）。
   2. -（减）：整数与整数相减，整数与浮点数相减（得到浮点数）。
   3. \*（乘）：整数与整数相乘，整数与浮点数相乘（得到浮点数），字符串与整数相乘（字符串复制）。
   4. /（除）：整数与整数相除（得到浮点数），整数与浮点数相除（得到浮点数）。
   5. %（取模）：整数与整数取模（得到整数），整数与浮点数取模（得到浮点数）。
   6. \*\*（幂）：a ** b 即 a 的 b 次幂，如 2 ** 10 = 1024；4 ** 0.5 = 2（开根号）；
   7. //（向下整除）：当商不是整数时，向下取整，如：9 / 2 = 4；-9 / 2 = -5；

   > 注：整数与浮点数的计算结果总是浮点数

2. 赋值运算符：=，将等号右侧的值复制给左边的变量。

   其他复制运算符：+=，-=，\*=，/=、%=，\*\*=，//=

3. 比较（关系）运算符：用来比较两个值之间的关系，返回一个 bool 值。

   如：\>（大于），<（小于），\>=（大于等于），<（小于等于），==（等于），!=（不等于），<>（不等于）。

   > 在 Python 中，可以对字符串使用关系运算符进行比较，在比较时，比较的是 Unicode 编码，对字符串的逐个字符进行比较。
   >
   > 注：在 Python 中使用比较运算符进行比较时，比较的是两个对象的值，并不关心两个对象是否是同一个对象。

4. 逻辑运算符：对 bool 值进行逻辑运算。

   如：not（逻辑非），and（逻辑与），or（逻辑或）

   > Python 中的运算符是短路的，如果第一个值已经确定了结果，则不会去运算第二个值。
   >
   > ~~~python
   > True and print("Hello")
   > True or print("World")
   > ~~~
   >
   > 此时只有第一句会打印。

   对非 bool 值的逻辑运算，Python 会将其当做 bool 值运算并返回原值。

   由于 Python 中运算符是短路的，使用 and 时，会去表达式中找 False 并返回最后遇到的值

   ​	如：2 and 3，先看第一个值为 True，则继续找第二个值，无论第二个值是什么都原样返回；

   ​	如：0.0 and "abc"，第一个值为 False，则不会去查看第二个值，直接返回 0.0；

   使用 or 符号时，会去表达式中找 True 并返回最后遇到的值，与 and 的逻辑相同。

5. 条件（三元）运算符：`语句 if 表达式1 else 表达式2`，当语句的返回值为 True 时执行表达式1并返回执行结果，否则执行表达式2并返回执行结果。

6. 位运算符：把数字转换为二进制来进行计算

   例：a = 60 --> 0011 1100，b = 13 --> 0000 1101（位数不足时在前面补 0）

   1. &（按位与）：如果两个相应位都为 1，则该位的结果为 1，否则为 0，a & b = 0000 1100 = 12
   2. |（按位或）：两个相应位只要有一个为 1，则该位的结果为 1，否则为 0，a | b = 0011 1101 = 61
   3. ^（按位异或）：当两对应的二进位不同时，结果为 1，否则为 0，a ^ b = 0011 0001 = 49
   4. ~（按位取反）：将数据的每个二进制位取反，即把 1 变为 0，把 0 变为 1，~a = 1100 0011 = -61
   5. <<（左移运算）：二进位全部左移若干位，<< 右边的数字指定移动的位数，高位丢弃，低位补 0，a << 2 = 1111 0000 = 240
   6. \>\>（右移运算）：二进位全部右移若干位，\>> 右边的数字指定移动的位数，a >> 2 = 0000 1111 = 15

7. 成员运算符：测试实例中是否包含指定元素，使用 in/not in

   ~~~python
   li = [1, 3, 5, 10, 20]
   print(10 in li)
   print(15 in li)
   print(15 not in li)
   print("a" in "Hello")
   print("e" in "Hello")
   ~~~

   返回：True，False，True，False，True

8. 身份运算符：比较两个对象的存储单元，即是否是同一个对象，使用 is/is not

   ~~~python
   a = 1
   b = True
   print(a == b)
   print(a is b)
   print(a is not b)
   ~~~

   输出：True，False，True



**运算符优先级**

在 Python 中运算符的优先级如下：

| 运算符                   | 描述                                                   |
| :----------------------- | :----------------------------------------------------- |
| **                       | 指数 (最高优先级)                                      |
| ~ + -                    | 按位翻转, 一元加号和减号 (最后两个的方法名为 +@ 和 -@) |
| * / % //                 | 乘，除，取模和取整除                                   |
| + -                      | 加法减法                                               |
| >> <<                    | 右移，左移运算符                                       |
| &                        | 位 'and'                                               |
| ^ \|                     | 位运算符                                               |
| <= < > >=                | 比较运算符                                             |
| <> == !=                 | 等于运算符                                             |
| = %= /= //= -= += *= **= | 赋值运算符                                             |
| is is not                | 身份运算符                                             |
| in not in                | 成员运算符                                             |
| not and or               | 逻辑运算符                                             |

当运算中的符号过多时，我们需要使用小括号来改变运算符的优先级。

> 在 Python 中，多个比较运算符可以连用，且具有特殊的规则（Python 独有）
>
> 例如：表达式 2 > 5 > 3，相当于 2 > 5 and 5 > 3 --> False and True --> 返回 False
>
> ​	 表达式 2 > 1 < 3 > 0，相当于 2 > 1 and 1 < 3 and 3 > 0 --> True and True and True --> 返回 True



---

### 6.流程控制

Python 在执行代码时是按照从上到下顺序执行的，通过流程控制语句，可以改变程序的执行顺序，也可以让程序反复执行多次。

流程控制语句分为两大类：条件判断语句和循环语句。



**条件判断语句**

if 语句：

~~~python
threshold = 15
if threshold > 10:
    print("超出了阈值限定范围")
~~~

一般的，if 的下一行进行缩进，表示这一行代码收到 if 管理，如果希望管理多条语句，继续缩进即可：

~~~python
threshold = 15
if threshold > 10:
    print("超出了阈值限定范围")
    print("阈值为 10，输入为", threshold)
print("Hello", "World")    
~~~

此时前两行代码都受到 if 管理，第三行无论如何都会执行。

> input 函数：等待获取用户输入，输入后点击回车，程序继续向下执行（
>
> - 返回结果：将用户输入作为字符串返回。
> - 参数（可选）：可以填入字符串内容作为提示信息。
>
> ~~~python
> a = input("请输入：")
> print(a)
> ~~~
>
> 其他用法：在程序的最后加入一个空的 input() ，阻塞程序执行，用户输入回车后程序结束。
>
> ~~~python
> print("Hello Python!")
> input("输入回车结束...")
> ~~~

if else 语句：

~~~python
age = input("请输入你的年龄:")
age = int(age)
if age > 18:
    print("您已成年。")
else:
    print("您未成年。")
~~~

if elseif else 语句：

~~~python
grade = int(input("请输入小明的成绩："))
if grade == 100:
    print("奖励一台电脑")
elif grade > 80:
    print("奖励一部IPhone")
elif grade > 60:
    print("奖励一本书")
else:
    print("奖励一顿毒打")
~~~



**while 循环语句**

循环语句可以使指定代码块执行指定的次数，循环语句分为 while 循环和 for 循环。

 while 循环：

~~~python
i = 0
while i < 10:
    print("Hello")
    i += 1
~~~

> 在 Python 中，while 可以添加 else 代码块，当跳出 while 循环时执行。
>
> ~~~python
> i = 0
> while i < 10:
>     print("Hello")
>     i += 1
> else:
>     print("循环完成。")
> ~~~

break 和 continue：

break：立即退出当前循环语句。

continue：结束此次循环，立即进入下一次循环。

小实例：打印九九乘法表

~~~python
print("======================== 九九乘法表 ========================")
row = 1
while row <= 9:
    column = 1
    row_str = ""
    while column <= row:
        row_str += "{} x {} = {:<2d} ".format(row, column, row * column)
        column += 1
    print(row_str)
    row += 1
~~~



**for 循环语句**

在 Python 中，一般使用 for 循环来遍历序列：

~~~python
for c in "Hello":
    print(c)
~~~



---

### 7.序列与列表

> **序列（sequence）**
>
> 序列是 Python 中一种最基本的数据结构，序列中可以保存多个有序数值。
>
> Python 中有两种序列：可变序列（list）和不可变序列（str，元组：tuple）



**列表（list）**

列表（list）是 Python 中的一个对象，列表属于可变序列，通过 [] 可以创建列表。

~~~python
# 创建空列表
li = []
# 创建非空列表
li = [10, "Hello", None, [5, 6], print]
~~~

注：list 中可以保存任意对象，列表中的元素按照插入的顺序进行存储。



**序列的通用操作**

序列元素获取：使用 [index] 来获取（下标从 0 开始），如 my_list[0]

> 在 Python 中，可以使用负的 index 来获取序列中的元素，如：my_list[-1] 表示获取 my_list 的倒数第一个元素。

序列长度获取：使用内建函数 len() 来获取列表长度，如：len(my_list)

序列切片：从现有序列中获取一个子序列，使用 [start:end]（不会包含 end 位置的元素）如：my_list[0:2] 获取序列前两个元素，此方法总会返回一个新的序列，原序列不做改变。

扩展用法：

1. 省略 start 参数或 end 参数，表示从 0 开始截取（省略 start）和一直截取到最后一个元素（省略 end）。
2. 可以使用负数，如：my_list[1:-2] 表示从 1 截取到倒数第二个元素（不包括倒数第二个元素）。
3. 同时省略 start 和 end，相当于全部截取，即复制序列。

> 序列切片可以添加步长参数，表示每隔几个元素进行截取，不写时默认为 1，用法：my_list[1:5:2] 表示从第 1 个元素截取到第 5 个元素，每截取一个元素后跳跃 2 个 index。
>
> ~~~python
> my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
> print(my_list[1:5:2])
> ~~~
>
> 输出：['孙悟空', '沙僧']
>
> 注：步长不可以为 0，但是可以为负数，为负数时表示向前跳跃，如：my_list[::-1] 可以翻转序列

序列相加：使用 + 号对两个序列进行相加，可以将两个序列合成一个新序列。

序列相乘：使用 * 号对两个序列进行相乘，可以将序列复制多次成为一个新序列。

序列包含元素判断：in 和 not in

获取序列中的最小值和最大值：min() 和 max()，如：min(my_list)，max(my_list)

获取指定元素的下标：index() 方法

~~~python
my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
print(my_list.index("孙悟空"))
~~~

注：此方法仅仅会返回匹配到的第一个元素的下标，如果序列中不包含该元素，则会抛出 ValueError 异常。

除此之外，index() 还可以添加 2 个参数限定查找范围，第一个参数是起始下标，第二个参数是结束下标（不包含结束下标）。

获取指定元素在序列中的个数：count() 方法

~~~python
my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿", "孙悟空"]
print(my_list.count("孙悟空"))
~~~



**可变序列（list）中的元素修改**

1. 修改元素：直接通过下标修改，如：my_list[1] = "孙悟空"

2. 删除元素：del my_list[1]，删除 my_list 的第二个元素；del my_list[1:3] 删除 my_list 的部分元素。

3. 通过切片修改元素：my_list[1:2] = [3, 4] 将列表的指定部分替换为新列表（等号右边必须为列表类型）。

   ~~~python
   my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
   my_list[2:4] = [1, 2, 3]
   print(my_list)
   ~~~

   输出：['唐僧', '孙悟空', 1, 2, 3, '白骨精', '如来佛祖', '红孩儿']

   > 其他用法：
   >
   > 1. 可以通过 my_list[i:i] = [x, y, z] 在列表的 i 位置插入数据。
   > 2. 可以加入步长参数，my_list[i:j:n] = [x, y, z]，注意：在加入步长时，等号右边的元素个数必须与左边切片的元素个数相等。
   > 3. 使用 my_list[i:j] = [] 来删除元素。

4. 通过方法修改元素：

   1. append() 方法：将元素添加到列表最后

      ~~~python
      my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
      my_list.append("牛魔王")
      print(my_list)
      ~~~

      输出：['唐僧', '孙悟空', '猪八戒', '沙僧', '白骨精', '如来佛祖', '红孩儿', '牛魔王']

   2. insert() 方法：在指定位置前插入元素

      ~~~python
      my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
      my_list.insert(2, "牛魔王")
      print(my_list)
      ~~~

      输出：['唐僧', '孙悟空', '牛魔王', '猪八戒', '沙僧', '白骨精', '如来佛祖', '红孩儿']

   3. extend() 方法：使用序列来扩展当前序列

      ~~~python
      my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
      my_list.extend("观世音菩萨")
      print(my_list)
      ~~~

      输出：['唐僧', '孙悟空', '猪八戒', '沙僧', '白骨精', '如来佛祖', '红孩儿', '观', '世', '音', '菩', '萨']

   4. clear() 方法：清空序列。

   5. pop() 方法：根据索引删除并返回该元素，如：my_list.pop() - 删除最后一个元素并返回，my_list.pop(2) - 删除 index 为 2 的元素并返回。

   6. remove() 方法：删除指定值的元素，如：my_list.remove("猪八戒")，只会删除匹配到的第一个元素。

   7. reverse() 方法：翻转列表。

   8. sort() 方法：对列表中的元素进行排序，可以传入 reverse=True 来降序排列。

      ~~~python
      my_num = [1, 5, 3, 25, 11, 98, 0]
      my_num.sort()
      print(my_num)
      my_num.sort(reverse=True)
      print(my_num)
      ~~~
   
5. 使用 copy() 方法浅拷贝一个新列表：my_list2 = my_list.copy()，如果列表当中存在可变对象，则只是拷贝引用，可变对象改变时会同时影响到两个列表。

> 通过 list() 函数可以将不可变序列转换为 list，然后可以执行可变序列的相关操作。



**序列的遍历**

可以使用 for 循环来遍历序列：

~~~python
my_num = [1, 5, 3, 25, 11, 98, 0]
for c in my_num:
    print(c)
~~~



**range() 函数**

生成一个自然数组成的序列，如 range(5) = [0, 1, 2, 3, 4]

此函数需要 3 个参数：起始位置，结束位置，步长。

通过 range() 可以创建一个指定次数的 for 循环。

~~~python
for i in range(20):
    print(i)
~~~

通过 range() 实现 fori 循环：

~~~python
my_list = ["唐僧", "孙悟空", "猪八戒", "沙僧", "白骨精", "如来佛祖", "红孩儿"]
for i in range(len(my_list)):
    my_list[i] += "酱"
print(my_list)
~~~

输出：['唐僧酱', '孙悟空酱', '猪八戒酱', '沙僧酱', '白骨精酱', '如来佛祖酱', '红孩儿酱']



**元组（tuple）**

元组是一个不可变序列，除了元素不可改变外，它的操作与列表一致。

当我们希望数据不改变时，使用元组，其他情况使用列表。

元组创建：使用 () 创建：

~~~python
my_tuple = ("a", "b")
print(type(my_tuple))
~~~

输出：<class 'tuple'>

如果元组不是空元组，可以省略括号

~~~python
my_tuple = "a", "b"
print(type(my_tuple))
~~~

如果元组当中只有一个元素，在创建时也应该在末尾添加都好表示其是一个元组

~~~python
my_tuple = ("a",)
my_tuple = "a",
~~~

使用元组为变量赋值：

~~~python
my_tuple = "a", "b", "c"
a, b, c = my_tuple
~~~

赋值方法巧用：

~~~python
a = 200
b = 300
a, b = b, a
~~~

为两个变量或多个变量相互赋值。

使用元组赋值变量时，当两边的变量个数不相等时，也可以赋值为 list

~~~python
my_tuple = "a", "b", "c", "d", "e", "f", "g"
a, b, *c, d = my_tuple
print(a, b, c, d)
~~~

输出：a b ['c', 'd', 'e', 'f'] g，此时将中间部分看作是一个 list 进行赋值。



**可变对象**

值可以改变的对象成为可变对象，list 就是一个可变对象。

可变对象的操作：

1. 修改对象：my_list[0] = 10，此种方式是修改对象的值，其他指向该对象的变量值也会受到影响。
2. 修改变量：my_list = []，此种方式是修改变量的引用，其他指向该对象的变量不会受到影响。



---

### 8.字典

字典（dict）是一种映射的数据结构，类似于 Map。

字典的作用于 list 类似，都是用来存储对象的容器，字典中每一个元素都有一个唯一的 key，通过这个唯一的 key 可以快速查找到指定的 value。

list 存储数据的性能很好，但是查询较慢；而 dict 存储数据的性能不如 list，单查询效率较高。

字典的创建：使用 {} 或 dict() 创建字典

~~~python
my_dict = {"name": "Monkey King", "species": "monkey"}
# 使用此种方式创建的 dict 的 key 都是 str
this_dict = dict(name="Monkey King", species="monkey")
# 使用双值子 tuple 创建 dict
that_dict = dict([("name", "Monkey King"), ("species", "monkey")])
~~~

字典的 key 可以是任意的不可变对象（int，str，bool，tuple...），字典的值可以是任意对象。

字典的 key 不可重复，如果有重复的，前面的 value 将会被覆盖。

获取字典的值：

~~~python
my_dict = {"name": "Monkey King", "species": "monkey"}
print(my_dict["name"])
~~~

如果使用了字典中不存在的键，则会抛出 KeyError。



**字典的使用**

获取字典中的键值对个数：len(my_dict)

检查字典中是否包含指定的键：in/not in

~~~python
my_dict = {"name": "Monkey King", "species": "monkey"}
print("name" in my_dict)
~~~

获取 dict 中 key 对应的值：my_dict["name"] 或 my_dict.get("name")

~~~python
my_dict = {"name": "Monkey King", "species": "monkey"}
print(my_dict.get("address"))
print(my_dict.get("address", "天涯海角"))
~~~

使用 get() 方法，当获取不到值时返回 None，还可以使用第二个参数设置一个默认值。

修改字典的值：

1. my_dict["name"] = "Tang Seng"，当字典中有该 name 的 key 时，则为修改现有元素，否则为添加新元素。

2. 使用 setdefault：如果字典中存在 key 则不作操作并返回 key 对应的 value，否则将 key-value 设置到 dict 中。

   ~~~python
   my_dict = {"name": "Monkey King", "species": "monkey"}
   my_dict.setdefault("name", "Zhu BaJie")
   print(my_dict)
   ~~~

   第二个参数key省略，省略时相当于 get() 函数。

3. update() 函数，将其他字典中的 key-value 添加到当前字典当中

   ~~~python
   person_dict = {"name": "Monkey King", "species": "monkey"}
   job_dict = {"job": "Demon Master", "name": "モンキーキング"}
   person_dict.update(job_dict)
   print(person_dict)
   ~~~

   输出：{'name': 'モンキーキング', 'species': 'monkey', 'job': 'Demon Master'}，当前 dict 中重复的 key 的值会被覆盖。

删除字典中的键值对：

1. del my_dict["name"]，当删除不存在的值时，抛出 KeyError。

2. 使用 popitem() 函数：随机删除（一般都是最后一个元素） dict 的元素并将作为 tuple 返回

   ~~~python
   my_dict = {"name": "Monkey King", "species": "monkey"}
   print(my_dict.popitem())
   ~~~

   输出：('species', 'monkey')，当删除空字典时，抛出 KeyError。

3. 使用 pop() 函数：根据 key 删除 value，并返回该 value。

   ~~~python
   my_dict = {"name": "Monkey King", "species": "monkey"}
   print(my_dict.pop("name"))
   ~~~

   如果删除不存在的 key，则抛出 KeyError；此时可以添加第二个参数，如果不存在 key，直接返回第二个参数，如：print(my_dict.pop("address", "无"))。

4. clear() 函数，删除字典中所有元素。

浅复制：使用 copy() 函数，复制出的 dict 与原 dict 相互独立，但 dict 中的元素不会重新拷贝（如果 value 是可变对象，则会相互影响）。

~~~python
my_dict = {"name": "Monkey King", "species": "monkey", "list": [1, 3, 5]}
copy_dict = my_dict.copy()
copy_dict["list"][2] = 8
print(my_dict["list"])
~~~

此时，my_dict 中的 list 会变为 [1, 3, 8]。



**字典的遍历**

遍历字典用到的方法：

- keys() - 返回字典的所有的 key 组成的序列

- values() - 返回字典的所有的 value 组成的序列

- items() - 返回字典的所有的 key-value 组成的序列，每一个 key-value 封装成为一个双值元组。

  ~~~python
  my_dict = {"name": "Monkey King", "species": "monkey", "list": [1, 3, 5]}
  print(my_dict.items())
  ~~~

  输出：dict_items([('name', 'Monkey King'), ('species', 'monkey'), ('list', [1, 3, 8])])

  ~~~python
  my_dict = {"name": "Monkey King", "species": "monkey", "list": [1, 3, 5]}
  for k, v in my_dict.items():
      print(k, v)
  ~~~

  此时可以用两个值去接受序列中的子序列。



---

### 9.集合

集合（set）与列表非常相似，不同点：

- 集合中只能存储不可变对象。
- 集合中的元素是无序的（不是按照插入顺序排序的，不能通过索引查找）。
- 集合中不能出现重复元素（集合中的元素都是唯一的）。

集合创建：使用 {}

~~~python
my_set = {2, 3, 4, 1, 2}
print(my_set)
~~~

输出：{1, 2, 3, 4}，如果创建空集合，只能使用 set()，不能使用 {}，因为此时默认创建的是空字典。

使用 set() 函数将序列或字典转换为集合：

~~~python
this_set = set([2, 3, 4, 1, 2])
print(this_set)
# 使用 dict 创建集合时，只会使用 dict 当中的 key
this_set = set(my_dict)
~~~

> 如果给 set 存放可变对象，则会抛出 TypeError。



**集合的使用**

1. 使用 in/not in 判断集合是否包含某元素。

2. 使用 len() 获取集合的长度。

3. 向集合中添加元素：使用 add() 方法，如：my_set.add(2)

4. 将另一个序列中的元素添加到当前集合：使用 update() 方法

   ~~~python
   my_set = {2, 3, 4, 1, 2}
   my_set.update("hello")
   print(my_set)
   ~~~

   输出：{1, 2, 3, 4, 'o', 'l', 'h', 'e'}

5. 随机删除（并返回）集合中的元素：pop() 方法，一般为删除第一个元素

   ~~~python
   my_set = {2, 3, 4, 1, 2}
   my_set.pop()
   ~~~

6. 删除集合中的指定元素：remove() 方法。

7. clear() 方法清空集合。

8. copy() 方法对集合进行浅拷贝。



**集合的运算**

1. 求两个集合的交集：

   ~~~python
   set1 = set("tomato")
   set2 = set("orange")
   new_set = set1 & set2
   print(new_set)
   ~~~

   输出：{'a', 'o'}，只返回同时在两个集合当中出现的元素。

2. 求两个集合的并集：

   ~~~python
   set1 = set("tomato")
   set2 = set("orange")
   new_set = set1 | set2
   print(new_set)
   ~~~

   输出：{'m', 'o', 'n', 'a', 'g', 'e', 't', 'r'}，返回在任意一个集合中出现过的元素。

3. 求两个集合的差集：

   ~~~python
   set1 = set("tomato")
   set2 = set("orange")
   new_set = set1 - set2
   print(new_set)
   ~~~

   输出：{'t', 'm'}，返回只在 set1 集合中出现的元素。

4. 求两个集合的异或集：

   ~~~python
   set1 = set("tomato")
   set2 = set("orange")
   new_set = set1 ^ set2
   print(new_set)
   ~~~

   输出：{'g', 'n', 'r', 't', 'e', 'm'}，返回只在某一个集合中出现（另一个集合当中没有）的元素。

5. 检查一个集合是否是另一个集合的子集、超集（包含且含多余元素）、相等：>=，<=，>，<，==

   ~~~python
   set1 = set("tomato")
   set2 = set("orange")
   new_set = set1 | set2
   print(new_set >= set1)
   ~~~

   

---

### 10.函数