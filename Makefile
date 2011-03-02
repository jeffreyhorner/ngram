CFLAGS=-Wall -O2
CC=gcc
INCLUDES=

wide: wide.c

clean:
	rm wide *.o

.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@
