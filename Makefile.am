bin_PROGRAMS = cpipes

check_PROGRAMS = test_locale
TEST_LOG_DRIVER = prove
TESTS = test_locale

cpipes_SOURCES = src/cpipes.c \
				src/pipe.c src/pipe.h \
				src/render.c src/render.h \
				src/util.c src/util.h
cpipes_CFLAGS = $(WARN_CFLAGS)
cpipes_LDFLAGS = $(WARN_CFLAGS)
cpipes_LDADD = $(CURSES_LIBS)
cpipes_CPPFLAGS = $(CURSES_CFLAGS)

test_locale_SOURCES = t/locale.c \
					  src/pipe.c src/pipe.h \
					  src/util.c src/util.h
test_locale_CFLAGS = -I$(srcdir)/src $(WARN_CFLAGS)
test_locale_LDFLAGS = $(WARN_CFLAGS)
test_locale_LDADD = $(CURSES_LIBS)
test_locale_CPPFLAGS = $(CURSES_CFLAGS)
