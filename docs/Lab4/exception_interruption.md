# Exception & Interruption

<!-- !!! danger "本实验并未 release，内容随时都会变化。个人水平有限，如您发现文档中的疏漏欢迎 Issue！" -->

!!! danger "请先保存 Lab4-3 的工程文件"

## 前置知识

### Exception and Interruption

在标准中有对 exception 和 interruption 的解释：

> We use the term ***exception*** to refer to an unusual condition occurring at run time **associated with
an instruction** in the current RISC-V hart. We use the term ***interrupt*** to refer to an **external
asynchronous event** that may cause a RISC-V hart to experience an unexpected transfer of control.
We use the term ***trap*** to refer to **the transfer** of control to a trap handler caused by either an
exception or an interrupt.

为了方便文档描述，下文中我们用“中断”指代 *interruption*，用“异常”指代 *exception*，用 *trap* 表示中断与异常。

### Control and Status Registers(CSRs)

在 32 个通用寄存器之外（即 `x0 - x31`），还有若干*控制状态寄存器*(Control and Status Register, CSR)。在我们的实验中，CPU 始终运行在 Machine Mode 下，在本实验中我们只需要关注 Machine Mode 下的部分 CSR。

对于每个 CSR 的详细介绍，请查看 [Volume II: RISC-V Privileged Architectures V20240411](https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-382fd8b-2024-04-11/priv-isa-asciidoc.pdf)，这里仅对我们本次实验需要用到的 CSRs 进行简介：

* **mstatus**： Machine Status Register，存储当前控制状态。
    * ![](./pic/mstatus.png)
    * 本次实验中你可以做相对简化，只要可以保证在中断处理过程中不会触发新的中断即可。
* **mtvec**： Machine Trap-Vector Base-Address Register，存储中断向量表基地址。
    * ![](./pic/mtvec.png)
    * 低两位记录跳转模式，`0` 为 Direct 模式，即所有 trap 都先进入 `BASE`；`1` 为 Vectored 模式，将进入 `BASE + 4*cause`。高位记录的是 `BASE` 的值（请注意对齐，`BASE << 2` 才是真正要跳转的地址）。
    * 本次实验中，要求使用 Direct 模式。
* **mcause**： Machine Cause Register，存储引起这次 trap 的原因。
    * ![](./pic/mcause.png)
    * 如果进入 trap 的原因是中断，则最高位 interrupt bit 设置为 1，若为异常则设为 0。
    * 本次实验允许你自由的设计 Exception Code 的含义，在实验报告中说明即可。
* **mtval**： Machine Trap Value Register，存储异常的相关信息以帮助软件处理异常，曾称 mbadaddr。
    * ![](./pic/mtval.png)
* **mepc**： Machine Exception Program Counter，存储 trap 触发时将要执行的指令地址，在 `mret` 时作为返回地址。
    * ![](./pic/mepc.png)
    * 本次实验不涉及 PC 非对齐异常，因此不需要考虑将跳转指令的目标地址送入 `mepc` 的情况。
    * 需要注意的是，在一般的实现中，你需要在 trap 处理程序中检查 `mcause` 寄存器，如果是中断则更新 `mepc <- mepc + 4`，这部分不是你的硬件实现，而是由**软件（你的 trap 处理程序）进行管理**的。

## 模块实现

### CSR 寄存器及其指令

本实验需要修改 Lab4-3 中的 CPU，使其支持操作 CSR 寄存器。

需要支持的 CSR 寄存器有：`mstatus`, `mtvec`, `mcause`, `mtval`, `mepc`. 

需要实现的 CSR 相关指令有：`csrrw`, `csrrs`, `csrrc`, `csrrwi`, `csrrsi`, `csrrci`, `ecall`, `mret`.

