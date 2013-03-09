#! perl

use Test::Approvals::Reporters;
use Test::More::Behaviour;

plan tests => 2;

describe 'AndReporter' => sub {
    it 'invokes two reporters' => sub {
        my $left  = Test::Approvals::Reporters::FakeReporter->new();
        my $right = Test::Approvals::Reporters::FakeReporter->new();
        my $and =
          Test::Approvals::Reporters::AndReporter->new(
            reporters => [ $left, $right ] );
        $and->report( 'foo', 'bar' );
        ok $left->was_called();
        ok $right->was_called();
      }
};
