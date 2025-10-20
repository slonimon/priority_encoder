`timescale 1us / 100 ps

module testbench();

parameter T = 2;
parameter WIDTH = 5;
parameter NUM_OF_WORDS = 10;

integer i;

logic clk_i;
logic srst_i;
logic data_val_i;
logic [WIDTH-1:0] data_i;

logic [WIDTH-1:0] data_left_o;
logic [WIDTH-1:0] data_right_o;
logic data_val_o;

logic ref_test_data_val_i [NUM_OF_WORDS-1:0];
logic [WIDTH-1:0] ref_test_data_i [NUM_OF_WORDS-1:0];
logic [WIDTH-1:0] ref_test_data_left_o [NUM_OF_WORDS-1:0];
logic [WIDTH-1:0] ref_test_data_right_o [NUM_OF_WORDS-1:0];


priority_encoder #(
  .WIDTH(WIDTH)
) priority_encoder_test (
  .clk_i       (clk_i        ),
  .srst_i      (srst_i       ),
  .data_val_i  (data_val_i   ),
  .data_i      (data_i       ),
  .data_left_o (data_left_o  ),
  .data_right_o(data_right_o ),
  .data_val_o  (data_val_o   )
);

initial begin
  clk_i = 1'b0;
  forever #(T/2) clk_i = ~clk_i;
end
initial begin
  srst_i = 1'b1;
  #(2*T);
  srst_i = 1'b0;
end

initial begin

  wait (srst_i  == 1'b0);
  #(T/2);
  
  $readmemb("D:/NIR/Source_Code/Priority_Encoder/ref_test_data_i.txt", ref_test_data_i);
  $readmemb("D:/NIR/Source_Code/Priority_Encoder/ref_test_data_left_o.txt", ref_test_data_left_o);
  $readmemb("D:/NIR/Source_Code/Priority_Encoder/ref_test_data_right_o.txt", ref_test_data_right_o);
  $readmemb("D:/NIR/Source_Code/Priority_Encoder/ref_test_data_val_i.txt", ref_test_data_val_i);

  for (i = 0; i < NUM_OF_WORDS; i = i + 1) begin
      data_i = ref_test_data_i[i];
      data_val_i = ref_test_data_val_i[i];
      #(T);
      $monitor("data_i=%b, data_left_o=%b, ref_test_data_left_o=%b, data_right_o=%2b , ref_test_data_right_o=%2b\n",
          data_i, data_left_o, ref_test_data_left_o[i], data_right_o, ref_test_data_right_o[i]);
  end 
  #(2*T)

  $monitor("data_i=%b, data_left_o=%b, data_right_o=%2b \n", data_i, data_left_o, data_right_o);
  
  #(2*T)
  data_i = 5'b11111;
  data_val_i = 1'b1;
  #(T);
  data_i = 5'b00000;
  data_val_i = 1'b1;

  #(T);
  data_val_i = 1'b1;
  data_i = 5'b00100;
  #(T);
  data_val_i = 1'b1;
  data_i = 5'b00110;

  #(T);
  data_val_i = 1'b0;
  data_i = 5'b01110;
  #(T);
  data_val_i = 1'b1;
  data_i = 5'b00101;
  
  #(T);
  data_val_i = 1'b0;
  data_i = 5'b01010;
  #(T);
  data_val_i = 1'b1;
  data_i = 5'b00001;
  #(T);
  data_val_i = 1'b1;
  data_i = 5'b10000;
  
  $display("finished OK!");
end

endmodule