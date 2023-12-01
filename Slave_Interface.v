`timescale 1ns / 1ps

module Slave_Interface
#(
    parameter REG_WIDTH = 32
)
(
    //global signal
    input ACLK,
    input ARESETN,
    
    //module read port
    output reg [REG_WIDTH-1:0] S_2_MOD_RADDR,
    input [REG_WIDTH-1:0] MOD_2_S_RDATA,
    input MOD_2_S_RRQST,
    
    //read address channel
    input [REG_WIDTH-1:0]ARADDR,
    input ARVALID,
    output reg ARREADY,
    
    //read data channel
    output reg [REG_WIDTH-1:0] RDATA,
    output reg RVALID,
    input RREADY,
    
    //write address channel
    output AWREADY,
    input [REG_WIDTH-1:0] AWADDR,
    input AWVALID,
    
    //write data channel
    output WREADY,
    input [REG_WIDTH-1:0] WDATA,
    input WVALID,
    
    //write response channel
    output BVALID,
    input BREADY
);

//Read Channel

//Read Address
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) begin
        ARREADY <= 0;
        S_2_MOD_RADDR <= 0;
    end
    
    else begin
        S_2_MOD_RADDR <= ARADDR;
        if(!ARREADY && ARVALID) ARREADY <= 1;
        else if(ARREADY && ARVALID) ARREADY <= 0;
    end       
end

//end of Read Address

//Read Data
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) begin
        RDATA <= 0;
        RVALID <= 0;
    end
    
    else begin    
        RVALID <= MOD_2_S_RRQST; 
        RDATA <= MOD_2_S_RDATA;
        
        if(RVALID && RREADY) begin
            RVALID <= 0;
            RDATA <= 0;
        end
        //else if(RREADY && !RVALID) RVALID <= 1;
    end
end
//end of Read Data

//end of Read Channel

endmodule   
