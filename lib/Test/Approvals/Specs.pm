#! perl
use strict;
use warnings FATAL => qw(all);

package Test::Approvals::Specs;

use version; our $VERSION = qv(0.0.1);
use base qw(Exporter);
our @EXPORT_OK = qw(describe it run_tests);

use Test::Builder;
use Readonly;

Readonly my $TEST => Test::Builder->new();

my $context;
my @specs;

sub describe {
    $context = shift;
    my $specs = shift;
    $specs->();
    return;
}

sub it {
    my $name = shift;
    my $spec = shift;
    push @specs, sub { $spec->("$context $name") };
    return;
}

sub run_tests {
    my $other_tests = shift // 0;
    $TEST->plan( tests => ( scalar @specs + $other_tests ) );
    for (@specs) { $_->(); }
    return;
}

1;
__END__
=head1 NAME

Test::Approvals::Specs - Tiny BDD Tools

=head1 SUBROUTINES

=head2 describe
    
    describe 'A bank account', sub {
        # ...
    };

'describe' groups a set of examples, which taken together specify some system
behaviour.  

=head2 it

    it 'Holds money', sub {
        my $name = shift;
        my $bank_account = Bank::Account->new();
        $bank_account->deposit(1, 'Bitcoin');
        is $bank_account->balance, 1, $name;
    };

'it' is an executable example of some particular system behavior (in other 
words, a test).  'it' always recieves its own description, decorated by it's 
group description, as the first argument when invoked.  Combining the two 
examples above, the value 'A bank account Holds money' is assigned to $name.

=head2 run_tests

    run_tests();

Execute each example.  Examples do not execute immediately, instead they are
stored until you invoke run_tests.  'run_tests' will count the number of 'it' 
examples and setup your test plan accordingly.  However, each example only 
counts as 1 test, and if you place multiple asserts in your example, you will
need to "balance the books" by passing the number of extra tests to run_tests.

    describe 'A bank account', sub { 
        it 'Holds money', sub {
            my $name = shift;
            my $bank_account = Bank::Account->new();
            $bank_account->deposit(1, 'Bitcoin');
            is  $bank_account->balance, 
                1,
                $name;
            
            # Second assertion!
            is  $bank_account->currency, 
                'Bitcoin',
                "$name in a specific currency";
        };
    };

    run_tests(1); # I have 1 extra assertion

This can also be useful if you have some "plain old tests" mixed in with your 
examples.

    my $bank_account = Bank::Account->new();
    
    # Plain old test not accounted for
    ok defined $bank_account, 'I have a bank account';

    describe 'A bank account', sub { 
        it 'Holds money', sub {
            my $name = shift;
            $bank_account->deposit(1, 'Bitcoin');
            is  $bank_account->balance, 
                1,
                $name;
        };
    };

    run_tests(1); # Account for the plain old test

While this can be useful when migrating legacy tests, I don't reccomend it.  
'plan' is my least favorite aspect of the Perl test ecosystem, so I try to 
avoid planning by always using examples, and always using one assertion per 
example.  However, this functionality is there if you need it.
