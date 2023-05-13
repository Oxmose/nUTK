import json
import sys
import os
import re

class COLORS:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

TYPE_STR = [
    "BYTE",
    "UBYTE",
    "HALF",
    "UHALF",
    "WORD",
    "UWORD",
    "DWORD",
    "UDWORD",
    "FLOAT",
    "DOUBLE",
    "RCODE"
]

TARGET_LIST = [
    "x86_64",
    "x86_i386"
]

if __name__ == "__main__":
    print(COLORS.OKBLUE + COLORS.BOLD + "#==============================================================================#" + COLORS.ENDC)
    print(COLORS.OKBLUE + COLORS.BOLD + "| UTK UNIT TEST FRAMEWORK                                                      |" + COLORS.ENDC)
    print(COLORS.OKBLUE + COLORS.BOLD + "#==============================================================================#"  + COLORS.ENDC)
    if len(sys.argv) != 5:
        print("Usage: {} target test_group_file test_list test_file_output".format(sys.argv[0]))
        exit(1)

