module DSP48A1_tb ();
    reg CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE;
    reg CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
    reg [7:0] OPMODE;
    reg [17:0] A, B, D, BCIN;
    reg [47:0] C, PCIN;
    // OUTPUTS
    wire CARRYOUT_tb, CARRYOUTF_tb;
    wire [17:0] BCOUT_tb;
    wire [35:0] M_tb;
    wire [47:0] P_tb;
    wire [47:0] PCOUT_tb;
    // Instantiation
    DSP48A1 #(
        .A0REG(0),
        .A1REG(0),
        .B0REG(0),
        .B1REG(0),
        .CREG(0),
        .DREG(0),
        .MREG(0),
        .PREG(1),
        .CARRYINREG(0),
        .CARRYOUTREG(0),
        .OPMODEREG(0),
        .CARRYINSEL("OPMODE5"),
        .B_INPUT("CASCADE"),
        .RSTTYPE("SYNC")
    ) DUT (
        .CLK(CLK),
        .CARRYIN(CARRYIN),
        .RSTA(RSTA),
        .RSTB(RSTB),
        .RSTM(RSTM),
        .RSTP(RSTP),
        .RSTC(RSTC),
        .RSTD(RSTD),
        .RSTCARRYIN(RSTCARRYIN),
        .RSTOPMODE(RSTOPMODE),
        .CEA(CEA),
        .CEB(CEB),
        .CEM(CEM),
        .CEP(CEP),
        .CEC(CEC),
        .CED(CED),
        .CECARRYIN(CECARRYIN),
        .CEOPMODE(CEOPMODE),
        .OPMODE(OPMODE),
        .A(A),
        .B(B),
        .D(D),
        .BCIN(BCIN),
        .C(C),
        .PCIN(PCIN),
        .CARRYOUT(CARRYOUT_tb),
        .CARRYOUTF(CARRYOUTF_tb),
        .BCOUT(BCOUT_tb),
        .M(M_tb),
        .PCOUT(PCOUT_tb),
        .P(P_tb)
    );
    initial begin
        CLK=0;
        forever begin
            #1 CLK = ~CLK;
        end
    end
    initial begin
        CECARRYIN=1;
        CEOPMODE=1;
        CEA =1;
        CEB =1;
        CEM =1;
        CEP =1;
        CEC =1;
        CED =1;
        RSTA = 0;
        RSTB = 0;
        RSTM = 0;
        RSTP = 0;
        RSTC = 0;
        RSTD = 0;
        RSTCARRYIN = 0;
        RSTOPMODE = 0;
        @(negedge CLK);
        RSTA = 1;
        RSTB = 1;
        RSTM = 1;
        RSTP = 1;
        RSTC = 1;
        RSTD = 1;
        RSTCARRYIN = 1;
        RSTOPMODE = 1;
        @(negedge CLK);
        RSTA = 0;
        RSTB = 0;
        RSTM = 0;
        RSTP = 0;
        RSTC = 0;
        RSTD = 0;
        RSTCARRYIN = 0;
        RSTOPMODE = 0;
        //--------------
        //test 3
        D=10;
        B=15;
        BCIN=20;
        A=8;
        C=10;
        OPMODE='b0001_0000;
        PCIN=30;
        CARRYIN=1;
        repeat(1) @(negedge CLK);
        OPMODE='b0001_1110;
        repeat(4) @(negedge CLK);
        $stop;
    end
endmodule
