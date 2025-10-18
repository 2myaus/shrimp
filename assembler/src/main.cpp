#include <iostream>

#include "reader.h"
#include "writer.h"

int main(int argc, char *argv[])
{
  if(argc != 3){
    std::cout << "Incorrect arguments! shrasm [in.shrasm] [out.bin]" << std::endl;
    return 1;
  }
  writeInstructions(parseFile(argv[1]), argv[2]);

  std::cout << "Parsed " << argv[1] << " to " << argv[2] << std::endl;
}
