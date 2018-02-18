# Snakes

> *A small piece of software designed to emulate the windows "pipes"
screensaver in a terminal window.*

## Compilation

The code should compile with a C99-compliant compiler an a POSIX-compliant-ish
system (that is, most systems). To compile, simply run:

    make

## Installation

You can install Snakes by running the following command:

    make install  # install to /usr/local
    # make uninstall

Use `PREFIX=/path/to` for different location, for example:

    make install PREFIX=$HOME/.local

## Usage

To get help, run `snake --help`. In my opinion, the following options are
especially interesting:

    snake -p30 -r1
    snake -p100 -r0 -i1

## Bugs

Please report any bugs using the Github issue tracker.
