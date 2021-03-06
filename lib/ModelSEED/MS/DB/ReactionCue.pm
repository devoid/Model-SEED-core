########################################################################
# ModelSEED::MS::DB::ReactionCue - This is the moose object corresponding to the ReactionCue object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::ReactionCue;
use Moose;
use Moose::Util::TypeConstraints;
extends 'ModelSEED::MS::BaseObject';
use namespace::autoclean;


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::Reaction', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has cue_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1, printOrder => '0' );
has count => ( is => 'rw', isa => 'Num', type => 'attribute', metaclass => 'Typed', default => '', printOrder => '0' );




# LINKS:
has cue => (is => 'rw',lazy => 1,builder => '_buildcue',isa => 'ModelSEED::MS::Cue', type => 'link(Biochemistry,Cue,uuid,cue_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildcue {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Cue','uuid',$self->cue_uuid());
}


# CONSTANTS:
sub _type { return 'ReactionCue'; }


__PACKAGE__->meta->make_immutable;
1;
