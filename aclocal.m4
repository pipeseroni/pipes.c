# generated automatically by aclocal 1.16.5 -*- Autoconf -*-

# Copyright (C) 1996-2021 Free Software Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

m4_ifndef([AC_CONFIG_MACRO_DIRS], [m4_defun([_AM_CONFIG_MACRO_DIRS], [])m4_defun([AC_CONFIG_MACRO_DIRS], [_AM_CONFIG_MACRO_DIRS($@)])])
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
m4_if(m4_defn([AC_AUTOCONF_VERSION]), [2.71],,
[m4_warning([this file was generated for autoconf 2.71.
You have another version of autoconf.  It may work, but is not guaranteed to.
If you have problems, you may need to regenerate the build system entirely.
To do so, use the procedure documented by the package, typically 'autoreconf'.])])

# ===========================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_gcc_func_attribute.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_GCC_FUNC_ATTRIBUTE(ATTRIBUTE)
#
# DESCRIPTION
#
#   This macro checks if the compiler supports one of GCC's function
#   attributes; many other compilers also provide function attributes with
#   the same syntax. Compiler warnings are used to detect supported
#   attributes as unsupported ones are ignored by default so quieting
#   warnings when using this macro will yield false positives.
#
#   The ATTRIBUTE parameter holds the name of the attribute to be checked.
#
#   If ATTRIBUTE is supported define HAVE_FUNC_ATTRIBUTE_<ATTRIBUTE>.
#
#   The macro caches its result in the ax_cv_have_func_attribute_<attribute>
#   variable.
#
#   The macro currently supports the following function attributes:
#
#    alias
#    aligned
#    alloc_size
#    always_inline
#    artificial
#    cold
#    const
#    constructor
#    constructor_priority for constructor attribute with priority
#    deprecated
#    destructor
#    dllexport
#    dllimport
#    error
#    externally_visible
#    fallthrough
#    flatten
#    format
#    format_arg
#    gnu_format
#    gnu_inline
#    hot
#    ifunc
#    leaf
#    malloc
#    noclone
#    noinline
#    nonnull
#    noreturn
#    nothrow
#    optimize
#    pure
#    sentinel
#    sentinel_position
#    unused
#    used
#    visibility
#    warning
#    warn_unused_result
#    weak
#    weakref
#
#   Unsupported function attributes will be tested with a prototype
#   returning an int and not accepting any arguments and the result of the
#   check might be wrong or meaningless so use with care.
#
# LICENSE
#
#   Copyright (c) 2013 Gabriele Svelto <gabriele.svelto@gmail.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 13

