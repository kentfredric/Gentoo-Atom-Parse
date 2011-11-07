#!/usr/bin/perl
use 5.14.2;
use strict;
use warnings;

while ( my $line = <> ) {
  chomp $line;
  system(q(qatom), $line );
}
