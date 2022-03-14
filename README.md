# Pipes.c

Emulate the Windoes "pipes" screensaver in a terminal window.

## Compilation

The code should compile with a C99-compliant compiler and a POSIX-compliant-ish
system (that is, most systems). A `configure` script is included in the source
tree and can be used in the usual way.

    ./configure && make && make install

Alternative, the meson build system can be used.

    meson setup builddir
    meson compile -C builddir
    meson install -C builddir

## Usage

To get help, run `cpipes --help`. In my opinion, the following options are
especially interesting:

    cpipes -p30 -r1
    cpipes -p100 -r0 -i1

## Bugs

Please report any bugs using the Github issue tracker.

## Regenerating `configure` and `Makefile.in`

For development, the `configure` script can be regenerated using using [GNU
Autoconf][autoconf]. The build scripts make use of some extensions from the
[Autoconf Archive][autoconf-archive], so you will also need that installed.

    autoreconf -i

If you see messages about missing macros, you may need to get a copy of the
Autoconf Archive manually and tell `autoreconf` to use the local copy:

    git clone git://git.sv.gnu.org/autoconf-archive.git
    autoreconf -i -I autoconf-archive/m4
    ./configure && make && make install

Note that at least version 2017.03.21 of the autoconf-archive is required.

If you wish to run the unit tests, you will need to install [libtap][libtap].
This is configured as a submodule, so can use `git submodule` to get a copy:

    git submodule init
    git submodule update

[autoconf]: https://www.gnu.org/software/autoconf/autoconf.html
[autoconf-archive]: https://www.gnu.org/software/autoconf-archive/
[libtap]: https://github.com/zorgnax/libtap
