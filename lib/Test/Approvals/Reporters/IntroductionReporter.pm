#!perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals::Reporters::IntroductionReporter;
{
    use version; our $VERSION = qv('v0.0_1');

    use Moose;
    use Test::Builder;

    with 'Test::Approvals::Reporters::Reporter';

    sub report {
        my $test    = Test::Builder->new();
        my $message = <<'EOF';

Welcome to ApprovalTests for Perl (Test::Approvals).
ApprovalTests use a reporter to show you results when your test fails.
For example, you could use a diff tool, or simply display the output.
You can find several reporters under Test::Approvals::Reporters, or 
create your own by implementing the Test::Approvals::Reporters::Reporter 
role.  
EOF
        $test->diag($message);
        return;
    }

}
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Test::Approvals::Reporters::IntroductionReporter - Print diagnostic message 
explaining reporter usage.

=head2 report

    my $received = 'test.received.txt';
    my $approved = 'test.approved.txt';
    $reporter->report($received, $approved);

Print diagnostic message on failure.
