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
        
        bits = len(data)*4 # Calculate amt of bits
        binData = binToHexConverter.hexToBin(data, bits) # Get binary data
        
        itr = 0
        # Iterate through all values, printing spaces and newlines if needed
        for char in binData:
            print(char, end="")
            itr += 1

            if itr % 32 == 0: print("")
            elif itr % 8 == 0: print(" ", end="")
