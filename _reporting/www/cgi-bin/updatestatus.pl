#!/usr/bin/perl -w
use strict;
use DBI;
use CGI;

my $query = CGI->new();
my $filename = $query->param('file');
my %long = ('01','January','02','February','03','March','04','April','05','May','06','June','07','July','08','August','09','September','10','October','11','November','12','December');
my $timestamp = $filename;
$timestamp =~ tr/0-9//cd;
my $year = substr($timestamp, 0, 4);
my $month = substr($timestamp, 4, 2);
my $longmonth = "$long{$month}";
my $sort = $query->param('sort');
my $servertag = "server name";
my $patchtag = "patch schedule";
my $grouptag = "server group";
my $agingtag = "aging status";

if ($sort =~ "server") { $servertag = "<b>server name</b>"; }
elsif ($sort =~ "patch") { $patchtag = "<b>patch schedule</b>"; }
elsif ($sort =~ "group") { $grouptag = "<b>server group</b>"; }
elsif ($sort =~ "lupdate") { $agingtag = "<b>aging status</b>"; }

# Header for content frame
print "Content-type: text/html\n\n";
print "<html>\n  <head>\n";
print "    <LINK REL=StyleSheet HREF=\"../css/updatestatus.css\" TYPE=\"text/css\" MEDIA=screen>\n";
print "  </head>\n";
print "<table width=\"100\%\"><tr><td align=\"left\"> <b>$longmonth $year</b>";
print " - sort by: <a href=\"updatestatus.pl?file=$filename&sort=patch\">$patchtag</a>";
print " - <a href=\"updatestatus.pl?file=$filename&sort=server\">$servertag</a>";
print " - <a href=\"updatestatus.pl?file=$filename&sort=group\">$grouptag</a>";
print " - <a href=\"updatestatus.pl?file=$filename&sort=lupdate\">$agingtag</a>";
print "</td><td align=\"right\"><a href=\"/updatestatus/$filename\"> download CSV </a></td></tr></table>";

# Connect to the database, (the directory containing our csv file(s))
my $dbh = DBI->connect("DBI:CSV:f_dir=/var/www/html/updatestatus;csv_eol=\r;");

# Associate our csv file with the table name 'updates'
$dbh->{'csv_tables'}->{'updates'} = {'file' => "$filename"};

# Summary Report Queries
my $group_a_total = $dbh->prepare("SELECT count(*) FROM updates where group='a'");
my $group_a_current = $dbh->prepare("SELECT count(*) FROM updates where group='a' and current='YES'");
my $group_b_total = $dbh->prepare("SELECT count(*) FROM updates where group='b'");
my $group_b_current = $dbh->prepare("SELECT count(*) FROM updates where group='b' and current='YES'");
my $group_c_total = $dbh->prepare("SELECT count(*) FROM updates where group='c'");
my $group_c_current = $dbh->prepare("SELECT count(*) FROM updates where group='c' and current='YES'");
my $group_d_total = $dbh->prepare("SELECT count(*) FROM updates where group='d'");
my $group_d_current = $dbh->prepare("SELECT count(*) FROM updates where group='d' and current='YES'");
my $group_e_total = $dbh->prepare("SELECT count(*) FROM updates where group='e'");
my $group_e_current = $dbh->prepare("SELECT count(*) FROM updates where group='e' and current='YES'");
my $group_x_total = $dbh->prepare("SELECT count(*) FROM updates where group='x'");
my $group_x_current = $dbh->prepare("SELECT count(*) FROM updates where group='x' and current='YES'");
my $patch_0_total = $dbh->prepare("SELECT count(*) FROM updates where patch='0'");
my $patch_0_current = $dbh->prepare("SELECT count(*) FROM updates where patch='0' and current='YES'");
my $patch_1_total = $dbh->prepare("SELECT count(*) FROM updates where patch='1'");
my $patch_1_current = $dbh->prepare("SELECT count(*) FROM updates where patch='1' and current='YES'");
my $patch_2_total = $dbh->prepare("SELECT count(*) FROM updates where patch='2'");
my $patch_2_current = $dbh->prepare("SELECT count(*) FROM updates where patch='2' and current='YES'");
my $patch_3_total = $dbh->prepare("SELECT count(*) FROM updates where patch='3'");
my $patch_3_current = $dbh->prepare("SELECT count(*) FROM updates where patch='3' and current='YES'");
my $patch_4_total = $dbh->prepare("SELECT count(*) FROM updates where patch='4'");
my $patch_4_current = $dbh->prepare("SELECT count(*) FROM updates where patch='4' and current='YES'");
my $patch_9_total = $dbh->prepare("SELECT count(*) FROM updates where patch='9'");
my $patch_9_current = $dbh->prepare("SELECT count(*) FROM updates where patch='9' and current='YES'");
my $overall_total = $dbh->prepare("SELECT count(*) FROM updates");
my $overall_current = $dbh->prepare("SELECT count(*) FROM updates where current='YES'");

