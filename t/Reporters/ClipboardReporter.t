#! perl
use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv('v0.0.5_3');

use Clipboard;
use Test::Approvals qw(verify_ok use_reporter use_name namer);
use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals::Reporters;
use Test::More;

use_reporter('Test::Approvals::Reporters::DiffReporter');

describe "A clipboard reporter" => sub {
    *get_command_line =
      \&Test::Approvals::Reporters::ClipboardReporter::get_command_line;
    it 'Produces a unix move command' => sub {
        use_name(shift);
        my $result = get_command_line( 'r', 'a', 'darwin' );
        is $result, 'mv r a', namer()->name;
    };
    it 'Produces a win32 move command' => sub {
        use_name(shift);
        my $result = get_command_line( 'r', 'a', 'MSWin32' );
        is $result, q{move /Y "r" "a"}, namer()->name;
    };
    it 'Reports to the clipboard' => sub {
        use_name(shift);
        Clipboard->copy;
        my $reporter = Test::Approvals::Reporters::ClipboardReporter->new();
        $reporter->report( 'r', 'a' );
        my $result = Clipboard->paste;
        is $result, q{move /Y "r" "a"}, namer()->name;
    };
};

run_tests();
