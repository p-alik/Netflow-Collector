Netflow-Collector

[![Build Status](https://travis-ci.org/p-alik/Netflow-Collector.png)](https://travis-ci.org/p-alik/Netflow-Collector)
[![Coverage Status](https://coveralls.io/repos/github/p-alik/Netflow-Collector/badge.png?branch=upstream)](https://coveralls.io/github/p-alik/Netflow-Collector?branch=upstream)

Netflow::Collector is a perl module, that aims to simplify your work by collecting of netflow data

```
use Netflow::Collector;

my $foo = Netflow::Collector->new(port => 9999, dispatch => sub {..});
$foo->run();

```

INSTALLATION

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc Netflow::Collector

