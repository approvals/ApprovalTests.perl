#! perl

use strict;
use warnings FATAL => qw(all);
use autodie;
use version; our $VERSION = qv(0.0.1);

use Perl6::Slurp;
use Test::Approvals::Specs qw(describe it run_tests);
use Test::Approvals::Writers::TextWriter;
use Test::More;

describe 'A TextWriter', sub {
    my $w = Test::Approvals::Writers::TextWriter->new( result => 'Hello' );
    it 'Writes the contents to a file', sub {
        my ($spec) = @_;
        $w->write_to('out.txt');

        my $written = slurp('out.txt');
        unlink 'out.txt';
        is $written, 'Hello', $spec;
    };

    it 'Writes the contents to a handle', sub {
        my ($spec) = @_;
        my $out_buf;
        open my $out, '>', \$out_buf;
        $w->print_to($out);
        close $out;
        is $out_buf, 'Hello', $spec;
    };
};

run_tests();
