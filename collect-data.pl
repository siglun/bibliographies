#!/usr/bin/perl -w

use strict;

open(my $bibl,"find ~  -name references.text -print|") or die;

my $file_no=0;
while(my $file = <$bibl> ) {
    chomp $file;
    $file_no++;
    print "mv $file $file_no\.text\n";;

}
