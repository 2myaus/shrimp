package pkg_shrimp_cpu_defs;
  typedef enum bit [3:0] {
    AND,
    OR,
    XOR,
    ADD,
    SUB,  // subtract
    CMP,  // <, >, or =
    NEG,  // negate
    WRITE_MEM_WORD,  // full register
    WRITE_MEM_BYTE,  // least significant 8 bits
    READ_MEM,  // read full 16bit word from memory
    BRANCH_EQ,  // on some condition
    SYSCALL,
    SRA,  // arithmatic rightshift
    SRL,  // logical rightshift
    SLL,  // logical leftshift
    LOAD_IMM  // (immediate-type) Load immediate value
  } cpu_opcode_e;

  typedef struct packed {
    bit [7:0] data;  // immediate value in I-type, otherwise operand registers
    bit [3:0] regDst;  // desination register address
    cpu_opcode_e opcode;
  } instruction_t;

  typedef struct packed {
    bit [7:0] immedVal;  // immediate 8-bit val
    bit [3:0] regDst;  // destination register address
    cpu_opcode_e opcode;
  } instruction_i_t;  // immediate-type instruction

  typedef struct packed {
    bit [3:0] regA;  // operand register A address
    bit [3:0] regB;  // operand register B address
    bit [3:0] regDst;  // destination register address
    cpu_opcode_e opcode;
  } instruction_s_t;  // standard-type instruction

endpackage
