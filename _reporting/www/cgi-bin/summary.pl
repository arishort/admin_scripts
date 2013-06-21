#!/usr/bin/perl
use strict;
use DBI;
use CGI;

my $query = CGI->new();
my $year = $query->param('year');

my $f;
my @files;
opendir(DIR, "/logs/reports/updatestatus/") || die("Cannot open directory");
@files = sort grep (/$year/, readdir(DIR));
closedir(DIR);

# Header for content frame
print "Content-type: text/html\n\n";
print "<html>\n  <head>\n";
print "    <LINK REL=StyleSheet HREF=\"../css/updatestatus.css\" TYPE=\"text/css\" MEDIA=screen>\n";
print "  </head>\n";

# Connect to the database, (the directory containing our csv file(s))
my $dbh = DBI->connect("DBI:CSV:f_dir=/logs/reports/updatestatus;csv_eol=\r;");

# Month and Quarter arrays
my %long = ('01','Jan','02','Feb','03','Mar','04','Apr','05','May','06','Jun','07','Jul','08','Aug','09','Sep','10','Oct','11','Nov','12','Dec');
my @quarters = ( [ '01','02','03' ],
                 [ '04','05','06' ],
                 [ '07','08','09' ],
                 [ '10','11','12' ],
               );

# Monthly stats array
my %monthstats = ();

foreach $f (@files)
{
  unless ( ($f eq ".") || ($f eq "..") )
  {
  my $filename = $f;
  my $timestamp = $filename;
  $timestamp =~ tr/0-9//cd;
  my $month = substr($timestamp, 4, 2);
  my $longmonth = "$long{$month}";

  # Associate our csv file with the table name 'updates'
  $dbh->{'csv_tables'}->{'updates'} = { 'file' => "$filename"};

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
  my $overall_total = $dbh->prepare("SELECT count(*) FROM updates");
  my $overall_current = $dbh->prepare("SELECT count(*) FROM updates where current='YES'");
  
  my $group_a_quarter = $dbh->prepare("SELECT count(*) FROM updates where group='a' and over90=''");
  my $group_b_quarter = $dbh->prepare("SELECT count(*) FROM updates where group='b' and over90=''");
  my $group_c_quarter = $dbh->prepare("SELECT count(*) FROM updates where group='c' and over90=''");
  my $group_d_quarter = $dbh->prepare("SELECT count(*) FROM updates where group='d' and over90=''");
  my $group_e_quarter = $dbh->prepare("SELECT count(*) FROM updates where group='e' and over90=''");
  my $group_x_quarter = $dbh->prepare("SELECT count(*) FROM updates where group='x' and over90=''");
  my $overall_quarter = $dbh->prepare("SELECT count(*) FROM updates where over90=''");
  
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

  $group_a_quarter->execute();
  my $gaq = $group_a_quarter->fetchrow();
  $group_a_quarter->finish;
  my $gaqp = 0;
  if ($gat != 0) {
    $gaqp = ($gaq/$gat*100);
    $gaqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }
  $group_b_quarter->execute();
  my $gbq = $group_b_quarter->fetchrow();
  $group_b_quarter->finish;
  my $gbqp = 0;
  if ($gbt != 0) {
    $gbqp = ($gbq/$gbt*100);
    $gbqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }
  $group_c_quarter->execute();
  my $gcq = $group_c_quarter->fetchrow();
  $group_c_quarter->finish;
  my $gcqp = 0;
  if ($gct != 0) {
    $gcqp = ($gcq/$gct*100);
    $gcqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }
  $group_d_quarter->execute();
  my $gdq = $group_d_quarter->fetchrow();
  $group_d_quarter->finish;
  my $gdqp = 0;
  if ($gdt != 0) {
    $gdqp = ($gdq/$gdt*100);
    $gdqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }
  $group_e_quarter->execute();
  my $geq = $group_e_quarter->fetchrow();
  $group_e_quarter->finish;
  my $geqp = 0;
  if ($get != 0) {
    $geqp = ($geq/$get*100);
    $geqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }
  $group_x_quarter->execute();
  my $gxq = $group_x_quarter->fetchrow();
  $group_x_quarter->finish;
  my $gxqp = 0;
  if ($gxt != 0) {
    $gxqp = ($gxq/$gxt*100);
    $gxqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }
  $overall_quarter->execute();
  my $oq = $overall_quarter->fetchrow();
  $overall_quarter->finish;
  my $oqp = 0;
  if ($ot != 0) {
    $oqp = ($oq/$ot*100);
    $oqp =~s/(^\d{1,}\.\d{2})(.*$)/$1/;
  }  

  $monthstats{"gat$month"} = "$gat";
  $monthstats{"gac$month"} = "$gac";
  $monthstats{"gap$month"} = "$gap";
  $monthstats{"gbt$month"} = "$gbt";
  $monthstats{"gbc$month"} = "$gbc";
  $monthstats{"gbp$month"} = "$gbp";
  $monthstats{"gct$month"} = "$gct";
  $monthstats{"gcc$month"} = "$gcc";
  $monthstats{"gcp$month"} = "$gcp";
  $monthstats{"gdt$month"} = "$gdt";
  $monthstats{"gdc$month"} = "$gdc";
  $monthstats{"gdp$month"} = "$gdp";
  $monthstats{"get$month"} = "$get";
  $monthstats{"gec$month"} = "$gec";
  $monthstats{"gep$month"} = "$gep";
  $monthstats{"gxt$month"} = "$gxt";
  $monthstats{"gxc$month"} = "$gxc";
  $monthstats{"gxp$month"} = "$gxp";
  $monthstats{"ot$month"} = "$ot";
  $monthstats{"oc$month"} = "$oc";
  $monthstats{"op$month"} = "$op";
  $monthstats{"gaq$month"} = "$gaq";
  $monthstats{"gaqp$month"} = "$gaqp";
  $monthstats{"gbq$month"} = "$gbq";
  $monthstats{"gbqp$month"} = "$gbqp";
  $monthstats{"gcq$month"} = "$gcq";
  $monthstats{"gcqp$month"} = "$gcqp";
  $monthstats{"gdq$month"} = "$gdq";
  $monthstats{"gdqp$month"} = "$gdqp";
  $monthstats{"geq$month"} = "$geq";
  $monthstats{"geqp$month"} = "$geqp";
  $monthstats{"gxq$month"} = "$gxq";
  $monthstats{"gxqp$month"} = "$gxqp";
  $monthstats{"oq$month"} = "$oq";
  $monthstats{"oqp$month"} = "$oqp";
  }
}

