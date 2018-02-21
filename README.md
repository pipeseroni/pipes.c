# Pipes.c

> *A small piece of software designed to emulate the windows "pipes"
screensaver in a terminal window.*

## Compilation

The code should compile with a C99-compliant compiler and a POSIX-compliant-ish
system (that is, most systems). Releases include a `configure` script and can
be built in the usual way:

    ./configure && make && make install

### Building source from Git

If you got the code directly from Git, you will need to generate the
`configure` script using [GNU Autoconf][autoconf]. The build scripts make use
of some extensions from the [Autoconf Archive][autoconf-archive], so you will
also need that installed.

    autoreconf -i
    ./configure && make && make install

If you see messages about missing macros, you may need to get a copy of the
Autoconf Archive manually and tell `autoreconf` to use the local copy:

    git clone git://git.sv.gnu.org/autoconf-archive.git
    autoreconf -i -I autoconf-archive/m4
    ./configure && make && make install

Note that at least version 2.64 of autoconf and version 2017.03.21 of
autoconf-archive are required.

## Usage

To get help, run `pipes-c --help`. In my opinion, the following options are
especially interesting:

    pipes-c -p30 -r1
    pipes-c -p100 -r0 -i1

## Bugs

Please report any bugs using the Github issue tracker.

[autoconf]: https://www.gnu.org/software/autoconf/autoconf.html
[autoconf-archive]: https://www.gnu.org/software/autoconf-archive/
