module pipeline_processor (
    input  wire       clk,
    input  wire       reset,
    // handy output for checking
    output wire [3:0] final_result_out,
    output wire       IF_valid,
    output wire       ID_valid,
    output wire       EX_valid,
    output wire       WB_valid,
    output wire [15:0] IF_instr,
    output wire [15:0] ID_instr,
    output wire [15:0] EX_instr,
    output wire [15:0] WB_instr,
    output wire [3:0]  ID_opA,
    output wire [3:0]  ID_opB,
    output wire [3:0]  EX_result,
    output wire [3:0]  WB_wdata
);
    localparam [3:0] OP_NOP  = 4'h0;
    localparam [3:0] OP_ADD  = 4'h1;
    localparam [3:0] OP_SUB  = 4'h2;
    localparam [3:0] OP_LOAD = 4'h3;
    reg [15:0] instr_mem [0:15]; 
    reg [3:0]  data_mem  [0:15];  
    reg [3:0]  regfile   [0:15]; 
    reg  [3:0] pc;
    wire [15:0] fetched_instr = instr_mem[pc];
    // pipeline valid generation
    reg if_valid_r;
    reg        if_id_valid;
    reg [15:0] if_id_instr;
    reg        id_ex_valid;
    reg [15:0] id_ex_instr;
    reg [3:0]  id_ex_opA;
    reg [3:0]  id_ex_opB;
    reg [3:0]  id_ex_addr; 
    reg        ex_wb_valid;
    reg [15:0] ex_wb_instr;
    reg [3:0]  ex_wb_result;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc          <= 4'd0;
            if_valid_r  <= 1'b0;
            if_id_valid <= 1'b0;
            if_id_instr <= 16'h0000;
        end else begin
            if_valid_r  <= 1'b1;
            if_id_valid <= if_valid_r;
            if_id_instr <= fetched_instr;
            pc <= pc + 4'd1;
        end
    end
    wire [3:0] id_rd     = if_id_instr[11:8];
    wire [3:0] id_rs     = if_id_instr[7:4];
    wire [3:0] id_rtaddr = if_id_instr[3:0];
    wire [3:0] id_readA = regfile[id_rs];
    wire [3:0] id_readB = regfile[id_rtaddr];  
    wire [3:0] id_addr  = id_rtaddr;          
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_ex_valid <= 1'b0;
            id_ex_instr <= 16'h0000;
            id_ex_opA   <= 4'd0;
            id_ex_opB   <= 4'd0;
            id_ex_addr  <= 4'd0;
        end else begin
            id_ex_valid <= if_id_valid;
            id_ex_instr <= if_id_instr;
            id_ex_opA   <= id_readA;
            id_ex_opB   <= id_readB;
            id_ex_addr  <= id_addr;
        end
    end
    wire [3:0] ex_opcode = id_ex_instr[15:12];
    reg  [3:0] ex_res;
    always @(*) begin
        case (ex_opcode)
            OP_ADD:  ex_res = id_ex_opA + id_ex_opB;
            OP_SUB:  ex_res = id_ex_opA - id_ex_opB;
            OP_LOAD: ex_res = data_mem[id_ex_addr]; 
            default: ex_res = 4'd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_wb_valid  <= 1'b0;
            ex_wb_instr  <= 16'h0000;
            ex_wb_result <= 4'd0;
        end else begin
            ex_wb_valid  <= id_ex_valid;
            ex_wb_instr  <= id_ex_instr;
            ex_wb_result <= ex_res;
        end
    end
    wire [3:0] wb_opcode = ex_wb_instr[15:12];
    wire [3:0] wb_rd     = ex_wb_instr[11:8];
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                regfile[i] <= 4'd0;
        end else begin
            if (ex_wb_valid && (wb_opcode != OP_NOP)) begin
                regfile[wb_rd] <= ex_wb_result;
            end
        end
    end
    initial begin
        data_mem[0] = 4'd9;
        data_mem[1] = 4'd4;
        instr_mem[0] = {OP_LOAD, 4'd1, 4'd0, 4'd0};
        instr_mem[1] = {OP_LOAD, 4'd2, 4'd0, 4'd1};
        instr_mem[2] = {OP_NOP,  4'd0, 4'd0, 4'd0};
        instr_mem[3] = {OP_ADD,  4'd3, 4'd1, 4'd2};
        instr_mem[4] = {OP_NOP,  4'd0, 4'd0, 4'd0};
        instr_mem[5] = {OP_SUB,  4'd4, 4'd3, 4'd2};
        instr_mem[6]  = 16'h0000; instr_mem[7]  = 16'h0000;
        instr_mem[8]  = 16'h0000; instr_mem[9]  = 16'h0000;
        instr_mem[10] = 16'h0000; instr_mem[11] = 16'h0000;
        instr_mem[12] = 16'h0000; instr_mem[13] = 16'h0000;
        instr_mem[14] = 16'h0000; instr_mem[15] = 16'h0000;
    end
    assign final_result_out = regfile[4];
    assign IF_valid = if_valid_r;
    assign ID_valid = if_id_valid;
    assign EX_valid = id_ex_valid;
    assign WB_valid = ex_wb_valid;
    assign IF_instr = fetched_instr;
    assign ID_instr = if_id_instr;
    assign EX_instr = id_ex_instr;
    assign WB_instr = ex_wb_instr;
    assign ID_opA    = id_readA;
    assign ID_opB    = id_readB;
    assign EX_result = ex_res;
    assign WB_wdata  = ex_wb_result;
endmodule
