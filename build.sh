nasm -f elf64 nabeatsu.s
gcc nabeatsu.o -nostartfiles -no-pie
