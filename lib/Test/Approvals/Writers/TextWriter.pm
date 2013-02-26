package Test::Approvals::Writers::TextWriter;
{
    use Moose;
    use Carp;
    use English qw(-no_match_vars);

    has result         => ( is => 'ro', isa => 'Str', default => q{} );
    has file_extension => ( is => 'ro', isa => 'Str', default => 'txt' );

    sub write {
        my ( $self, $path ) = @_;
        open my $file, '>', $path
          or croak "Could not open $path for writing: $OS_ERROR";
        print {$file} $self->result()
          or croak "Could not write to $path: $OS_ERROR";
        close $file or croak "Could not close $path after writing: $OS_ERROR";

        return $path;
    }
}
__PACKAGE__->meta->make_immutable;

1;
__END__
=head1 NAME

Test::Approvals::Writers::TextWriter - Write results to text files.

=head2 write

    my $path = 'foo.txt';
    $path = $writer->write($path);

Write the contents of the result property to $path, and return the path to 
the written path.