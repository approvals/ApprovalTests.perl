#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::EnvironmentAwareReporter;
{
    use version; our $VERSION = qv('v0.0_1');

    use Moose::Role;

    requires qw(exe);

    sub is_working_in_this_environment {
        my ($self) = @_;
        return ( -e $self->exe() );
    }
}
1;
__END__
=head1 NAME

Test::Approvals::Reporters::EnvironmentAwareReporter - Provides a role which
Reporters can extend when they want to provide a value inidicating whether 
they work in the test environment.

=head2 is_working_in_this_environment 

    $reporter->is_working_in_this_environment();

Gets a value indicating whether the reporter appears to be working in the test
environment.  By default, this just means that the reporter was able to locate 
it's executable.
