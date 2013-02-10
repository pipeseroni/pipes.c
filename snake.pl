#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Term::ANSIColor;
use Time::HiRes qw/usleep tv_interval gettimeofday/;
use Getopt::Long;
use Pod::Usage;

=head1 NAME

snake.pl [OPTIONS]

=head1 USAGE

snake.pl [OPTIONS]

Options:

    -p, --pipes=N   Number of pipes.                  (Default: 1  )
    -f, --fps=N     Frames per second.                (Default: 75 )
    -a, --ascii     ASCII mode.                       (Default: no )
    -l, --length=N  Minimum length of pipe.           (Default: 2  )
    -r, --prob=N    Probability of chaning direction. (Default: 0.1)
    -h, --help      This help message.

=head1 ARGUMENTS

=over

=item B<-p>, B<--pipes>=I<integer>

Number of pipes. A large number of pipes will probably slow things down a bit.
Default 1.

=item B<-f>, B<--fps>=I<integer>

Frames per second. This will be kept to as well as possible. Default 75.

=item B<-a>, B<--ascii>

Use ASCII rather than unicode. This'll probably look pretty bad.

=item B<-l>, B<--length>=I<integer>

Minimum length of a pipe, measured in characters.

=item B<-r>, B<--prob>=I<float>

Probability of a pipe changing direction per time step.

=item B<-h>, B<--help>

Display this help message.

=back

=cut

#The states describe the current "velocity" of a pipe.  Notice that the allowed
#transitions are given by a change of +/- 1. So, for example, a pipe heading
#left may go up or down but not right.
#             Right  Down   Left    Up
my @states = ([1,0], [0,1], [-1,0], [0,-1]);

#The transition matrices here describe the character that should be output upon
#a transition from] one state (direction) to another. If you wanted, you could
#modify these to include the probability of a transition.
my $trans_unicode  = [
#       R D L U
    [qw/0 ┓ 0 ┛/], #R
    [qw/┗ 0 ┛ 0/], #D
    [qw/0 ┏ 0 ┗/], #L
    [qw/┏ 0 ┓ 0/], #U
];
my $trans_ascii  = [
#       R D L U
    [qw/0 + 0 +/], #R
    [qw/+ 0 + 0/], #D
    [qw/0 + 0 +/], #L
    [qw/+ 0 + 0/], #U
];

#Colors; You may wish to add "black" and remove another colour, depending on
#the background colour of your terminal.
my @colours = qw/red green yellow blue magenta cyan white/;

#The characters to represent a travelling (or extending, I suppose) pipe.
my $unicode_pipe_chars = [qw/━ ┃/];
my $ascii_pipe_chars = [qw/- |/];


#Command line options
my $fps = 75;
my $num_pipes = 1;
my $ascii = 0;
my $prob = 0.1;
my $min_len = 2;
my $help;
GetOptions(
    'fps|f=i'     => \$fps,
    'pipes|p=i'   => \$num_pipes,
    'ascii|a',    => \$ascii,
    'prob|r=f',   => \$prob,
    'length|l=f', => \$min_len,
    'help|h'      => \$help,
) or pod2usage(2);
pod2usage(1) if $help;


#Initialisation; read properties of the terminal and set up the transition and
#travel characters.
my $width = int(`tput cols`);
my $height = int(`tput lines`);
my $trans      = $ascii ? $trans_ascii : $trans_unicode;
my $pipe_chars = $ascii ? $ascii_pipe_chars : $unicode_pipe_chars;

#Delay is calculated from the frames per second. The "$delta" will be set to
#the desired delay minus the time actually taken for rendering. Time is in
#microseconds.
my $delay = 1e6 / $fps;
my $delta = $delay;

#Try and output UTF-8 if we aren't using ASCII.
binmode STDOUT, ':encoding(UTF-8)' if not $ascii;

#Set up the pipes. Just give each of them a random position, state and colour.
my @pipes = ();
for(my $i=0; $i<$num_pipes; $i++){
    my @r = (int(rand($width)), int(rand($height)));
    push @pipes, {
        colour => int(rand(@colours)),
        state  => int(rand(@states)),
        length => 0,
        r      => \@r
    };
}

#Initialise terminal. This says "save state, clear the screen and make the
#cursor invisible."
system 'tput smcup';
system 'tput reset';
system 'tput civis';

#Catch interrupts and stop main loop
my $go = 1;
$SIG{INT} = sub {$go = 0};

while($go && usleep($delta)){
    #Record time taken and take it from $delta.
    my $t0 = [gettimeofday];
    for my $pipe(@pipes){
        last if not $go;
        #When a pipe crosses a border, change its colour and translate it.
        my $r = $pipe->{r};
        $r->[0] += $states[$pipe->{state}][0];
        $r->[1] += $states[$pipe->{state}][1];
        if(    $r->[0] < 0 || $r->[0] == $width
            || $r->[1] < 0 || $r->[1] == $height)
        {
            $pipe->{colour} = int(rand(@colours));
            $r->[1] %= $height;
            $r->[0] %= $width;
        }
        $pipe->{length}++;

        #"Please place the cursor at y, x."
        system "tput cup $r->[1] $r->[0]";
        #Send colour escape code
        print color $colours[$pipe->{colour}];

        if(rand() < $prob && $pipe->{length} > $min_len){ 
            my $new_state = ($pipe->{state} + (-1,1)[int(rand(2))]) % @states;
            print $trans->[$pipe->{state}][$new_state];
            $pipe->{state} = $new_state;
            $pipe->{length} = 0;
        }else{
            print $pipe_chars->[$pipe->{state} % 2];
        }
    }

    #Try and take the correct amount of time (falling back to no delay; we
    #can't have a negative delay).
    my $delta = 1e6 * tv_interval($t0) - $delay;
    $delta = ($delta < 0) ? 0 : $delta;
}

#"Please reset the screen and make the cursor visible"
system 'tput rmcup';
system 'tput cnorm';
