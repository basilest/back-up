# author: sbasile  date:2015.may
use strict;
use warnings;

package classInfo;

sub new {
        my $class = shift @_;
        my $self = {
                    _id              => shift,
                    _class_path      => shift,
                    _filesys_path    => shift,
                    _array_father    => [],
                    _array_method    => [],
                    _array_prop      => [],
                    _array_attr_data => []
                   };
        bless $self, $class;
        return $self;
}

sub add_father {
        my ( $self, $father_name ) = @_;
        if ($father_name ) {
           if ($father_name ne $self->{_class_path}) {
                push @{$self->{_array_father}}, $father_name;
           }
        }
}
sub add_method {
        my ( $self, $method_name ) = @_;
        if ($method_name) {
            push @{$self->{_array_method}}, $method_name;
        }
}
sub add_prop {
        my ( $self, $prop_name ) = @_;
        if ($prop_name) {
            push @{$self->{_array_prop}}, $prop_name;
        }
}
sub add_attr_data {
        my ( $self, $attr_name ) = @_;
        if ($attr_name) {
            push @{$self->{_array_attr_data}}, $attr_name;
        }
}
sub print_array {
    my ($header_string, @array) = @_;
    print "\n\n". '-' x 20 ;
    print $header_string . "\n";
    print $_."\n" foreach @array;
}
sub dump {
    my ( $self) = @_;
    print '_' x 80;
    print "\n\n".$self->{_id}.")\tclass: ".$self->{_class_path}."\n";
    print   "\tfile: " .$self->{_filesys_path}."\n";
    print_array ("HIERARCHY",  @{$self->{_array_father}});
    print_array ("METHODS",    @{$self->{_array_method}});
    print_array ("PROPERTIES", @{$self->{_array_prop}});
    print_array ("ATTR_DATA",  @{$self->{_array_attr_data}});
}
1;
