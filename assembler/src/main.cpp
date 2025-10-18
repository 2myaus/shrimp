#include <cstdio>
#include <cstdint>
#include <stdexcept>

#include "instructions.h"

instruction_type opcode_to_type(const asm_opcode opcode_in){
  switch(opcode_in){
    case ASMOP_AND:
      return IT_STD;
    case ASMOP_OR:
      return IT_STD;
    case ASMOP_XOR:
      return IT_STD;
    case ASMOP_ADD:
      return IT_STD;
    case ASMOP_ADDI:
      return IT_IMMS;
    case ASMOP_SUB:
      return IT_STD;
    case ASMOP_SUBI:
      return IT_IMMS;
    case ASMOP_CMP:
      return IT_STD;
    case ASMOP_NEG:
      return IT_STD;
    case ASMOP_MEMORY:
      return IT_IMMS;
    case ASMOP_BRANCH_EQ:
      return IT_STD;
    case ASMOP_SRA:
      return IT_STD;
    case ASMOP_SLL:
      return IT_STD;
    case ASMOP_SRAI:
      return IT_IMMS;
    case ASMOP_SLLI:
      return IT_IMMS;
    case ASMOP_LOAD_IMM:
      return IT_IMM;
    default:
      throw std::invalid_argument("Invalid opcode!");
  }
}

uint16_t instruction_to_bin(const asm_instruction instr_in){
  /*
    1010 1010 1010 1010 - instruction MSb to LSb L to R, BE
    OPCD REGA REGB REGO - std type
    OPCD REGA IMM0 REGO - imms type
    OPCD IMM0 IMM1 REGO - imm type
  */
  uint16_t out = 0x00;
  out |= instr_in.opcode << 12; // opcode in MSbs

  switch(opcode_to_type(instr_in.opcode)){
    case IT_STD:
      out |= instr_in.standard.reg_operand_a << 8;
      out |= instr_in.standard.reg_operand_b << 4;
      out |= instr_in.standard.reg_operand_c << 0;
      break;
    case IT_IMMS:
      out |= instr_in.short_immediate.reg_operand_a << 8;
      out |= instr_in.short_immediate.data << 4;
      out |= instr_in.short_immediate.reg_operand_c << 0;
      break;
    case IT_IMM:
      out |= instr_in.immediate.data << 4;
      out |= instr_in.immediate.reg_operand_c << 0;
      break;
    default:
      throw std::exception();
  }
  
  return out;
}

int main(){
  asm_instruction instr1 = {
    .opcode = ASMOP_LOAD_IMM,
    .immediate = {
      .data = 0xFF,
      .reg_operand_c = REG_A0
    }
  };
  asm_instruction instr2 = {
    .opcode = ASMOP_LOAD_IMM,
    .immediate = {
      .data = 0x80,
      .reg_operand_c = REG_A1
    }
  };
  asm_instruction instr3 = {
    .opcode = ASMOP_MEMORY,
    .short_immediate= {
      .reg_operand_a = REG_A1,
      .data = 0x1,
      .reg_operand_c = REG_A0
    }
  };
  std::printf("%X\n", instruction_to_bin(instr1));
  std::printf("%X\n", instruction_to_bin(instr2));
  std::printf("%X\n", instruction_to_bin(instr3));
}
