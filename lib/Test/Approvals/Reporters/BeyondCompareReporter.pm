#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::BeyondCompareReporter;
{
    use version; our $VERSION = qv('v0.0_1');
    use Moose;

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub exe {
        return locate_exe( 'Beyond Compare 3/', 'BCompare.exe' );
    }

    sub argv {
        return default_argv();
    }
}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::BeyondCompareReporter - Report with BeyondCompare

=head1 METHODS

=head2 argv

Returns the argument portion expected by the reporter when invoked from the 
command line.

=head2 exe

Returns the path to the reporter executable.
