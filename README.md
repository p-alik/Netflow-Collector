Netflow-Collector
=============

[![CPAN version](https://badge.fury.io/pl/Netflow-Collector.png)](https://badge.fury.io/pl/Netflow-Collector)
[![Build Status](https://travis-ci.org/p-alik/Netflow-Collector.png)](https://travis-ci.org/p-alik/Netflow-Collector)
[![Coverage Status](https://coveralls.io/repos/github/p-alik/Netflow-Collector/badge.png)](https://coveralls.io/github/p-alik/Netflow-Collector)

Netflow::Collector is a perl module, that aims to simplify your work by collecting of netflow data

INSTALLATION
------------
To install this module, run the following commands:
```bash
perl Makefile.PL
make
make test
make install
```
DOCUMENTATION
-------------
```
perldoc Netflow::Collector
```

USAGE
-----

```perl
use Netflow::Collector;

my $foo = Netflow::Collector->new(port => 9999, dispatch => sub {..});
$foo->run();

```
