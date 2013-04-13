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
    use Test::Builder;

    require Exporter;
    use base qw(Exporter);

    our @EXPORT_OK = qw(use_reporter use_reporter_instance verify verify_ok
      reporter use_name namer);

    my $Test = Test::Builder->new();
    my $namer_instance;
    my $reporter_instance =
      Test::Approvals::Reporters::IntroductionReporter->new();

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

    sub use_reporter_instance {
        $reporter_instance = shift;
        return $reporter_instance;
    }

    sub use_reporter {
        my ($reporter_type) = @_;
        return use_reporter_instance $reporter_type->new();
    }

    sub verify {
        my ($results) = @_;
        my $w = Test::Approvals::Writers::TextWriter->new( result => $results );

        return Test::Approvals::Core::FileApprover::verify( $w, namer(),
            reporter() );
    }

    sub verify_ok {
        my ( $results, $name ) = @_;
        if ( defined $name ) {
            use_name($name);
        }
        $Test->ok( verify $results, $namer_instance->name );
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

=head2 use_reporter_instance

    my $reporter = Test::Approvals::Reporters::DiffReporter->new();
    my $ref = use_reporter_instance($reporter);

Like 'use_reporter', but use the provided instance instead of constructing a 
new instance.

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

=head2 verify_ok

    use_name('Hello Test');
    verify_ok('Hello');

Like 'verify', but also automatically call 'ok' with the test name provided by
the current namer instance.  Or you can pass the name explicitly for a more
traditional Test::More experience:

    verify_ok 'Hello', 'Hello Test';
