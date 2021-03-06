# Holder for ModelSEED::MS::CompoundAlias
package ModelSEED::MS::LazyHolder::CompoundAlias;
use Moose;
use Moose::Util::TypeConstraints;
use ModelSEED::MS::CompoundAlias;
use ModelSEED::MS::Types::CompoundAlias;
use namespace::autoclean;

BEGIN {
    subtype 'ModelSEED::MS::CompoundAlias::Lazy',
        as 'ModelSEED::MS::LazyHolder::CompoundAlias';
    coerce 'ModelSEED::MS::CompoundAlias::Lazy',
        from 'Any',
        via { ModelSEED::MS::LazyHolder::CompoundAlias->new( uncoerced => $_ ) };
}

has uncoerced => (is => 'rw');
has value => (
    is      => 'rw',
    isa     => 'ModelSEED::MS::ArrayRefOfCompoundAlias',
    lazy    => 1,
    coerce  => 1,
    builder => '_build'
);

sub _build {
    my ($self) = @_; 
    my $val = $self->uncoerced;
    $self->uncoerced(undef);
    return $val;
}
__PACKAGE__->meta->make_immutable;
1;

