package pkg_shrimp_cpu_defs;
  typedef enum bit [3:0] {
    AND,
    OR,
    XOR,
    ADD,
    SUB,  // subtract A-B
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
    union packed {
      bit [7:0] immediate;
      struct packed {
        bit [3:0] regA;
        bit [3:0] regB;
      } regs;
    } operands;  // immediate value in I-type, otherwise operand registers
    bit [3:0] regDst;  // desination register address
    cpu_opcode_e opcode;
  } instruction_t;

endpackage
