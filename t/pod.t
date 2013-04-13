#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use version; our $VERSION = qv(0.0.1);
use Readonly;
use English qw(-no_match_vars);

# Ensure a recent version of Test::Pod
Readonly my $MIN_TP => 1.22;

my $skip = 0;
## no critic (ProhibitStringyEval)
eval "use Test::Pod $MIN_TP" or $skip = 1;
## use critic

if ( $skip or $EVAL_ERROR ) {
    plan skip_all => "Test::Pod $MIN_TP required for testing POD";
}

all_pod_files_ok();
