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


# Instruction Memory data for CMPEN331's final project
projectData = """
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

binToHexConverter.convertPrint(projectData)
