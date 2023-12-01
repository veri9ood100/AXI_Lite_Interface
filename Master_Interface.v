`timescale 1ns / 1ps

module Master_Interface
#(
    parameter REG_WIDTH = 32
)
(   
    //global signal
    input ACLK,
    input ARESETN,
    
    //read channel port
    
    //read address tb stimulus
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
    output reg RREADY
    
    //end of read channel port
    
    /*
    //write channel port
    
    //write address tb stimulus
    input MOD_2_M_WARQST,
    input MOD_2_M_WADDR,
    
    //write address channel
    input AWREADY,
    output reg [REG_WIDTH-1:0] AWADDR,
    output reg AWVALID,
    
    //write data tb stimulus
    input MOD_2_M_WRQST,
    input MOD_2_M_WDATA,
    
    //write data channel
    input WREADY,
    output reg [REG_WIDTH-1:0] WDATA,
    output reg WVALID,
    
    //write response tb stimuli
    output reg M_2_MOD_WRESULT,
    
    //write response channel
    input BVALID,
    output reg BREADY
    
    //end of write channel port
    */
); 

//Read Channel
//reg flag_read_done;

//Read Address
always @(posedge ACLK, negedge ARESETN) begin
    if(!ARESETN) begin
        ARADDR <= 0;
        ARVALID <= 0;
    end
    
    else begin
        //flag_read_done <= ~MOD_2_M_RRQST; 
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
        //flag_read_done <= 0;
    end
    
    else begin
        if(RREADY /*&& !flag_read_done*/) begin 
            M_2_MOD_RDATA <= RDATA;
            //flag_read_done <= 1;            
        end
        else M_2_MOD_RDATA <= 0;
        
        if(RVALID && !RREADY) RREADY <= 1;
        else if(!RVALID) RREADY <= 0; //
    end
end
//end of Read Data

//end of Read Channel

/*
//write channel

//write address channel
always @(posedge ACLK, negedge ARESETN) begin
    
    if(!ARESETN) begin
        AWADDR <= 0;
        AWVALID <= 0;
    end
    
    else begin
        AWVALID <= MOD_2_M_WARQST;
        AWADDR <=  MOD_2_M_WADDR;
        if(AWVALID && AWREADY) begin
            AWVALID <= 0;
            AWADDR <= 0;
        end
    end
end

//end of write address channel

always @(posedge ACLK, negedge ARESETN) begin
    
    if(!ARESETN) begin
        WVALID <= 0;
        WDATA <= 0;
    end
    
    else begin
        WVALID <= MOD_2_M_WRQST;
        WDATA <= MOD_2_M_WDATA;
        if(WVALID &&WREADY) begin
            WVALID <= 0;
            WDATA <= 0;
        end
    end
    
end

//end of write channel

//write response channel
always @(posedge ACLK, negedge ARESETN) begin
    
    if(!ARESETN) begin
        BREADY <= 0;
        M_2_MOD_WRESULT <= 0;
    end
    else begin
        M_2_MOD_WRESULT <= BVALID;
        if(BVALID && !BREADY) BREADY <= 1;
        else if(BVALID && BREADY) BREADY <= 0; 
    end
    
end    
    
//end of write response channel
*/
endmodule
