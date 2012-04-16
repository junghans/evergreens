#! /usr/bin/perl -w
#
# (C) 2006-2008 Chr. Junghans
# junghans@votca,org
#
#
#version 0.1  , 08.07.08 -- initial version
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
OPTIONS:
-v, --version         Prints version
-h, --help            Show this help message
-q, --quiet           Do not show messages
    --hg              Show last log message for hg (or cvs)

Examples:  $progname -q
           $progname

Report bugs and comments at https://code.google.com/p/cj-overlay/issues/list
                         or junghans\@votca.org
END
		exit;
	}
	elsif (($ARGV[0] eq "-v") or ($ARGV[0] eq "--version"))
	{
		my $version=`perl -ne 'print "\$1\n" if /^#(version .*?) -- .*/' $0 | perl -ne 'print if eof'`;
		chomp($version);
		print "$progname, $version  by C. Junghans\n";
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

