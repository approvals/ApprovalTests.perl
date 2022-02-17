#!/bin/sh

cpan Module::Build
perl Build.PL
./Build
./Build test
./Build install
