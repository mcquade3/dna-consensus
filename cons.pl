#!/usr/local/bin/perl
# Mike McQuade
# cons.pl
# Computes the consensus for a given series of dna strings.

use strict;
use warnings;

# Initialize variables
my ($consensus,@a,@c,@g,@t);

# Open the file to read
open(my $fh,"<cons.txt") or die $!;

# Read in all the letters form the file
while (my $line = <$fh>) {
	chomp($line);
	if (substr($line,0,1) ne ">") {
		# Generate the profile matrix for the strings by
		# counting how many times each letter appears in
		# a given spot in each string.
		for (my $i = 0; $i < length($line); $i++) {
			if (substr($line,$i,1) eq 'A') {$a[$i] += 1;} else {$a[$i] += 0;}
			if (substr($line,$i,1) eq 'C') {$c[$i] += 1;} else {$c[$i] += 0;}
			if (substr($line,$i,1) eq 'G') {$g[$i] += 1;} else {$g[$i] += 0;}
			if (substr($line,$i,1) eq 'T') {$t[$i] += 1;} else {$t[$i] += 0;}
		}
	}
}
calcGreatest(); # Computes the consensus based on the given profile matrix

# Close the file
close($fh) || die "Couldn't close file properly";

# Print out the results
print "$consensus\n";
print "A: @a\n";
print "C: @c\n";
print "G: @g\n";
print "T: @t\n";




sub calcGreatest {
	# Check each column in the matrix for the greatest occuring letter
	for (my $i = 0; $i < scalar(@a); $i++) {
		# One letter occurring more than all others
		if ($a[$i] > $c[$i] && $a[$i] > $g[$i] && $a[$i] > $t[$i]) {$consensus .= 'A'}
		if ($c[$i] > $a[$i] && $c[$i] > $g[$i] && $c[$i] > $t[$i]) {$consensus .= 'C'}
		if ($g[$i] > $a[$i] && $g[$i] > $c[$i] && $g[$i] > $t[$i]) {$consensus .= 'G'}
		if ($t[$i] > $a[$i] && $t[$i] > $c[$i] && $t[$i] > $g[$i]) {$consensus .= 'T'}

		# Two letters occuring the same number of times, more than the other two
		if ($a[$i] == $c[$i] && $a[$i] > $g[$i] && $a[$i] > $t[$i]) {$consensus .= 'A'}
		if ($a[$i] == $g[$i] && $a[$i] > $c[$i] && $a[$i] > $t[$i]) {$consensus .= 'A'}
		if ($a[$i] == $t[$i] && $a[$i] > $c[$i] && $a[$i] > $g[$i]) {$consensus .= 'A'}
		if ($c[$i] == $g[$i] && $c[$i] > $a[$i] && $c[$i] > $t[$i]) {$consensus .= 'C'}
		if ($c[$i] == $t[$i] && $c[$i] > $a[$i] && $c[$i] > $g[$i]) {$consensus .= 'C'}
		if ($g[$i] == $t[$i] && $g[$i] > $a[$i] && $g[$i] > $c[$i]) {$consensus .= 'G'}

		# Three letters occuring the same number of times, more than the last one
		if ($a[$i] == $c[$i] && $a[$i] == $g[$i] && $a[$i] > $t[$i]) {$consensus .= 'A'}
		if ($a[$i] == $c[$i] && $a[$i] > $g[$i] && $a[$i] == $t[$i]) {$consensus .= 'A'}
		if ($a[$i] > $c[$i] && $a[$i] == $g[$i] && $a[$i] == $t[$i]) {$consensus .= 'A'}
		if ($c[$i] > $a[$i] && $c[$i] == $g[$i] && $c[$i] == $t[$i]) {$consensus .= 'C'}

		# All letters occur the same number of times
		if ($a[$i] == $c[$i] && $a[$i] == $g[$i] && $a[$i] == $t[$i]) {$consensus .= 'A'}
	}
}