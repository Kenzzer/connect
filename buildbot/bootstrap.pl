#!/usr/bin/perl
# vim: set ts=2 sw=2 tw=99 noet: 

use strict;
use Cwd;
use File::Basename;
use File::Path;

my ($myself, $path) = fileparse($0);
chdir($path);

require 'helpers.pm';

#Go back above build dir
chdir(Build::PathFormat('../..'));

#Get the source path.
our ($root) = getcwd();

rmtree('OUTPUT');
mkdir('OUTPUT') or die("Failed to create output folder: $!\n");
chdir('OUTPUT');
my ($result);
print "Attempting to reconfigure...\n";

#update and configure shiz
if ($^O eq "linux") {
	$ENV{'SOURCEMOD13'} = '/home/builds/common/sourcemod-1.3';
	$ENV{'MMSOURCE18'} = '/home/builds/common/mmsource-1.8';
	
	$ENV{'HL2SDKOBVALVE'} = '/home/builds/common/hl2sdk-ob-valve';
} elsif ($^O eq "darwin") {
	$ENV{'SOURCEMOD13'} = '/Users/builds/slaves/common/sourcemod-1.3';
	$ENV{'MMSOURCE18'} = '/Users/builds/slaves/common/mmsource-1.8';
	
	$ENV{'HL2SDKOBVALVE'} = '/Users/builds/slaves/common/hl2sdk-ob-valve';
} else {
	$ENV{'SOURCEMOD13'} = 'C:/Scripts/common/sourcemod-1.3';
	$ENV{'MMSOURCE18'} = 'C:/Scripts/common/mmsource-1.8';
	
	#$ENV{'HL2SDKOBVALVE'} = 'H:/hl2sdk-ob-valve';
}

#configure AMBuild
if ($^O eq "linux") {
	$result = `CC=gcc CXX=gcc python3 ../build/configure.py --enable-optimize`;
} elsif ($^O eq "darwin") {
	$result = `CC=clang CXX=clang python3 ../build/configure.py --enable-optimize`;
} else {
	$result = `C:\\Python31\\Python.exe ..\\build\\configure.py --enable-optimize`;
}
print "$result\n";
if ($? != 0) {
	die('Could not configure!');
}
