#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::AndReporter;
{
    use Moose;
    use version; our $VERSION = qv('v0.0_1');

    has reporters => ( is => 'ro' );

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my ( $self, $approved, $received ) = @_;
        foreach my $reporter ( @{ $self->reporters() } ) {
            $reporter->report( $approved, $received );
        }

        return;
    }
}
__PACKAGE__->meta->make_immutable;
1;
__END__
=head1 NAME

Test::Approvals::Reporters::AndReporter - Report with multiple reporters

=head1 METHODS

=head2 report

    my $left  = Test::Approvals::Reporters::FakeReporter->new();
    my $right = Test::Approvals::Reporters::FakeReporter->new();
    my $and   = Test::Approvals::Reporters::AndReporter->new(
        reporters => [ $left, $right ] 
    );

    $and->report( 'r.txt', 'a.txt' );

Each reporter passed to the constructor in the reporters argument will be 
called by report with the arguments provided to report.
