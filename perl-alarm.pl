#!/usr/local/perl -w
use strict;
use warnings;
use Data::Dumper;
use Browser::Open qw( open_browser );

#INFORMATION -------------------------------------------------------------------
# author: David Kwan
# version: 1.0

#DESCRIPTION  ------------------------------------------------------------------
#A simple alarm clock implementation in perl.
#The alarm will open a browser window to a "random" song.
#The list of available songs can be modified or else a default will be created

#USAGE -------------------------------------------------------------------------
# Run the program, enter desired alarm time when prompted.
# Leave program running until alarm sounds.

#KNOWN BUGS --------------------------------------------------------------------
# I can't get the current time to print on the same line repeatedly.
# Using a \r carriage return instead of a newline
# is acting weird and not displaying the line at all.

#PROGRAM START -----------------------------------------------------------------
my $songfile = 'songs.txt';
print "songs.txt file does not exist, creating it...\n" unless -e $songfile;
open (SFILEH, '>>', $songfile) or die $!;
print SFILEH 'https://www.youtube.com/watch?v=0JQ0xnJyb0A' unless -s $songfile; #if file is empty: add default song
close SFILEH or die $!;

my ($alarm, $a_hour, $a_min) = (0,00,00);
do  {
	print "Enter an alarm time: ________ ? (eg: 1:00, 14:00, 22:52)\n";
	$alarm = <STDIN>;
	chomp $alarm;
	if ($alarm =~ /^(\d+)\:(\d+)$/) {
		$a_hour = $1;
		$a_min = $2;
	}
	if ($a_hour > 23) {
		$alarm = 0;
	} elsif ($a_min > 59) {
		$alarm = 0;
	}
} until ($alarm =~ /^(\d?\d)\:(\d\d)$/);

print "Alarm accepted, I will wake you up at $alarm\n";

my ($sec,$min,$min_display,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
my $switch = ':';
do {
	#refresh the current time
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
	#add a 0 to the minute display if its a single digit
	($min =~ /^\d$/) ? ($min_display = "0".$min) : ($min_display = $min); 

	print "Current time is " . $hour.$switch.$min_display . "\n"; #cant figure out why a carriage return here doesnt work as intended
 
 	#make the ':' blink every second
	($switch eq ':') ? ($switch = ' ') : ($switch = ':');
	sleep 1; #program will crash if you delete this
} until ($hour eq $a_hour && $min eq $a_min);
print "WAKE UP!\n";

open (SFILEH, '<', $songfile) or die $!;
chomp(my @songs = <SFILEH>);
close SFILEH or die $!;

open_browser($songs[rand @songs]);





