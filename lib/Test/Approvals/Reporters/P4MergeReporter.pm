#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::P4MergeReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'Perforce', 'p4merge.exe' );
    }

    sub argv {
        return '"APPROVED" "RECEIVED" "APPROVED" "APPROVED"';
    }
}
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Test::Approvals::Reporters::P4MergeReporter - Report failures with 
P4Merge

=head2 report

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->report($received, $approved);

Normalize the paths to received and approved files, then try to launch the diff
utility.    