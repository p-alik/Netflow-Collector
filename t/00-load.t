use v5.10;
use strict;
use warnings FATAL => 'all';

use Test::More tests => 1;

use_ok("Netflow::Collector");

diag("Testing Netflow::Collector $Netflow::Collector::VERSION, Perl $], $^X");

