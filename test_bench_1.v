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
    wire [47:0] PCOUT_tb, P_tb;
    // Instantiation
    DSP48A1 #(
        .A0REG(1),
        .A1REG(1),
        .B0REG(1),
        .B1REG(1),
        .CREG(1),
        .DREG(1),
        .MREG(1),
        .PREG(1),
        .CARRYINREG(1),
        .CARRYOUTREG(1),
        .OPMODEREG(1),
        .CARRYINSEL("CARRYIN"),
        .B_INPUT("DIRECT"),
        .RSTTYPE("ASYNC")
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
        //test 1
        D=10;
        B=15;
        BCIN=20;
        A=8;
        C=10;
        OPMODE='b0001_1111;
        PCIN=0;
        CARRYIN=1;
        repeat(4) @(negedge CLK);
        $stop;

        

    end
endmodule
