# 基本 SCPU

!!! tip "[Lab4-0 附件](https://pan.zju.edu.cn/share/f8e25fa70962b721082cc31492)"

## 模块实现

本实验需要使用提供的 IP 核组成 SCPU，参考附件的电路图 [IP2CPU.pdf](./attachment/IP2CPU.pdf) 完成连线即可。

* 请下载附件里的 IP 核：SCPU_Ctrl，DataPath。
* 你需要将之前的 SCPU IP 核替换为你自己设计的 SCPU 模块。

## 仿真验证

仿真验证方式同 Lab2。

## 下板验证

验证方式同 Lab2，即使用之前实验的 Fibonacci 列进行简单测试。

!!! warning "本实验不需要验收。"

## 实验要求

本次实验你需要完成的内容有：

* 使用提供的 DataPath 和 CtrlUnit 的 IP 核组成 SCPU。
* 对实现的 CPU 进行仿真验证、下板验证。
* 实验报告里需要包含的内容：
    * SCPU 模块代码。
    * 仿真代码与波形截图（注意缩放比例、数制选择合适），并分析仿真波形。
    * 下板图片与现象描述。
