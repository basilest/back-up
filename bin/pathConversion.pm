#!/usr/bin/perl
# author: sbasile  date:2015.may
use strict;
use warnings;

package pathConversion;

my $username = getpwuid( $< );
my @base_dirs = ("/home/".$username."/MODULES/");

sub build_filesys_path {
    my ($class_path) = @_; 
    my $dir;
    my $absolute_path;
    $class_path =~ s/::/\//g;
    foreach $dir (@base_dirs) {
             $absolute_path = $dir . $class_path . ".pm";
             if (-e $absolute_path) {
                return $absolute_path;
             }
    }
    return "";  #file not found;
}

sub  main {
  my ($class_path) = @_; 
  my $absolute_path = (-e $class_path) ? $class_path : # if already in filesys format do not transform
                                         build_filesys_path ($class_path); # transform
  print $absolute_path;
}

1;
