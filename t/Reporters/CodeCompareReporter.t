#! perl

use Test::Approvals::Reporters;
use Test::More::Behaviour;

plan tests => 1;

use Test::More::Behaviour;

describe CodeCompareReporter => sub {
    my $reporter = Test::Approvals::Reporters::CodeCompareReporter->new();
    it 'invokes DevArt CodeCompare' => sub {
        like $reporter->exe(), qr{Devart\\Code\sCompare\\CodeCompare.exe}misx;
    };
};
