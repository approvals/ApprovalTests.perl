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
