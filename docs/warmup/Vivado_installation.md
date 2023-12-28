# Vivado安装

请确保有足够的磁盘容量。（约40GB）

???+ warning "追加"
    如果使用 webpack 下载经常遇到需要 retry 的情况，你可以在**校网**环境下使用 FTP 获得 2020.2 版本；

    FTP 地址为 ftp://10.78.18.205/

    FTP中有相关指导。为了防止传输中断导致的失败，请使用支持断点续传的 FTP 软件，比如 FileZilla。

💡请选择不低于 **2020.2** 的版本

* 在官网提供的[下载网页](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html)中找到合适的版本(版本号；Windows/Linux)，选择“...Web Installer”（约300MB的文件）。

* 打开下载安装程序，使用注册的Xilinx账号登陆，并选择“Download and install now”
* 选择安装的软件 (Vivado) 、版本 (Vivado HL WebPACK)
* 选择需要的组件（以下为必须勾选）：Design Tools (Vivado Deign Suite, DocNav); Devices (Kintex-7); Installation Options (Install Cable Drivers)。选择完成后查看磁盘空间，使用上述选择需要30-40GB空间用来安装
    * 如果你之后需要使用其他型号的设备，可以通过 installer 补充下载，不必要一次全部安装(可以查看 [Xilinx-Support-60112](https://support.xilinx.com/s/article/60112))
* 确保空间充足，开始下载，并等待安装结束

> 习惯使用 Linux 系统的同学可以安装 Linux 版本，WSL2 也可尝试安装。
>
> Vivado 安装路径上不要出现中文和空格。

## FAQ

### 安装找不到 *WebPack* 选项

选择 *Standard* 版本即可。 *Enterprise* 版本需要付费。

### Device 看不到 Kintex-7 选项

展开 *7 Series*，在里面可以找到 K7 板。