#!/bin/sh

	perl Build.PL
	./Build
	./Build test
	./Build install
