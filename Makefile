TARGET = snake
LIBS = -lm -lrt 
LIBS += $(if $(shell pkg-config --exists ncursesw && echo y),\
	$(shell pkg-config --libs ncursesw),\
	$(if $(shell pkg-config --exists ncurses && echo y),\
		$(shell pkg-config --libs ncurses),-lcurses))
CFLAGS = -Wall -std=c99

INSTALL = install
INSTALL_BIN = $(INSTALL) -D -m 755

PREFIX=/usr/local
DESTDIR=

INSTDIR=$(DESTDIR)$(PREFIX)
INSTBIN=$(INSTDIR)/bin

all: $(TARGET)

$(TARGET): snake.c
	$(CC) -o$@ $(CFLAGS) $< $(LIBS)

clean:
	-rm -f $(TARGET)

install:
	$(INSTALL_BIN) $(TARGET) $(INSTBIN)

uninstall:
	$(RM) $(INSTBIN)/$(TARGET)

.PHONY: all clean install uninstall
