#!/usr/bin/perl -w
use strict;
use DBI;
use CGI;

my $query = CGI->new();
my $filename = "linux-server-list-test";
my $sort = $query->param('sort');
my $servertag = "server name";
my $grouptag = "server group";
my $patchtag = "patch schedule";
my $spatchtag = "patch sub-schedule";


if ($sort =~ "server") { $servertag = "<b>server name</b>"; }
elsif ($sort =~ "group") { $grouptag = "<b>server group</b>"; }
elsif ($sort =~ "patch") { $patchtag = "<b>patch schedule</b>"; }
elsif ($sort =~ "spatch") { $spatchtag = "<b>patch sub-schedule</b>"; }

# Header for content frame
print "Content-type: text/html\n\n";
print "<html>\n  <head>\n";
print "    <LINK REL=StyleSheet HREF=\"../css/serverdb.css\" TYPE=\"text/css\" MEDIA=screen>\n";
print "  </head>\n";
print "<table width=\"100\%\"><tr><td align=\"left\"> All Servers View";
print " - sort by: <a href=\"serverdb.pl?sort=server\">$servertag</a>";
print " - <a href=\"serverdb.pl?sort=group\">$grouptag</a>";
print " - <a href=\"serverdb.pl?sort=patch\">$patchtag</a>";
print " - <a href=\"serverdb.pl?sort=spatch\">$spatchtag</a>";
print "</td></tr></table>";

# Connect to the database, (the directory containing our csv file(s))
my $dbh = DBI->connect("DBI:CSV:f_dir=/var/www/serverdb;csv_eol=\r;");

# Associate our csv file with the table name 'serverdb'
$dbh->{'csv_tables'}->{'serverdb'} = {'file' => "$filename"};

# Output row information in html format
print("  <table class=\"pretty\">\n");
print("    <tr><th>server</th><th>group</th><th>patch</th><th>sub-patch</th></tr>\n");

# Full Report Query
my $sth = $dbh->prepare("SELECT * FROM serverdb order by $sort,server");
$sth->execute();

my $i = 0;

while (my $row = $sth->fetchrow_hashref) {   
  if ($i == 0) {
    print("    <tr>");
    $i = 1;
  }
  else {
    print("    <tr class=\"odd\">");
    $i = 0;
  }
  print ("<td>", $row->{'server'}, "</td><td>", $row->{'group'}, "</td><td>", $row->{'patch'}, "</td><td>", $row->{'spatch'}, "</td></tr>\n");
}
print("  </table>\n</html>\n");
$sth->finish();
$dbh->disconnect;
