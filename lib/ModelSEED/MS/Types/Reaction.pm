#
# Subtypes for ModelSEED::MS::Reaction
#
package ModelSEED::MS::Types::Reaction;
use Moose::Util::TypeConstraints;
use ModelSEED::MS::DB::Reaction;

coerce 'ModelSEED::MS::DB::Reaction',
    from 'HashRef',
    via { ModelSEED::MS::DB::Reaction->new($_) };
subtype 'ModelSEED::MS::ArrayRefOfReaction',
    as 'ArrayRef[ModelSEED::MS::DB::Reaction]';
coerce 'ModelSEED::MS::ArrayRefOfReaction',
    from 'ArrayRef',
    via { [ map { ModelSEED::MS::DB::Reaction->new( $_ ) } @{$_} ] };

1;
