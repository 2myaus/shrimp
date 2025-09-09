package pkg_shrimp_alu_defs;
  typedef enum bit [3:0] {
    XOR,   // xor A^B
    AND,   // and A&B
    OR,    // or A|B
    ADDU,  // add unsigned A+B
    ADDS,  // add signed A+B
    NEG,   // negate by 2's comp -A
    CMP    // compare A>B (in LSB 001 A>B, 010 A<B, 100 A=B)
  } alu_opcode_e;
endpackage
