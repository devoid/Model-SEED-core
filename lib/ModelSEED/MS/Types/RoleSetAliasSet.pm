#
# Subtypes for ModelSEED::MS::RoleSetAliasSet
#
package ModelSEED::MS::Types::RoleSetAliasSet;
use Moose::Util::TypeConstraints;
use Class::Autouse qw ( ModelSEED::MS::DB::RoleSetAliasSet );

coerce 'ModelSEED::MS::RoleSetAliasSet',
    from 'HashRef',
    via { ModelSEED::MS::DB::RoleSetAliasSet->new($_) };
subtype 'ModelSEED::MS::ArrayRefOfRoleSetAliasSet',
    as 'ArrayRef[ModelSEED::MS::DB::RoleSetAliasSet]';
coerce 'ModelSEED::MS::ArrayRefOfRoleSetAliasSet',
    from 'ArrayRef',
    via { [ map { ModelSEED::MS::DB::RoleSetAliasSet->new( $_ ) } @{$_} ] };

1;
