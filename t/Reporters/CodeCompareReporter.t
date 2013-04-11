#! perl
use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv(0.0.1);

use Test::Approvals qw(verify use_reporter use_name namer);
use Test::Approvals::Specs qw(describe it run_tests);
use Test::More;
use Test::Approvals::Reporters;

describe 'A CodeCompareReporter' => sub {
    use_reporter('Test::Approvals::Reporters::DiffReporter');

    my $reporter = Test::Approvals::Reporters::CodeCompareReporter->new();

    it 'Reports with DevArt CodeCompare' => sub {
        use_name(shift);

        my $cmd = $reporter->exe . " " . $reporter->argv;

        my $ok = verify($cmd);
        if ( !$ok ) {
            $reporter->report( 'r.txt', 'a.txt' );
        }

        ok $ok, namer()->name;
    };
};

run_tests();