AC_DEFUN([AX_GCC_FUNC_ATTRIBUTE], [
    AS_VAR_PUSHDEF([ac_var], [ax_cv_have_func_attribute_$1])

    AC_CACHE_CHECK([for __attribute__(($1))], [ac_var], [
        AC_LINK_IFELSE([AC_LANG_PROGRAM([
            m4_case([$1],
                [alias], [
                    int foo( void ) { return 0; }
                    int bar( void ) __attribute__(($1("foo")));
                ],
                [aligned], [
                    int foo( void ) __attribute__(($1(32)));
                ],
                [alloc_size], [
                    void *foo(int a) __attribute__(($1(1)));
                ],
                [always_inline], [
                    inline __attribute__(($1)) int foo( void ) { return 0; }
                ],
                [artificial], [
                    inline __attribute__(($1)) int foo( void ) { return 0; }
                ],
                [cold], [
                    int foo( void ) __attribute__(($1));
                ],
                [const], [
                    int foo( void ) __attribute__(($1));
                ],
                [constructor_priority], [
                    int foo( void ) __attribute__((__constructor__(65535/2)));
                ],
                [constructor], [
                    int foo( void ) __attribute__(($1));
                ],
                [deprecated], [
                    int foo( void ) __attribute__(($1("")));
                ],
                [destructor], [
                    int foo( void ) __attribute__(($1));
                ],
                [dllexport], [
                    __attribute__(($1)) int foo( void ) { return 0; }
                ],
                [dllimport], [
                    int foo( void ) __attribute__(($1));
                ],
                [error], [
                    int foo( void ) __attribute__(($1("")));
                ],
                [externally_visible], [
                    int foo( void ) __attribute__(($1));
                ],
                [fallthrough], [
                    void foo( int x ) {switch (x) { case 1: __attribute__(($1)); case 2: break ; }};
                ],
                [flatten], [
                    int foo( void ) __attribute__(($1));
                ],
                [format], [
                    int foo(const char *p, ...) __attribute__(($1(printf, 1, 2)));
                ],
                [gnu_format], [
                    int foo(const char *p, ...) __attribute__((format(gnu_printf, 1, 2)));
                ],
                [format_arg], [
                    char *foo(const char *p) __attribute__(($1(1)));
                ],
                [gnu_inline], [
                    inline __attribute__(($1)) int foo( void ) { return 0; }
                ],
                [hot], [
                    int foo( void ) __attribute__(($1));
                ],
                [ifunc], [
                    int my_foo( void ) { return 0; }
                    static int (*resolve_foo(void))(void) { return my_foo; }
                    int foo( void ) __attribute__(($1("resolve_foo")));
                ],
                [leaf], [
                    __attribute__(($1)) int foo( void ) { return 0; }
                ],
                [malloc], [
                    void *foo( void ) __attribute__(($1));
                ],
                [noclone], [
                    int foo( void ) __attribute__(($1));
                ],
                [noinline], [
                    __attribute__(($1)) int foo( void ) { return 0; }
                ],
                [nonnull], [
                    int foo(char *p) __attribute__(($1(1)));
                ],
                [noreturn], [
                    void foo( void ) __attribute__(($1));
                ],
                [nothrow], [
                    int foo( void ) __attribute__(($1));
                ],
                [optimize], [
                    __attribute__(($1(3))) int foo( void ) { return 0; }
                ],
                [pure], [
                    int foo( void ) __attribute__(($1));
                ],
                [sentinel], [
                    int foo(void *p, ...) __attribute__(($1));
                ],
                [sentinel_position], [
                    int foo(void *p, ...) __attribute__(($1(1)));
                ],
                [returns_nonnull], [
                    void *foo( void ) __attribute__(($1));
                ],
                [unused], [
                    int foo( void ) __attribute__(($1));
                ],
                [used], [
                    int foo( void ) __attribute__(($1));
                ],
                [visibility], [
                    int foo_def( void ) __attribute__(($1("default")));
                    int foo_hid( void ) __attribute__(($1("hidden")));
                    int foo_int( void ) __attribute__(($1("internal")));
                    int foo_pro( void ) __attribute__(($1("protected")));
                ],
                [warning], [
                    int foo( void ) __attribute__(($1("")));
                ],
                [warn_unused_result], [
                    int foo( void ) __attribute__(($1));
                ],
                [weak], [
                    int foo( void ) __attribute__(($1));
                ],
                [weakref], [
                    static int foo( void ) { return 0; }
                    static int bar( void ) __attribute__(($1("foo")));
                ],
                [
                 m4_warn([syntax], [Unsupported attribute $1, the test may fail])
                 int foo( void ) __attribute__(($1));
                ]
            )], [])
            ],
            dnl GCC doesn't exit with an error if an unknown attribute is
            dnl provided but only outputs a warning, so accept the attribute
            dnl only if no warning were issued.
            [AS_IF([grep -- -Wattributes conftest.err],
                [AS_VAR_SET([ac_var], [no])],
                [AS_VAR_SET([ac_var], [yes])])],
            [AS_VAR_SET([ac_var], [no])])
    ])

    AS_IF([test yes = AS_VAR_GET([ac_var])],
        [AC_DEFINE_UNQUOTED(AS_TR_CPP(HAVE_FUNC_ATTRIBUTE_$1), 1,
            [Define to 1 if the system has the `$1' function attribute])], [])

    AS_VAR_POPDEF([ac_var])
])

# ===========================================================================
#      https://www.gnu.org/software/autoconf-archive/ax_is_release.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_IS_RELEASE(POLICY)
#
# DESCRIPTION
#
#   Determine whether the code is being configured as a release, or from
#   git. Set the ax_is_release variable to 'yes' or 'no'.
#
#   If building a release version, it is recommended that the configure
#   script disable compiler errors and debug features, by conditionalising
#   them on the ax_is_release variable.  If building from git, these
#   features should be enabled.
#
#   The POLICY parameter specifies how ax_is_release is determined. It can
#   take the following values:
#
#    * git-directory:  ax_is_release will be 'no' if a '.git'
#                      directory or git worktree exists
#    * minor-version:  ax_is_release will be 'no' if the minor version number
#                      in $PACKAGE_VERSION is odd; this assumes
#                      $PACKAGE_VERSION follows the 'major.minor.micro' scheme
#    * micro-version:  ax_is_release will be 'no' if the micro version number
#                      in $PACKAGE_VERSION is odd; this assumes
#                      $PACKAGE_VERSION follows the 'major.minor.micro' scheme
#    * dash-version:   ax_is_release will be 'no' if there is a dash '-'
#                      in $PACKAGE_VERSION, for example 1.2-pre3, 1.2.42-a8b9
#                      or 2.0-dirty (in particular this is suitable for use
#                      with git-version-gen)
#    * always:         ax_is_release will always be 'yes'
#    * never:          ax_is_release will always be 'no'
#
#   Other policies may be added in future.
#
# LICENSE
#
#   Copyright (c) 2015 Philip Withnall <philip@tecnocode.co.uk>
#   Copyright (c) 2016 Collabora Ltd.
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.

#serial 8

AC_DEFUN([AX_IS_RELEASE],[
    AC_BEFORE([AC_INIT],[$0])

    m4_case([$1],
      [git-directory],[
        # $is_release = (.git directory does not exist)
        AS_IF([test -d ${srcdir}/.git || (test -f ${srcdir}/.git && grep \.git/worktrees ${srcdir}/.git)],[ax_is_release=no],[ax_is_release=yes])
      ],
      [minor-version],[
        # $is_release = ($minor_version is even)
        minor_version=`echo "$PACKAGE_VERSION" | sed 's/[[^.]][[^.]]*.\([[^.]][[^.]]*\).*/\1/'`
        AS_IF([test "$(( $minor_version % 2 ))" -ne 0],
              [ax_is_release=no],[ax_is_release=yes])
      ],
      [micro-version],[
        # $is_release = ($micro_version is even)
        micro_version=`echo "$PACKAGE_VERSION" | sed 's/[[^.]]*\.[[^.]]*\.\([[^.]]*\).*/\1/'`
        AS_IF([test "$(( $micro_version % 2 ))" -ne 0],
              [ax_is_release=no],[ax_is_release=yes])
      ],
      [dash-version],[
        # $is_release = ($PACKAGE_VERSION has a dash)
        AS_CASE([$PACKAGE_VERSION],
                [*-*], [ax_is_release=no],
                [*], [ax_is_release=yes])
      ],
      [always],[ax_is_release=yes],
      [never],[ax_is_release=no],
      [
        AC_MSG_ERROR([Invalid policy. Valid policies: git-directory, minor-version, micro-version, dash-version, always, never.])
      ])
])

# ===========================================================================
#    https://www.gnu.org/software/autoconf-archive/ax_require_defined.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_REQUIRE_DEFINED(MACRO)
#
# DESCRIPTION
#
#   AX_REQUIRE_DEFINED is a simple helper for making sure other macros have
#   been defined and thus are available for use.  This avoids random issues
#   where a macro isn't expanded.  Instead the configure script emits a
#   non-fatal:
#
#     ./configure: line 1673: AX_CFLAGS_WARN_ALL: command not found
#
#   It's like AC_REQUIRE except it doesn't expand the required macro.
#
#   Here's an example:
#
#     AX_REQUIRE_DEFINED([AX_CHECK_LINK_FLAG])
#
# LICENSE
#
#   Copyright (c) 2014 Mike Frysinger <vapier@gentoo.org>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 2

AC_DEFUN([AX_REQUIRE_DEFINED], [dnl
  m4_ifndef([$1], [m4_fatal([macro ]$1[ is not defined; is a m4 file missing?])])
])dnl AX_REQUIRE_DEFINED

# ===========================================================================
#      https://www.gnu.org/software/autoconf-archive/ax_with_curses.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_WITH_CURSES
#
# DESCRIPTION
#
#   This macro checks whether a SysV or X/Open-compatible Curses library is
#   present, along with the associated header file.  The NcursesW
#   (wide-character) library is searched for first, followed by Ncurses,
#   then the system-default plain Curses.  The first library found is the
#   one returned. Finding libraries will first be attempted by using
#   pkg-config, and should the pkg-config files not be available, will
#   fallback to combinations of known flags itself.
#
#   The following options are understood: --with-ncursesw, --with-ncurses,
#   --without-ncursesw, --without-ncurses.  The "--with" options force the
#   macro to use that particular library, terminating with an error if not
#   found.  The "--without" options simply skip the check for that library.
#   The effect on the search pattern is:
#
#     (no options)                           - NcursesW, Ncurses, Curses
#     --with-ncurses     --with-ncursesw     - NcursesW only [*]
#     --without-ncurses  --with-ncursesw     - NcursesW only [*]
#                        --with-ncursesw     - NcursesW only [*]
#     --with-ncurses     --without-ncursesw  - Ncurses only [*]
#     --with-ncurses                         - NcursesW, Ncurses [**]
#     --without-ncurses  --without-ncursesw  - Curses only
#                        --without-ncursesw  - Ncurses, Curses
#     --without-ncurses                      - NcursesW, Curses
#
#   [*]  If the library is not found, abort the configure script.
#
#   [**] If the second library (Ncurses) is not found, abort configure.
#
#   The following preprocessor symbols may be defined by this macro if the
#   appropriate conditions are met:
#
#     HAVE_CURSES             - if any SysV or X/Open Curses library found
#     HAVE_CURSES_ENHANCED    - if library supports X/Open Enhanced functions
#     HAVE_CURSES_COLOR       - if library supports color (enhanced functions)
#     HAVE_CURSES_OBSOLETE    - if library supports certain obsolete features
#     HAVE_NCURSESW           - if NcursesW (wide char) library is to be used
#     HAVE_NCURSES            - if the Ncurses library is to be used
#
#     HAVE_CURSES_H           - if <curses.h> is present and should be used
#     HAVE_NCURSESW_H         - if <ncursesw.h> should be used
#     HAVE_NCURSES_H          - if <ncurses.h> should be used
#     HAVE_NCURSESW_CURSES_H  - if <ncursesw/curses.h> should be used
#     HAVE_NCURSES_CURSES_H   - if <ncurses/curses.h> should be used
#
#   (These preprocessor symbols are discussed later in this document.)
#
#   The following output variables are defined by this macro; they are
#   precious and may be overridden on the ./configure command line:
#
#     CURSES_LIBS  - library to add to xxx_LDADD
#     CURSES_CFLAGS  - include paths to add to xxx_CPPFLAGS
#
#   In previous versions of this macro, the flags CURSES_LIB and
#   CURSES_CPPFLAGS were defined. These have been renamed, in keeping with
#   AX_WITH_CURSES's close bigger brother, PKG_CHECK_MODULES, which should
#   eventually supersede the use of AX_WITH_CURSES. Neither the library
#   listed in CURSES_LIBS, nor the flags in CURSES_CFLAGS are added to LIBS,
#   respectively CPPFLAGS, by default. You need to add both to the
#   appropriate xxx_LDADD/xxx_CPPFLAGS line in your Makefile.am. For
#   example:
#
#     prog_LDADD = @CURSES_LIBS@
#     prog_CPPFLAGS = @CURSES_CFLAGS@
#
#   If CURSES_LIBS is set on the configure command line (such as by running
#   "./configure CURSES_LIBS=-lmycurses"), then the only header searched for
#   is <curses.h>. If the user needs to specify an alternative path for a
#   library (such as for a non-standard NcurseW), the user should use the
#   LDFLAGS variable.
#
#   The following shell variables may be defined by this macro:
#
#     ax_cv_curses           - set to "yes" if any Curses library found
#     ax_cv_curses_enhanced  - set to "yes" if Enhanced functions present
#     ax_cv_curses_color     - set to "yes" if color functions present
#     ax_cv_curses_obsolete  - set to "yes" if obsolete features present
#
#     ax_cv_ncursesw      - set to "yes" if NcursesW library found
#     ax_cv_ncurses       - set to "yes" if Ncurses library found
#     ax_cv_plaincurses   - set to "yes" if plain Curses library found
#     ax_cv_curses_which  - set to "ncursesw", "ncurses", "plaincurses" or "no"
#
#   These variables can be used in your configure.ac to determine the level
#   of support you need from the Curses library.  For example, if you must
#   have either Ncurses or NcursesW, you could include:
#
#     AX_WITH_CURSES
#     if test "x$ax_cv_ncursesw" != xyes && test "x$ax_cv_ncurses" != xyes; then
#         AC_MSG_ERROR([requires either NcursesW or Ncurses library])
#     fi
#
#   If any Curses library will do (but one must be present and must support
#   color), you could use:
#
#     AX_WITH_CURSES
#     if test "x$ax_cv_curses" != xyes || test "x$ax_cv_curses_color" != xyes; then
#         AC_MSG_ERROR([requires an X/Open-compatible Curses library with color])
#     fi
#
#   Certain preprocessor symbols and shell variables defined by this macro
#   can be used to determine various features of the Curses library.  In
#   particular, HAVE_CURSES and ax_cv_curses are defined if the Curses
#   library found conforms to the traditional SysV and/or X/Open Base Curses
#   definition.  Any working Curses library conforms to this level.
#
#   HAVE_CURSES_ENHANCED and ax_cv_curses_enhanced are defined if the
#   library supports the X/Open Enhanced Curses definition.  In particular,
#   the wide-character types attr_t, cchar_t and wint_t, the functions
#   wattr_set() and wget_wch() and the macros WA_NORMAL and _XOPEN_CURSES
#   are checked.  The Ncurses library does NOT conform to this definition,
#   although NcursesW does.
#
#   HAVE_CURSES_COLOR and ax_cv_curses_color are defined if the library
#   supports color functions and macros such as COLOR_PAIR, A_COLOR,
#   COLOR_WHITE, COLOR_RED and init_pair().  These are NOT part of the
#   X/Open Base Curses definition, but are part of the Enhanced set of
#   functions.  The Ncurses library DOES support these functions, as does
#   NcursesW.
#
#   HAVE_CURSES_OBSOLETE and ax_cv_curses_obsolete are defined if the
#   library supports certain features present in SysV and BSD Curses but not
#   defined in the X/Open definition.  In particular, the functions
#   getattrs(), getcurx() and getmaxx() are checked.
#
#   To use the HAVE_xxx_H preprocessor symbols, insert the following into
#   your system.h (or equivalent) header file:
#
#     #if defined HAVE_NCURSESW_CURSES_H
#     #  include <ncursesw/curses.h>
#     #elif defined HAVE_NCURSESW_H
#     #  include <ncursesw.h>
#     #elif defined HAVE_NCURSES_CURSES_H
#     #  include <ncurses/curses.h>
#     #elif defined HAVE_NCURSES_H
#     #  include <ncurses.h>
#     #elif defined HAVE_CURSES_H
#     #  include <curses.h>
#     #else
#     #  error "SysV or X/Open-compatible Curses header file required"
#     #endif
#
#   For previous users of this macro: you should not need to change anything
#   in your configure.ac or Makefile.am, as the previous (serial 10)
#   semantics are still valid.  However, you should update your system.h (or
#   equivalent) header file to the fragment shown above. You are encouraged
#   also to make use of the extended functionality provided by this version
#   of AX_WITH_CURSES, as well as in the additional macros
#   AX_WITH_CURSES_PANEL, AX_WITH_CURSES_MENU and AX_WITH_CURSES_FORM.
#
# LICENSE
#
#   Copyright (c) 2009 Mark Pulford <mark@kyne.com.au>
#   Copyright (c) 2009 Damian Pietras <daper@daper.net>
#   Copyright (c) 2012 Reuben Thomas <rrt@sc3d.org>
#   Copyright (c) 2011 John Zaitseff <J.Zaitseff@zap.org.au>
#
#   This program is free software: you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation, either version 3 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <https://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.

#serial 18

# internal function to factorize common code that is used by both ncurses
# and ncursesw
AC_DEFUN([_FIND_CURSES_FLAGS], [
    AC_MSG_CHECKING([for $1 via pkg-config])

    AX_REQUIRE_DEFINED([PKG_CHECK_EXISTS])
    _PKG_CONFIG([_ax_cv_$1_libs], [libs], [$1])
    _PKG_CONFIG([_ax_cv_$1_cppflags], [cflags], [$1])

    AS_IF([test "x$pkg_failed" = "xyes" || test "x$pkg_failed" = "xuntried"],[
        AC_MSG_RESULT([no])
        # No suitable .pc file found, have to find flags via fallback
        AC_CACHE_CHECK([for $1 via fallback], [ax_cv_$1], [
            AS_ECHO()
            pkg_cv__ax_cv_$1_libs="-l$1"
            pkg_cv__ax_cv_$1_cppflags="-D_GNU_SOURCE $CURSES_CFLAGS"
            LIBS="$ax_saved_LIBS $pkg_cv__ax_cv_$1_libs"
            CPPFLAGS="$ax_saved_CPPFLAGS $pkg_cv__ax_cv_$1_cppflags"

            AC_MSG_CHECKING([for initscr() with $pkg_cv__ax_cv_$1_libs])
            AC_LINK_IFELSE([AC_LANG_CALL([], [initscr])],
                [
                    AC_MSG_RESULT([yes])
                    AC_MSG_CHECKING([for nodelay() with $pkg_cv__ax_cv_$1_libs])
                    AC_LINK_IFELSE([AC_LANG_CALL([], [nodelay])],[
                        ax_cv_$1=yes
                        ],[
                        AC_MSG_RESULT([no])
                        m4_if(
                            [$1],[ncursesw],[pkg_cv__ax_cv_$1_libs="$pkg_cv__ax_cv_$1_libs -ltinfow"],
                            [$1],[ncurses],[pkg_cv__ax_cv_$1_libs="$pkg_cv__ax_cv_$1_libs -ltinfo"]
                        )
                        LIBS="$ax_saved_LIBS $pkg_cv__ax_cv_$1_libs"

                        AC_MSG_CHECKING([for nodelay() with $pkg_cv__ax_cv_$1_libs])
                        AC_LINK_IFELSE([AC_LANG_CALL([], [nodelay])],[
                            ax_cv_$1=yes
                            ],[
                            ax_cv_$1=no
                        ])
                    ])
                ],[
                    ax_cv_$1=no
            ])
        ])
        ],[
        AC_MSG_RESULT([yes])
        # Found .pc file, using its information
        LIBS="$ax_saved_LIBS $pkg_cv__ax_cv_$1_libs"
        CPPFLAGS="$ax_saved_CPPFLAGS $pkg_cv__ax_cv_$1_cppflags"
        ax_cv_$1=yes
    ])
])

AU_ALIAS([MP_WITH_CURSES], [AX_WITH_CURSES])
AC_DEFUN([AX_WITH_CURSES], [
    AC_ARG_VAR([CURSES_LIBS], [linker library for Curses, e.g. -lcurses])
    AC_ARG_VAR([CURSES_CFLAGS], [preprocessor flags for Curses, e.g. -I/usr/include/ncursesw])
    AC_ARG_WITH([ncurses], [AS_HELP_STRING([--with-ncurses],
        [force the use of Ncurses or NcursesW])],
        [], [with_ncurses=check])
    AC_ARG_WITH([ncursesw], [AS_HELP_STRING([--without-ncursesw],
        [do not use NcursesW (wide character support)])],
        [], [with_ncursesw=check])

    ax_saved_LIBS=$LIBS
    ax_saved_CPPFLAGS=$CPPFLAGS

    AS_IF([test "x$with_ncurses" = xyes || test "x$with_ncursesw" = xyes],
        [ax_with_plaincurses=no], [ax_with_plaincurses=check])

    ax_cv_curses_which=no

    # Test for NcursesW
    AS_IF([test "x$CURSES_LIBS" = x && test "x$with_ncursesw" != xno], [
        _FIND_CURSES_FLAGS([ncursesw])

        AS_IF([test "x$ax_cv_ncursesw" = xno && test "x$with_ncursesw" = xyes], [
            AC_MSG_ERROR([--with-ncursesw specified but could not find NcursesW library])
        ])

        AS_IF([test "x$ax_cv_ncursesw" = xyes], [
            ax_cv_curses=yes
            ax_cv_curses_which=ncursesw
            CURSES_LIBS="$pkg_cv__ax_cv_ncursesw_libs"
            CURSES_CFLAGS="$pkg_cv__ax_cv_ncursesw_cppflags"
            AC_DEFINE([HAVE_NCURSESW], [1], [Define to 1 if the NcursesW library is present])
            AC_DEFINE([HAVE_CURSES],   [1], [Define to 1 if a SysV or X/Open compatible Curses library is present])

            AC_CACHE_CHECK([for working ncursesw/curses.h], [ax_cv_header_ncursesw_curses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <ncursesw/curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        attr_t d = WA_NORMAL;
                        cchar_t e;
                        wint_t f;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                        wattr_set(stdscr, d, 0, NULL);
                        wget_wch(stdscr, &f);
                    ]])],
                    [ax_cv_header_ncursesw_curses_h=yes],
                    [ax_cv_header_ncursesw_curses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncursesw_curses_h" = xyes], [
                ax_cv_curses_enhanced=yes
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_ENHANCED],   [1], [Define to 1 if library supports X/Open Enhanced functions])
                AC_DEFINE([HAVE_CURSES_COLOR],      [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE],   [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSESW_CURSES_H], [1], [Define to 1 if <ncursesw/curses.h> is present])
            ])

            AC_CACHE_CHECK([for working ncursesw.h], [ax_cv_header_ncursesw_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <ncursesw.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        attr_t d = WA_NORMAL;
                        cchar_t e;
                        wint_t f;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                        wattr_set(stdscr, d, 0, NULL);
                        wget_wch(stdscr, &f);
                    ]])],
                    [ax_cv_header_ncursesw_h=yes],
                    [ax_cv_header_ncursesw_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncursesw_h" = xyes], [
                ax_cv_curses_enhanced=yes
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_ENHANCED], [1], [Define to 1 if library supports X/Open Enhanced functions])
                AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSESW_H],      [1], [Define to 1 if <ncursesw.h> is present])
            ])

            AC_CACHE_CHECK([for working ncurses.h], [ax_cv_header_ncurses_h_with_ncursesw], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <ncurses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        attr_t d = WA_NORMAL;
                        cchar_t e;
                        wint_t f;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                        wattr_set(stdscr, d, 0, NULL);
                        wget_wch(stdscr, &f);
                    ]])],
                    [ax_cv_header_ncurses_h_with_ncursesw=yes],
                    [ax_cv_header_ncurses_h_with_ncursesw=no])
            ])
            AS_IF([test "x$ax_cv_header_ncurses_h_with_ncursesw" = xyes], [
                ax_cv_curses_enhanced=yes
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_ENHANCED], [1], [Define to 1 if library supports X/Open Enhanced functions])
                AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSES_H],       [1], [Define to 1 if <ncurses.h> is present])
            ])

            AS_IF([test "x$ax_cv_header_ncursesw_curses_h" = xno && test "x$ax_cv_header_ncursesw_h" = xno && test "x$ax_cv_header_ncurses_h_with_ncursesw" = xno], [
                AC_MSG_WARN([could not find a working ncursesw/curses.h, ncursesw.h or ncurses.h])
            ])
        ])
    ])
    unset pkg_cv__ax_cv_ncursesw_libs
    unset pkg_cv__ax_cv_ncursesw_cppflags

    # Test for Ncurses
    AS_IF([test "x$CURSES_LIBS" = x && test "x$with_ncurses" != xno && test "x$ax_cv_curses_which" = xno], [
        _FIND_CURSES_FLAGS([ncurses])

        AS_IF([test "x$ax_cv_ncurses" = xno && test "x$with_ncurses" = xyes], [
            AC_MSG_ERROR([--with-ncurses specified but could not find Ncurses library])
        ])

        AS_IF([test "x$ax_cv_ncurses" = xyes], [
            ax_cv_curses=yes
            ax_cv_curses_which=ncurses
            CURSES_LIBS="$pkg_cv__ax_cv_ncurses_libs"
            CURSES_CFLAGS="$pkg_cv__ax_cv_ncurses_cppflags"
            AC_DEFINE([HAVE_NCURSES], [1], [Define to 1 if the Ncurses library is present])
            AC_DEFINE([HAVE_CURSES],  [1], [Define to 1 if a SysV or X/Open compatible Curses library is present])

            AC_CACHE_CHECK([for working ncurses/curses.h], [ax_cv_header_ncurses_curses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <ncurses/curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                    ]])],
                    [ax_cv_header_ncurses_curses_h=yes],
                    [ax_cv_header_ncurses_curses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncurses_curses_h" = xyes], [
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_COLOR],     [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE],  [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSES_CURSES_H], [1], [Define to 1 if <ncurses/curses.h> is present])
            ])

            AC_CACHE_CHECK([for working ncurses.h], [ax_cv_header_ncurses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <ncurses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                    ]])],
                    [ax_cv_header_ncurses_h=yes],
                    [ax_cv_header_ncurses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncurses_h" = xyes], [
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSES_H],       [1], [Define to 1 if <ncurses.h> is present])
            ])

            AS_IF([test "x$ax_cv_header_ncurses_curses_h" = xno && test "x$ax_cv_header_ncurses_h" = xno], [
                AC_MSG_WARN([could not find a working ncurses/curses.h or ncurses.h])
            ])
        ])
    ])
    unset pkg_cv__ax_cv_ncurses_libs
    unset pkg_cv__ax_cv_ncurses_cppflags

    # Test for plain Curses (or if CURSES_LIBS was set by user)
    AS_IF([test "x$with_plaincurses" != xno && test "x$ax_cv_curses_which" = xno], [
        AS_IF([test "x$CURSES_LIBS" != x], [
            LIBS="$ax_saved_LIBS $CURSES_LIBS"
        ], [
            LIBS="$ax_saved_LIBS -lcurses"
        ])

        AC_CACHE_CHECK([for Curses library], [ax_cv_plaincurses], [
            AC_LINK_IFELSE([AC_LANG_CALL([], [initscr])],
                [ax_cv_plaincurses=yes], [ax_cv_plaincurses=no])
        ])

        AS_IF([test "x$ax_cv_plaincurses" = xyes], [
            ax_cv_curses=yes
            ax_cv_curses_which=plaincurses
            AS_IF([test "x$CURSES_LIBS" = x], [
                CURSES_LIBS="-lcurses"
            ])
            AC_DEFINE([HAVE_CURSES], [1], [Define to 1 if a SysV or X/Open compatible Curses library is present])

            # Check for base conformance (and header file)

            AC_CACHE_CHECK([for working curses.h], [ax_cv_header_curses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        initscr();
                    ]])],
                    [ax_cv_header_curses_h=yes],
                    [ax_cv_header_curses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_curses_h" = xyes], [
                AC_DEFINE([HAVE_CURSES_H], [1], [Define to 1 if <curses.h> is present])

                # Check for X/Open Enhanced conformance

                AC_CACHE_CHECK([for X/Open Enhanced Curses conformance], [ax_cv_plaincurses_enhanced], [
                    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                            @%:@define _XOPEN_SOURCE_EXTENDED 1
                            @%:@include <curses.h>
                            @%:@ifndef _XOPEN_CURSES
                            @%:@error "this Curses library is not enhanced"
                            "this Curses library is not enhanced"
                            @%:@endif
                        ]], [[
                            chtype a = A_BOLD;
                            int b = KEY_LEFT;
                            chtype c = COLOR_PAIR(1) & A_COLOR;
                            attr_t d = WA_NORMAL;
                            cchar_t e;
                            wint_t f;
                            initscr();
                            init_pair(1, COLOR_WHITE, COLOR_RED);
                            wattr_set(stdscr, d, 0, NULL);
                            wget_wch(stdscr, &f);
                        ]])],
                        [ax_cv_plaincurses_enhanced=yes],
                        [ax_cv_plaincurses_enhanced=no])
                ])
                AS_IF([test "x$ax_cv_plaincurses_enhanced" = xyes], [
                    ax_cv_curses_enhanced=yes
                    ax_cv_curses_color=yes
                    AC_DEFINE([HAVE_CURSES_ENHANCED], [1], [Define to 1 if library supports X/Open Enhanced functions])
                    AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                ])

                # Check for color functions

                AC_CACHE_CHECK([for Curses color functions], [ax_cv_plaincurses_color], [
                    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <curses.h>
                        ]], [[
                            chtype a = A_BOLD;
                            int b = KEY_LEFT;
                            chtype c = COLOR_PAIR(1) & A_COLOR;
                            initscr();
                            init_pair(1, COLOR_WHITE, COLOR_RED);
                        ]])],
                        [ax_cv_plaincurses_color=yes],
                        [ax_cv_plaincurses_color=no])
                ])
                AS_IF([test "x$ax_cv_plaincurses_color" = xyes], [
                    ax_cv_curses_color=yes
                    AC_DEFINE([HAVE_CURSES_COLOR], [1], [Define to 1 if library supports color (enhanced functions)])
                ])

                # Check for obsolete functions

                AC_CACHE_CHECK([for obsolete Curses functions], [ax_cv_plaincurses_obsolete], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                    ]])],
                    [ax_cv_plaincurses_obsolete=yes],
                    [ax_cv_plaincurses_obsolete=no])
                ])
                AS_IF([test "x$ax_cv_plaincurses_obsolete" = xyes], [
                    ax_cv_curses_obsolete=yes
                    AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                ])
            ])

            AS_IF([test "x$ax_cv_header_curses_h" = xno], [
                AC_MSG_WARN([could not find a working curses.h])
            ])
        ])
    ])

    AS_IF([test "x$ax_cv_curses"          != xyes], [ax_cv_curses=no])
    AS_IF([test "x$ax_cv_curses_enhanced" != xyes], [ax_cv_curses_enhanced=no])
    AS_IF([test "x$ax_cv_curses_color"    != xyes], [ax_cv_curses_color=no])
    AS_IF([test "x$ax_cv_curses_obsolete" != xyes], [ax_cv_curses_obsolete=no])

    LIBS=$ax_saved_LIBS
    CPPFLAGS=$ax_saved_CPPFLAGS

    unset ax_saved_LIBS
    unset ax_saved_CPPFLAGS
])dnl

# pkg.m4 - Macros to locate and utilise pkg-config.   -*- Autoconf -*-
# serial 11 (pkg-config-0.29.1)

dnl Copyright © 2004 Scott James Remnant <scott@netsplit.com>.
dnl Copyright © 2012-2015 Dan Nicholson <dbn.lists@gmail.com>
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful, but
dnl WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
dnl General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
dnl 02111-1307, USA.
dnl
dnl As a special exception to the GNU General Public License, if you
dnl distribute this file as part of a program that contains a
dnl configuration script generated by Autoconf, you may include it under
dnl the same distribution terms that you use for the rest of that
dnl program.

dnl PKG_PREREQ(MIN-VERSION)
dnl -----------------------
dnl Since: 0.29
dnl
dnl Verify that the version of the pkg-config macros are at least
dnl MIN-VERSION. Unlike PKG_PROG_PKG_CONFIG, which checks the user's
dnl installed version of pkg-config, this checks the developer's version
dnl of pkg.m4 when generating configure.
dnl
dnl To ensure that this macro is defined, also add:
dnl m4_ifndef([PKG_PREREQ],
dnl     [m4_fatal([must install pkg-config 0.29 or later before running autoconf/autogen])])
dnl
dnl See the "Since" comment for each macro you use to see what version
dnl of the macros you require.
m4_defun([PKG_PREREQ],
[m4_define([PKG_MACROS_VERSION], [0.29.1])
m4_if(m4_version_compare(PKG_MACROS_VERSION, [$1]), -1,
    [m4_fatal([pkg.m4 version $1 or higher is required but ]PKG_MACROS_VERSION[ found])])
])dnl PKG_PREREQ

dnl PKG_PROG_PKG_CONFIG([MIN-VERSION])
dnl ----------------------------------
dnl Since: 0.16
dnl
dnl Search for the pkg-config tool and set the PKG_CONFIG variable to
dnl first found in the path. Checks that the version of pkg-config found
dnl is at least MIN-VERSION. If MIN-VERSION is not specified, 0.9.0 is
dnl used since that's the first version where most current features of
dnl pkg-config existed.
AC_DEFUN([PKG_PROG_PKG_CONFIG],
[m4_pattern_forbid([^_?PKG_[A-Z_]+$])
m4_pattern_allow([^PKG_CONFIG(_(PATH|LIBDIR|SYSROOT_DIR|ALLOW_SYSTEM_(CFLAGS|LIBS)))?$])
m4_pattern_allow([^PKG_CONFIG_(DISABLE_UNINSTALLED|TOP_BUILD_DIR|DEBUG_SPEW)$])
AC_ARG_VAR([PKG_CONFIG], [path to pkg-config utility])
AC_ARG_VAR([PKG_CONFIG_PATH], [directories to add to pkg-config's search path])
AC_ARG_VAR([PKG_CONFIG_LIBDIR], [path overriding pkg-config's built-in search path])

if test "x$ac_cv_env_PKG_CONFIG_set" != "xset"; then
	AC_PATH_TOOL([PKG_CONFIG], [pkg-config])
fi
if test -n "$PKG_CONFIG"; then
	_pkg_min_version=m4_default([$1], [0.9.0])
	AC_MSG_CHECKING([pkg-config is at least version $_pkg_min_version])
	if $PKG_CONFIG --atleast-pkgconfig-version $_pkg_min_version; then
		AC_MSG_RESULT([yes])
	else
		AC_MSG_RESULT([no])
		PKG_CONFIG=""
	fi
fi[]dnl
])dnl PKG_PROG_PKG_CONFIG

dnl PKG_CHECK_EXISTS(MODULES, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl -------------------------------------------------------------------
dnl Since: 0.18
dnl
dnl Check to see whether a particular set of modules exists. Similar to
dnl PKG_CHECK_MODULES(), but does not set variables or print errors.
dnl
dnl Please remember that m4 expands AC_REQUIRE([PKG_PROG_PKG_CONFIG])
dnl only at the first occurence in configure.ac, so if the first place
dnl it's called might be skipped (such as if it is within an "if", you
dnl have to call PKG_CHECK_EXISTS manually
AC_DEFUN([PKG_CHECK_EXISTS],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
if test -n "$PKG_CONFIG" && \
    AC_RUN_LOG([$PKG_CONFIG --exists --print-errors "$1"]); then
  m4_default([$2], [:])
m4_ifvaln([$3], [else
  $3])dnl
fi])

dnl _PKG_CONFIG([VARIABLE], [COMMAND], [MODULES])
dnl ---------------------------------------------
dnl Internal wrapper calling pkg-config via PKG_CONFIG and setting
dnl pkg_failed based on the result.
m4_define([_PKG_CONFIG],
[if test -n "$$1"; then
    pkg_cv_[]$1="$$1"
 elif test -n "$PKG_CONFIG"; then
    PKG_CHECK_EXISTS([$3],
                     [pkg_cv_[]$1=`$PKG_CONFIG --[]$2 "$3" 2>/dev/null`
		      test "x$?" != "x0" && pkg_failed=yes ],
		     [pkg_failed=yes])
 else
    pkg_failed=untried
fi[]dnl
])dnl _PKG_CONFIG

dnl _PKG_SHORT_ERRORS_SUPPORTED
dnl ---------------------------
dnl Internal check to see if pkg-config supports short errors.
AC_DEFUN([_PKG_SHORT_ERRORS_SUPPORTED],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])
if $PKG_CONFIG --atleast-pkgconfig-version 0.20; then
        _pkg_short_errors_supported=yes
else
        _pkg_short_errors_supported=no
fi[]dnl
])dnl _PKG_SHORT_ERRORS_SUPPORTED


dnl PKG_CHECK_MODULES(VARIABLE-PREFIX, MODULES, [ACTION-IF-FOUND],
dnl   [ACTION-IF-NOT-FOUND])
dnl --------------------------------------------------------------
dnl Since: 0.4.0
dnl
dnl Note that if there is a possibility the first call to
dnl PKG_CHECK_MODULES might not happen, you should be sure to include an
dnl explicit call to PKG_PROG_PKG_CONFIG in your configure.ac
AC_DEFUN([PKG_CHECK_MODULES],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
AC_ARG_VAR([$1][_CFLAGS], [C compiler flags for $1, overriding pkg-config])dnl
AC_ARG_VAR([$1][_LIBS], [linker flags for $1, overriding pkg-config])dnl

pkg_failed=no
AC_MSG_CHECKING([for $1])

_PKG_CONFIG([$1][_CFLAGS], [cflags], [$2])
_PKG_CONFIG([$1][_LIBS], [libs], [$2])

m4_define([_PKG_TEXT], [Alternatively, you may set the environment variables $1[]_CFLAGS
and $1[]_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.])

if test $pkg_failed = yes; then
   	AC_MSG_RESULT([no])
        _PKG_SHORT_ERRORS_SUPPORTED
        if test $_pkg_short_errors_supported = yes; then
	        $1[]_PKG_ERRORS=`$PKG_CONFIG --short-errors --print-errors --cflags --libs "$2" 2>&1`
        else 
	        $1[]_PKG_ERRORS=`$PKG_CONFIG --print-errors --cflags --libs "$2" 2>&1`
        fi
	# Put the nasty error message in config.log where it belongs
	echo "$$1[]_PKG_ERRORS" >&AS_MESSAGE_LOG_FD

	m4_default([$4], [AC_MSG_ERROR(
[Package requirements ($2) were not met:

$$1_PKG_ERRORS

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

_PKG_TEXT])[]dnl
        ])
elif test $pkg_failed = untried; then
     	AC_MSG_RESULT([no])
	m4_default([$4], [AC_MSG_FAILURE(
[The pkg-config script could not be found or is too old.  Make sure it
is in your PATH or set the PKG_CONFIG environment variable to the full
path to pkg-config.

_PKG_TEXT

To get pkg-config, see <http://pkg-config.freedesktop.org/>.])[]dnl
        ])
else
	$1[]_CFLAGS=$pkg_cv_[]$1[]_CFLAGS
	$1[]_LIBS=$pkg_cv_[]$1[]_LIBS
        AC_MSG_RESULT([yes])
	$3
fi[]dnl
])dnl PKG_CHECK_MODULES


dnl PKG_CHECK_MODULES_STATIC(VARIABLE-PREFIX, MODULES, [ACTION-IF-FOUND],
dnl   [ACTION-IF-NOT-FOUND])
dnl ---------------------------------------------------------------------
dnl Since: 0.29
dnl
dnl Checks for existence of MODULES and gathers its build flags with
dnl static libraries enabled. Sets VARIABLE-PREFIX_CFLAGS from --cflags
dnl and VARIABLE-PREFIX_LIBS from --libs.
dnl
dnl Note that if there is a possibility the first call to
dnl PKG_CHECK_MODULES_STATIC might not happen, you should be sure to
dnl include an explicit call to PKG_PROG_PKG_CONFIG in your
dnl configure.ac.
AC_DEFUN([PKG_CHECK_MODULES_STATIC],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
_save_PKG_CONFIG=$PKG_CONFIG
PKG_CONFIG="$PKG_CONFIG --static"
PKG_CHECK_MODULES($@)
PKG_CONFIG=$_save_PKG_CONFIG[]dnl
])dnl PKG_CHECK_MODULES_STATIC


dnl PKG_INSTALLDIR([DIRECTORY])
dnl -------------------------
dnl Since: 0.27
dnl
dnl Substitutes the variable pkgconfigdir as the location where a module
dnl should install pkg-config .pc files. By default the directory is
dnl $libdir/pkgconfig, but the default can be changed by passing
dnl DIRECTORY. The user can override through the --with-pkgconfigdir
dnl parameter.
AC_DEFUN([PKG_INSTALLDIR],
[m4_pushdef([pkg_default], [m4_default([$1], ['${libdir}/pkgconfig'])])
m4_pushdef([pkg_description],
    [pkg-config installation directory @<:@]pkg_default[@:>@])
AC_ARG_WITH([pkgconfigdir],
    [AS_HELP_STRING([--with-pkgconfigdir], pkg_description)],,
    [with_pkgconfigdir=]pkg_default)
AC_SUBST([pkgconfigdir], [$with_pkgconfigdir])
m4_popdef([pkg_default])
m4_popdef([pkg_description])
])dnl PKG_INSTALLDIR


dnl PKG_NOARCH_INSTALLDIR([DIRECTORY])
dnl --------------------------------
dnl Since: 0.27
dnl
dnl Substitutes the variable noarch_pkgconfigdir as the location where a
dnl module should install arch-independent pkg-config .pc files. By
dnl default the directory is $datadir/pkgconfig, but the default can be
dnl changed by passing DIRECTORY. The user can override through the
dnl --with-noarch-pkgconfigdir parameter.
AC_DEFUN([PKG_NOARCH_INSTALLDIR],
[m4_pushdef([pkg_default], [m4_default([$1], ['${datadir}/pkgconfig'])])
m4_pushdef([pkg_description],
    [pkg-config arch-independent installation directory @<:@]pkg_default[@:>@])
AC_ARG_WITH([noarch-pkgconfigdir],
    [AS_HELP_STRING([--with-noarch-pkgconfigdir], pkg_description)],,
    [with_noarch_pkgconfigdir=]pkg_default)
AC_SUBST([noarch_pkgconfigdir], [$with_noarch_pkgconfigdir])
m4_popdef([pkg_default])
m4_popdef([pkg_description])
])dnl PKG_NOARCH_INSTALLDIR


dnl PKG_CHECK_VAR(VARIABLE, MODULE, CONFIG-VARIABLE,
dnl [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl -------------------------------------------
dnl Since: 0.28
dnl
dnl Retrieves the value of the pkg-config variable for the given module.
AC_DEFUN([PKG_CHECK_VAR],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
AC_ARG_VAR([$1], [value of $3 for $2, overriding pkg-config])dnl

_PKG_CONFIG([$1], [variable="][$3]["], [$2])
AS_VAR_COPY([$1], [pkg_cv_][$1])

AS_VAR_IF([$1], [""], [$5], [$4])dnl
])dnl PKG_CHECK_VAR

dnl PKG_WITH_MODULES(VARIABLE-PREFIX, MODULES,
dnl   [ACTION-IF-FOUND],[ACTION-IF-NOT-FOUND],
dnl   [DESCRIPTION], [DEFAULT])
dnl ------------------------------------------
dnl
dnl Prepare a "--with-" configure option using the lowercase
dnl [VARIABLE-PREFIX] name, merging the behaviour of AC_ARG_WITH and
dnl PKG_CHECK_MODULES in a single macro.
AC_DEFUN([PKG_WITH_MODULES],
[
m4_pushdef([with_arg], m4_tolower([$1]))

m4_pushdef([description],
           [m4_default([$5], [build with ]with_arg[ support])])

m4_pushdef([def_arg], [m4_default([$6], [auto])])
m4_pushdef([def_action_if_found], [AS_TR_SH([with_]with_arg)=yes])
m4_pushdef([def_action_if_not_found], [AS_TR_SH([with_]with_arg)=no])

m4_case(def_arg,
            [yes],[m4_pushdef([with_without], [--without-]with_arg)],
            [m4_pushdef([with_without],[--with-]with_arg)])

AC_ARG_WITH(with_arg,
     AS_HELP_STRING(with_without, description[ @<:@default=]def_arg[@:>@]),,
    [AS_TR_SH([with_]with_arg)=def_arg])

AS_CASE([$AS_TR_SH([with_]with_arg)],
            [yes],[PKG_CHECK_MODULES([$1],[$2],$3,$4)],
            [auto],[PKG_CHECK_MODULES([$1],[$2],
                                        [m4_n([def_action_if_found]) $3],
                                        [m4_n([def_action_if_not_found]) $4])])

m4_popdef([with_arg])
m4_popdef([description])
m4_popdef([def_arg])

])dnl PKG_WITH_MODULES

dnl PKG_HAVE_WITH_MODULES(VARIABLE-PREFIX, MODULES,
dnl   [DESCRIPTION], [DEFAULT])
dnl -----------------------------------------------
dnl
dnl Convenience macro to trigger AM_CONDITIONAL after PKG_WITH_MODULES
dnl check._[VARIABLE-PREFIX] is exported as make variable.
AC_DEFUN([PKG_HAVE_WITH_MODULES],
[
PKG_WITH_MODULES([$1],[$2],,,[$3],[$4])

AM_CONDITIONAL([HAVE_][$1],
               [test "$AS_TR_SH([with_]m4_tolower([$1]))" = "yes"])
])dnl PKG_HAVE_WITH_MODULES

dnl PKG_HAVE_DEFINE_WITH_MODULES(VARIABLE-PREFIX, MODULES,
dnl   [DESCRIPTION], [DEFAULT])
dnl ------------------------------------------------------
dnl
dnl Convenience macro to run AM_CONDITIONAL and AC_DEFINE after
dnl PKG_WITH_MODULES check. HAVE_[VARIABLE-PREFIX] is exported as make
dnl and preprocessor variable.
AC_DEFUN([PKG_HAVE_DEFINE_WITH_MODULES],
[
PKG_HAVE_WITH_MODULES([$1],[$2],[$3],[$4])

AS_IF([test "$AS_TR_SH([with_]m4_tolower([$1]))" = "yes"],
        [AC_DEFINE([HAVE_][$1], 1, [Enable ]m4_tolower([$1])[ support])])
])dnl PKG_HAVE_DEFINE_WITH_MODULES

# Copyright (C) 2002-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
# (This private macro should not be called outside this file.)
AC_DEFUN([AM_AUTOMAKE_VERSION],
[am__api_version='1.16'
dnl Some users find AM_AUTOMAKE_VERSION and mistake it for a way to
dnl require some minimum version.  Point them to the right macro.
m4_if([$1], [1.16.5], [],
      [AC_FATAL([Do not call $0, use AM_INIT_AUTOMAKE([$1]).])])dnl
])

# _AM_AUTOCONF_VERSION(VERSION)
# -----------------------------
# aclocal traces this macro to find the Autoconf version.
# This is a private macro too.  Using m4_define simplifies
# the logic in aclocal, which can simply ignore this definition.
m4_define([_AM_AUTOCONF_VERSION], [])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION and AM_AUTOMAKE_VERSION so they can be traced.
# This function is AC_REQUIREd by AM_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
[AM_AUTOMAKE_VERSION([1.16.5])dnl
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
_AM_AUTOCONF_VERSION(m4_defn([AC_AUTOCONF_VERSION]))])

# Copyright (C) 2011-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_AR([ACT-IF-FAIL])
# -------------------------
# Try to determine the archiver interface, and trigger the ar-lib wrapper
# if it is needed.  If the detection of archiver interface fails, run
# ACT-IF-FAIL (default is to abort configure with a proper error message).
AC_DEFUN([AM_PROG_AR],
[AC_BEFORE([$0], [LT_INIT])dnl
AC_BEFORE([$0], [AC_PROG_LIBTOOL])dnl
AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([ar-lib])dnl
AC_CHECK_TOOLS([AR], [ar lib "link -lib"], [false])
: ${AR=ar}

AC_CACHE_CHECK([the archiver ($AR) interface], [am_cv_ar_interface],
  [AC_LANG_PUSH([C])
   am_cv_ar_interface=ar
   AC_COMPILE_IFELSE([AC_LANG_SOURCE([[int some_variable = 0;]])],
     [am_ar_try='$AR cru libconftest.a conftest.$ac_objext >&AS_MESSAGE_LOG_FD'
      AC_TRY_EVAL([am_ar_try])
      if test "$ac_status" -eq 0; then
        am_cv_ar_interface=ar
      else
        am_ar_try='$AR -NOLOGO -OUT:conftest.lib conftest.$ac_objext >&AS_MESSAGE_LOG_FD'
        AC_TRY_EVAL([am_ar_try])
        if test "$ac_status" -eq 0; then
          am_cv_ar_interface=lib
        else
          am_cv_ar_interface=unknown
        fi
      fi
      rm -f conftest.lib libconftest.a
     ])
   AC_LANG_POP([C])])

case $am_cv_ar_interface in
ar)
  ;;
lib)
  # Microsoft lib, so override with the ar-lib wrapper script.
  # FIXME: It is wrong to rewrite AR.
  # But if we don't then we get into trouble of one sort or another.
  # A longer-term fix would be to have automake use am__AR in this case,
  # and then we could set am__AR="$am_aux_dir/ar-lib \$(AR)" or something
  # similar.
  AR="$am_aux_dir/ar-lib $AR"
  ;;
unknown)
  m4_default([$1],
             [AC_MSG_ERROR([could not determine $AR interface])])
  ;;
esac
AC_SUBST([AR])dnl
])

# AM_AUX_DIR_EXPAND                                         -*- Autoconf -*-

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to '$srcdir/foo'.  In other projects, it is set to
# '$srcdir', '$srcdir/..', or '$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is '.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

AC_DEFUN([AM_AUX_DIR_EXPAND],
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
# Expand $ac_aux_dir to an absolute path.
am_aux_dir=`cd "$ac_aux_dir" && pwd`
])

# AM_CONDITIONAL                                            -*- Autoconf -*-

# Copyright (C) 1997-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[AC_PREREQ([2.52])dnl
 m4_if([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
       [$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])dnl
AC_SUBST([$1_FALSE])dnl
_AM_SUBST_NOTMAKE([$1_TRUE])dnl
_AM_SUBST_NOTMAKE([$1_FALSE])dnl
m4_define([_AM_COND_VALUE_$1], [$2])dnl
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([[conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.]])
fi])])

# Copyright (C) 1999-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.


# There are a few dirty hacks below to avoid letting 'AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...


# _AM_DEPENDENCIES(NAME)
# ----------------------
# See how the compiler implements dependency checking.
# NAME is "CC", "CXX", "OBJC", "OBJCXX", "UPC", or "GJC".
# We try a few techniques and use that to set a single cache variable.
#
# We don't AC_REQUIRE the corresponding AC_PROG_CC since the latter was
# modified to invoke _AM_DEPENDENCIES(CC); we would have a circular
# dependency, and given that the user is not expected to run this macro,
# just rely on AC_PROG_CC.
AC_DEFUN([_AM_DEPENDENCIES],
[AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_REQUIRE([AM_OUTPUT_DEPENDENCY_COMMANDS])dnl
AC_REQUIRE([AM_MAKE_INCLUDE])dnl
AC_REQUIRE([AM_DEP_TRACK])dnl

m4_if([$1], [CC],   [depcc="$CC"   am_compiler_list=],
      [$1], [CXX],  [depcc="$CXX"  am_compiler_list=],
      [$1], [OBJC], [depcc="$OBJC" am_compiler_list='gcc3 gcc'],
      [$1], [OBJCXX], [depcc="$OBJCXX" am_compiler_list='gcc3 gcc'],
      [$1], [UPC],  [depcc="$UPC"  am_compiler_list=],
      [$1], [GCJ],  [depcc="$GCJ"  am_compiler_list='gcc3 gcc'],
                    [depcc="$$1"   am_compiler_list=])

AC_CACHE_CHECK([dependency style of $depcc],
               [am_cv_$1_dependencies_compiler_type],
[if test -z "$AMDEP_TRUE" && test -f "$am_depcomp"; then
  # We make a subdir and do the tests there.  Otherwise we can end up
  # making bogus files that we don't know about and never remove.  For
  # instance it was reported that on HP-UX the gcc test will end up
  # making a dummy file named 'D' -- because '-MD' means "put the output
  # in D".
  rm -rf conftest.dir
  mkdir conftest.dir
  # Copy depcomp to subdir because otherwise we won't find it if we're
  # using a relative directory.
  cp "$am_depcomp" conftest.dir
  cd conftest.dir
  # We will build objects and dependencies in a subdirectory because
  # it helps to detect inapplicable dependency modes.  For instance
  # both Tru64's cc and ICC support -MD to output dependencies as a
  # side effect of compilation, but ICC will put the dependencies in
  # the current directory while Tru64 will put them in the object
  # directory.
  mkdir sub

  am_cv_$1_dependencies_compiler_type=none
  if test "$am_compiler_list" = ""; then
     am_compiler_list=`sed -n ['s/^#*\([a-zA-Z0-9]*\))$/\1/p'] < ./depcomp`
  fi
  am__universal=false
  m4_case([$1], [CC],
    [case " $depcc " in #(
     *\ -arch\ *\ -arch\ *) am__universal=true ;;
     esac],
    [CXX],
    [case " $depcc " in #(
     *\ -arch\ *\ -arch\ *) am__universal=true ;;
     esac])

  for depmode in $am_compiler_list; do
    # Setup a source with many dependencies, because some compilers
    # like to wrap large dependency lists on column 80 (with \), and
    # we should not choose a depcomp mode which is confused by this.
    #
    # We need to recreate these files for each test, as the compiler may
    # overwrite some of them when testing with obscure command lines.
    # This happens at least with the AIX C compiler.
    : > sub/conftest.c
    for i in 1 2 3 4 5 6; do
      echo '#include "conftst'$i'.h"' >> sub/conftest.c
      # Using ": > sub/conftst$i.h" creates only sub/conftst1.h with
      # Solaris 10 /bin/sh.
      echo '/* dummy */' > sub/conftst$i.h
    done
    echo "${am__include} ${am__quote}sub/conftest.Po${am__quote}" > confmf

    # We check with '-c' and '-o' for the sake of the "dashmstdout"
    # mode.  It turns out that the SunPro C++ compiler does not properly
    # handle '-M -o', and we need to detect this.  Also, some Intel
    # versions had trouble with output in subdirs.
    am__obj=sub/conftest.${OBJEXT-o}
    am__minus_obj="-o $am__obj"
    case $depmode in
    gcc)
      # This depmode causes a compiler race in universal mode.
      test "$am__universal" = false || continue
      ;;
    nosideeffect)
      # After this tag, mechanisms are not by side-effect, so they'll
      # only be used when explicitly requested.
      if test "x$enable_dependency_tracking" = xyes; then
	continue
      else
	break
      fi
      ;;
    msvc7 | msvc7msys | msvisualcpp | msvcmsys)
      # This compiler won't grok '-c -o', but also, the minuso test has
      # not run yet.  These depmodes are late enough in the game, and
      # so weak that their functioning should not be impacted.
      am__obj=conftest.${OBJEXT-o}
      am__minus_obj=
      ;;
    none) break ;;
    esac
    if depmode=$depmode \
       source=sub/conftest.c object=$am__obj \
       depfile=sub/conftest.Po tmpdepfile=sub/conftest.TPo \
       $SHELL ./depcomp $depcc -c $am__minus_obj sub/conftest.c \
         >/dev/null 2>conftest.err &&
       grep sub/conftst1.h sub/conftest.Po > /dev/null 2>&1 &&
       grep sub/conftst6.h sub/conftest.Po > /dev/null 2>&1 &&
       grep $am__obj sub/conftest.Po > /dev/null 2>&1 &&
       ${MAKE-make} -s -f confmf > /dev/null 2>&1; then
      # icc doesn't choke on unknown options, it will just issue warnings
      # or remarks (even with -Werror).  So we grep stderr for any message
      # that says an option was ignored or not supported.
      # When given -MP, icc 7.0 and 7.1 complain thusly:
      #   icc: Command line warning: ignoring option '-M'; no argument required
      # The diagnosis changed in icc 8.0:
      #   icc: Command line remark: option '-MP' not supported
      if (grep 'ignoring option' conftest.err ||
          grep 'not supported' conftest.err) >/dev/null 2>&1; then :; else
        am_cv_$1_dependencies_compiler_type=$depmode
        break
      fi
    fi
  done

  cd ..
  rm -rf conftest.dir
else
  am_cv_$1_dependencies_compiler_type=none
fi
])
AC_SUBST([$1DEPMODE], [depmode=$am_cv_$1_dependencies_compiler_type])
AM_CONDITIONAL([am__fastdep$1], [
  test "x$enable_dependency_tracking" != xno \
  && test "$am_cv_$1_dependencies_compiler_type" = gcc3])
])


# AM_SET_DEPDIR
# -------------
# Choose a directory name for dependency files.
# This macro is AC_REQUIREd in _AM_DEPENDENCIES.
AC_DEFUN([AM_SET_DEPDIR],
[AC_REQUIRE([AM_SET_LEADING_DOT])dnl
AC_SUBST([DEPDIR], ["${am__leading_dot}deps"])dnl
])


# AM_DEP_TRACK
# ------------
AC_DEFUN([AM_DEP_TRACK],
[AC_ARG_ENABLE([dependency-tracking], [dnl
AS_HELP_STRING(
  [--enable-dependency-tracking],
  [do not reject slow dependency extractors])
AS_HELP_STRING(
  [--disable-dependency-tracking],
  [speeds up one-time build])])
if test "x$enable_dependency_tracking" != xno; then
  am_depcomp="$ac_aux_dir/depcomp"
  AMDEPBACKSLASH='\'
  am__nodep='_no'
fi
AM_CONDITIONAL([AMDEP], [test "x$enable_dependency_tracking" != xno])
AC_SUBST([AMDEPBACKSLASH])dnl
_AM_SUBST_NOTMAKE([AMDEPBACKSLASH])dnl
AC_SUBST([am__nodep])dnl
_AM_SUBST_NOTMAKE([am__nodep])dnl
])

# Generate code to set up dependency tracking.              -*- Autoconf -*-

# Copyright (C) 1999-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_OUTPUT_DEPENDENCY_COMMANDS
# ------------------------------
AC_DEFUN([_AM_OUTPUT_DEPENDENCY_COMMANDS],
[{
  # Older Autoconf quotes --file arguments for eval, but not when files
  # are listed without --file.  Let's play safe and only enable the eval
  # if we detect the quoting.
  # TODO: see whether this extra hack can be removed once we start
  # requiring Autoconf 2.70 or later.
  AS_CASE([$CONFIG_FILES],
          [*\'*], [eval set x "$CONFIG_FILES"],
          [*], [set x $CONFIG_FILES])
  shift
  # Used to flag and report bootstrapping failures.
  am_rc=0
  for am_mf
  do
    # Strip MF so we end up with the name of the file.
    am_mf=`AS_ECHO(["$am_mf"]) | sed -e 's/:.*$//'`
    # Check whether this is an Automake generated Makefile which includes
    # dependency-tracking related rules and includes.
    # Grep'ing the whole file directly is not great: AIX grep has a line
    # limit of 2048, but all sed's we know have understand at least 4000.
    sed -n 's,^am--depfiles:.*,X,p' "$am_mf" | grep X >/dev/null 2>&1 \
      || continue
    am_dirpart=`AS_DIRNAME(["$am_mf"])`
    am_filepart=`AS_BASENAME(["$am_mf"])`
    AM_RUN_LOG([cd "$am_dirpart" \
      && sed -e '/# am--include-marker/d' "$am_filepart" \
        | $MAKE -f - am--depfiles]) || am_rc=$?
  done
  if test $am_rc -ne 0; then
    AC_MSG_FAILURE([Something went wrong bootstrapping makefile fragments
    for automatic dependency tracking.  If GNU make was not used, consider
    re-running the configure script with MAKE="gmake" (or whatever is
    necessary).  You can also try re-running configure with the
    '--disable-dependency-tracking' option to at least be able to build
    the package (albeit without support for automatic dependency tracking).])
  fi
  AS_UNSET([am_dirpart])
  AS_UNSET([am_filepart])
  AS_UNSET([am_mf])
  AS_UNSET([am_rc])
  rm -f conftest-deps.mk
}
])# _AM_OUTPUT_DEPENDENCY_COMMANDS


# AM_OUTPUT_DEPENDENCY_COMMANDS
# -----------------------------
# This macro should only be invoked once -- use via AC_REQUIRE.
#
# This code is only required when automatic dependency tracking is enabled.
# This creates each '.Po' and '.Plo' makefile fragment that we'll need in
# order to bootstrap the dependency handling code.
AC_DEFUN([AM_OUTPUT_DEPENDENCY_COMMANDS],
[AC_CONFIG_COMMANDS([depfiles],
     [test x"$AMDEP_TRUE" != x"" || _AM_OUTPUT_DEPENDENCY_COMMANDS],
     [AMDEP_TRUE="$AMDEP_TRUE" MAKE="${MAKE-make}"])])

# Do all the work for Automake.                             -*- Autoconf -*-

# Copyright (C) 1996-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This macro actually does too much.  Some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

dnl Redefine AC_PROG_CC to automatically invoke _AM_PROG_CC_C_O.
m4_define([AC_PROG_CC],
m4_defn([AC_PROG_CC])
[_AM_PROG_CC_C_O
])

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_PREREQ([2.65])dnl
m4_ifdef([_$0_ALREADY_INIT],
  [m4_fatal([$0 expanded multiple times
]m4_defn([_$0_ALREADY_INIT]))],
  [m4_define([_$0_ALREADY_INIT], m4_expansion_stack)])dnl
dnl Autoconf wants to disallow AM_ names.  We explicitly allow
dnl the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl
AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
AC_REQUIRE([AC_PROG_INSTALL])dnl
if test "`cd $srcdir && pwd`" != "`pwd`"; then
  # Use -I$(srcdir) only when $(srcdir) != ., so that make's output
  # is not polluted with repeated "-I."
  AC_SUBST([am__isrc], [' -I$(srcdir)'])_AM_SUBST_NOTMAKE([am__isrc])dnl
  # test to see if srcdir already configured
  if test -f $srcdir/config.status; then
    AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
  fi
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[AC_DIAGNOSE([obsolete],
             [$0: two- and three-arguments forms are deprecated.])
m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
dnl Diagnose old-style AC_INIT with new-style AM_AUTOMAKE_INIT.
m4_if(
  m4_ifset([AC_PACKAGE_NAME], [ok]):m4_ifset([AC_PACKAGE_VERSION], [ok]),
  [ok:ok],,
  [m4_fatal([AC_INIT should be called with package and version arguments])])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED([PACKAGE], ["$PACKAGE"], [Name of package])
 AC_DEFINE_UNQUOTED([VERSION], ["$VERSION"], [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG([ACLOCAL], [aclocal-${am__api_version}])
AM_MISSING_PROG([AUTOCONF], [autoconf])
AM_MISSING_PROG([AUTOMAKE], [automake-${am__api_version}])
AM_MISSING_PROG([AUTOHEADER], [autoheader])
AM_MISSING_PROG([MAKEINFO], [makeinfo])
AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
AC_REQUIRE([AM_PROG_INSTALL_STRIP])dnl
AC_REQUIRE([AC_PROG_MKDIR_P])dnl
# For better backward compatibility.  To be removed once Automake 1.9.x
# dies out for good.  For more background, see:
# <https://lists.gnu.org/archive/html/automake/2012-07/msg00001.html>
# <https://lists.gnu.org/archive/html/automake/2012-07/msg00014.html>
AC_SUBST([mkdir_p], ['$(MKDIR_P)'])
# We need awk for the "check" target (and possibly the TAP driver).  The
# system "awk" is bad on some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl
_AM_IF_OPTION([tar-ustar], [_AM_PROG_TAR([ustar])],
	      [_AM_IF_OPTION([tar-pax], [_AM_PROG_TAR([pax])],
			     [_AM_PROG_TAR([v7])])])
_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
		  [_AM_DEPENDENCIES([CC])],
		  [m4_define([AC_PROG_CC],
			     m4_defn([AC_PROG_CC])[_AM_DEPENDENCIES([CC])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
		  [_AM_DEPENDENCIES([CXX])],
		  [m4_define([AC_PROG_CXX],
			     m4_defn([AC_PROG_CXX])[_AM_DEPENDENCIES([CXX])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJC],
		  [_AM_DEPENDENCIES([OBJC])],
		  [m4_define([AC_PROG_OBJC],
			     m4_defn([AC_PROG_OBJC])[_AM_DEPENDENCIES([OBJC])])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJCXX],
		  [_AM_DEPENDENCIES([OBJCXX])],
		  [m4_define([AC_PROG_OBJCXX],
			     m4_defn([AC_PROG_OBJCXX])[_AM_DEPENDENCIES([OBJCXX])])])dnl
])
# Variables for tags utilities; see am/tags.am
if test -z "$CTAGS"; then
  CTAGS=ctags
fi
AC_SUBST([CTAGS])
if test -z "$ETAGS"; then
  ETAGS=etags
fi
AC_SUBST([ETAGS])
if test -z "$CSCOPE"; then
  CSCOPE=cscope
fi
AC_SUBST([CSCOPE])

AC_REQUIRE([AM_SILENT_RULES])dnl
dnl The testsuite driver may need to know about EXEEXT, so add the
dnl 'am__EXEEXT' conditional if _AM_COMPILER_EXEEXT was seen.  This
dnl macro is hooked onto _AC_COMPILER_EXEEXT early, see below.
AC_CONFIG_COMMANDS_PRE(dnl
[m4_provide_if([_AM_COMPILER_EXEEXT],
  [AM_CONDITIONAL([am__EXEEXT], [test -n "$EXEEXT"])])])dnl

# POSIX will say in a future version that running "rm -f" with no argument
# is OK; and we want to be able to make that assumption in our Makefile
# recipes.  So use an aggressive probe to check that the usage we want is
# actually supported "in the wild" to an acceptable degree.
# See automake bug#10828.
# To make any issue more visible, cause the running configure to be aborted
# by default if the 'rm' program in use doesn't match our expectations; the
# user can still override this though.
if rm -f && rm -fr && rm -rf; then : OK; else
  cat >&2 <<'END'
Oops!

Your 'rm' program seems unable to run without file operands specified
on the command line, even when the '-f' option is present.  This is contrary
to the behaviour of most rm programs out there, and not conforming with
the upcoming POSIX standard: <http://austingroupbugs.net/view.php?id=542>

Please tell bug-automake@gnu.org about your system, including the value
of your $PATH and any error possibly output before this message.  This
can help us improve future automake versions.

END
  if test x"$ACCEPT_INFERIOR_RM_PROGRAM" = x"yes"; then
    echo 'Configuration will proceed anyway, since you have set the' >&2
    echo 'ACCEPT_INFERIOR_RM_PROGRAM variable to "yes"' >&2
    echo >&2
  else
    cat >&2 <<'END'
Aborting the configuration process, to ensure you take notice of the issue.

You can download and install GNU coreutils to get an 'rm' implementation
that behaves properly: <https://www.gnu.org/software/coreutils/>.

If you want to complete the configuration process using your problematic
'rm' anyway, export the environment variable ACCEPT_INFERIOR_RM_PROGRAM
to "yes", and re-run configure.

END
    AC_MSG_ERROR([Your 'rm' program is bad, sorry.])
  fi
fi
dnl The trailing newline in this macro's definition is deliberate, for
dnl backward compatibility and to allow trailing 'dnl'-style comments
dnl after the AM_INIT_AUTOMAKE invocation. See automake bug#16841.
])

dnl Hook into '_AC_COMPILER_EXEEXT' early to learn its expansion.  Do not
dnl add the conditional right here, as _AC_COMPILER_EXEEXT may be further
dnl mangled by Autoconf and run in a shell conditional statement.
m4_define([_AC_COMPILER_EXEEXT],
m4_defn([_AC_COMPILER_EXEEXT])[m4_provide([_AM_COMPILER_EXEEXT])])

# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_arg=$1
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $_am_arg | $_am_arg:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $_am_arg" >`AS_DIRNAME(["$_am_arg"])`/stamp-h[]$_am_stamp_count])

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.
AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
if test x"${install_sh+set}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    install_sh="\${SHELL} '$am_aux_dir/install-sh'" ;;
  *)
    install_sh="\${SHELL} $am_aux_dir/install-sh"
  esac
fi
AC_SUBST([install_sh])])

# Copyright (C) 2003-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# Check to see how 'make' treats includes.	            -*- Autoconf -*-

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_MAKE_INCLUDE()
# -----------------
# Check whether make has an 'include' directive that can support all
# the idioms we need for our automatic dependency tracking code.
AC_DEFUN([AM_MAKE_INCLUDE],
[AC_MSG_CHECKING([whether ${MAKE-make} supports the include directive])
cat > confinc.mk << 'END'
am__doit:
	@echo this is the am__doit target >confinc.out
.PHONY: am__doit
END
am__include="#"
am__quote=
# BSD make does it like this.
echo '.include "confinc.mk" # ignored' > confmf.BSD
# Other make implementations (GNU, Solaris 10, AIX) do it like this.
echo 'include confinc.mk # ignored' > confmf.GNU
_am_result=no
for s in GNU BSD; do
  AM_RUN_LOG([${MAKE-make} -f confmf.$s && cat confinc.out])
  AS_CASE([$?:`cat confinc.out 2>/dev/null`],
      ['0:this is the am__doit target'],
      [AS_CASE([$s],
          [BSD], [am__include='.include' am__quote='"'],
          [am__include='include' am__quote=''])])
  if test "$am__include" != "#"; then
    _am_result="yes ($s style)"
    break
  fi
done
rm -f confinc.* confmf.*
AC_MSG_RESULT([${_am_result}])
AC_SUBST([am__include])])
AC_SUBST([am__quote])])

# Fake the existence of programs that GNU maintainers use.  -*- Autoconf -*-

# Copyright (C) 1997-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])

# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it is modern enough.
# If it is, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([missing])dnl
if test x"${MISSING+set}" != xset; then
  MISSING="\${SHELL} '$am_aux_dir/missing'"
fi
# Use eval to expand $SHELL
if eval "$MISSING --is-lightweight"; then
  am_missing_run="$MISSING "
else
  am_missing_run=
  AC_MSG_WARN(['missing' script is too old or missing])
fi
])

# Helper functions for option handling.                     -*- Autoconf -*-

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# --------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), [1])])

# _AM_SET_OPTIONS(OPTIONS)
# ------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[m4_foreach_w([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

# Copyright (C) 1999-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_PROG_CC_C_O
# ---------------
# Like AC_PROG_CC_C_O, but changed for automake.  We rewrite AC_PROG_CC
# to automatically call this.
AC_DEFUN([_AM_PROG_CC_C_O],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([compile])dnl
AC_LANG_PUSH([C])dnl
AC_CACHE_CHECK(
  [whether $CC understands -c and -o together],
  [am_cv_prog_cc_c_o],
  [AC_LANG_CONFTEST([AC_LANG_PROGRAM([])])
  # Make sure it works both with $CC and with simple cc.
  # Following AC_PROG_CC_C_O, we do the test twice because some
  # compilers refuse to overwrite an existing .o file with -o,
  # though they will create one.
  am_cv_prog_cc_c_o=yes
  for am_i in 1 2; do
    if AM_RUN_LOG([$CC -c conftest.$ac_ext -o conftest2.$ac_objext]) \
         && test -f conftest2.$ac_objext; then
      : OK
    else
      am_cv_prog_cc_c_o=no
      break
    fi
  done
  rm -f core conftest*
  unset am_i])
if test "$am_cv_prog_cc_c_o" != yes; then
   # Losing compiler, so override with the script.
   # FIXME: It is wrong to rewrite CC.
   # But if we don't then we get into trouble of one sort or another.
   # A longer-term fix would be to have automake use am__CC in this case,
   # and then we could set am__CC="\$(top_srcdir)/compile \$(CC)"
   CC="$am_aux_dir/compile $CC"
fi
AC_LANG_POP([C])])

# For backward compatibility.
AC_DEFUN_ONCE([AM_PROG_CC_C_O], [AC_REQUIRE([AC_PROG_CC])])

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_RUN_LOG(COMMAND)
# -------------------
# Run COMMAND, save the exit status in ac_status, and log it.
# (This has been adapted from Autoconf's _AC_RUN_LOG macro.)
AC_DEFUN([AM_RUN_LOG],
[{ echo "$as_me:$LINENO: $1" >&AS_MESSAGE_LOG_FD
   ($1) >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&AS_MESSAGE_LOG_FD
   (exit $ac_status); }])

# Check to make sure that the build environment is sane.    -*- Autoconf -*-

# Copyright (C) 1996-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Reject unsafe characters in $srcdir or the absolute working directory
# name.  Accept space and tab only in the latter.
am_lf='
'
case `pwd` in
  *[[\\\"\#\$\&\'\`$am_lf]]*)
    AC_MSG_ERROR([unsafe absolute working directory name]);;
esac
case $srcdir in
  *[[\\\"\#\$\&\'\`$am_lf\ \	]]*)
    AC_MSG_ERROR([unsafe srcdir value: '$srcdir']);;
esac

# Do 'set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   am_has_slept=no
   for am_try in 1 2; do
     echo "timestamp, slept: $am_has_slept" > conftest.file
     set X `ls -Lt "$srcdir/configure" conftest.file 2> /dev/null`
     if test "$[*]" = "X"; then
	# -L didn't work.
	set X `ls -t "$srcdir/configure" conftest.file`
     fi
     if test "$[*]" != "X $srcdir/configure conftest.file" \
	&& test "$[*]" != "X conftest.file $srcdir/configure"; then

	# If neither matched, then we have a broken ls.  This can happen
	# if, for instance, CONFIG_SHELL is bash and it inherits a
	# broken ls alias from the environment.  This has actually
	# happened.  Such a system could not be considered "sane".
	AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
  alias in your environment])
     fi
     if test "$[2]" = conftest.file || test $am_try -eq 2; then
       break
     fi
     # Just in case.
     sleep 1
     am_has_slept=yes
   done
   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT([yes])
# If we didn't sleep, we still need to ensure time stamps of config.status and
# generated files are strictly newer.
am_sleep_pid=
if grep 'slept: no' conftest.file >/dev/null 2>&1; then
  ( sleep 1 ) &
  am_sleep_pid=$!
fi
AC_CONFIG_COMMANDS_PRE(
  [AC_MSG_CHECKING([that generated files are newer than configure])
   if test -n "$am_sleep_pid"; then
     # Hide warnings about reused PIDs.
     wait $am_sleep_pid 2>/dev/null
   fi
   AC_MSG_RESULT([done])])
rm -f conftest.file
])

# Copyright (C) 2009-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_SILENT_RULES([DEFAULT])
# --------------------------
# Enable less verbose build rules; with the default set to DEFAULT
# ("yes" being less verbose, "no" or empty being verbose).
AC_DEFUN([AM_SILENT_RULES],
[AC_ARG_ENABLE([silent-rules], [dnl
AS_HELP_STRING(
  [--enable-silent-rules],
  [less verbose build output (undo: "make V=1")])
AS_HELP_STRING(
  [--disable-silent-rules],
  [verbose build output (undo: "make V=0")])dnl
])
case $enable_silent_rules in @%:@ (((
  yes) AM_DEFAULT_VERBOSITY=0;;
   no) AM_DEFAULT_VERBOSITY=1;;
    *) AM_DEFAULT_VERBOSITY=m4_if([$1], [yes], [0], [1]);;
esac
dnl
dnl A few 'make' implementations (e.g., NonStop OS and NextStep)
dnl do not support nested variable expansions.
dnl See automake bug#9928 and bug#10237.
am_make=${MAKE-make}
AC_CACHE_CHECK([whether $am_make supports nested variables],
   [am_cv_make_support_nested_variables],
   [if AS_ECHO([['TRUE=$(BAR$(V))
BAR0=false
BAR1=true
V=1
am__doit:
	@$(TRUE)
.PHONY: am__doit']]) | $am_make -f - >/dev/null 2>&1; then
  am_cv_make_support_nested_variables=yes
else
  am_cv_make_support_nested_variables=no
fi])
if test $am_cv_make_support_nested_variables = yes; then
  dnl Using '$V' instead of '$(V)' breaks IRIX make.
  AM_V='$(V)'
  AM_DEFAULT_V='$(AM_DEFAULT_VERBOSITY)'
else
  AM_V=$AM_DEFAULT_VERBOSITY
  AM_DEFAULT_V=$AM_DEFAULT_VERBOSITY
fi
AC_SUBST([AM_V])dnl
AM_SUBST_NOTMAKE([AM_V])dnl
AC_SUBST([AM_DEFAULT_V])dnl
AM_SUBST_NOTMAKE([AM_DEFAULT_V])dnl
AC_SUBST([AM_DEFAULT_VERBOSITY])dnl
AM_BACKSLASH='\'
AC_SUBST([AM_BACKSLASH])dnl
_AM_SUBST_NOTMAKE([AM_BACKSLASH])dnl
])

# Copyright (C) 2001-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_STRIP
# ---------------------
# One issue with vendor 'install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in "make install-strip", and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using 'strip' when the user
# run "make install-strip".  However 'strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the 'STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be 'maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

# Copyright (C) 2006-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Prevent Automake from outputting VARIABLE = @VARIABLE@ in Makefile.in.
# This macro is traced by Automake.
AC_DEFUN([_AM_SUBST_NOTMAKE])

# AM_SUBST_NOTMAKE(VARIABLE)
# --------------------------
# Public sister of _AM_SUBST_NOTMAKE.
AC_DEFUN([AM_SUBST_NOTMAKE], [_AM_SUBST_NOTMAKE($@)])

# Check how to create a tarball.                            -*- Autoconf -*-

# Copyright (C) 2004-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# _AM_PROG_TAR(FORMAT)
# --------------------
# Check how to create a tarball in format FORMAT.
# FORMAT should be one of 'v7', 'ustar', or 'pax'.
#
# Substitute a variable $(am__tar) that is a command
# writing to stdout a FORMAT-tarball containing the directory
# $tardir.
#     tardir=directory && $(am__tar) > result.tar
#
# Substitute a variable $(am__untar) that extract such
# a tarball read from stdin.
#     $(am__untar) < result.tar
#
AC_DEFUN([_AM_PROG_TAR],
[# Always define AMTAR for backward compatibility.  Yes, it's still used
# in the wild :-(  We should find a proper way to deprecate it ...
AC_SUBST([AMTAR], ['$${TAR-tar}'])

# We'll loop over all known methods to create a tar archive until one works.
_am_tools='gnutar m4_if([$1], [ustar], [plaintar]) pax cpio none'

m4_if([$1], [v7],
  [am__tar='$${TAR-tar} chof - "$$tardir"' am__untar='$${TAR-tar} xf -'],

  [m4_case([$1],
    [ustar],
     [# The POSIX 1988 'ustar' format is defined with fixed-size fields.
      # There is notably a 21 bits limit for the UID and the GID.  In fact,
      # the 'pax' utility can hang on bigger UID/GID (see automake bug#8343
      # and bug#13588).
      am_max_uid=2097151 # 2^21 - 1
      am_max_gid=$am_max_uid
      # The $UID and $GID variables are not portable, so we need to resort
      # to the POSIX-mandated id(1) utility.  Errors in the 'id' calls
      # below are definitely unexpected, so allow the users to see them
      # (that is, avoid stderr redirection).
      am_uid=`id -u || echo unknown`
      am_gid=`id -g || echo unknown`
      AC_MSG_CHECKING([whether UID '$am_uid' is supported by ustar format])
      if test $am_uid -le $am_max_uid; then
         AC_MSG_RESULT([yes])
      else
         AC_MSG_RESULT([no])
         _am_tools=none
      fi
      AC_MSG_CHECKING([whether GID '$am_gid' is supported by ustar format])
      if test $am_gid -le $am_max_gid; then
         AC_MSG_RESULT([yes])
      else
        AC_MSG_RESULT([no])
        _am_tools=none
      fi],

  [pax],
    [],

  [m4_fatal([Unknown tar format])])

  AC_MSG_CHECKING([how to create a $1 tar archive])

  # Go ahead even if we have the value already cached.  We do so because we
  # need to set the values for the 'am__tar' and 'am__untar' variables.
  _am_tools=${am_cv_prog_tar_$1-$_am_tools}

  for _am_tool in $_am_tools; do
    case $_am_tool in
    gnutar)
      for _am_tar in tar gnutar gtar; do
        AM_RUN_LOG([$_am_tar --version]) && break
      done
      am__tar="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$$tardir"'
      am__tar_="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$tardir"'
      am__untar="$_am_tar -xf -"
      ;;
    plaintar)
      # Must skip GNU tar: if it does not support --format= it doesn't create
      # ustar tarball either.
      (tar --version) >/dev/null 2>&1 && continue
      am__tar='tar chf - "$$tardir"'
      am__tar_='tar chf - "$tardir"'
      am__untar='tar xf -'
      ;;
    pax)
      am__tar='pax -L -x $1 -w "$$tardir"'
      am__tar_='pax -L -x $1 -w "$tardir"'
      am__untar='pax -r'
      ;;
    cpio)
      am__tar='find "$$tardir" -print | cpio -o -H $1 -L'
      am__tar_='find "$tardir" -print | cpio -o -H $1 -L'
      am__untar='cpio -i -H $1 -d'
      ;;
    none)
      am__tar=false
      am__tar_=false
      am__untar=false
      ;;
    esac

    # If the value was cached, stop now.  We just wanted to have am__tar
    # and am__untar set.
    test -n "${am_cv_prog_tar_$1}" && break

    # tar/untar a dummy directory, and stop if the command works.
    rm -rf conftest.dir
    mkdir conftest.dir
    echo GrepMe > conftest.dir/file
    AM_RUN_LOG([tardir=conftest.dir && eval $am__tar_ >conftest.tar])
    rm -rf conftest.dir
    if test -s conftest.tar; then
      AM_RUN_LOG([$am__untar <conftest.tar])
      AM_RUN_LOG([cat conftest.dir/file])
      grep GrepMe conftest.dir/file >/dev/null 2>&1 && break
    fi
  done
  rm -rf conftest.dir

  AC_CACHE_VAL([am_cv_prog_tar_$1], [am_cv_prog_tar_$1=$_am_tool])
  AC_MSG_RESULT([$am_cv_prog_tar_$1])])

AC_SUBST([am__tar])
AC_SUBST([am__untar])
]) # _AM_PROG_TAR

