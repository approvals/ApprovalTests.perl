#! perl

use Modern::Perl '2012';
use strict;
use warnings FATAL => 'all';

use version; our $VERSION = qv('v0.0.4_4');

use Test::Perl::Critic::Progressive qw( progressive_critic_ok set_critic_args);
set_critic_args( -severity => 1 );
progressive_critic_ok();
