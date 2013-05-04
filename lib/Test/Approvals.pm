package Test::Approvals;
use strict;
use warnings FATAL => 'all';
use version; our $VERSION = qv('v0.0.4_3');

use Test::Approvals::Reporters;
use Test::Approvals::Namers::DefaultNamer;
use Test::Approvals::Core::FileApprover qw();
use Test::Approvals::Writers::TextWriter;
use Test::Builder;

require Exporter;
use base qw(Exporter);

our @EXPORT_OK = qw(use_reporter use_reporter_instance verify verify_ok
  reporter use_name namer);

my $test = Test::Builder->new();
my $namer_instance;
my $reporter_instance = Test::Approvals::Reporters::IntroductionReporter->new();

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
    return $test->ok( verify $results, $namer_instance->name );
}

1;
__END__
=head1 NAME

Test::Approvals - Capture human intelligence in your tests

=head1 VERSION

This documentation refers to Test::Approvals version v0.0.4_3

=head1 SYNOPSIS

    use Test::Approvals qw(use_reporter verify_ok);

    use_reporter('Test::Approvals::Reporters::DiffReporter');
    verify_ok 'Hello', 'Hello Test';

=head1 DESCRIPTION

The Test::Approvals modules provides the top level interface to ApprovalTestss
for Perl.  You can use ApprovalTests to verify objects that require more than 
a simple assert, including long strings, large arrays, and complex hash
structures and objects.  Perl already has great modules that overlap with 
ApprovalTests, but Test::Approvals really shines when you take advantage of
reporters to provide different views into failing tests.  Sometimes printing to 
STDOUT just isn't enough.  

=head1 SUBROUTINES/METHODS

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

=head1 DIAGNOSTICS

None at this time.

=head1 CONFIGURATION AND ENVIRONMENT

None.

=head1 DEPENDENCIES

=over

Exporter
Test::Builder
version

=back

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

Windows-only.  Linux/OSX/other support will be added when time and access to 
those platforms permit.

=head1 AUTHOR

Jim Counts - @jamesrcounts

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2013 Jim Counts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    L<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

