#! perl
use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv('v0.0.3');

use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals qw(verify use_reporter reporter use_name namer);
use Test::More;

describe 'An Approval', sub {
    it 'Reports failure using the configured reporter', sub {
        my ($spec) = @_;

        use_reporter('Test::Approvals::Reporters::FakeReporter');
        use_name($spec);
        verify('Hello');
        ok reporter()->was_called, $spec;
        unlink namer()->get_received_file('txt');
    };
};

run_tests();
