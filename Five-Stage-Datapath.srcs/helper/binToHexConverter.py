# This is a small python helper function to convert hexadecimal values
#  to a simplified human-readable format.
#  I used this program to convert values for Instruction Memory.

class binToHexConverter:

    # Converts hex string input to binary output
    @staticmethod
    def hexToBin(data, bits=32):
        # Not even going to try to explain this one
        # Credit to https://stackoverflow.com/a/4859937/13821979
        return bin(int(data, 16))[2:].zfill(bits)

    # Prints out binary output cleanly
    @staticmethod
    def convertPrint(data):
        # Sanitize data input with spaces and newlines
        data = data.replace("\n", "")
        data = data.replace(" ", "")

        bits = len(data)*4  # Calculate amt of bits
        binData = binToHexConverter.hexToBin(data, bits)  # Get binary data

        itr = 0
        # Iterate through all values, printing spaces and newlines if needed
        for char in binData:
            print(char, end="")
            itr += 1

            if itr % 32 == 0:
                print("")
            elif itr % 8 == 0:
                print(" ", end="")

    # Prints out the corresponding verilog code for the hex input for ROM data
    @staticmethod
    def verilogCodeRom(data):
        # Remove leading and trailing newlines
        data = data.strip("\n")

        # Split data on newlines
        data = data.splitlines()

        # Calculate binary for each instruction
        binData = [binToHexConverter.hexToBin(inst, 32) for inst in data]

        itr = 0
        # Iterate through each instruction in both binary and hex
        for instruction, hexInst in zip(binData, data):
            # Split instruction into byte portions
            # Also not gonna explain this one either
            # Credit to https://stackoverflow.com/a/22571558/13821979
            byteset = list(map("".join, zip(*[iter(instruction)]*8)))

            # Loop through byte portions
            for byte in byteset:
                addr = str(itr).zfill(3)  # Pad itr value to 3 spaces
                print(f"instructionMemory[{addr}] = 8'b{byte};", end="")

                if itr % 4 == 0:
                    print(f" // 0x{hexInst}", end="")

                itr += 1

                print("")  # end the line

            print("")  # Newline

    # Prints out the corresponding verilog code for the hex input for RAM data
    @staticmethod
    def verilogCodeRam(data):
        # Remove leading and trailing newlines
        data = data.strip("\n")

        # Split data on newlines
        data = data.splitlines()

        # Calculate binary for each instruction
        binData = [binToHexConverter.hexToBin(inst, 32) for inst in data]

        itr = 0
        # Iterate through each instruction in both binary and hex
        for instruction, hexInst in zip(binData, data):
            # Split instruction into byte portions
            # Also not gonna explain this one either
            # Credit to https://stackoverflow.com/a/22571558/13821979
            byteset = list(map("".join, zip(*[iter(instruction)]*8)))

            # Loop through byte portions
            for byte in byteset:
                addr = str(itr).zfill(3)  # Pad itr value to 3 spaces
                print(f"dataMemory[{addr}] = 8'b{byte};", end="")

                if itr % 4 == 0:
                    print(f" // 0x{hexInst}", end="")

                itr += 1

                print("")  # end the line

            print("")  # Newline


# Instruction Memory data for CMPEN331's final project
romData = """
3c010000
34240050
0c00001b
20050004
ac820000
8c890000
01244022
20050003
20a5ffff
34a8ffff
39085555
2009ffff
312affff
01493025
01494026
01463824
10a00003
00000000
08000008
00000000
2005ffff
000543c0
00084400
00084403
000843c2
08000019
00000000
00004020
8c890000
01094020
20a5ffff
14a0fffc
20840004
03e00008
00081000
"""

ramData = """
000000a3
00000027
00000079
00000115
"""

# binToHexConverter.verilogCodeRom(romData)
binToHexConverter.verilogCodeRam(ramData)
