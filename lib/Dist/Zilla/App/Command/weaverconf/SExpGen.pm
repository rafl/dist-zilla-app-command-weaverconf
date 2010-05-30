package # no indexing, please
    Dist::Zilla::App::Command::weaverconf::SExpGen;

use Moose;
use Moose::Autobox;
use namespace::autoclean;

extends 'Data::Visitor';

sub visit_value {
    my ($self, $value) = @_;
    return qq{'$value};
}

override visit_normal_hash => sub {
    my ($self) = @_;
    my $ret = super;
    return sprintf q{(list %s)}, $ret->keys->map(sub {
        sprintf "%s %s", $_, $ret->{$_}
    })->join(q{ });
};

override visit_normal_array => sub {
    my ($self) = @_;
    return sprintf q{(list %s)}, super->join(q{ });
};

1;
