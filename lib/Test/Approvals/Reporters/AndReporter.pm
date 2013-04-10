#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::AndReporter;
{
    use Moose;
    use version; our $VERSION = qv(0.0.1);

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
