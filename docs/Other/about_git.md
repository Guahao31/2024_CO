# Git 基础

你也许很早就听说过 `git` 这个工具（[官网](https://git-scm.com/)），希望通过本实验，你可以比较熟练的使用它，并为你之后的学习与工程服务。

## Git 有什么用？

不知道你是否经历过以下痛苦：

> * 误删重要源码：在一个大作业即将完成时，
>     * Windows 用户：不小心按 `shift+delete` 又敲了一下 `enter` 把关键源码删了
>     * Linux 用户：`rm main.c`
> * 对已经写好的代码进行了很大的改动，发现越改越错，但是忘记了改过哪里
> * 小组合作时使用“基于QQ的版本控制”，最后代码合到一起根本过不了编译

我们通常无法一次通关一款游戏，为了保持进度，游戏中设置了若干`存档点`；同样的，在写代码（尤其是小组合作）时我们通常无法一下写完，这就需要一个工具来保存进度，这就是 `git` 存在的意义。

## 安装

请合理使用搜索引擎。

在安装成功之后，你也许需要进行一些全局配置，以便之后提交：
```
$ git config --global user.name "CO_2023"
$ git config --global user.email "CoputerOrganization@zju.edu.cn"
```

更多的配置内容，可以查看 [git 文档](https://git-scm.com/docs/git-config#_configuration_file)。

## `git init` & `git clone`

如果你从零开始一个工程，需要使用 `git init` 来对当前目录进行相关的初始化，它会创建一个 `.git` 目录用来保存信息。

如果已经有人提供了一个初始仓库，并将其托管到了某平台（比如 [GitHub](https://github.com)），就可以使用 `git clone <repository>` 将这个工程`克隆`下来。

现在，你已经开启了一个“新的游戏存档”，可以开始你的工作与游戏了！

## 存档

当你完成了一部分任务，希望进行存档时，可以：

* `git status` 查看你到底对什么内容进行了修改
    * 你还可以用 `git diff` 来查看在上一个存档之后，你具体进行了什么修改
* `git add <pathspec>` 将你想保留在新的存档的更改添加进来
    * 如果你想保留当前工作目录下的所有更改，可以 `git add .`
* `git commit -m "some log"` 通过 `commit` 来对你的更改进行提交

至此，一个新的存档产生了，你之后的工作都会在这个存档的基础上完成。

## 看看过去

你想查看一下到目前为止，都做了什么存档，使用 `git log` 即可，它会提供至今为止所有的 `commit` 信息（时间，提交者，描述，hashcode），为了通过`log`更好的查看工作，你也许需要写出更优秀的commit信息 ([angular规范](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines))。

如果你想回到过去的某个 `commit`，可以使用 `git reset --hard <commit>`。需要注意的是，如果你使用了 `--hard`，在回到你指定的commit后，你将无法前往这个commit之后的任何一个commit，因此在操作前请慎重。

## 分支

如同Galgame会有剧情分支一样，我们的工程可能延伸出来若干 `feature`，我们可以使用 `git checkout -b <feature>` 来新建一个分支，并在这个分支上完成相关工作，最后通过 `git merge` 将新的内容合并到之前的主分支中。（有可能需要解决不同分支的冲突）
分支算是 `git` 的灵魂之一，当然并不属于非常基本的内容，如果你好奇的话，请自行学习并尝试。

## 忽略文件

我们希望 `git` 管理的内容大多是文本内容，而在我们学习C程序设计时，经常需要构建一个可执行程序（如 `a.out`），它的空间占用通常较大而且是没有必要保存在仓库中的。

`git` 提供了 `.gitignore` 帮助我们方便的区分哪些文件是需要记录与跟踪的，具体内容可以查看 [.gitignore介绍](https://git-scm.com/docs/gitignore)。

举一个简单的例子，如果我们不希望保存所有 `.out` 结尾的可执行文件，以及目录 `./site/` 下的所有文件，你可以这样写：

```title=".gitignore"
# All files end with '.out'
*.out
# All files below 'site'
site
```

`.gitignore` 中还可以通过 `!` 指定希望跟踪哪些文件，比如我们希望保存 `./pics` 目录下的所有 `.png` 图片，而不保存其他目录下的图片，可以这样写：

```title=".gitignore"
# All of the .png
*.png
# But the .png files under pics
!pics/*.png
```

!!! tip "你可能需要：[适用于Vivado工程的.gitignore](https://support.xilinx.com/s/article/61232?language=en_US)。"

以上内容只是 `git` 使用的最基本指令，你还可以学习使用 `git` 管理工程的工作流(比如[ bilibili 视频](https://www.bilibili.com/video/BV19e4y1q7JJ)。如果遇到问题，可以查看 `git` 文档或 `git --help` 查看帮助。