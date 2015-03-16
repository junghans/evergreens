#! /usr/bin/perl -w
#
# Copyright (C) 2012-2015 Christoph Junghans
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#
#version 0.1, 08.07.08 -- initial version
use strict;

$_=$0;
s#^.*/##;
my $progname=$_;
my $usage="Usage: $progname [OPTIONS] FILE";

#Defaults
my $quiet=undef;

while ((defined ($ARGV[0])) and ($ARGV[0] =~ /^-./))
{
        if (($ARGV[0] !~ /^--/) and (length($ARGV[0])>2)){
           $_=shift(@ARGV);
           #short opt having agruments examples fo
           if ( $_ =~ /^-[fo]/ ) {
              unshift(@ARGV,substr($_,0,2),substr($_,2));
           }
           else{
              unshift(@ARGV,substr($_,0,2),"-".substr($_,2));
           }
        }
	if (($ARGV[0] eq "-h") or ($ARGV[0] eq "--help"))
	{
		print <<END;
This is a skeleton script
$usage

Options:
 -v, --version         Prints version
 -h, --help            Show this help message
 -q, --quiet           Do not show messages
      --vcs            Show last log message for use with VCS

Examples:
 $progname -q          Run in quiet mode
 $progname             Run

Report bugs and comments at https://github.com/junghans/cwdiff/issues or junghans\@votca.org
END
		exit;
	}
	elsif (($ARGV[0] eq "-v") or ($ARGV[0] eq "--version"))
	{
		my $version=`$^X -ne 'print "\$1\n" if /^#version (.*?) -- .*/' $0 | $^X -ne 'print if eof'`;
		chomp($version);
		print "$progname $version\n\n";
		system("$^X -ne 'print \$1 if /^# (Copyright.*)/;' $0");
		print "\nThis is free software: you are free to change and redistribute it.\n";
		print "License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl2.html>\n";
		print "There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n\n";
		print "Written by C. Junghans <junghans\@votca.org>\n";
		exit;
	}
	elsif ($ARGV[0] eq "--hg")
	{
		my $message=`perl -ne 'print "\$1\n" if /^#version .*? -- (.*)\$/' $0 | perl -ne 'print if eof'`;
		chomp($message);
		print "$progname: $message\n";
		exit;
	}
	elsif (($ARGV[0] eq "-q") or ($ARGV[0] eq "--quiet"))
	{
		$quiet='yes';
		shift(@ARGV);
	}
	else
	{
		die "Unknow option '".$ARGV[0]."' !\n";
	}
}

#Print usage
die "no file given\n$usage\n" unless $#ARGV > -1;

