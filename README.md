# Test-Approvals

[![test](https://github.com/approvals/ApprovalTests.perl/actions/workflows/test.yml/badge.svg)](https://github.com/approvals/ApprovalTests.perl/actions/workflows/test.yml)

Capturing Human Intelligence - ApprovalTests is an open source 
assertion/verification library to aid testing.  Test::Approvals
is the ApprovalTests port for Perl.

For more information see: www.approvaltests.com

## What can I use ApprovalTests for?

You can use ApprovalTests to verify objects that require more than
a simple assert including long strings, large arrays, and complex
hash structures and objects.  Although modules exist which allow this
kind of testing, ApprovalTests really shines when you need a more
granular look at the test failure.  Sometimes, trying to find a small
difference in a long string printed to STDOUT is just too hard!  
ApprovalTests solves this problem by providing reporters which let you
view the test results in one of many popular diff utilities.

## INSTALLATION

From CPAN ( http://search.cpan.org/~jrcounts/Test-Approvals/ ):

	cpan install Test::Approvals

From PPM ( http://code.activestate.com/ppm/Test-Approvals/ ):

	ppm install Test::Approvals

From source:

	git clone https://github.com/approvals/Perl-Test-Approvals.git
	cd Perl-Test-Approvals
	perl Build.PL
	./Build
	./Build test
	./Build install

## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc Test::Approvals

You can also look for information at:

    GitHub 
        https://github.com/approvals/Perl-Test-Approvals

    ApprovalTests Homepage
        http://www.approvaltests.com
        
## LICENSE AND COPYRIGHT

Copyright (C) 2013 Jim Counts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

