#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::CodeCompareReporter;
{
    use version; our $VERSION = qv('v0.0_1');
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'Devart/Code Compare/', 'CodeCompare.exe' );
    }

    sub argv {
        return '/ENVIRONMENT=standalone "RECEIVED" "APPROVED"';
    }
}
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Test::Approvals::Reporters::CodeCompareReporter - Report with CodeCompare

=head1 METHODS

=head2 argv

Returns the argument portion expected by the reporter when invoked from the 
command line.

=head2 exe

Returns the path to the reporter executable.
