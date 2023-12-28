module multiplier(
  input clk,
  input start,
  input[31:0] A,
  input[31:0] B,
  output reg finish,
  output reg[63:0] res
);

  reg state; // 记录 multiplier 是不是正在进行运算
  reg[31:0] multiplicand; // 保存当前运算中的被乘数

  reg[4:0] cnt; // 记录当前计算已经经历了几个周期（运算与移位）
  wire[5:0] cnt_next = cnt + 6'b1;

  reg sign = 0; // 记录当前运算的结果是否是负数

  initial begin
    res <= 0;
    state <= 0;
    finish <= 0;
    cnt <= 0;
    multiplicand <= 0;
  end

  always @(posedge clk) begin
    if(~state && start) begin
      // Not Running
      sign <= ...;
      multiplicand <= ...;
      res <= ...;
      state <= ...;
      finish <= ...;
      cnt <= ...;
    end else if(state) begin
      // Running
      // Why not "else"?
      // 你需要在这里处理“一次”运算与移位
      cnt <= ...;
      res <= ...;
    end

    // 填写 cnt 相关的内容，用 cnt 查看当前运算是否结束
    if(...) begin
      // 得到结果
      cnt <= ...;
      finish <= ...;
      state <= ...;
      res <= ...;
    end
  end

endmodule