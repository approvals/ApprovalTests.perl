#! perl
use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv(0.0.1);

use Test::Approvals qw(verify use_reporter use_name namer);
use Test::Approvals::Specs qw(describe it run_tests);
use Test::More;
use Test::Approvals::Reporters;

use_reporter('Test::Approvals::Reporters::DiffReporter');

sub test_reporter {
    my $class    = shift;
    my $reporter = $class->new();
    my $cmd      = $reporter->exe . " " . $reporter->argv;

    my $ok = verify($cmd);
    if ( !$ok ) {
        $reporter->report( 'r.txt', 'a.txt' );
    }

    return $ok;
}

describe 'A CodeCompareReporter' => sub {
    it 'Reports with DevArt CodeCompare' => sub {
        use_name(shift);
        ok test_reporter 'Test::Approvals::Reporters::CodeCompareReporter',
          namer()->name();
    };
};

describe 'A WinMerge Reporter' => sub {
    it 'Reports with WinMerge' => sub {
        use_name(shift);
        ok test_reporter 'Test::Approvals::Reporters::WinMergeReporter',
          namer()->name();
    };
};

describe 'A File Launcher Reporter' => sub {
    it 'uses the shell to locate a reporter' => sub {
        use_name(shift);
        ok test_reporter 'Test::Approvals::Reporters::FileLauncherReporter',
          namer()->name();
    };
};

describe 'A BeyondCompare Reporter' => sub {
    it 'Reports with BeyondCompare' => sub {
        use_name(shift);
        ok test_reporter 'Test::Approvals::Reporters::BeyondCompareReporter',
          namer()->name();
    };
};

describe 'A KDiff Reporter' => sub {
    it 'Reports with KDiff' => sub {
        use_name(shift);
        ok test_reporter 'Test::Approvals::Reporters::KDiffReporter',
          namer()->name();
    };
};

run_tests();
