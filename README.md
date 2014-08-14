#Introduction

"Snakes" is a small piece of software designed to emulate the windows "pipes"
screensaver in a terminal window.

#Compilation

The code should compile with a C99-compliant compiler an a POSIX-compliant-ish
system (that is, most systems). To compile, simply run:

    make

#Usage

To get help, run `snake --help`. In my opinion, the following options are
especially interesting:

    snake -p30 -r1
    snake -p100 -r0 -i1

#Bugs

Please report any bugs to <stefans.mezulis@gmail.com>.

#Thanks

Thanks to Yu-Jie Lin for supplying code and prompting me to make this more
widely available.
