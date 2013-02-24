#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::FirstWorkingReporter;
{
    use version; our $VERSION = qv(0.0.1);
    use Moose;
    use Moose::Util qw(does_role);
    use File::Spec;
    use List::Util qw(first);
    use List::MoreUtils qw(any);

    has reporters => ( is => 'ro' );

    has exe  => ( is => 'rw', isa => 'Str', default => q{} );
    has argv => ( is => 'rw', isa => 'Str', default => q{} );

    with 'Test::Approvals::Reporters::Win32Launcher';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    around report => sub {
        my ( $report_method, $self, $approved, $received ) = @_;

        my $working = first { $_->is_working_in_this_environment() }
        grep {
            does_role( $_,
                'Test::Approvals::Reporters::EnvironmentAwareReporter' )
        } @{ $self->reporters() };

        if ( !defined $working ) {
            die "FirstWorkingReporter could not find a Reporter for $received";
        }

        $self->exe( $working->exe() );
        $self->argv( $working->argv() );

        $self->$report_method( $approved, $received );
        return;
    };

    around is_working_in_this_environment => sub {
        my ( $method, $self ) = @_;
        return any {
            does_role( $_,
                'Test::Approvals::Reporters::EnvironmentAwareReporter' )
              && $_->is_working_in_this_environment();
        }
        @{ $self->reporters() };
    };
}
__PACKAGE__->meta->make_immutable;
1;
