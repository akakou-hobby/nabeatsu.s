a.out:
	gcc -O9 main.c

run: main.c a.out
	chmod +x ./a.out && ./a.out

time: main.c a.out
	chmod +x ./a.out && time ./a.out

clean:
	rm a.out
