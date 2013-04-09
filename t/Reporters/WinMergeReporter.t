#! perl
use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv(0.0.1);

use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals::Reporters::WinMergeReporter;
use Test::More;

describe 'A WinMergeReporter', sub {
    my $r          = Test::Approvals::Reporters::WinMergeReporter->new();
    my $context_ok = 1;
    it 'Uses the default arguments', sub {
        my ($spec) = @_;
        $context_ok &= is $r->argv, $r->default_argv, $spec;
    };

    it 'Uses the WinMerge executable', sub {
        my ($spec) = @_;
        $context_ok &= is $r->exe,
          'C:\Program Files (x86)\WinMerge\WinMergeU.exe', $spec;
    };

    it 'Reports using WinMerge', sub {
        my ($spec) = @_;
        if ( !$context_ok ) {
            $r->report( 'r.txt', 'a.txt' );
        }

        ok $context_ok, $spec;
    };
};

run_tests();
