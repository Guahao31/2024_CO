# Finite State Machine

Finite State Machine（FSM，有限状态机）是在有限个状态之间按照一定规律转换状态（并给出输出）的时序电路。 FSM 是数逻重点部分，如果印象模糊请认真复习数逻对应部分，在此不赘述。

本节实验要求使用 Verilog 等 HDL 设计“测谎仪”的一部分。

## 问题叙述

“测谎仪”接收一段叙述，给出结果“可信”或“不可信”。在设计“测谎仪”功能时，我们可以将它拆分为两个模块，真实分析器(TruthAnalyzer)和信任评估器(TruthEvaluator)。**真实分析器**获得一段输入，内部进行分析后，给出“可以信任”或“可能说谎”的判断；**信任评估器**根据应答者的回答诚信度历史以及本次真实分析器的判断，给出最终的判断。其模式图如下：

<img src="../../pic/LieDetector.png">

**本次实验要求**完成信任评估器的模块设计。模块名与端口名如下：

```verilog
module TruthEvaluator(
    input  clk,
    input  truth_detection,
    output trust_decision
);
```

我们规定其**输入** `truth_detection` 为 `1` 时表示真实分析器给出的结果是“可以信任”，否则是“可能说谎”；其**输出** `trust_decision` 在信任评估器认为“可信”时为 `1`，否则为 `0`。

为了简化设计，我们规定信任评估器的行为如下所述：

* **内部状态**有 4 个 `HIGHLY_TRUSTWORTHY, TRUSTWORTHY, SUSPICIOUS, UNTRUSTWORTHY`，分别表示“非常可信”、“可信”、“可疑”、“不可信”
    * 初始内部状态为“非常可信” `HIGHLY_TRUSTWORTHY`
* **状态转移**每次时钟上升沿，根据输入 `truth_detection` 的值
    * 为 `1` 时，状态向“更加信任”的方向转移
        * `HIGHLY_TRUSTWORTHY` 则保持状态为 `HIGHLY_TRUSTWORTHY`
        * `TRUSTWORTHY` 则转移为 `HIGHLY_TRUSTWORTHY`
        * `SUSPICIOUS` 则转移为 `TRUSTWORTHY`
        * `UNTRUSTWORTHY` 则转移为 `SUSPICIOUS`
    * 为 `0` 时，状态向“更加怀疑”的方向转移，与上述类似但方向相反，在此不再赘述
* **输出判断**仅与当前状态有关
    * 状态为 `HIGHLY_TRUSTWORTHY, TRUSTWORTHY` 时输出 `trust_decision` 为 `1`
    * 状态为 `SUSPICIOUS, UNTRUSTWORTHY` 时输出 `trust_decision` 为 `0`

!!! question "思考题"
    请根据以上要求，完成信任评估器的**状态转移图**，你可以纸笔书写并拍照，或使用 drawio 等工具绘图。

## 模块实现

!!! note "报告中需要给出你写出的完整代码。"

**三段式描述**：将*输出信号*与*状态跳转*分开描述，状态跳转用组合逻辑来控制。

根据你绘制的状态图，使用三段式描述完成序列检测的任务。

你的代码主体将主要分为以下几个部分：

* 第一段主要用来控制时序，保证下一个时钟上升沿完成状态转移，同时需要注意重置时将状态变为起始状态；
* 第二段使用组合逻辑，主要是根据现态和输入决定次态，为此你可能需要使用 `case` 关键词；
* 第三段决定输出，根据你的状态转移图，将所有输出为1的状态取或即可，类似于 `assign out = (Q1 == curr_state) || (Q2 == curr_state);`。

```verilog linenums="1" title="seq.v"
module seq(
	input clk,
	input reset,
	input in,
	output out
);
// State definition
  localparam 
    Q1 = ...,
    Q2 = ...,
    ...;

// First segment: state transfer
  always @(posedge clk or posedge rst) begin
        ...
  end

// Sencond segment: transfer condition
  always @(*) begin // combination logic
    case(curr_state)
      Q1: begin
        if(1'b0 == input) next_state = ...;
        else next_state = ...;
      end
      ...
      default: next_state = ...;
    endcase
  end

// Third segment: output
  ...

endmodule
```

## 仿真测试

!!! note "报告中需要给出 testbench 代码，测试波形与解释（波形截图需要保证缩放与变量数制合适）。"

附件 `seq_moore/seq_moore_tb.v` 已经给出了基本的测试代码，但是它有点冗长了，

???+ question "思考题"
    请你修改测试代码，使得给定一个特定输入序列 `reg[31:0] input_seq = 32'hD72DBEEF` 从高位到低位依次输入到 `seq` 子模块中。你可以用任何能够使代码更简洁的写法，本题意在考察对 Verilog 语法的熟悉程度。（Hint：如果你没有思路，可以搜索 `for loop`；还可以用位运算的方式“一次”处理一位）
    !!! note "你需要在报告中给出修改后的测试代码，并用 `32'hD72DBEEF` 作为输入序列进行测试，给出测试波形。"