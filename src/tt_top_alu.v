module top_alu_fpga (
    input [7:0] ui_in,       // Entradas de usuario (switches)
    input [2:0] uio_in,      // Entradas adicionales (botones)
    output [7:0] uo_out,     // Salidas principales (LEDs)
    output [7:0] uio_out,    // Salidas adicionales
    output [7:0] uio_oe      // Dirección de E/S adicionales
);
    // Asignación de entradas:
    wire [7:0] A = ui_in;    // Primer operando (switches 0-7)
    wire [7:0] B = {uio_in[2:0], ui_in[7:3]}; // Segundo operando (combinación de entradas)
    
    // Selección de operación con los 3 bits más altos de ui_in
    wire [2:0] ALU_Sel = ui_in[7:5];
    
    // Conexión a la ALU de 8 bits:
    wire [7:0] ALU_Result;   // Resultado de 8 bits
    wire Zero;               // Bandera Zero
    wire CarryOut;           // Bandera CarryOut

    ALU_8bit alu_inst (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Result),
        .Zero(Zero),
        .CarryOut(CarryOut)
    );

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
