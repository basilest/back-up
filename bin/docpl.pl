#!/usr/bin/perl
# author: sbasile  date:2015.may
use strict;
use warnings;
my $username;
my $my_lib;

BEGIN {
    $username = getpwuid( $< );
    $my_lib = "/Users/".$username."/bin";
}
use lib $my_lib;
use Data::Dumper;
use classInfo;
use pathConversion;

my $level = 0;
my $line;

my @classInfo_array;
my $REFERENCE_PATH = $ARGV[1];
parse_class ( $ARGV[0] );
#print Dumper(@classInfo_array);
foreach my $classInfo (@classInfo_array) {
           $classInfo -> dump();
}

sub parse_file {
   my $classInfo = shift;
   my $inFile = $classInfo -> {_filesys_path};
   my $inFile_h;

   if (open ($inFile_h, "<", $inFile))  {
       #print "\tparsing file: $inFile\n";
       while($line = <$inFile_h>) {
         chomp $line;
         $line =~ s/^\s+//;  #remove initial blanks
         $line =~ s/#.*//;   #remove comments

         while ($line =~ m/\S/) {
             if ($level == 0) {
                        if ($line =~ m/base\s+qw[( ]+([^) ]*)[) ](.*)/) {
                            $classInfo->add_father($1);
                            $line = $2;
                        }
                        elsif ($line =~ m/\s*sub\s+(\w+)(.*)/) {
                            $classInfo->add_method($1);
                            $line = $2;
                        }
                        elsif ($line =~ m/\s*properties\s*=\s*\((.*)/) {
                            $line   = $1;
                            $level  = 1;      # 1: parsing properties
                        }
                        elsif ($line =~ m/\s*_attr_data\s*=\s*\((.*)/) {
                            $line   = $1;
                            $level  = 2;      # 2: parsing attr_data  (DATA BASE modules)
                        }
                        else { $line =""; }
             }
             elsif ($level == 1) {
                        if ($line =~ m/([^;]*);(.*)/) {
                            $classInfo->add_prop($1);
                            $line = $2;
                            $level  = 0;     # 0: back to parsing at high level
                        }
                        else {
                            $classInfo->add_prop($line);
                            $line = "";
                        }
             }
             elsif ($level == 2) {
                        if ($line =~ m/([^;]*);(.*)/) {
                            $classInfo->add_attr_data($1);
                            $line = $2;
                            $level  = 0;     # 0: back to parsing at high level
                        }
                        else {
                            $classInfo->add_attr_data($line);
                            $line = "";
                        }
             }
         }
       }
   }
   else {print "Couldn't open '".$inFile."' for reading because: ".$!;}
}

my $NUM_CLASS = 0;

sub parse_class {
    my ($class_path ) = @_;
    my $absolute_path = pathConversion::get_absolute_path ($class_path, $REFERENCE_PATH, 0);

    $NUM_CLASS++;
    print "\n$NUM_CLASS)\t$absolute_path\n";
    my $classInfo = new classInfo ($NUM_CLASS, $class_path, $absolute_path);
    my $father_class;
    parse_file ($classInfo);
    my $str = join("\n",@{$classInfo->{_array_father}});
    push @classInfo_array, $classInfo;
    foreach $father_class (@{$classInfo -> {_array_father}}) {
            parse_class ($father_class);
    }
}
