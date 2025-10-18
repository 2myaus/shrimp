import sys

def bin_to_vhdl(bin_file, vhdl_file):
    try:
        # Read the binary file
        with open(bin_file, 'rb') as f:
            bin_data = f.read()

        # Open the VHDL file for writing
        with open(vhdl_file, 'w') as vhdl:
            vhdl.write("library IEEE;\n")
            vhdl.write("use IEEE.STD_LOGIC_1164.ALL;\n")

            vhdl.write("package testvec_data is\n")
            vhdl.write("    constant testvec : std_logic_vector(")
            vhdl.write(f"{len(bin_data)*8-1} downto 0) := -- {len(bin_data)} bytes\n \"")

            # Write the std_logic_vector data in VHDL format
            for i in range(len(bin_data)-1, 0, -2):
                # Get the current byte and the next byte (if available)
                byte2 = bin_data[i-1] if i > 0 else 0 # Pad with 0 if there's an odd byte count
                byte1 = bin_data[i]

                # Write the 16-bit word in correct order (byte1 is the low byte, byte2 is the high byte)
                word = (byte2 << 8) | byte1  # Combine the two bytes to form a 16-bit word
                vhdl.write(f"{word:016b}")  # Write it as a 16-bit binary value

            vhdl.write("\";\n")

            vhdl.write("\nend package;\n")
        
        print(f"VHDL file '{vhdl_file}' has been generated successfully.")
    
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_bin_file> <output_vhdl_file>")
        sys.exit(1)

    bin_file = sys.argv[1]
    vhdl_file = sys.argv[2]

    bin_to_vhdl(bin_file, vhdl_file)

if __name__ == "__main__":
    main()
