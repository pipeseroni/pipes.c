#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
AC_PREREQ([2.64])

# Package version from `git describe`
AC_INIT([pipes.c],
        m4_esyscmd_s([git describe --always --tags --dirty | sed 's/^v//' ]),
        [stefans.mezulis@gmail.com])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([src/cpipes.c])
AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])
AC_PROG_SED
AC_LANG([C])
AC_PROG_CC_C99

dnl Obsolete macro, but required by old versions of automake
AM_PROG_CC_C_O

# Use POSIX 200809L functions.
# _POSIX_C_SOURCE >= 200809L should be equivalent to _XOPEN_SOURCE >= 700,
# but at least on RHEL7 it is not.
AC_DEFINE([_POSIX_C_SOURCE], [200809L], [Use POSIX 200809L features])
AC_DEFINE([_XOPEN_SOURCE], [700], [Use POSIX 200809L features])

# Non-release versions have a dash (e.g. 0.0.1-1-g1abcde)
AX_IS_RELEASE([dash-version])

# Require curses
AX_WITH_CURSES


libs=$LIBS
LIBS=$CURSES_LIBS

# Macro for checking for a particular function in all libraies in LIBS
# have_function([preamble], [function(1, 2, 3)], [symbol to define])
AC_DEFUN([have_fn], [dnl
    AC_MSG_CHECKING([for $2])
    AC_LINK_IFELSE([AC_LANG_PROGRAM([$1],
                                    [$2;])],
                   [AC_DEFINE([$3],
                              [1],
                              [have $2])
                    AC_MSG_RESULT([yes])],
                   [AC_MSG_RESULT([no])])
])
have_fn([#include <curses.h>],
        [init_extended_color(0, 0, 0, 0)],
        [HAVE_EXTENDED_COLOR])

have_fn([#include <curses.h>],
        [alloc_pair(0, 0)],
        [HAVE_ALLOC_PAIR])

LIBS=$libs

# Enable as many compiler warnings as possible
AX_COMPILER_FLAGS()

# Remove warning for declaration-after-statement: this does not apply to C99
WARN_CFLAGS=$(AS_ECHO(["$WARN_CFLAGS"]) | dnl
              $SED 's/-W\(error=\)\?declaration-after-statement *//g')
AC_SUBST([WARN_CFLAGS])

# OSX requires linking against libiconv
AC_SEARCH_LIBS([iconv], [iconv], [],
               [AC_MSG_ERROR(["iconv is required for locale conversion"])])
# Some systems require librt for clock_gettime
AC_SEARCH_LIBS([clock_gettime], [rt], [],
               [AC_MSG_ERROR(["clock_gettime is required for timing"])])

# Use noreturn attribute if available
AC_CHECK_HEADERS_ONCE([stdnoreturn.h])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