my $overall_over30 = $dbh->prepare("SELECT count(*) FROM updates where over30='Over 30' and over90='' and over180=''");
my $overall_over90 = $dbh->prepare("SELECT count(*) FROM updates where over90='Over 90' and over180=''");
my $overall_over180 = $dbh->prepare("SELECT count(*) FROM updates where over180='Over 180'");

$group_a_total->execute();
my $gat = $group_a_total->fetchrow();
$group_a_total->finish;
$group_a_current->execute();
my $gac = $group_a_current->fetchrow();
$group_a_current->finish;
my $gap = 0;
if ($gat != 0) {
  $gap = ($gac/$gat*100);
  $gap =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$group_b_total->execute();
my $gbt = $group_b_total->fetchrow();
$group_b_total->finish;
$group_b_current->execute();
my $gbc = $group_b_current->fetchrow();
$group_b_current->finish;
my $gbp = 0;
if ($gbt != 0) {
  $gbp = ($gbc/$gbt*100);
  $gbp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$group_c_total->execute();
my $gct = $group_c_total->fetchrow();
$group_c_total->finish;
$group_c_current->execute();
my $gcc = $group_c_current->fetchrow();
$group_c_current->finish;
my $gcp = 0;
if ($gct != 0) {
  $gcp = ($gcc/$gct*100);
  $gcp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$group_d_total->execute();
my $gdt = $group_d_total->fetchrow();
$group_d_total->finish;
$group_d_current->execute();
my $gdc = $group_d_current->fetchrow();
$group_d_current->finish;
my $gdp = 0;
if ($gdt != 0) {
  $gdp = ($gdc/$gdt*100);
  $gdp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$group_e_total->execute();
my $get = $group_e_total->fetchrow();
$group_e_total->finish;
$group_e_current->execute();
my $gec = $group_e_current->fetchrow();
$group_e_current->finish;
my $gep = 0;
if ($get != 0) {
  $gep = ($gec/$get*100);
  $gep =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$group_x_total->execute();
my $gxt = $group_x_total->fetchrow();
$group_x_total->finish;
$group_x_current->execute();
my $gxc = $group_x_current->fetchrow();
$group_x_current->finish;
my $gxp = 0;
if ($gxt != 0) {
  $gxp = ($gxc/$gxt*100);
  $gxp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$patch_0_total->execute();
my $p0t = $patch_0_total->fetchrow();
$patch_0_total->finish;
$patch_0_current->execute();
my $p0c = $patch_0_current->fetchrow();
$patch_0_current->finish;
my $p0p = 0;
if ($p0t != 0) {
  $p0p = ($p0c/$p0t*100);
  $p0p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$patch_1_total->execute();
my $p1t = $patch_1_total->fetchrow();
$patch_1_total->finish;
$patch_1_current->execute();
my $p1c = $patch_1_current->fetchrow();
$patch_1_current->finish;
my $p1p = 0;
if ($p1t != 0) {
  $p1p = ($p1c/$p1t*100);
  $p1p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$patch_2_total->execute();
my $p2t = $patch_2_total->fetchrow();
$patch_2_total->finish;
$patch_2_current->execute();
my $p2c = $patch_2_current->fetchrow();
$patch_2_current->finish;
my $p2p = 0;
if ($p2t != 0) {
  $p2p = ($p2c/$p2t*100);
  $p2p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$patch_3_total->execute();
my $p3t = $patch_3_total->fetchrow();
$patch_3_total->finish;
$patch_3_current->execute();
my $p3c = $patch_3_current->fetchrow();
$patch_3_current->finish;
my $p3p = 0;
if ($p3t != 0) {
  $p3p = ($p3c/$p3t*100);
  $p3p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$patch_4_total->execute();
my $p4t = $patch_4_total->fetchrow();
$patch_4_total->finish;
$patch_4_current->execute();
my $p4c = $patch_4_current->fetchrow();
$patch_4_current->finish;
my $p4p = 0;
if ($p4t != 0) {
  $p4p = ($p4c/$p4t*100);
  $p4p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$patch_9_total->execute();
my $p9t = $patch_9_total->fetchrow();
$patch_9_total->finish;
$patch_9_current->execute();
my $p9c = $patch_9_current->fetchrow();
$patch_9_current->finish;
my $p9p = 0;
if ($p9t != 0) {
  $p9p = ($p9c/$p9t*100);
  $p9p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$overall_total->execute();
my $ot = $overall_total->fetchrow();
$overall_total->finish;
$overall_current->execute();
my $oc = $overall_current->fetchrow();
$overall_current->finish;
my $op = 0; 
if ($ot != 0) {
  $op = ($oc/$ot*100);
  $op =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$overall_over30->execute();
my $ov30 = $overall_over30->fetchrow();
$overall_over30->finish;
my $ov30p = 0; 
if ($ot != 0) {
  $ov30p = ($ov30/$ot*100);
  $ov30p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$overall_over90->execute();
my $ov90 = $overall_over90->fetchrow();
$overall_over90->finish;
my $ov90p = 0; 
if ($ot != 0) {
  $ov90p = ($ov90/$ot*100);
  $ov90p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

$overall_over180->execute();
my $ov180 = $overall_over180->fetchrow();
$overall_over180->finish;
my $ov180p = 0; 
if ($ot != 0) {
  $ov180p = ($ov180/$ot*100);
  $ov180p =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
}

# Output Summary in html format
print("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr valign=\"top\"><td>\n");
print("  <table class=\"pretty\">\n");
print("    <tr><th> group </th><th> total </th><th> current </th><th> percent </th></tr>\n");
print("    <tr><td> A </td><td> $gat </td><td> $gac </td><td> $gap\% </td></tr>");
print("    <tr class=\"odd\"><td> B </td><td> $gbt </td><td> $gbc </td><td> $gbp\% </td></tr>");
print("    <tr><td> C </td><td> $gct </td><td> $gcc </td><td> $gcp\% </td></tr>");
print("    <tr class=\"odd\"><td> D </td><td> $gdt </td><td> $gdc </td><td> $gdp\% </td></tr>");
print("    <tr><td> E </td><td> $get </td><td> $gec </td><td> $gep\% </td></tr>");
print("    <tr class=\"odd\"><td> X  </td><td> $gxt </td><td> $gxc </td><td> $gxp\% </td></tr>");
print("    <tr><td> overall </td><td> $ot </td><td> $oc </td><td> $op\% </td></tr></table></td>");
print("  <td><table class=\"pretty\">\n");
print("    <tr><th> patch </th><th> total </th><th> current </th><th> percent </th></tr>\n");
print("    <tr><td> 0 </td><td> $p0t </td><td> $p0c </td><td> $p0p\% </td></tr>");
print("    <tr class=\"odd\"><td> 1 </td><td> $p1t </td><td> $p1c </td><td> $p1p\% </td></tr>");
print("    <tr><td> 2 </td><td> $p2t </td><td> $p2c </td><td> $p2p\% </td></tr>");
print("    <tr class=\"odd\"><td> 3 </td><td> $p3t </td><td> $p3c </td><td> $p3p\% </td></tr>");
print("    <tr><td> 4 </td><td> $p4t </td><td> $p4c </td><td> $p4p\% </td></tr>");
print("    <tr class=\"odd\"><td> 9 </td><td> $p9t </td><td> $p9c </td><td> $p9p\% </td></tr>");
print("    <tr><td> overall </td><td> $ot </td><td> $oc </td><td> $op\% </td></tr></table></td>");
print("  <td><table class=\"pretty\">\n");
print("    <tr><th> aging status </th><th> total  </th><th> percent </th></tr>");
print("    <tr><td> Current </td><td> $oc </td><td> $op </td></tr>");
print("    <tr class=\"odd\"><td> Over 30 </td><td> $ov30 </td><td> $ov30p </td></tr>");
print("    <tr><td> Over 90 </td><td> $ov90 </td><td> $ov90p </td></tr>");
print("    <tr class=\"odd\"><td> Over 180 </td><td> $ov180 </td><td> $ov180p </td></tr></table>");
print("</td></tr></table>");

# Output row information in html format
print("  <table class=\"pretty\">\n");
print("    <tr><th>server</th><th>patch</th><th>group</th><th>last reboot</th><th>last update</th><th>current</th><th>over30</th><th>over90</th><th>over180</th></tr>\n");

# Full Report Query
my $sth = $dbh->prepare("SELECT * FROM updates order by $sort,server");
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
  print ("<td>", $row->{'server'}, "</td><td>", $row->{'patch'}, "</td><td>", $row->{'group'}, "</td><td>", $row->{'lreboot'}, "</td><td>", $row->{'lupdate'}, "</td><td>", $row->{'current'}, "</td><td>", $row->{'over30'}, "</td><td>", $row->{'over90'}, "</td><td>", $row->{'over180'}, "</td></tr>\n");
}
print("  </table>\n</html>\n");
$sth->finish();
$dbh->disconnect;