my $mo;
my $quar;

# Output Summary in html format
print("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr valign=\"top\">\n");

for my $quarter (0..$#quarters)
{
  for my $month (0..$#{$quarters[$quarter]}) 
  {
    # Output stats for each month
    $mo=$quarters[$quarter][$month];
    print(" <td><table class=\"pretty\">\n");
    print("    <tr><th> </th><th> $long{$mo} </th><th> $year </th><th> </th></tr>\n");
    print("    <tr><th> group </th><th> total </th><th> current </th><th> percent </th></tr>\n");
    print("    <tr><td> A </td><td> $monthstats{\"gat$mo\"} </td><td> $monthstats{\"gac$mo\"} </td><td> $monthstats{\"gap$mo\"}\% </td></tr>");
    print("    <tr class=\"odd\"><td> B </td><td> $monthstats{\"gbt$mo\"} </td><td> $monthstats{\"gbc$mo\"} </td><td> $monthstats{\"gbp$mo\"}\% </td></tr>");
    print("    <tr><td> C </td><td> $monthstats{\"gct$mo\"} </td><td> $monthstats{\"gcc$mo\"} </td><td> $monthstats{\"gcp$mo\"}\% </td></tr>");
    print("    <tr class=\"odd\"><td> D </td><td> $monthstats{\"gdt$mo\"} </td><td> $monthstats{\"gdc$mo\"} </td><td> $monthstats{\"gdp$mo\"}\% </td></tr>");
    print("    <tr><td> E </td><td> $monthstats{\"get$mo\"} </td><td> $monthstats{\"gec$mo\"} </td><td> $monthstats{\"gep$mo\"}\% </td></tr>");
    print("    <tr class=\"odd\"><td> X </td><td> $monthstats{\"gxt$mo\"} </td><td> $monthstats{\"gxc$mo\"} </td><td> $monthstats{\"gxp$mo\"}\% </td></tr>");
    print("    <tr><td> overall </td><td> $monthstats{\"ot$mo\"} </td><td> $monthstats{\"oc$mo\"} </td><td> $monthstats{\"op$mo\"}\% </td></tr></table></td>");
  }
  # Output Quarterly Summary
  $mo=$quarters[$quarter][-1];
  $quar="Q".($quarter+1);
  print(" <td><table class=\"pretty\">\n");
  print("    <tr><th> </th><th> $quar </th><th> $year </th><th> </th></tr>\n");
  print("    <tr><th> group </th><th> total </th><th> current </th><th> percent </th></tr>\n");
  print("    <tr><td> A </td><td> $monthstats{\"gat$mo\"} </td><td> $monthstats{\"gaq$mo\"} </td><td> $monthstats{\"gaqp$mo\"}\% </td></tr>");
  print("    <tr class=\"odd\"><td> B </td><td> $monthstats{\"gbt$mo\"} </td><td> $monthstats{\"gbq$mo\"} </td><td> $monthstats{\"gbqp$mo\"}\% </td></tr>");
  print("    <tr><td> C </td><td> $monthstats{\"gct$mo\"} </td><td> $monthstats{\"gcq$mo\"} </td><td> $monthstats{\"gcqp$mo\"}\% </td></tr>");
  print("    <tr class=\"odd\"><td> D </td><td> $monthstats{\"gdt$mo\"} </td><td> $monthstats{\"gdq$mo\"} </td><td> $monthstats{\"gdqp$mo\"}\% </td></tr>");
  print("    <tr><td> E </td><td> $monthstats{\"get$mo\"} </td><td> $monthstats{\"geq$mo\"} </td><td> $monthstats{\"geqp$mo\"}\% </td></tr>");
  print("    <tr class=\"odd\"><td> X </td><td> $monthstats{\"gxt$mo\"} </td><td> $monthstats{\"gxq$mo\"} </td><td> $monthstats{\"gxqp$mo\"}\% </td></tr>");
  print("    <tr><td> overall </td><td> $monthstats{\"ot$mo\"} </td><td> $monthstats{\"oq$mo\"} </td><td> $monthstats{\"oqp$mo\"}\% </td></tr></table></td>");

  print "</tr><tr>";
}

print("</tr></table></body></html>");

$dbh->disconnect;
