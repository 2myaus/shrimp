#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

#include "instructions.h"

asm_opcode parseOpcode(const std::string &opcodeString){
  std::string opstr = opcodeString;

  std::transform(opstr.begin(), opstr.end(), opstr.begin(),
      [](unsigned char c){ return std::tolower(c); });

  if(opstr == "and"){ return ASMOP_AND; }
  else if(opstr == "or"){ return ASMOP_OR; }
  else if(opstr == "xor"){ return ASMOP_XOR; }
  else if(opstr == "add"){ return ASMOP_ADD; }
  else if(opstr == "addi"){ return ASMOP_ADDI; }
  else if(opstr == "sub"){ return ASMOP_SUB; }
  else if(opstr == "subi"){ return ASMOP_SUBI; }
  else if(opstr == "cmp"){ return ASMOP_CMP; }
  else if(opstr == "neg"){ return ASMOP_NEG; }
  else if(opstr == "mem"){ return ASMOP_MEMORY; }
  else if(opstr == "beq"){ return ASMOP_BRANCH_EQ; }
  else if(opstr == "sra"){ return ASMOP_SRA; }
  else if(opstr == "sll"){ return ASMOP_SLL; }
  else if(opstr == "srai"){ return ASMOP_SRAI; }
  else if(opstr == "slli"){ return ASMOP_SLLI; }
  else if(opstr == "limm"){ return ASMOP_LOAD_IMM; }

  throw std::invalid_argument("Given string is not an opcode!");
}

register_address parseReg(const std::string &registerString){
  std::string regstr = registerString;

  std::transform(regstr.begin(), regstr.end(), regstr.begin(),
    [](unsigned char c){ return std::tolower(c); });

  if(regstr == "a0"){ return REG_A0; }
  else if(regstr == "a1"){ return REG_A1; }
  else if(regstr == "a2"){ return REG_A2; }
  else if(regstr == "a3"){ return REG_A3; }
  else if(regstr == "a4"){ return REG_A4; }
  else if(regstr == "a5"){ return REG_A5; }

  else if(regstr == "s0"){ return REG_S0; }
  else if(regstr == "s1"){ return REG_S1; }
  else if(regstr == "s2"){ return REG_S2; }
  else if(regstr == "s3"){ return REG_S3; }
  else if(regstr == "s4"){ return REG_S4; }
  else if(regstr == "s5"){ return REG_S5; }

  else if(regstr == "t0"){ return REG_T0; }

  else if(regstr == "sp"){ return REG_SP; }
  else if(regstr == "r0"){ return REG_R0; }

  else if(regstr == "00"){ return REG_00; }

  throw std::invalid_argument("Given string is not a register!");
}

asm_instruction parseInstruction(std::string instrString){
  std::istringstream lineStream(instrString);
  std::string word;

  std::vector<std::string> words;
  words.reserve(4);

  while(lineStream >> word){
    if(word[0] == '#'){ break; } // stop reading at comment
    words.push_back(word);
  }

  assert(words.size() > 0);
  
  bool readShortImm = true;
  
  // pseudoinstructions
  asm_opcode opcode;
  int data;
  uint8_t ndata;

  if(words[0] == "rmemw"){ // read memory word
    opcode = ASMOP_MEMORY;
    readShortImm = false;
    ndata = 0;
  }
  else if(words[0] == "wmemw"){ // write memory word
    opcode = ASMOP_MEMORY;
    readShortImm = false;
    ndata = 1;
  }
  else if(words[0] == "rmemb"){ // read memory byte
    opcode = ASMOP_MEMORY;
    readShortImm = false;
    ndata = 2;
  }
  else if(words[0] == "wmemb"){ // write memory byte
    opcode = ASMOP_MEMORY;
    readShortImm = false;
    ndata = 3;
  }
  else if(words[0] == "slup"){ // leftshift LSB up to MSB
    opcode = ASMOP_SLLI;
    readShortImm = false;
    ndata = 0x8;
  }
  else if(words[0] == "cp"){ // copy
    opcode = ASMOP_ADDI;
    readShortImm = false;
    ndata = 0x0;
  }
  else{
    opcode = parseOpcode(words[0]);    
  }

  instruction_type instr_type = opcode_to_type(opcode);

  switch(instr_type){
    case IT_STD: // standard (reg reg reg)
      assert(words.size() == 4);
      return {
        .opcode = opcode,
        .standard = {
          .reg_a = parseReg(words[1]),
          .reg_b = parseReg(words[2]),
          .reg_c = parseReg(words[3])
        }
      };

    case IT_IMMS: // short immediate (reg data reg)
      if(readShortImm){ assert(words.size() == 4); }
      else{ assert(words.size() == 3); }

      if(readShortImm){ // if the short immediate value isn't already filled by a pseudoinstruction
        data = std::stoi(words[2], nullptr, 0);
        if(data > 0xF or (opcode == ASMOP_MEMORY and data >= 0x4)){ // max of 4bit int or invalid memory operation
          throw std::out_of_range("Immediate value is too large!");
        }
        ndata = data;
      }
      
      return {
        .opcode = opcode,
        .short_immediate = {
          .reg_a = parseReg(words[1]),
          .data = ndata,
          .reg_c = parseReg(words[readShortImm ? 3 : 2])
        }
      };

    case IT_IMM: // long immediate (data regg)
      assert(words.size() == 3);

      data = std::stoi(words[1], nullptr, 0);
      if(data > 0xFF){ // max of 8bit int
        throw std::out_of_range("Immediate value is too large!");
      }
      ndata = data;

      return {
        .opcode = opcode,
        .immediate = {
          .data = ndata,
          .reg_c = parseReg(words[2])
        }
      };
    default:
      throw std::exception();
  }
}

std::vector<asm_instruction> parseFile(std::string fileName){
  std::ifstream infile(fileName);

  std::vector<asm_instruction> instructions_out;
  std::string line; // One assembly instruction
  while(std::getline(infile, line)){
    instructions_out.push_back(parseInstruction(line));
  }

  return instructions_out;
}
