#!/usr/bin/perl

use strict;

use File::Basename qw(basename);

my $program = basename($0);

my $fifo = '/var/log/proftpd.fifo';

open(FIFO, "+< $fifo") or die "$program: unable to open $fifo: $!\n";

while(FIFO) {
    print $_;
}

close(FIFO);

exit 0;
