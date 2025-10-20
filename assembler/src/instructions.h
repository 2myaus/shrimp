#pragma once

#include <cstdint>

/*! instruction opcodes */
enum asm_opcode : uint8_t {
  /*! bitwise AND reg_a & reg_b to reg_c */
  ASMOP_AND = 0b0000,

  /*! bitwise OR reg_a & reg_b to reg_c */
  ASMOP_OR = 0b0001,

  /*! bitwise XOR reg_a & reg_b to reg_c */
  ASMOP_XOR = 0b0010,

  /*! add reg_a + reg_b to reg_c */
  ASMOP_ADD = 0b0011,

  /*! (short-immediate-type) add reg_a + imm to reg_c; imm is unsigned */
  ASMOP_ADDI = 0b0100,
  
  /*! subtract reg_a - reg_b to reg_c */
  ASMOP_SUB = 0b0101,
  
  /*! (short-immediate-type) subtract reg_a - imm to reg_c; imm is unsigned */
  ASMOP_SUBI = 0b0110,

  /*! compare reg_a and reg_b to reg_c (if A>B, C=1; if A<B, C=-1, if A=B, C=0) */
  ASMOP_CMP = 0b0111,

  /*! (short-immediate-type) negate reg_a to reg_c (if imm=0, 1's comp; if imm=1, 2's comp) */
  ASMOP_NEG = 0b1000,

  /*! (short-immediate-type) read/write memory at address reg_a to/from reg_c
  MEMORY 0: read full word; MEMORY 1: write full word; MEMORY 2: read byte to MSB end; MEMORY 3: write byte from MSB end */
  ASMOP_MEMORY = 0b1001,

  /*! jump/offset pc by reg_c if reg_a = reg_b */
  ASMOP_BRANCH_EQ = 0b1010,

  /*! arithmatic rightshift reg_a by reg_b to reg_c */
  ASMOP_SRA = 0b1011,

  /*! logical leftshift reg_a by reg_b to reg_c */
  ASMOP_SLL = 0b1100,

  /*! (short-immediate-type) arithmatic rightshift reg_a by imm to reg_c */
  ASMOP_SRAI = 0b1101,

  /*! (short-immediate-type) logical leftshift reg_a by imm to reg_c */
  ASMOP_SLLI = 0b1110,

  /*! (immediate-type) load imm into reg_dest/reg_c */
  ASMOP_LOAD_IMM = 0b1111
};

/*! cpu register addresses */
enum register_address : uint8_t{
  REG_A0 = 0x0, //! argument/return 0
  REG_A1 = 0x1, //! argument/return 1
  REG_A2 = 0x2, //! argument/return 2
  REG_A3 = 0x3, //! argument/return 3
  REG_A4 = 0x4, //! argument 4 (no return)
  REG_A5 = 0x5, //! argument 5 (no return)

  REG_S0 = 0x6, //! saved reg 0 (saved by callee)
  REG_S1 = 0x7, //! saved reg 1
  REG_S2 = 0x8, //! saved reg 2
  REG_S3 = 0x9, //! saved reg 3
  REG_S4 = 0xA, //! saved reg 4
  REG_S5 = 0xB, //! saved reg 5

  REG_T0 = 0xC, //! temp reg (saved by caller)

  REG_SP = 0xD, //! stack pointer
  REG_R0 = 0xE, //! return address

  REG_00 = 0xF  //! hardwired zero
};

enum instruction_type{
  IT_IMM,
  IT_STD,
  IT_IMMS
};

struct asm_instruction{
  asm_opcode opcode : 4;
  union{
    struct{
      register_address reg_a : 4;
      register_address reg_b : 4;
      register_address reg_c : 4;
    } standard;

    struct{
      register_address reg_a : 4;
      uint8_t data : 4;
      register_address reg_c : 4;
    } short_immediate;

    struct{
      uint8_t data : 8;
      register_address reg_c : 4;
    } immediate;
  };
};

uint16_t instruction_to_bin(const asm_instruction instr_in);
instruction_type opcode_to_type(const asm_opcode opcode_in);
