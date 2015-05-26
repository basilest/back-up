#!/usr/bin/perl
# author: sbasile  date:2015.may
use strict;
use warnings;
my $username;
my $my_lib;

BEGIN {
    $username = getpwuid( $< );
    $my_lib = "/home/".$username."/bin";
}
use lib $my_lib;
use Data::Dumper;
use classInfo;
use pathConversion;

my $level = 0;
my $line;
my @base_dirs = ("/home/".$username."/MODULES/");

my @classInfo_array;
parse_class ( $ARGV[0]);
#print Dumper(@classInfo_array);
foreach my $classInfo (@classInfo_array) {
           $classInfo -> dump();
}

sub parse_file {
   my $classInfo = shift;
   my $inFile = $classInfo -> {_filesys_path};
   my $inFile_h;

   if (open ($inFile_h, "<", $inFile))  {
       print "parsing file: $inFile\n";
       while($line = <$inFile_h>) {
         chomp $line;
         $line =~ s/^\s+//;  #remove initial blanks
         $line =~ s/#.*//;   #remove comments
       
         while ($line =~ m/\S/) {
             if ($level == 0) {
                        if ($line =~ m/base\s+qw[( ]+([^) ]*)[) ](.*)/) {
                            $classInfo->add_father($1);
                            $line = $2;
                            #print "added 1 father:".$1."\n"; 
                        }
                        elsif ($line =~ m/\s*sub\s+(\w+)(.*)/) {
                            $classInfo->add_method($1);
                            $line = $2;
                        }
                        elsif ($line =~ m/\s*properties\s*=\s\((.*)/) {
                            $line   = $1;
                            $level  = 1;      # 1: parsing properties 
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
         }
       }
   }
   else {print "Couldn't open '".$inFile."' for reading because: ".$!;}
}

sub parse_class {
    my ($class_path) = @_; 
    my $absolute_path = (-e $class_path) ? $class_path : # if already in filesys format do not transform
                                           pathConversion::build_filesys_path ($class_path); # transform

    my $classInfo = new classInfo ($class_path, $absolute_path);
    my $father_class;
    parse_file ($classInfo);
    my $str = join("\n",@{$classInfo->{_array_father}});
    push @classInfo_array, $classInfo;
    foreach $father_class (@{$classInfo -> {_array_father}}) {
            parse_class ($father_class);
    }
}
