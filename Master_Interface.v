`timescale 1ns / 1ps

module Master_Interface
#(
    parameter REG_WIDTH = 32
)
(   
    //global signal
    input ACLK,
    input ARESETN,
    
    //module port
    input MOD_2_M_RRQST,
    input [REG_WIDTH-1:0] MOD_2_M_RADDR,
    output reg [REG_WIDTH-1:0] M_2_MOD_RDATA,
    
    //read address channel
    output reg [REG_WIDTH-1:0] ARADDR,
    output reg ARVALID,
    input ARREADY,
    
    //read data channel
    input [REG_WIDTH-1:0] RDATA,
    input RVALID,
    output reg RREADY,
    
    //write address channel
    input AWREADY,
    output [REG_WIDTH-1:0] AWADDR,
    output AWVALID,
    
    //write data channel
    input WREADY,
    output [REG_WIDTH-1:0] WDATA,
    output WVALID,
    
    //write response channel
    input BVALID,
    output BREADY
); 

//Read Channel

//Read Address
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) begin
        ARADDR <= 0;
        ARVALID <= 0;
    end
    
    else begin
        ARVALID <= MOD_2_M_RRQST;
        ARADDR <= MOD_2_M_RADDR;
        
        if(ARVALID && ARREADY) begin
            ARVALID <= 0;
            ARADDR <= 0;
        end        
        //else if(!ARVALID && ARREADY) ARVALID <= 1;
    end
end

//end of Read Address

//Read Data
always @(posedge ACLK, negedge ARESETN) begin
    
    if(!ARESETN) begin
        M_2_MOD_RDATA <= 0;
        RREADY <= 0;
    end
    
    else begin
        if(RREADY) M_2_MOD_RDATA <= RDATA;
        else M_2_MOD_RDATA <= 0;
        
        if(RVALID && !RREADY) RREADY <= 1;
        else if(RVALID && RREADY) RREADY <= 0;  
    end
end
//end of Read Data

//end of Read Channel

//write channel

//write address channel

//end of write address channel

//end of write channel

endmodule
