#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
AC_PREREQ([2.64])

# Package version from `git describe --always`
AC_INIT([pipes.c],
        m4_esyscmd_s([git describe --always | sed 's/^v//' ]),
        [stefans.mezulis@gmail.com])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([src/cpipes.c])
AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])
AC_PROG_SED
AC_LANG([C])
AC_PROG_CC_C99

dnl Obsolete macro, but required by old versions of automake
AM_PROG_CC_C_O

# Non-release versions have a dash (e.g. 0.0.1-1-g1abcde)
AX_IS_RELEASE([dash-version])

# Require curses
AX_WITH_CURSES

# Enable as many compiler warnings as possible
AX_COMPILER_FLAGS()

# Remove warning for declaration-after-statement: this does not apply to C99
WARN_CFLAGS=$(AS_ECHO(["$WARN_CFLAGS"]) | dnl
              $SED 's/-W\(error=\)\?declaration-after-statement *//g')
AC_SUBST([WARN_CFLAGS])

# Use noreturn attribute if available
AC_CHECK_HEADERS_ONCE([stdnoreturn.h])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
