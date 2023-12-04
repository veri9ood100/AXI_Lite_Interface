`timescale 1ns / 1ps

module tb_top();

parameter REG_WIDTH = 32;

//global signal
reg ACLK0;
reg ACLK1;//for test CDC
reg ARESETN;

//module read port
reg MOD_2_M_RRQST;
reg [REG_WIDTH-1:0] MOD_2_M_RADDR;
wire [REG_WIDTH-1:0] M_2_MOD_RDATA;

//read address channel
wire [REG_WIDTH-1:0]ARADDR;
wire ARVALID;
wire ARREADY;

//read data channel
wire [REG_WIDTH-1:0] RDATA;
//input RRESP,
wire RVALID;
wire RREADY;

//write address tb stimulus
reg MOD_2_M_WARQST;
reg [REG_WIDTH -1:0]MOD_2_M_WADDR;

//write address channel
wire AWREADY;
wire [REG_WIDTH-1:0]AWADDR;
wire AWVALID;

//write data tb stimulus
reg MOD_2_M_WRQST;
reg [REG_WIDTH -1:0]MOD_2_M_WDATA;

//write data channel
wire WREADY;
wire [REG_WIDTH -1:0]WDATA;
wire WVALID;

//write response tb stimuli
wire M_2_MOD_WRESULT;

//write response channel
wire BVALID;
wire BREADY;
    
Master_Interface MI(
    //global signal
    .ACLK(ACLK0),
    .ARESETN(ARESETN),
    //read channel port
    .MOD_2_M_RRQST(MOD_2_M_RRQST),
    .MOD_2_M_RADDR(MOD_2_M_RADDR),
    .M_2_MOD_RDATA(M_2_MOD_RDATA),
    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),
    .RDATA(RDATA),
    .RVALID(RVALID),
    .RREADY(RREADY),
    //write channel port
    .MOD_2_M_WARQST(MOD_2_M_WARQST),
    .MOD_2_M_WADDR(MOD_2_M_WADDR),
    .AWREADY(AWREADY),
    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    .MOD_2_M_WRQST(MOD_2_M_WRQST),
    .MOD_2_M_WDATA(MOD_2_M_WDATA),
    .WREADY(WREADY),
    .WDATA(WDATA),
    .WVALID(WVALID),
    .M_2_MOD_WRESULT(M_2_MOD_WRESULT),
    .BVALID(BVALID),
    .BREADY(BREADY)
);

Slave_Interface SI(
    //global signal
    .ACLK(ACLK0),
    .ARESETN(ARESETN),
    //read channel
    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),
    .RDATA(RDATA),
    .RVALID(RVALID),
    .RREADY(RREADY),
    //write channel
    .AWREADY(AWREADY),
    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    //.MOD_2_S_WRQST(MOD_2_S_WRQST),
    //.S_2_MOD_WDATA(S_2_MOD_WDATA),
    .WREADY(WREADY),
    .WDATA(WDATA),
    .WVALID(WVALID),
    //.MOD_2_S_WRESULT(MOD_2_S_WRESULT),
    .BVALID(BVALID),
    .BREADY(BREADY)
);

//generate clock
always #10 ACLK0 <= ~ACLK0;
always #33 ACLK1 <= ~ACLK1; 

initial begin
    ACLK0 <= 0;
    ACLK1 <= 0;
    ARESETN <= 0; //reset on
    //read channel stimulus
    MOD_2_M_RRQST <= 0;
    MOD_2_M_RADDR <= 0;
    //writec channel stimulus
    MOD_2_M_WARQST <= 0;
    MOD_2_M_WADDR <= 0;
    MOD_2_M_WRQST <= 0;
    MOD_2_M_WDATA <= 0;
    
    #50 ARESETN <=1; //reset off
    
    #10 MOD_2_M_RRQST <= 1;
        MOD_2_M_RADDR <= 15;
        MOD_2_M_WARQST <= 1;
        MOD_2_M_WADDR <= 10;
        MOD_2_M_WRQST <= 1;
        MOD_2_M_WDATA <= 'h2564;
end

initial begin
    #300 $finish;
end

always @(posedge ACLK0) begin
    if(MOD_2_M_RRQST && ARREADY) begin
        MOD_2_M_RRQST <= 0;
        MOD_2_M_RADDR <= 0;
    end
end

always @(posedge ACLK0) begin
    if(MOD_2_M_WARQST && MOD_2_M_WRQST && AWREADY && WREADY) begin
        MOD_2_M_WARQST <= 0;
        MOD_2_M_WADDR <= 0;
        MOD_2_M_WRQST <= 0;
        MOD_2_M_WDATA <= 0;
    end
end

endmodule
