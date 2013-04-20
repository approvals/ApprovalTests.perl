#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::DiffReporter;
{
    use version; our $VERSION = qv('v0.0_1');
    use Moose;
    use Test::Approvals::Reporters;

    has exe  => ( is => 'ro', isa => 'Str', default => q{} );
    has argv => ( is => 'ro', isa => 'Str', default => q{} );
    has reporter => ( is => 'ro' );

    with 'Test::Approvals::Reporters::Win32Reporter';
    with 'Test::Approvals::Reporters::Reporter';
    with 'Test::Approvals::Reporters::EnvironmentAwareReporter';

    sub BUILD {
        my ($self) = @_;
        $self->{reporter} =
          Test::Approvals::Reporters::FirstWorkingReporter->new(
            reporters => [
                Test::Approvals::Reporters::BeyondCompareReporter->new(),
                Test::Approvals::Reporters::CodeCompareReporter->new(),
                Test::Approvals::Reporters::WinMergeReporter->new(),
                Test::Approvals::Reporters::TortoiseDiffReporter->new(),
                Test::Approvals::Reporters::KDiffReporter->new(),
                Test::Approvals::Reporters::P4MergeReporter->new(),
            ]
          );
        return;
    }

    around report => sub {
        my ( $method, $self, $approved, $received ) = @_;
        my $reporter = $self->reporter();
        $reporter->report( $approved, $received );
        return;
    };

    around is_working_in_this_environment => sub {
        my ( $method, $self ) = @_;
        my $reporter = $self->reporter();

        return $reporter->is_working_in_this_environment();
    };

}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::DiffReporter - A reporter configured to choose 
the first working diff utility it can find and use it for reporting.

=head2 BUILD

Used internally to configure a FirstWorkingReporter with instances of available
diff Reporters.
