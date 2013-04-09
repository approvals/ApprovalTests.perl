#! perl

use strict;
use warnings FATAL => qw(all);
use version; our $VERSION = qv(0.0.1);

use Perl6::Slurp;
use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals::Writers::TextWriter;
use Test::More;

describe 'A TextWriter', sub {
    my $w = Test::Approvals::Writers::TextWriter->new( result => 'Hello' );
    it 'Writes the contents to a file', sub {
        my ($spec) = @_;
        $w->write('out.txt');

        my $written = slurp('out.txt');
        unlink 'out.txt';
        is $written, 'Hello', $spec;
    };
};

run_tests();
