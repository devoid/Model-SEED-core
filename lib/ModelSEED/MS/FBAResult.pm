########################################################################
# ModelSEED::MS::FBAResult - This is the moose object corresponding to the FBAResult object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-05-25T05:08:47
########################################################################
use strict;
use ModelSEED::MS::DB::FBAResult;
package ModelSEED::MS::FBAResult;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::DB::FBAResult';
#***********************************************************************************************************
# ADDITIONAL ATTRIBUTES:
#***********************************************************************************************************

#***********************************************************************************************************
# BUILDERS:
#***********************************************************************************************************

#***********************************************************************************************************
# CONSTANTS:
#***********************************************************************************************************

#***********************************************************************************************************
# FUNCTIONS:
#***********************************************************************************************************
=head3 buildFromOptSolution
Definition:
	ModelSEED::MS::FBAResults = ModelSEED::MS::FBAResults->runFBA();
Description:
	Runs the FBA study described by the fomulation and returns a typed object with the results
=cut
sub buildFromOptSolution {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,["LinOptSolution"],{});
	for (my $i=0; $i < @{$args->{LinOptSolution}->solutionvariables()}; $i++) {
		my $var = $args->{LinOptSolution}->solutionvariables()->[$i];
		my $type = $var->variable()->type();
		if ($type eq "flux" || $type eq "forflux" || $type eq "revflux" || $type eq "fluxuse" || $type eq "forfluxuse" || $type eq "revfluxuse") {
			$self->integrateReactionFluxRawData($var);
		} elsif ($type eq "biomassflux") {
			$self->create("FBABiomassVariable",{
				biomass_uuid => $var->entity_uuid(),
				variableType => $type,
				lowerBound => $var->lowerBound(),
				upperBound => $var->upperBound(),
				min => $var->min(),
				max => $var->max(),
				value => $var->value()
			});
		} elsif ($type eq "drainflux" || $type eq "fordrainflux" || $type eq "revdrainflux" || $type eq "drainfluxuse" || $type eq "fordrainfluxuse" || $type eq "revdrainfluxuse") {
			$self->integrateCompoundFluxRawData($var);
		}
	}	
}
=head3 integrateReactionFluxRawData
Definition:
	void ModelSEED::MS::FBAResults->integrateReactionFluxRawData();
Description:
	Translates a raw flux or flux use variable into a reaction variable with decomposed reversible reactions recombined
=cut
sub integrateReactionFluxRawData {
	my ($self,$solVar) = @_;
	my $type = "flux";
	my $max = 0;
	my $min = 0;
	my $var = $solVar->variable();
	if ($var->type() =~ m/use$/) {
		$max = 1;
		$min = -1;
		$type = "fluxuse";	
	}
	my $fbavar = $self->getObject("FBAReactionVariable",{
		reaction_uuid => $var->entity_uuid(),
		variableType => $type
	});
	if (!defined($fbavar)) {
		$fbavar = $self->create("FBAReactionVariable",{
			modelreaction_uuid => $var->entity_uuid(),
			variableType => $type,
			lowerBound => $min,
			upperBound => $max,
			min => $min,
			max => $max,
			value => 0
		});
	}
	if ($var->type() eq $type) {
		$fbavar->upperBound($var->upperBound());
		$fbavar->lowerBound($var->lowerBound());
		$fbavar->max($solVar->max());
		$fbavar->min($solVar->min());
		$fbavar->value($solVar->value());
	} elsif ($var->type() eq "for".$type) {
		if ($var->upperBound() > 0) {
			$fbavar->upperBound($var->upperBound());	
		}
		if ($var->lowerBound() > 0) {
			$fbavar->lowerBound($var->lowerBound());
		}
		if ($var->max() > 0) {
			$fbavar->max($solVar->max());
		}
		if ($var->min() > 0) {
			$fbavar->min($solVar->min());
		}
		if ($var->value() > 0) {
			$fbavar->value($solVar->value());
		}
	} elsif ($var->type() eq "rev".$type) {
		if ($var->upperBound() > 0) {
			$fbavar->lowerBound((-1*$var->upperBound()));
		}
		if ($var->lowerBound() > 0) {
			$fbavar->upperBound((-1*$var->lowerBound()));
		}
		if ($var->max() > 0) {
			$fbavar->min((-1*$solVar->max()));
		}
		if ($var->min() > 0) {
			$fbavar->max((-1*$solVar->min()));
		}
		if ($var->value() > 0) {
			$fbavar->value((-1*$solVar->value()));
		}
	}
}
=head3 integrateCompoundFluxRawData
Definition:
	void ModelSEED::MS::FBAResults->integrateCompoundFluxRawData();
Description:
	Translates a raw flux or flux use variable into a compound variable with decomposed reversible reactions recombined
=cut
sub integrateCompoundFluxRawData {
	my ($self,$var) = @_;
	my $type = "drainflux";
	my $max = 0;
	my $min = 0;
	if ($var->type() =~ m/use$/) {
		$max = 1;
		$min = -1;
		$type = "drainfluxuse";	
	}
	my $fbavar = $self->getObject("FBACompoundVariable",{
		compound_uuid => $var->entity_uuid(),
		variableType => $type
	});
	if (!defined($fbavar)) {
		$fbavar = $self->create("FBACompoundVariable",{
			modelcompound_uuid => $var->entity_uuid(),
			variableType => $type,
			lowerBound => $min,
			upperBound => $max,
			min => $min,
			max => $max,
			value => 0
		});
	}
	if ($var->type() eq $type) {
		$fbavar->upperBound() = $var->upperBound();
		$fbavar->lowerBound() = $var->lowerBound();
		$fbavar->max() = $var->max();
		$fbavar->min() = $var->min();
		$fbavar->value() = $var->value();
	} elsif ($var->type() eq "for".$type) {
		if ($var->upperBound() > 0) {
			$fbavar->upperBound($var->upperBound());	
		}
		if ($var->lowerBound() > 0) {
			$fbavar->lowerBound($var->lowerBound());
		}
		if ($var->max() > 0) {
			$fbavar->max($var->max());
		}
		if ($var->min() > 0) {
			$fbavar->min($var->min());
		}
		if ($var->value() > 0) {
			$fbavar->value($var->value());
		}
	} elsif ($var->type() eq "rev".$type) {
		if ($var->upperBound() > 0) {
			$fbavar->lowerBound((-1*$var->upperBound()));
		}
		if ($var->lowerBound() > 0) {
			$fbavar->upperBound((-1*$var->lowerBound()));
		}
		if ($var->max() > 0) {
			$fbavar->min((-1*$var->max()));	
		}
		if ($var->min() > 0) {
			$fbavar->max((-1*$var->min()));
		}
		if ($var->value() > 0) {
			$fbavar->value((-1*$var->value()));
		}
	}
}


__PACKAGE__->meta->make_immutable;
1;
