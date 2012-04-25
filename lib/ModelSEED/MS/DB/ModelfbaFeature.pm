########################################################################
# ModelSEED::MS::DB::ModelfbaFeature - This is the moose object corresponding to the ModelfbaFeature object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-04-24T02:58:24
########################################################################
use strict;
use ModelSEED::MS::BaseObject;
package ModelSEED::MS::DB::ModelfbaFeature;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::FBASolution', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has feature_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has variables => ( is => 'rw', isa => 'HashRef', type => 'attribute', metaclass => 'Typed' );
has class => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed' );
has ko => ( is => 'rw', isa => 'Int', type => 'attribute', metaclass => 'Typed', default => '0' );




# LINKS:
has feature => (is => 'rw',lazy => 1,builder => '_buildfeature',isa => 'ModelSEED::MS::Feature', type => 'link(Annotation,Feature,uuid,feature_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildfeature {
	my ($self) = @_;
	return $self->getLinkedObject('Annotation','Feature','uuid',$self->feature_uuid());
}


# CONSTANTS:
sub _type { return 'ModelfbaFeature'; }


__PACKAGE__->meta->make_immutable;
1;