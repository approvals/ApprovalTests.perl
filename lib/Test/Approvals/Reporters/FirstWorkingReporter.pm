#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::FirstWorkingReporter;
{
    use version; our $VERSION = qv('v0.0_1');

    use Moose;
    use Moose::Util qw(does_role);

    use Carp;
    use File::Spec;
    use List::Util qw(first);
    use List::MoreUtils qw(any);

    with 'Test::Approvals::Reporters::MultiReporter';
    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    around report => sub {
        my ( $report_method, $self, $approved, $received ) = @_;

        my $working = first { _is_working($_) } @{ $self->reporters() };

        _assert_found( $working, $received );

        $working->report( $approved, $received );
        return;
    };

    around is_working_in_this_environment => sub {
        my ( $method, $self ) = @_;
        return any { _is_working($_) } @{ $self->reporters() };
    };

    sub _is_working {
        my ($reporter) = @_;
        return does_role( $reporter,
            'Test::Approvals::Reporters::EnvironmentAwareReporter' )
          && $reporter->is_working_in_this_environment();
    }

    sub _assert_found {
        my ( $reporter, $received ) = @_;
        if ( !defined $reporter ) {
            croak
              "FirstWorkingReporter could not find a Reporter for $received";
        }
        return;
    }
}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::FirstWorkingReporter - Report using the first 
reporter that appears to be working in the test environment.

=head1 SYNOPSIS
    
    use Test::Approvals::Reporters;

    my @reporters = (
        Test::Approvals::Reporters::BeyondCompareReporter->new(),
        Test::Approvals::Reporters::CodeCompareReporter->new(),
    );

    my $reporter = Test::Approvals::Reporters::FirstWorkingReporter->new(
        reporters => \@reporters
    );

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->report($received, $approved);

