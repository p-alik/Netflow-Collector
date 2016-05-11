use v5.10;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Netflow::Collector',
    AUTHOR             => q{Alexei Pastuchov <palik@cpan.org>},
    VERSION_FROM       => 'lib/Netflow/Collector.pm',
    ABSTRACT           => 'netflow collector',
    LICENSE            => 'Artistic_2_0',
    PL_FILES           => {},
    MIN_PERL_VERSION   => v5.10,
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0, },
    BUILD_REQUIRES     => {
        'Test::More'      => 0,
        'Test::Moose'     => 0,
        'Test::Exception' => 0
    },
    PREREQ_PM => {
        'IO::Select'                   => 0,
        'IO::Socket::INET'             => 0,
        'Moose'                        => 0,
        'Moose::Util::TypeConstraints' => 0,
        'Socket'                       => 0,
        'Throwable::Error'             => 0,
        'namespace::autoclean'         => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Netflow-Collector-*' },
);
