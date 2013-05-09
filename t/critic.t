#! perl

use Modern::Perl '2012';
use strict;
use warnings FATAL => 'all';
use version; our $VERSION = qv('v0.0.4_7');

use Test::More;

eval { require Test::Perl::Critic::Progressive };
plan skip_all => 'T::P::C::Progressive required for this test' if $@;

Test::Perl::Critic::Progressive::set_critic_args( -severity => 1 );
Test::Perl::Critic::Progressive::progressive_critic_ok();

