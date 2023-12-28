# RISC-V Decoder 与 CPU Testbench

## Venus

[Venus](https://venus.cs61c.org/) 平台是 CS61C 课程开放的 RISC-V 线上平台。我们可以在 Venus 上将我们书写的汇编代码转为机器码，或运行查看指令流动与寄存器值。

在 `Editor` 中输入你的代码。

在 `Simulator` 中点击 `Assemble & Simulate from Editor` 按钮，此时你将在界面中看到你输入的代码、对应的 PC 值与机器码等信息。如果你又在 `Editor` 中修改了代码，可以点击 `Re-assemble from Editor` 获得新的内容。

为获得机器码，在 `Simulator` 中点击 `dump`，下方 console 会得到机器码，点击 `Download!` 或拷贝即可。

## xg 还是你 xg

[@TonyCrane](https://github.com/TonyCrane) 基于 CyberChef 所做扩展，可以支持我们需要的指令 decode（暂时不支持 label 的使用），它部署在[这里](https://lab.tonycrane.cc/CyberChef)。拖动 `TonyCrane Extensions` 下的 `RISC-V Encode` 到 `Recipe` 中，选择 `Hex string` 输出模式即可。

## TestBench

为了方便在仿真时直接查看对应的指令，你可以使用新的 [Python code](./attachment/testbench_gen.py) 快速生成需要的 `testbench` 模块，请注意：**这份 python code 可能存在问题，如发现问题欢迎 Issue**！

通过 Python code，你可以得到一份类似下方代码的 `testbench module`：

```verilog title="Generated_testbench.v"
// Generated code
module testbench(
    input clk,
    input rst
);

    /* SCPU 中接出 */
    wire [31:0] Addr_out;
    wire [31:0] Data_out;       
    wire        CPU_MIO;
    wire        MemRW;
    wire [31:0] PC_out;
    /* RAM 接出 */
    wire [31:0] douta;
    /* ROM_in_testbench 接出 */
    wire [31:0] spo;
    wire [8*30:1] inst_msg;

    SCPU u0(
        .clk(clk),
        .rst(rst),
        .Data_in(douta),
        .MIO_ready(CPU_MIO),
        .inst_in(spo),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .CPU_MIO(CPU_MIO),
        .MemRW(MemRW),
        .PC_out(PC_out)
    );

    RAM_B u1(
        .clka(~clk),
        .wea(MemRW),
        .addra(Addr_out[11:2]),
        .dina(Data_out),
        .douta(douta)
    );

    ROM_in_testbench u2(
        .a(PC_out[11:2]),
        .spo(spo),
        .inst_msg(inst_msg)
    );

endmodule // tesebench

module ROM_in_testbench(
    input [9:0] a,
    output [31:0] spo,
    output [8*30:1] inst_msg
);
    reg[8*30:1] inst_string[0:9];
    reg[31:0] inst [0:1023];

    assign spo = inst[a];
    assign inst_msg = inst_string[a];

    // Initial inst
	initial begin
		inst[0]	 <= 32'h3E810093;
		inst[1]	 <= 32'h00A14093;
		inst[2]	 <= 32'h00116093;
		inst[3]	 <= 32'h00017093;
		inst[4]	 <= 32'h01411093;
		inst[5]	 <= 32'h00515093;
		inst[6]	 <= 32'h41815093;
		inst[7]	 <= 32'hFFF12093;
		inst[8]	 <= 32'h3FF13093;
		inst[9]	 <= 32'h0E910083;
	end

	// Initial inst_string
	initial begin
		inst_string[0]	 <= "addi x1, x2, 1000";
		inst_string[1]	 <= "xori x1, x2, 10";
		inst_string[2]	 <= "ori x1, x2, 1";
		inst_string[3]	 <= "andi x1, x2, 0";
		inst_string[4]	 <= "slli x1, x2, 20";
		inst_string[5]	 <= "srli x1, x2, 5";
		inst_string[6]	 <= "srai x1, x2, 24";
		inst_string[7]	 <= "slti x1, x2, -1";
		inst_string[8]	 <= "sltiu x1, x2, 1023";
		inst_string[9]	 <= "lb x1, 233(x2)";
	end

endmodule // ROM_in_test
```

在新的 `testbench` 模块中，我们书写了一个新的 `ROM` 模块，用来减少重复生成 ROM 核的麻烦，但是在你准备下板时，还需要将 ROM 核使用验收代码初始化文件进行初始化，得到 `ROM_B` 模块。