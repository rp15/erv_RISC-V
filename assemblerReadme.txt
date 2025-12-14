1

Install gcc for riscV:

###############################################
export TOP=$(pwd)

git clone https://github.com/riscv/riscv-tools.git

cd $TOP/riscv-tools

git submodule update --init --recursive

sudo apt-get install autoconf automake autotools-dev curl device-tree-compiler libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config

export RISCV=$TOP/riscv

export PATH=$PATH:$RISCV/bin

./build.sh



#################################
Test it:


cd $TOP

echo -e '#include <stdio.h>\n int main(void) { printf("Hello world!\\n"); return 0; }' > hello.c

riscv64-unknown-elf-gcc -S -o hello.s hello.c

riscv64-unknown-elf-gcc -o hello hello.c

spike $TOP/riscv/riscv64-unknown-elf/bin/pk hello 
###############################################

2

Write C code considering the following:

Variables: Only "long long int." No structures. No pointers.

Every variable needs to get an initial value at declaration (e.g. 0x1).

If you want the variable to be modified in memory, declare it global (outside main). To verify all variables, everything can be declared global. 

You can write your own global/local functions.

Cannot use any predefined functions, #includes.

3

riscv64-unknown-elf-gcc -S -o XXX.s XXX.c

4

Run the assembler (asm_lib.pm needed):

perl riscv_asm.pl PATH_TO_XXX/XXX.s

5

The instruction and data memory are printed to the console. Copy these into the appropriate locations for RTL simulation. The register file can be set to all zeros initially, except for the register at 0x2, the stack pointer. Initial value for sp should be 0x3ffffffff0. The program counter is assumed to be 0x400000 after reset.

6

For verification purposes, a reference data memory might be needed. To obtain final values of variables, the programmer can print the values to console from the C file using gcc or spike (the print statements and includes have to be removed from the code before riscV compilation). Then create a reference data memory that has the expected values at the appropriate addresses. The address of a specific variable can be determined from the symbol table, which is printed to the console during assembly.

