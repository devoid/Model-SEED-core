########################################################################
# ModelSEED::MS::DB::ReactionSetReaction - This is the moose object corresponding to the ReactionSetReaction object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::ReactionSetReaction;
use Moose;
use Moose::Util::TypeConstraints;
extends 'ModelSEED::MS::BaseObject';
use namespace::autoclean;


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::ReactionSet', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has reaction_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1, printOrder => '0' );




# LINKS:
has reaction => (is => 'rw',lazy => 1,builder => '_buildreaction',isa => 'ModelSEED::MS::Reaction', type => 'link(Biochemistry,Reaction,uuid,reaction_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildreaction {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Reaction','uuid',$self->reaction_uuid());
}


# CONSTANTS:
sub _type { return 'ReactionSetReaction'; }


__PACKAGE__->meta->make_immutable;
1;
