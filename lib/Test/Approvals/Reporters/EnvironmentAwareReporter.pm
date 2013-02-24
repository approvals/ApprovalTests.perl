#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::EnvironmentAwareReporter;
{
    use version; our $VERSION = qv(0.0.1);

    use Moose::Role;

    requires qw(exe);

    sub is_working_in_this_environment {
        my ($self) = @_;
        return ( -e $self->exe() );
    }

}
1;
