`timescale 1ns / 1ps

module Slave_Interface
#(
    parameter REG_WIDTH = 32
)
(
    //global signal
    input ACLK,
    input ARESETN,
    
    //read channel port
    
    //read address channel stilus
    //output reg [REG_WIDTH-1:0] S_2_MOD_RADDR,
    //input [REG_WIDTH-1:0] MOD_2_S_RDATA,
    //input MOD_2_S_RRQST,
    
    //read address channel
    input [REG_WIDTH-1:0]ARADDR,
    input ARVALID,
    output reg ARREADY,
    
    //read data channel
    output reg [REG_WIDTH-1:0] RDATA,
    output reg RVALID,
    input RREADY
    
    //end of read channel port
    
    /*
    //write channel port
    
    //write address tb stimulus
    output reg MOD_2_S_WARQST,
    output reg S_2_MOD_WADDR,
    
    //write address channel
    output reg AWREADY,
    input [REG_WIDTH-1:0] AWADDR,
    input AWVALID,
    
    //write data tb stimulus
    output reg MOD_2_S_WRQST,
    output reg S_2_MOD_WDATA,
    
    //write data channel
    output reg WREADY,
    input [REG_WIDTH-1:0] WDATA,
    input WVALID,
    
    //write response tb stimuli
    input MOD_2_S_WRESULT,
    
    //write response channel
    output reg BVALID,
    input BREADY
    
    //end of write channel port
    */
);

//slave memory
reg [REG_WIDTH -1:0] MEM [0:REG_WIDTH-1];

//Read Channel

//Read Address
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) begin
        ARREADY <= 0;
    end
    
    else begin
        if(!ARREADY && ARVALID) ARREADY <= 1;
        else if(!ARVALID) ARREADY <= 0;//
    end       
end

//end of Read Address

//Read Data (Memory Controller)
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) begin
        $readmemh("MEM.mem",MEM);
        RDATA <= 0;
        RVALID <= 0;
    end
    
    else begin
        if(ARVALID) begin
            RVALID <= 1;
            RDATA <= MEM[ARADDR];
        end
        
        if(RVALID && RREADY) begin
            RVALID <= 0;
            RDATA <= 0;
        end
        //else if(RREADY && !RVALID) RVALID <= 1;
    end
end
//end of Read Data

//end of Read Channel

/*
//write channel 

//write address
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) AWREADY <= 0;
    else begin
        S_2_MOD_WADDR <= AWADDR;
        if(AWVALID && !AWREADY) AWREADY <= 1;
        else if(AWVALID)
    end
end


//end of write address
    

//end of write channel

*/
endmodule   
