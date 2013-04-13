#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use version; our $VERSION = qv(0.0.1);
use Readonly;
use English qw(-no_match_vars);

# Ensure a recent version of Test::Pod::Coverage
Readonly my $MIN_TPC => 1.08;

my $skip = 0;
## no critic (ProhibitStringyEval)
eval "use Test::Pod::Coverage $MIN_TPC" or $skip = 1;
## use critic

if ( $EVAL_ERROR or $skip ) {
    plan skip_all =>
      "Test::Pod::Coverage $MIN_TPC required for testing POD coverage";
}

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
Readonly my $MIC_PC => 0.18;

$skip = 0;
## no critic (ProhibitStringyEval)
eval "use Pod::Coverage $MIC_PC" or $skip = 1;
## use critic

if ( $EVAL_ERROR or $skip ) {
    plan skip_all => "Pod::Coverage $MIC_PC required for testing POD coverage";
}

all_pod_coverage_ok();
