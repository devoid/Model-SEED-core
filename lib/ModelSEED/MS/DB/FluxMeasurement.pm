########################################################################
# ModelSEED::MS::DB::FluxMeasurement - This is the moose object corresponding to the FluxMeasurement object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::FluxMeasurement;
use Moose;
use Moose::Util::TypeConstraints;
extends 'ModelSEED::MS::BaseObject';
use namespace::autoclean;


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::ExperimentDataPoint', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has value => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has reacton_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has compartment_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has type => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );




# LINKS:
has reaction => (is => 'rw',lazy => 1,builder => '_buildreaction',isa => 'ModelSEED::MS::Reaction', type => 'link(Biochemistry,Reaction,uuid,reacton_uuid)', metaclass => 'Typed',weak_ref => 1);
has compartment => (is => 'rw',lazy => 1,builder => '_buildcompartment',isa => 'ModelSEED::MS::Compartment', type => 'link(Biochemistry,Compartment,uuid,compartment_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildreaction {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Reaction','uuid',$self->reacton_uuid());
}
sub _buildcompartment {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Compartment','uuid',$self->compartment_uuid());
}


# CONSTANTS:
sub _type { return 'FluxMeasurement'; }


__PACKAGE__->meta->make_immutable;
1;
