#! perl
use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv('v0.0.4_6');

use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals qw(verify use_reporter reporter use_name use_name_in namer);
use Test::More;

describe 'An Approval', sub {
    use_reporter('Test::Approvals::Reporters::FakeReporter');
    it 'Reports failure using the configured reporter', sub {
        my ($spec) = @_;

        use_name($spec);
        verify('Hello');
        ok reporter()->was_called, $spec;
        unlink namer()->get_received_file('txt');
    };

    it 'Can generate names in any directory' => sub {
        my ($spec) = @_;
        my $expected =
            'C:\tmp\approvals.t.'
          . 'an_approval_can_generate_names_in_any_directory'
          . '.received.txt';
        use_name_in( $spec, 'C:\tmp' );
        is namer()->get_received_file('txt'), $expected, namer()->name;
      };

      it 'Still provides expected name for names in other directory' => sub{
      	my ($spec)=@_;
      	use_name_in($spec, 'C:\tmp');
      	is $spec, namer()->name, $spec;
      };
};

run_tests();
