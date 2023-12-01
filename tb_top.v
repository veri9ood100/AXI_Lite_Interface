`timescale 1ns / 1ps

module tb_top();

parameter REG_WIDTH = 32;

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
    
Master_Interface MI(
    .ACLK(ACLK0),
    .ARESETN(ARESETN),
    .MOD_2_M_RRQST(MOD_2_M_RRQST),
    .MOD_2_M_RADDR(MOD_2_M_RADDR),
    .M_2_MOD_RDATA(M_2_MOD_RDATA),
    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),
    .RDATA(RDATA),
    .RVALID(RVALID),
    .RREADY(RREADY)
);

Slave_Interface SI(
    .ACLK(ACLK1),
    .ARESETN(ARESETN),
    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),
    .RDATA(RDATA),
    .RVALID(RVALID),
    .RREADY(RREADY)
);

//generate clock
always #10 ACLK0 <= ~ACLK0;
always #34 ACLK1 <= ~ACLK1; 

initial begin
    ACLK0 <= 0;
    ACLK1 <= 0;
    ARESETN <= 0; //reset on
    MOD_2_M_RRQST <= 0;
    MOD_2_M_RADDR <= 0;
    
    #50 ARESETN <=1; //reset off
    
    #10 MOD_2_M_RRQST <= 1; 
        MOD_2_M_RADDR <= 10; 
end

initial begin
    #500 $finish;
end

//always @(posedge ACLK0) if(M_2_MOD_RDATA) $finish;

always @(posedge ACLK0) begin
    if(MOD_2_M_RRQST && ARREADY) begin
        MOD_2_M_RRQST <= 0;
        MOD_2_M_RADDR <= 0;
    end
end

endmodule
