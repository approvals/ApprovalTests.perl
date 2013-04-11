#! perl

use strict;
use warnings FATAL => 'all';

package Test::Approvals;
{
    use version; our $VERSION = qv(0.0.1);
    use Test::Approvals::Reporters;
    use Test::Approvals::Namers::DefaultNamer;
    use Test::Approvals::Core::FileApprover qw();
    use Test::Approvals::Writers::TextWriter;

    require Exporter;
    use base qw(Exporter);

    our @EXPORT_OK = qw(use_reporter verify reporter use_name namer);

    my $namer_instance;
    my $reporter_instance;

    sub namer {
        return $namer_instance;
    }

    sub reporter {
        return $reporter_instance;
    }

    sub use_name {
        my ($test_name) = @_;
        $namer_instance =
          Test::Approvals::Namers::DefaultNamer->new( name => $test_name );
        return $namer_instance;
    }

    sub use_reporter {
        my ($reporter_type) = @_;
        $reporter_instance = $reporter_type->new();
        return $reporter_instance;
    }

    sub verify {
        my ($results) = @_;
        my $w = Test::Approvals::Writers::TextWriter->new( result => $results );

        return Test::Approvals::Core::FileApprover::verify( $w, namer(),
            reporter() );
    }
}

1;
__END__
=head1 NAME

Test::Approvals - Capture human intelligence in your tests

=head1 SUBROUTINES

=head2 namer

    my $namer = namer();

Gets the currently configured Test::Approvals::Namers:: instance.

=head2 reporter

    my $reporter = reporter();

Gets the currently configured Test::Approvals::Reporters:: instance.

=head2 use_name

    my $namer = use_name('My Test Name');

Construct a namer for the specified name, configure it as the current instance, 
and return the instance.

=head2 use_reporter

    my $reporter = use_reporter('Test::Approvals::Reporters::DiffReporter');

Construct a reporter of the specified type, configure it as the current 
instance, and return the instance.

=head2 verify

    my $ok = verify('Hello');
    ok $ok, 'My Test';

Construct a writer for the specified data and use it (along with the current 
namer and reporter instances) to verify against the approved data.  Returns a
value indicating whether the data matched.  The reporter is launched when 
appropriate.

You can pass anything to verify that Perl can easily stringify in a scalar 
context.  So, passing an array, a hash, or raw reference to verify is not going 
to produce useful results.  In these cases, take advantage of Data::Dumper.

    use Data::Dumper;
    my %person = ( First => 'Fred', Last => 'Flintrock' );
    ok verify(Dumper( \%person )), 'Fred test';
