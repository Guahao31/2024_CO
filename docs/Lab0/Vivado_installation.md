# 配置实验环境

## Vivado 安装

请确保有足够的磁盘容量（约 40GB）。

???+ warning "如果官网下载失败"
    如果遇到使用 webpack 下载经常 retry 的情况，你可以在**校网**环境下使用 FTP 获得 2020.2 版本；

    FTP 地址为 ftp://10.78.18.205/

    FTP中有相关指导。为了防止传输中断导致的失败，请使用支持断点续传的 FTP 软件，比如 FileZilla。

💡请选择不低于 **2020.2** 的版本。

* 在官网提供的[下载网页](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html)中找到合适的版本(版本号；Windows/Linux)，选择“...Web Installer”（约300MB的文件）

* 打开下载安装程序，使用注册的 Xilinx 账号登陆，并选择 *Download and install now*
* 选择安装的软件 (Vivado) 、版本 (Vivado HL WebPACK)
* 选择需要的组件（以下为必须勾选）：Design Tools(Vivado Deign Suite, DocNav); Devices(Artix-7); Installation Options(Install Cable Drivers)。选择完成后查看磁盘空间，使用上述选择需要 30-40GB 空间用来安装
    * 如果你之后需要使用其他型号的设备，可以通过 installer 补充下载，不必要一次全部安装(可以查看 [Xilinx-Support-60112](https://support.xilinx.com/s/article/60112))
* 确保空间充足，开始下载，并等待安装结束

> 习惯使用 Linux 系统的同学可以安装 Linux 版本，WSL2 也可尝试安装。
>
> Vivado 安装路径上不要出现中文和空格。

## 环境配置（可选）

本学期实验可以使用 git 记录实验过程。

你需要在电脑上配置 `git`，可以参考[配置 git](https://www.windows11.pro/5639.html)。如果你之前从未使用过 git，可以查看“其他”中“[git 基础](../../Other/about_git/)”一节。配置完成后，可以新建仓库尝试一下简单操作。

使用 Vivado GUI 的 project 模式会使得 git 管理混乱，因为在使用 IP 核、仿真、综合等操作时会产生大量的中间文件，且无法简单地通过文件后缀名等方式分别。推荐使用 git 管理工程的同学使用 [batch mode](https://docs.xilinx.com/r/en-US/ug835-vivado-tcl-commands/Tcl-Batch-Mode)，它使用了 Tcl 脚本语言。一个容易上手的学习方式：使用 GUI 打开一个 Vivado 工程并进行若干操作后，工程目录下的 `vivado.jou` 会记录从打开工程到结束的各种操作对应的 Tcl 语句，更详细的内容可以参考[文档](https://docs.xilinx.com/r/en-US/ug835-vivado-tcl-commands/Tcl-Batch-Mode)。

## FAQ

### 安装找不到 *WebPack* 选项

选择 *Standard* 版本即可。 *Enterprise* 版本需要付费。

### Device 看不到 Artix-7 选项

展开 *7 Series*，在里面可以找到 A7 板。

### 追加设备

数逻使用 Vivado 的同学需要通过 installer 追加下载 A7 设备，否则无法完成板卡添加。

进入 Vivado，选择 `Help -> Add Design Tools or Devices`，在启动的 `xsetup` 中选择追加下载的型号，本课实验中需要下载 Artix-7。