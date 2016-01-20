`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module partial_led_test_0
(
  leds,
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error                    // IP to Bus error response
); 

// -- Bus protocol parameters, do not add to or delete
parameter C_NUM_REG                      = 4;
parameter C_SLV_DWIDTH                   = 32;

output reg [7:0]                         leds;   
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE;
output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output     reg                            IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;

reg [31:0] my_reg [0:3];
reg [31:0] reg_data_out;
//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

assign IP2Bus_Error = 1'b0;

always @(posedge Bus2IP_Clk)
begin
    if(~Bus2IP_Resetn) begin
		my_reg[0]    <= 'd0;
		my_reg[1]    <= 'd0;
		my_reg[2]    <= 'd0;
		my_reg[3]    <= 'd0;
	 end	
    else if(|Bus2IP_WrCE) begin
	    case (Bus2IP_WrCE)
			'd1 :  my_reg[0]   <= Bus2IP_Data + 'h004;
			'd2 :  my_reg[1]   <= Bus2IP_Data + 'h008;
			'd4 :  my_reg[2]   <= Bus2IP_Data + 'h00c;
			'd8 :  my_reg[3]   <= Bus2IP_Data + 'h010;
	    endcase
	end
end

assign IP2Bus_WrAck = |Bus2IP_WrCE;
assign IP2Bus_Data = reg_data_out;

always @(Bus2IP_Clk)
begin
    if(~Bus2IP_Resetn) begin
		reg_data_out <= 'd0;
	 end	
    else begin
		reg_data_out <= 'd0;
		case (Bus2IP_RdCE)
			'd1   : reg_data_out <= my_reg[0];
			'd2   : reg_data_out <= my_reg[1];
			'd4   : reg_data_out <= my_reg[2];
			'd8   : reg_data_out <= my_reg[3];
		endcase
	end
end

always @(posedge Bus2IP_Clk)
    IP2Bus_RdAck <= |Bus2IP_RdCE;

// Up/Down Counter to Register.
reg [23:0] bitflip;
always @( posedge Bus2IP_Clk )
begin
  if (~Bus2IP_Resetn)
    begin
        bitflip <= 24'b0;
        leds    <= 8'hFF;
    end 
  else
    begin
        if (&bitflip) begin
            leds <= leds + 1'b1;
            bitflip <= 'd0;
        end
        else begin
            bitflip <= bitflip + 1'b1;
        end
    end 
end     	

endmodule
