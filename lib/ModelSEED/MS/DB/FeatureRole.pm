########################################################################
# ModelSEED::MS::DB::FeatureRole - This is the moose object corresponding to the FeatureRole object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-03-20T19:18:07
########################################################################
use strict;
use namespace::autoclean;
use ModelSEED::MS::BaseObject;
use ModelSEED::MS::Feature;
use ModelSEED::MS::Role;
package ModelSEED::MS::DB::FeatureRole;
use Moose;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::Feature', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has feature_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has role_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has compartment => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', default => 'unknown' );
has comment => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', default => '' );
has delimiter => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', default => '' );




# LINKS:
has role => (is => 'rw',lazy => 1,builder => '_buildrole',isa => 'ModelSEED::MS::Role', type => 'link(Mapping,Role,uuid,role_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildrole {
	my ($self) = @_;
	return $self->getLinkedObject('Mapping','Role','uuid',$self->role_uuid());
}


# CONSTANTS:
sub _type { return 'FeatureRole'; }


__PACKAGE__->meta->make_immutable;
1;
