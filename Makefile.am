bin_PROGRAMS = cpipes

check_PROGRAMS = test_locale test_pipe_cell_list
TESTS = test_locale test_pipe_cell_list

cpipes_SOURCES = src/cpipes.c \
				src/pipe.c src/pipe.h \
				src/render.c src/render.h \
				src/util.c src/util.h \
				src/err.c src/err.h \
				src/canvas.h
cpipes_CFLAGS = $(WARN_CFLAGS)
cpipes_LDFLAGS = $(WARN_LDFLAGS)
cpipes_LDADD = $(CURSES_LIBS)
cpipes_CPPFLAGS = $(CURSES_CFLAGS)

noinst_LIBRARIES = libtap.a
libtap_a_SOURCES = tap/tap.c tap/tap.h

test_locale_SOURCES = t/locale.c \
					  src/pipe.c src/pipe.h \
					  src/util.c src/util.h \
					  src/err.c src/err.h
test_locale_CFLAGS = -I$(srcdir)/src -isystem tap $(WARN_CFLAGS)
test_locale_LDFLAGS = $(WARN_LDFLAGS)
test_locale_LDADD = $(CURSES_LIBS) libtap.a
test_locale_CPPFLAGS = $(CURSES_CFLAGS)

test_pipe_cell_list_SOURCES = t/pipe_cell_list.c \
							  src/pipe.c src/pipe.h \
							  src/util.c src/util.h \
							  src/err.c src/err.h \
							  src/canvas.c src/canvas.h
test_pipe_cell_list_CFLAGS = -I$(srcdir)/src -isystem tap $(WARN_CFLAGS)
test_pipe_cell_list_LDFLAGS = $(WARN_LDFLAGS)
test_pipe_cell_list_LDADD = $(CURSES_LIBS) libtap.a
test_pipe_cell_list_CPPFLAGS = $(CURSES_CFLAGS)

EXTRA_DIST = LICENSE README.md
