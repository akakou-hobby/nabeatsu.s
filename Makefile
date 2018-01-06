nabeatsu: nabeatsu.o
	ld -s -o nabeatsu nabeatsu.o

nabeatsu.o:
	nasm -f elf64 nabeatsu.s

build: nabeatsu.o nabeatsu
	chmod +x ./nabeatsu

run: nabeatsu.s nabeatsu.o nabeatsu
	chmod +x ./nabeatsu && ./nabeatsu

time: nabeatsu.s nabeatsu.o nabeatsu
	chmod +x ./nabeatsu && time ./nabeatsu

clean:
	rm nabeatsu.o nabeatsu
