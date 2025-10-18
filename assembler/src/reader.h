#pragma once

#include <string>
#include <vector>
#include "instructions.h"

asm_instruction parseInstruction(std::string instrString);
std::vector<asm_instruction> parseFile(std::string fileName);
