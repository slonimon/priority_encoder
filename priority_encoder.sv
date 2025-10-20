module priority_encoder #(
  parameter WIDTH = 32
) (
  input logic clk_i,
  input logic srst_i,
  input logic data_val_i,
  input logic [WIDTH-1:0] data_i,

  output logic [WIDTH-1:0] data_left_o,
  output logic [WIDTH-1:0] data_right_o,
  output logic data_val_o
);

logic [WIDTH-1:0] revers_data_i;
logic [WIDTH-1:0] revers_data_o;
logic [WIDTH-1:0] data_i_ff;
logic [WIDTH-1:0] data_l_next;
logic [WIDTH-1:0] data_r_next;
logic data_val_ff;

always_ff @(posedge clk_i) begin 
  if (srst_i) begin
    data_val_ff <= 1'b0;
    data_i_ff   <= {WIDTH{1'b0}};
  end else if (data_val_i) begin
    data_i_ff   <= data_i;
    data_val_ff <= 1'b1;
  end else if (~data_val_i) begin
    data_val_ff <= 1'b0;
  end  
end

genvar i;
generate
  for (i = 0; i < WIDTH; i = i + 1) begin
    assign revers_data_i[WIDTH-1-i] = data_i_ff[i];
    assign data_l_next[WIDTH-1-i] = revers_data_o[i];
  end
endgenerate

assign  revers_data_o = revers_data_i & ~(revers_data_i - 1'b1);
assign  data_r_next = data_i_ff & ~(data_i_ff - 1'b1);

always_ff @(posedge clk_i) begin 
  if (srst_i) begin
    data_left_o  <= {WIDTH{1'b0}};
    data_right_o <= {WIDTH{1'b0}};
    data_val_o <= 1'b0;
  end else if (data_val_ff) begin
    data_left_o <= data_l_next;
    data_right_o <= data_r_next;
    data_val_o <= 1'b1;
  end else if (~data_val_ff) begin
    data_val_o <= 1'b0;
  end  
end
endmodule