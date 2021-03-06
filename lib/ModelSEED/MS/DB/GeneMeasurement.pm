########################################################################
# ModelSEED::MS::DB::GeneMeasurement - This is the moose object corresponding to the GeneMeasurement object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::GeneMeasurement;
use Moose;
use Moose::Util::TypeConstraints;
extends 'ModelSEED::MS::BaseObject';
use namespace::autoclean;


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::ExperimentDataPoint', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has value => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has feature_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has method => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );




# LINKS:
has feature => (is => 'rw',lazy => 1,builder => '_buildfeature',isa => 'ModelSEED::MS::Feature', type => 'link(Genome,Feature,uuid,feature_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildfeature {
	my ($self) = @_;
	return $self->getLinkedObject('Genome','Feature','uuid',$self->feature_uuid());
}


# CONSTANTS:
sub _type { return 'GeneMeasurement'; }


__PACKAGE__->meta->make_immutable;
1;
