nabeatsu.o: nabeatsu.s
	nasm -f elf64 nabeatsu.s

nabeatsu: nabeatsu.o
	ld -s -o nabeatsu nabeatsu.o

build: nabeatsu.o nabeatsu
	chmod +x ./nabeatsu

run: nabeatsu.s nabeatsu.o nabeatsu
	chmod +x ./nabeatsu && ./nabeatsu

time: nabeatsu.s nabeatsu.o nabeatsu
	chmod +x ./nabeatsu && time ./nabeatsu

clean:
	rm nabeatsu.o nabeatsu
