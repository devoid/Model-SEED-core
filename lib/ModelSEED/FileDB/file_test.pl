use strict;
use warnings;

use ModelSEED::CoreApi2;
use ModelSEED::FileDB::FileIndex;

use Data::Dumper;

# point database to correct sqlite db and change biochem id

my $ind = ModelSEED::FileDB::FileIndex->new({
    filename => 'biochemistry.ind'
});

my $biochem = fromCore();

$ind->add_user('paul');

$ind->save_object({user => 'paul', object => $biochem});

$ind->add_alias({user => 'paul', uuid => $biochem->{uuid}, alias => 'test'});

my $uuids = $ind->get_uuids_for_user('paul');

print Dumper($uuids);

sub fromCore {
    my $bio_uuid = "358CFC9A-5E60-11E1-9EC2-C7374BC191FA";

    my $core_api = ModelSEED::CoreApi2->new({
	database => "/home/paul/Documents/ModelSEEDCore/Model.db",
	driver   => "sqlite"
    });

    my $time = time;
    my $biochem = $core_api->getBiochemistry({ uuid => $bio_uuid, with_all => 1 });
    print "Got biochemistry in " . sprintf("%.3f", time - $time) . " seconds\n";

    return $biochem;
}
