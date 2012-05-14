#
# Subtypes for ModelSEED::MS::Model
#
package ModelSEED::MS::Types::Model;
use Moose::Util::TypeConstraints;
use Class::Autouse qw ( ModelSEED::MS::DB::Model );

coerce 'ModelSEED::MS::Model',
    from 'HashRef',
    via { ModelSEED::MS::DB::Model->new($_) };
subtype 'ModelSEED::MS::ArrayRefOfModel',
    as 'ArrayRef[ModelSEED::MS::DB::Model]';
coerce 'ModelSEED::MS::ArrayRefOfModel',
    from 'ArrayRef',
    via { [ map { ModelSEED::MS::DB::Model->new( $_ ) } @{$_} ] };

1;
