module DSP48A1 #(
    //PARAMETERS
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,

    parameter CREG = 1,    
    parameter DREG = 1,    
    parameter MREG = 1,    
    parameter PREG = 1,    
    parameter CARRYINREG = 1,    
    parameter CARRYOUTREG = 1,    
    parameter OPMODEREG = 1,

    parameter CARRYINSEL = "OPMODE5",

    parameter B_INPUT = "DIRECT",

    parameter RSTTYPE = "SYNC"    
)(
    //INPUTS
    input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
    input CEA ,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
    input [7:0] OPMODE,
    input [17:0] A,B,D,BCIN,
    input [47:0] C,PCIN,
    //OUTPUTS
    output CARRYOUT,CARRYOUTF,
    output [17:0]BCOUT,
    output [35:0] M,
    output [47:0]PCOUT,P
);
//WIRES
    //1st stage wires
    wire [7:0] OPMODE_mux_out;
    wire [17:0] D_mux_out,B_mux_in1,B_mux_out1,A_mux_out1;
    wire [47:0] C_mux_out;
    //2nd stage wires
    wire [17:0] pre_add_sub_out,pre_add_sub_mux_out;
    //3rd stage wires 
    wire [17:0] B_mux_out2,A_mux_out2;
    //4th stage wires
    wire [35:0] mult_out;
    wire carry_mux_in;
    //5th stage wires
    wire [35:0] M_mux_out;
    wire carry_mux_out;
    //6th stage wires
    wire [47:0] X_mux_out,Z_mux_out;
    //7th stage wires
    wire [47:0] post_add_sub_out;
    wire post_add_sub_out_COUT;

//1st Stage: Register and Mux for inputs D, B, A, C, and OPMODE
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(18)) D_REG (.REG(DREG),.CEN(CED),.CLK(CLK),.RST(RSTD),.IN(D),.OUT(D_mux_out));
assign B_mux_in1 = (B_INPUT == "DIRECT")? B : (B_INPUT == "CASCADE")? BCIN : 0;
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(18)) B0_REG (.REG(B0REG),.CEN(CEB),.CLK(CLK),.RST(RSTB),.IN(B_mux_in1),.OUT(B_mux_out1));
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(18)) A0_REG (.REG(A0REG),.CEN(CEA),.CLK(CLK),.RST(RSTA),.IN(A),.OUT(A_mux_out1));
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(48)) C_REG (.REG(CREG),.CEN(CEC),.CLK(CLK),.RST(RSTC),.IN(C),.OUT(C_mux_out));
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(8)) OPMODE_REG (.REG(OPMODEREG),.CEN(CEOPMODE),.CLK(CLK),.RST(RSTOPMODE),.IN(OPMODE),.OUT(OPMODE_mux_out));

//2nd Stage: Pre-adder/subtractor and Mux
assign pre_add_sub_out = (OPMODE_mux_out[6])? D_mux_out-B_mux_out1 : D_mux_out+B_mux_out1;
assign pre_add_sub_mux_out = (OPMODE_mux_out[4])? pre_add_sub_out : B_mux_out1;

//3rd Stage: Register for B and A after pre-adder/subtractor
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(18)) B1_REG (.REG(B1REG),.CEN(CEB),.CLK(CLK),.RST(RSTB),.IN(pre_add_sub_mux_out),.OUT(B_mux_out2));
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(18)) A1_REG (.REG(A1REG),.CEN(CEA),.CLK(CLK),.RST(RSTA),.IN(A_mux_out1),.OUT(A_mux_out2));

//4th Stage: Multiplier and Carry-in Mux
assign BCOUT = B_mux_out2;
assign mult_out = A_mux_out2 * B_mux_out2;
assign carry_mux_in = (CARRYINSEL == "CARRYIN")? CARRYIN : (CARRYINSEL == "OPMODE5")? OPMODE_mux_out[5] : 0;

//5th Stage: Register for Carry-in and Multiplier output
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(1)) CYI_REG (.REG(CARRYINREG),.CEN(CECARRYIN),.CLK(CLK),.RST(RSTCARRYIN),.IN(carry_mux_in),.OUT(carry_mux_out));
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(36)) M_REG (.REG(MREG),.CEN(CEM),.CLK(CLK),.RST(RSTM),.IN(mult_out),.OUT(M_mux_out));
assign M = ~(~M_mux_out);

//6th Stage: Mux for X and Z inputs to the final adder/subtractor
assign X_mux_out = (OPMODE_mux_out[1:0]==2'b00)? 48'b0:(OPMODE_mux_out[1:0]==2'b01)? {12'b0,M_mux_out}:(OPMODE_mux_out[1:0]==2'b10)? PCOUT:{D_mux_out[11:0],A_mux_out1,B_mux_out1};
assign Z_mux_out = (OPMODE_mux_out[3:2]==2'b00)? 48'b0:(OPMODE_mux_out[3:2]==2'b01)? PCIN:(OPMODE_mux_out[3:2]==2'b10)? PCOUT:C_mux_out;

//7th Stage: Final adder/subtractor and output registers
assign {post_add_sub_out_COUT,post_add_sub_out} = (OPMODE_mux_out[7])? (Z_mux_out-(X_mux_out+{47'b0,carry_mux_out})): (Z_mux_out+X_mux_out+{47'b0,carry_mux_out});
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(1)) CARRY_REG (.REG(CARRYOUTREG),.CEN(CECARRYIN),.CLK(CLK),.RST(RSTCARRYIN),.IN(post_add_sub_out_COUT),.OUT(CARRYOUT));
assign CARRYOUTF = CARRYOUT;
param_mux #(.RSTTYPE(RSTTYPE),.WIDTH(48)) P_REG (.REG(PREG),.CEN(CEP),.CLK(CLK),.RST(RSTP),.IN(post_add_sub_out),.OUT(P));
assign PCOUT=P;
endmodule

