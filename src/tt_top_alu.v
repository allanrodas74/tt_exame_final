module tt_alu_fpga (
    input [7:0] ui_in,
    input [2:0] uio_in,
    output [7:0] uo_out,
    output [7:0] uio_out,
    output [7:0] uio_oe
);
    wire [7:0] A = ui_in;
    wire [7:0] B = {uio_in[2:0], ui_in[7:3]};
    wire [2:0] ALU_Sel = ui_in[7:5];
    
    wire [7:0] ALU_Result;
    wire Zero, CarryOut;

    ALU_8bit alu_inst (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Result),
        .Zero(Zero),
        .CarryOut(CarryOut)
    );

    assign uo_out = ALU_Result;
    assign uio_out = {6'b0, CarryOut, Zero};
    assign uio_oe = 8'b11111111;
endmodule

    // Asignación de salidas:
    assign uo_out = ALU_Result;  // Resultado en LEDs principales
    assign uio_out = {6'b0, CarryOut, Zero}; // Banderas en salidas adicionales
    
    // Configurar todas las E/S adicionales como salidas
    assign uio_oe = 8'b11111111;
    
    // Nota: En TinyTapeout, los pines uio_in[2:0] pueden usarse como:
    // - Botones físicos
    // - Parte del segundo operando B
    // - Otras configuraciones según necesidades
endmodule
