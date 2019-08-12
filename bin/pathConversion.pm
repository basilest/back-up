#!/usr/bin/perl
# author: sbasile  date:2015.may
use strict;
use warnings;

package pathConversion;

my $username = getpwuid( $< );
my $home = $ENV{HOME};
    #my @base_dirs = ("/Users/".$username."/CODE/MODULES/");
    #my @base_dirs = ("/Users/".$username."/CHL/chl-perl/websystems/MODULES/");
my $base_root = "/Users/".$username."/SingleService/chs-backend/";
my @base_dirs = ("$base_root/lib/", "$base_root/local/lib/perl5/", "$base_root/local/bin/mojo/");
    #my @base_dirs = ("/Users/".$username."/SingleService/chs-backend/lib/");

my %dirs = (
     CHL => {
        root => "$home/CHL/chl-perl/",
        dirs => [
                  "websystems/MODULES/"
                ]
     },

     CHS => {
         root => "$home/SingleService/chs-backend/",
         dirs => [
              "lib/",
              "local/lib/perl5/",
              "local/bin/mojo/"
          ]
     }
);

sub get_dirs {
    my ($class_path, $reference_path, @dirs) = @_;
    foreach my $key (keys %dirs) {
         my $root = $dirs{$key}{root};
         if (index($reference_path, $root) != -1) {
             @dirs = ($root, (map { $root.$_ } @{$dirs{$key}{dirs}}));
             last;
         }
    }
    return \@dirs;
}


sub build_filesys_path {
    my ($class_path, $reference_path ) = @_;
    my $dir;
    my $absolute_path;

    my $dirs = get_dirs($class_path, $reference_path );

    $class_path =~ s/::/\//g;
    foreach $dir (@$dirs) {
             $absolute_path = $dir . $class_path . ".pm";
             if (-e $absolute_path) {
                return $absolute_path;
             }
    }
    return "";  #file not found;
}

sub  get_absolute_path {
  my ($class_path, $reference_path, $print) = @_;
  my $absolute_path = (-e $class_path) ? $class_path : # if already in filesys format do not transform
                                         build_filesys_path ($class_path, $reference_path); # transform
  return $absolute_path if ! $print;
  print $absolute_path;
}

1;
