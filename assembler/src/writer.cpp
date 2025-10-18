#include <algorithm>
#include <vector>
#include <fstream>

#include "instructions.h"

void writeInstructions(std::vector<asm_instruction> instructions, std::string filename){
  std::ofstream outfile(filename, std::ios::out | std::ios::binary);

  std::for_each(instructions.begin(), instructions.end(),
    [&](asm_instruction instruction) {
      uint16_t instruction_bin = htobe16(instruction_to_bin(instruction));
      outfile.write(reinterpret_cast<const char*>(&instruction_bin), sizeof(instruction_bin));
    }
  );

  outfile.close();
}
