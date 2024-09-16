# Lab5

<!-- !!! danger "实验 5 并未 release，内容随时都会变化。个人水平有限，如您发现文档中的疏漏欢迎 Issue！" -->

本次实验你需要在 **Lab4-3**（即实现了 RISC-V 32I 指令集的所有指令，但不需要支持中断） 的基础上实现五级流水线 CPU。实验分为两大部分：

* Lab5-1：实现不处理冲突 (Hazard) 的五级流水线 CPU。
* Lab5-2：实现解决冲突的五级流水线 CPU。

如果你对自己的能力有信心，可以选择跳过 Lab5-1，直接完成 Lab5-2，通过 Lab5-2 后无需再完成 Lab5-1。如果你选择直接完成 Lab5-2，建议先通读 Lab5-1、Lab5-2 的文档。

请修改 VGA 模块或串口模块，将阶段寄存器存储的信号打印出来，[VGA 附件](./attachment/VGA.zip)。

使用 VGA 可能出现各种问题，这里提供基于 UART 的调试模块 [Lab5_UART](./attachment/Lab5_UART.zip) 替代 VGA。感谢 22 级图灵班[薛辰立](https://github.com/wxxcl0825)同学的大力协助！

!!! warning "本实验需要提交实验报告（Lab5 的两个小实验合成一份提交）"

!!! warning "本实验需要验收"