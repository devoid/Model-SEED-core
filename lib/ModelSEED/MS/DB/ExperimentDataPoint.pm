########################################################################
# ModelSEED::MS::DB::ExperimentDataPoint - This is the moose object corresponding to the ExperimentDataPoint object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::ExperimentDataPoint;
use Moose;
use Moose::Util::TypeConstraints;
use ModelSEED::MS::LazyHolder::FluxMeasurement;
use ModelSEED::MS::LazyHolder::UptakeMeasurement;
use ModelSEED::MS::LazyHolder::MetaboliteMeasurement;
use ModelSEED::MS::LazyHolder::GeneMeasurement;
extends 'ModelSEED::MS::BaseObject';
use namespace::autoclean;


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::Experiment', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', lazy => 1, builder => '_builduuid', printOrder => '0' );
has strain_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has media_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has pH => ( is => 'rw', isa => 'Num', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has temperature => ( is => 'rw', isa => 'Num', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has buffers => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has phenotype => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has notes => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has growthMeasurement => ( is => 'rw', isa => 'Num', type => 'attribute', metaclass => 'Typed', printOrder => '0' );
has growthMeasurementType => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', printOrder => '0' );


# ANCESTOR:
has ancestor_uuid => (is => 'rw',isa => 'uuid', type => 'acestor', metaclass => 'Typed');


# SUBOBJECTS:
has fluxMeasurements => (is => 'bare', coerce => 1, handles => { fluxMeasurements => 'value' }, default => sub{return []}, isa => 'ModelSEED::MS::FluxMeasurement::Lazy', type => 'child(FluxMeasurement)', metaclass => 'Typed');
has uptakeMeasurements => (is => 'bare', coerce => 1, handles => { uptakeMeasurements => 'value' }, default => sub{return []}, isa => 'ModelSEED::MS::UptakeMeasurement::Lazy', type => 'child(UptakeMeasurement)', metaclass => 'Typed');
has metaboliteMeasurements => (is => 'bare', coerce => 1, handles => { metaboliteMeasurements => 'value' }, default => sub{return []}, isa => 'ModelSEED::MS::MetaboliteMeasurement::Lazy', type => 'child(MetaboliteMeasurement)', metaclass => 'Typed');
has geneMeasurements => (is => 'bare', coerce => 1, handles => { geneMeasurements => 'value' }, default => sub{return []}, isa => 'ModelSEED::MS::GeneMeasurement::Lazy', type => 'child(GeneMeasurement)', metaclass => 'Typed');


# LINKS:
has strain => (is => 'rw',lazy => 1,builder => '_buildstrain',isa => 'ModelSEED::MS::Strain', type => 'link(Genome,Strain,uuid,strain_uuid)', metaclass => 'Typed',weak_ref => 1);
has media => (is => 'rw',lazy => 1,builder => '_buildmedia',isa => 'ModelSEED::MS::Media', type => 'link(Biochemistry,Media,uuid,media_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _builduuid { return Data::UUID->new()->create_str(); }
sub _buildstrain {
	my ($self) = @_;
	return $self->getLinkedObject('Genome','Strain','uuid',$self->strain_uuid());
}
sub _buildmedia {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Media','uuid',$self->media_uuid());
}


# CONSTANTS:
sub _type { return 'ExperimentDataPoint'; }
sub _typeToFunction {
	return {
		UptakeMeasurement => 'uptakeMeasurements',
		FluxMeasurement => 'fluxMeasurements',
		GeneMeasurement => 'geneMeasurements',
		MetaboliteMeasurement => 'metaboliteMeasurements',
	};
}


__PACKAGE__->meta->make_immutable;
1;
