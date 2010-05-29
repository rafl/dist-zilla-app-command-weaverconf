package # no indexing, please
    Dist::Zilla::App::Command::weaverconf::SExpGen;

use Moose;
use List::AllUtils qw(reduce);
use namespace::autoclean;

extends 'Data::Visitor';

sub visit_value {
    my ($self, $value) = @_;
    return qq{(quote $value)};
}

override visit_normal_hash => sub {
    my ($self) = @_;
    my $ret = super;
    return $self->foldr_cons(map {
        sprintf q{(cons %s %s)}, $_, $ret->{$_}
    } keys %{ $ret });
};

override visit_normal_array => sub {
    my ($self) = @_;
    return $self->foldr_cons(@{ super() }, q{nil});
};

sub foldr_cons {
    my ($self, @list) = @_;
    return join q{ } => reduce {
        sprintf q{(cons %s %s)}, $b, $a;
    } reverse @list;
}

1;
