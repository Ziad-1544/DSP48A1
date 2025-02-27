module param_mux #(
    parameter RSTTYPE = "SYNC",
    parameter WIDTH = 1 

) (
    input CEN,CLK,RST,REG,
    input [WIDTH-1:0] IN,
    output [WIDTH-1:0] OUT
);
reg [WIDTH-1:0] OUT_reg;
reg [WIDTH-1:0] OUT_DIRECT;
generate
    if(RSTTYPE =="SYNC")begin
        always @(posedge CLK ) begin
            if(RST)begin
                OUT_reg <= 0;
            end
            else if(CEN)begin 
                OUT_reg <= IN ;
            end
        end
    end
    else if(RSTTYPE == "ASYNC")begin
        always @(posedge CLK or posedge RST) begin
            if(RST)begin
                OUT_reg <= 0;
            end
            else if (CEN) begin
                OUT_reg <= IN ;
            end
        end
    end
endgenerate
always @(*) begin
        OUT_DIRECT = IN;
    end
assign OUT =(REG)?OUT_reg:OUT_DIRECT;
endmodule