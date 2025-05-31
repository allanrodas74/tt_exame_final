module ALU_8bit (
    input [7:0] A, B,         // Operandos de 8 bits
    input [2:0] ALU_Sel,      // Selector de operación (3 bits)
    output reg [7:0] ALU_Out, // Resultado de 8 bits
    output Zero,              // Bandera de resultado cero
    output CarryOut           // Bit de acarreo para operaciones aritméticas
);
    // Conexión al sumador prefix para suma:
    wire [7:0] sum;
    wire sum_carry;
    PrefixAdder8 prefix_adder_sum (
        .A(A),
        .B(B),
        .Sum(sum),
        .Cout(sum_carry)
    );
    
    // Conexión al sumador prefix para resta (suma con complemento a 2 de B):
    wire [7:0] B_neg = ~B + 1'b1;
    wire [7:0] diff;
    wire diff_carry;
    PrefixAdder8 prefix_adder_diff (
        .A(A),
        .B(B_neg),
        .Sum(diff),
        .Cout(diff_carry)
    );

    // Lógica para las banderas:
    assign Zero = (ALU_Out == 8'b0);  // 1 si el resultado es cero
    
    // Selección de operación:
    always @(*) begin
        case(ALU_Sel)
            3'b000: begin // Suma
                ALU_Out = sum;
                CarryOut = sum_carry;
            end
            3'b001: begin // Resta
                ALU_Out = diff;
                CarryOut = diff_carry;
            end
            3'b010: begin // AND bit a bit
                ALU_Out = A & B;
                CarryOut = 1'b0;
            end
            3'b011: begin // OR bit a bit
                ALU_Out = A | B;
                CarryOut = 1'b0;
            end
            3'b100: begin // XOR bit a bit
                ALU_Out = A ^ B;
                CarryOut = 1'b0;
            end
            3'b101: begin // Desplazamiento izquierda
                ALU_Out = {A[6:0], 1'b0};
                CarryOut = A[7];
            end
            3'b110: begin // Desplazamiento derecha
                ALU_Out = {1'b0, A[7:1]};
                CarryOut = A[0];
            end
            3'b111: begin // Comparación (A < B)
                ALU_Out = (A < B) ? 8'b00000001 : 8'b0;
                CarryOut = 1'b0;
            end
            default: begin
                ALU_Out = 8'b0;
                CarryOut = 1'b0;
            end
        endcase
    end
endmodule
