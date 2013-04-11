#! perl
use strict;
use warnings FATAL => qw(all);

package Test::Approvals::Writers::TextWriter;
{
    use Moose;
    use Carp;
    use English qw(-no_match_vars);
    use version; our $VERSION = qv(0.0.1);

    has result         => ( is => 'ro', isa => 'Str', default => q{} );
    has file_extension => ( is => 'ro', isa => 'Str', default => 'txt' );

    sub write_to {
        my ( $self, $path ) = @_;
        open my $file, '>', $path
          or croak "Could not open $path for writing: $OS_ERROR";
        $self->print_to($file)
          or croak "Could not write to $path: $OS_ERROR";
        close $file or croak "Could not close $path after writing: $OS_ERROR";

        return $path;
    }

    sub print_to {
        my ( $self, $h ) = @_;
        return $h->print( $self->result() );
    }
}
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Test::Approvals::Writers::TextWriter - Writes text to files

=head1 METHODS

=head2 print_to

Write the result to an open handle.

    my $w = Test::Approvals::Writers::TextWriter->new( result => 'Hello' );
    my $out_buf;
    open my $out, '>', \$out_buf;
    $w->print_to($out);
    close $out;

=head2 write_to

Write the result to a file at the specified path.

    my $w = Test::Approvals::Writers::TextWriter->new( result => 'Hello' );
    $w->write_to('out.txt');