CSR 指令相关含义请查看 [Volume II: RISC-V Privileged Architectures V20240411](https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-382fd8b-2024-04-11/priv-isa-asciidoc.pdf)， 也可见 [TonyCrane 的 RISC-V 特权级 ISA 笔记](https://note.tonycrane.cc/cs/pl/riscv/privileged/#csr-zicsr)。

具体来说，可以分为下面几步：

* 新建 CSR 模块，用于管理 CSR 寄存器的读写。（实现方式和寄存器堆类似）

    参考模块定义如下（你可能需要添加某些端口），同样地，你可以自行修改模块定义。
    ``` Verilog title="CSRRegs.v" linenums="1"
    module CSRRegs(
        input clk, rst,
        input[11:0] raddr, waddr,       // 读、写 CSR 寄存器的地址
        input[31:0] wdata,              // 写入 CSR 寄存器的数据
        input csr_w,                    // 写使能
        input[1:0] csr_wsc_mode,        // 写入 CSR 寄存器的模式
        output[31:0] rdata,             // 读出 CSR 寄存器的数据
    );
    ```

* 修改 CtrlUnit，增加 CSR 相关控制信号（如 CSR 寄存器的读写使能、CSR 寄存器的地址、写入 CSR 寄存器的模式等）。
* 修改 Datapath，增加 CSR 寄存器的读写逻辑。
* 在处理异常中断时，我们需要批量修改 CSR 寄存器。这可能需要修改 `CSRRegs` 的输入端口，你可以增加相关 CSR 的旁路输入，以及异常中断信号。当异常中断信号有效时，我们将旁路输入写到对应寄存器里。
    ``` Verilog linenums="1"
        ...
        input expt_int;                 // 是否有异常中断
        // 旁路输入
        input [31:0]mepc_bypasss_in,
        input [31:0]mscause_bypass_in,
        input [31:0]mtval_bypass_in,
        ... // mstatus 可以由外部输入，也可以在 CSR 模块内进行修改。
    ```


!!! Tips
    * 请注意设置 CSRs 的初始值（与寄存器不同，初始值不一定是全 0），并注意 `rst` 时恢复初始值。
    * 为了方便 debug，你可以修改异常中断处理模块的输出端口，将 `mstatus, mtvec, mcause, mtval, mepc` 或者其他 CSR 接出，并输入到 VGA 显示模块中，以便观察异常中断处理过程中 CSR 的变化。

### 异常中断处理

本实验需要修改 Lab4-3 中的 CPU，使其支持下面的 3 种中断异常：

* IO 外设产生的硬件**中断**（检测某个开关打开）
* 异常
    * 非法指令（未定义指令，即指令无法被正确译码）
    * `ecall` 指令（软件中断）

具体来说，可以分为下面几步：

* 首先要检测中断或者异常的发生。
    * 在 CtrlUnit 中可以检查 `ecall` 指令和非法指令，并传出相应信号。
    * 硬件中断通过顶层模块的输入传入。
* 检测到中断异常后，要阻止当前指令的执行。具体来说，就是要将当前的寄存器堆、内存等器件的写使能关闭。
* 保存中断异常的相关信息，包括 `mepc`, `mscause`, `mtval`，并修改 `mstatus`。
    * 更新 `mcause`，记录当前是不是中断，并记录 exception-code。
    * 更新 `mstatus`，防止在 trap 处理时又触发其他的 trap。
    * 更新 `mepc`，记录当前指令的地址，即 `mepc <- pc`。
    * 更新 `mtval`，记录错误信息（非法指令的内容，其他情况值任意）。
* 修改下一条要执行的 PC，使其指向 trap 处理程序的首条指令（即 `mtvec`）。
* trap 处理程序的部分由软件实现，具体要求可见下一部分。

中断处理主要是改变了**指令流**，由正常的指令运行切换到 trap 处理程序的执行，最终回到正常的指令流中继续执行。为此，我们需要设计一个模块，用来接收控制信号或外部信号，判断下一条要执行的指令是正常指令流运行还是 trap 处理的指令；同时，还需要修改 Datapath 以支持 PC 来源的改变。

```verilog title="RV_INT.v" linenums="1"
module RV_INT(
    input       clk,
    input       rst,
    input       INT,              // 外部中断信号
    input       ecall,            // ECALL 指令
    input       mret,             // MRET 指令
    input       illegal_inst,     // 非法指令信号
    input       l_access_fault,   // 数据访存不对齐
    input       j_access_fault,   // 跳转地址不对齐
    input [31:0] pc_current,      // 当前指令 PC 值
    output       en,              // 用于控制寄存器堆、内存等器件的写使能
    output[31:0] pc               // 将执行的指令 PC 值
);
```

这一模块中，你需要保存并管理 `mstatus, mtvec, mcause, mtval, mepc` 等 CSRs. 实现模块时，需要时刻注意：

* 如果正在进行 trap 处理程序（还未执行 `mret`），不接受其他 trap。
* 根据不同的中断信号，对 CSRs 进行修改。

!!! Tip
    * 因为我们没有实现用户态、特权态等功能，因此我们认为我们的代码都是跑在 Machine（M）模式下。
    * `mtvec` 的值要与你所写代码中 trap 处理程序首条指令位置相同，如果你改变了代码，需要检查是不是需要修改 `mtvec` 的值。
    * 对于外部中断，你需要在顶层模块中增加一个外部中断信号，并与某个不使用的开关绑定（修改引脚约束文件），通过 `CSSTE-SCPU-RV_INT` 传入异常中断处理模块。
    * 你可以在 `RV_INT` 模块里实例化 `CSRRegs` 模块，也可以选择分别实例化。修改 CSR 时你可以采用旁路输入的方法统一修改，也可以自己设计一个状态机，模拟 CSR 指令，每个周期执行一条 CSR 指令来修改对应的寄存器。

### 软件实现

你需要自行实现 trap 处理程序。我们要求**在软件中实现**：

* 读出 `mepc`, `mscause`, `mtval`, `mstatus`, `mtvec` 的值，放在某个寄存器当中。为了防止通用寄存器中的有效值丢失，最好选择在之前代码里未被使用的寄存器。
* 将 `mepc` 读出，处理 `mepc`：
    * 对于异常（非法指令与 `ecall`），`mepc <- mepc + 4`。
    * 对于中断，`mepc <- mepc`。（请使用 `mcause` 进行区分）
* 调用 `mret` 返回到原来的程序。（此时要恢复进入处理程序所保存的信息）
* 对于非法指令、`ecall` 与外部中断，你**不需要**在 trap 处理程序中进行其他如修正非法指令这样的处理，执行完上述操作即可。

除了 trap 处理程序，你还需要在程序开头通过 CSR 指令设置 `mtvec` 的值，使得发生异常中断时我们的程序能够跳转到 trap 处理程序。

!!! Tip
    * Venus 平台无法为你解析 `mret`，请自行书写，并注意 trap 中断处理程序的结尾一定要有 `mret`。
        * 为了不修改 trap 处理程序的跳转指令，你可以在原本 `mret` 的地方写一条 NOP 语句 `add x0, x0, x0` 来占一条指令的位置，在之后将它替换为 `mret`。
    * 在实际操作系统的 trap 处理中，我们会在进入 trap 处理程序之前，通过汇编代码将所有的通用寄存器保存在栈上，在退出 trap 处理程序时将所有的通用寄存器值恢复，这样我们在处理程序里可以使用任意的通用寄存器。本节实验你也可以这样做。更简单的做法是你直接选择在处理程序外没有被使用过的寄存器即可。

## 波形仿真

自行书写完整的测试代码，要求包括下面的内容：

* trap 处理程序。
* 使用 CSR 指令设置 `mtvec` 的值。
* 所有涉及到 CSR 操作的指令（`csrrw`, `csrrs`, `csrrc`, `csrrwi`, `csrrsi`, `csrrci`, `ecall`, `mret`）。
* 非法指令。
* `ecall` 指令。

对测试代码进行仿真。

## 下板验证

对测试代码进行下板验证。

!!! Tip
    * 不要忘记还有外部中断的测试。

!!! warning "本实验需要验收"

## 实验要求

* 根据实验指导，实现 CSR 指令和异常中断处理。
* 对实现的 CPU 进行仿真验证、下板验证、验收。
* 实验报告里需要包含的内容：
    * CSR 模块代码和异常中断处理代码，并解释模块逻辑。（其中需要解释 `mcause` 的设计）
    * 仿真代码与波形截图（注意缩放比例、数制选择合适），并分析仿真波形。 
    * 下板图片与现象描述。
    * 思考题。

## Lab4 思考题

这么重要的实验怎么能没有

!!! question "思考题(呢？)"
    * 在涉及到一个大立即数的读入时，我们经常能想到使用 `lui & addi` 来实现，比如下面这段代码就将 `0x22223333` 赋给了 `t0`:
    ```
    lui t0, 0x22223
    addi t0, t0, 0x333
    ```
    你是否能通过以下代码得到 `0xDEADBEEF`？如果你觉得不能的话，先解释为什么不能，再修改代码中的**一个字符**，使得以下代码有效地得到 `0xDEADBEEF`。（如果你觉得可以的话，请重新学习 [RISC-V ISA](https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-382fd8b-2024-04-11/unpriv-isa-asciidoc.pdf)）
    ```
    lui t1, 0xDEADB
    addi t1, t1, -273 // 0xEEF
    ```