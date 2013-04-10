#! perl

use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv(0.0.1);

use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals::Core::FileApprover qw(verify);
use Test::Approvals::Namers::DefaultNamer;
use Test::Approvals::Writers::TextWriter;
use Test::Approvals::Reporters::FakeReporter;
use Test::More;

describe 'A FileApprover', sub {
    my $w = Test::Approvals::Writers::TextWriter->new( result => 'Hello' );
    it 'Verifies Approved File Exists', sub {
        my ($spec) = @_;
        my $n = Test::Approvals::Namers::DefaultNamer->new( name => $spec );
        my $r = Test::Approvals::Reporters::FakeReporter->new();

        my $received = $n->get_received_file('.txt');
        ok !verify( $w, $n, $r ), $spec;
        unlink $received;
    };

    it 'Verifies Files Have Equal Size', sub {
        my ($spec) = @_;
        my $n = Test::Approvals::Namers::DefaultNamer->new( name => $spec );
        my $r = Test::Approvals::Reporters::FakeReporter->new();
        my $approved = $n->get_approved_file('.txt');

        open my $ah, '>', $approved;
        $ah->print('Hello World');
        $ah->close();

        ok !verify( $w, $n, $r ), $spec;
        unlink $approved;
        unlink $n->get_received_file('.txt');
    };
};

run_tests();
