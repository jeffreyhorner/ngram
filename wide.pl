#!/usr/bin/perl -w

use strict;

my $cur = undef;
my %year = ();
my $i;
my @col;
while(<STDIN>){
        chomp;
        @col = split /\t+/;
		#next if $col[0] =~ /^[a-zA-Z.?,!"';: ]+$/;
		if ($cur && $cur ne $col[0]){
			print "$cur\t";
			foreach $i (1890..2008){
				if (!$year{$i}) {
					print '0';
				} else {
					print $year{$i};
				}
				if ($i ne 2008){ print ' ';}
			}
			print "\n";
			%year = ();
		}
		$cur = $col[0];
		if ($col[1] >= 1890){
			 $year{$col[1]} = $col[2];
		}
}
print "$cur\t";
foreach $i (1890..2008){
	if (!$year{$i}) {
		print '0';
	} else {
		print $year{$i};
	}
	if ($i ne 2008){ print ' ';}
}
print "\n";
