#
# Subtypes for ModelSEED::MS::CompoundCue
#
package ModelSEED::MS::Types::CompoundCue;
use Moose::Util::TypeConstraints;
use Class::Autouse qw ( ModelSEED::MS::DB::CompoundCue );

coerce 'ModelSEED::MS::CompoundCue',
    from 'HashRef',
    via { ModelSEED::MS::DB::CompoundCue->new($_) };
subtype 'ModelSEED::MS::ArrayRefOfCompoundCue',
    as 'ArrayRef[ModelSEED::MS::DB::CompoundCue]';
coerce 'ModelSEED::MS::ArrayRefOfCompoundCue',
    from 'ArrayRef',
    via { [ map { ModelSEED::MS::DB::CompoundCue->new( $_ ) } @{$_} ] };

1;
