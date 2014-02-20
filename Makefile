TARGET = snake
LIBS = -lm -lrt 
LIBS += $(if $(shell pkg-config --exists ncursesw && echo y),\
	$(shell pkg-config --libs ncursesw),\
	$(if $(shell pkg-config --exists ncurses && echo y),\
		$(shell pkg-config --libs ncurses),-lcurses))
CFLAGS = -Wall -std=c99

all: $(TARGET)

$(TARGET): snake.c
	$(CC) -o$@ $(CFLAGS) $< $(LIBS)

clean:
	-rm -f $(TARGET)

.PHONY: all clean
