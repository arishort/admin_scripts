#!/usr/bin/perl -w
use strict;
my $f;
my $y;
my @years;
my @uniqyears;

opendir(DIR, "/logs/reports/updatestatus") || die("Cannot open directory");
my @files = reverse sort grep (!/^\.$|^\.\.$/, readdir(DIR));
closedir(DIR);

foreach $f (@files)
{
  my $timestamp = $f;
  $timestamp =~ tr/0-9//cd;
  my $year = substr($timestamp, 0, 4);
  push ( @years, $year );
}

my %seen = ();
foreach $y (@years) {
  push (@uniqyears, $y) unless $seen{$y}++;
}

@uniqyears = reverse sort (@uniqyears);

my %long = ('01','January','02','February','03','March','04','April','05','May','06','June','07','July','08','August','09','September','10','October','11','November','12','December');

print "Content-type: text/html\n\n";
print "<html><head>";
print "    <LINK REL=StyleSheet HREF=\"../css/updatestatus.css\" TYPE=\"text/css\" MEDIA=screen>\n";
print "</head><body><div id=\"list\">";

foreach $y (@uniqyears)
{
  print "<a href=\"/cgi-bin/summary.pl?year=$y\" target=\"content\"> $y Summary </a> <br>";
}

  print "<br>";

foreach $f (@files)
{
  unless ( ($f eq ".") || ($f eq "..") )
  {
  my $timestamp = $f;
  $timestamp =~ tr/0-9//cd;
  my $year = substr($timestamp, 0, 4);
  my $month = substr($timestamp, 4, 2);
  my $longmonth = "$long{$month}";

  print "<li><a href=\"/cgi-bin/updatestatus.pl?file=$f&sort=patch\" target=\"content\"> $year - $longmonth </a> </li>";
  }
}

print "</div></body></html>"; 
